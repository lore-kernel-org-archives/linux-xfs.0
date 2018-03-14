Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f178.google.com ([74.125.82.178]:36972 "EHLO
        mail-ot0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbeCNUnW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Mar 2018 16:43:22 -0400
Received: by mail-ot0-f178.google.com with SMTP id t2-v6so4671830otj.4
        for <linux-xfs@vger.kernel.org>; Wed, 14 Mar 2018 13:43:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180314181218.GR4865@magnolia>
References: <20180314171724.41951-1-bfoster@redhat.com> <20180314181218.GR4865@magnolia>
From: Dave Chiluk <chiluk+linuxxfs@indeed.com>
Date: Wed, 14 Mar 2018 15:42:50 -0500
Message-ID: <CAC=E7cUme5-0z9GjVOynD==nK5aG2athrHmm=WKA8HBFWX-hRQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: detect agfl count corruption and reset agfl
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Mar 14, 2018 at 1:12 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Wed, Mar 14, 2018 at 01:17:24PM -0400, Brian Foster wrote:
>> The struct xfs_agfl v5 header was originally introduced with
>> unexpected padding that caused the AGFL to operate with one less
>> slot than intended. The header has since been packed, but the fix
>> left an incompatibility for users who upgrade from an old kernel
>> with the unpacked header to a newer kernel with the packed header
>> while the AGFL happens to wrap around the end. The newer kernel
>> recognizes one extra slot at the physical end of the AGFL that the
>> previous kernel did not. The new kernel will eventually attempt to
>> allocate a block from that slot, which contains invalid data, and
>> cause a crash.
>>
>> This condition can be detected by comparing the active range of the
>> AGFL to the count. While this detects a padding mismatch, it can
>> also trigger false positives for unrelated flcount corruption. Since
>> we cannot distinguish a size mismatch due to padding from unrelated
>> corruption, we can't trust the AGFL enough to simply repopulate the
>> empty slot.
>>
>> Instead, avoid unnecessarily complex detection logic and and use a
>> solution that can handle any form of flcount corruption that slips
>> through read verifiers: distrust the entire AGFL and reset it to an
>> empty state. Any valid blocks within the AGFL are intentionally
>> leaked. This requires xfs_repair to rectify (which was already
>> necessary based on the state the AGFL was found in). The reset
>> mitigates the side effect of the padding mismatch problem from a
>> filesystem crash to a free space accounting inconsistency. The
>> generic approach also means that this patch can be safely backported
>> to kernels with or without a packed struct xfs_agfl.
>>
>> Check the AGF for an invalid freelist count on initial read from
>> disk. If detected, set a flag on the xfs_perag to indicate that a
>> reset is required before the AGFL can be used. In the first
>> transaction that attempts to use a flagged AGFL, reset it to empty,
>> warn the user about the inconsistency and allow the freelist fixup
>> code to repopulate the AGFL with new blocks. The xfs_perag flag is
>> cleared to eliminate the need for repeated checks on each block
>> allocation operation.
>>
>> Suggested-by: Dave Chinner <david@fromorbit.com>
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>> ---
>>
>> Hi all,
>>
>> Here's an actual patch for the AGFL reset approach. This survives a
>> normal xfstests run. I also ran some quick xfstests runs with hacks in
>> place to unconditionally trigger an agfl reset on first read. This
>> caused a ton of test failures due to the resulting accounting
>> inconsistency on the scratch device, but otherwise it survived from a
>> torture test perspective and didn't introduce any unrelated regressions
>> that I could see.
>>
>> Thoughts, reviews, flames appreciated.
>>
>> Brian
>>
>> v1:
>> - Use a simplified AGFL reset mechanism.
>> - Trigger on AGFL fixup rather than get/put.
>> - Various refactors, cleanups and comments.
>> rfc: https://marc.info/?l=linux-xfs&m=152045069616434&w=2
>>
>>  fs/xfs/libxfs/xfs_alloc.c | 96 +++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/xfs/xfs_mount.h        |  1 +
>>  fs/xfs/xfs_trace.h        |  9 ++++-
>>  3 files changed, 105 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
>> index 3db90b707fb2..7dfec92f28dc 100644
>> --- a/fs/xfs/libxfs/xfs_alloc.c
>> +++ b/fs/xfs/libxfs/xfs_alloc.c
>> @@ -2063,6 +2063,95 @@ xfs_alloc_space_available(
>>  }
>>
>>  /*
>> + * Check the agfl fields of the agf for inconsistency or corruption. The purpose
>> + * is to detect an agfl header padding mismatch between current and early v5
>> + * kernels. This problem manifests as a 1-slot size difference between the
>> + * on-disk flcount and the active [first, last] range of a wrapped agfl. This
>> + * may also catch variants of agfl count corruption unrelated to padding. Either
>> + * way, we'll reset the agfl and warn the user.
>> + *
>> + * Return true if a reset is required before the agfl can be used, false
>> + * otherwise.
>> + */
>> +static bool
>> +xfs_agfl_need_reset(

Nitpick: Rename xfs_agfl_need_reset to xfs_agfl_needs_reset for better
English and flow.

>> +     struct xfs_mount        *mp,
>> +     struct xfs_agf          *agf)
>> +{
>> +     uint32_t                f = be32_to_cpu(agf->agf_flfirst);
>> +     uint32_t                l = be32_to_cpu(agf->agf_fllast);
>> +     uint32_t                c = be32_to_cpu(agf->agf_flcount);
>> +     int                     agfl_size = xfs_agfl_size(mp);
>> +     int                     active;
>> +
>> +     /* no agfl header on v4 supers */
>> +     if (!xfs_sb_version_hascrc(&mp->m_sb))
>> +             return false;
>> +
>> +     /*
>> +      * The agf read verifier catches severe corruption of these fields.
>> +      * Repeat some sanity checks to cover a packed -> unpacked mismatch if
>> +      * the verifier allows it.
>> +      */
>> +     if (f >= agfl_size || l >= agfl_size)
>> +             return true;
>> +     if (c > agfl_size)
>> +             return true;
>> +
>> +     /*
>> +      * Check consistency between the on-disk count and the active range. An
>> +      * agfl padding mismatch manifests as an inconsistent flcount.
>> +      */
>> +     if (c && l >= f)
>> +             active = l - f + 1;
>> +     else if (c)
>> +             active = agfl_size - f + l + 1;
>> +     else
>> +             active = 0;
>> +     if (active != c)
>> +             return true;
>> +
>> +     return false;
>
> This could become "return active != c;"
>
> But otherwise looks ok enough to try it out,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>
> --D
>
>> +}
>> +
>> +/*
>> + * Reset the agfl to an empty state. Ignore/drop any existing blocks since the
>> + * agfl content cannot be trusted. Warn the user that a repair is required to
>> + * recover leaked blocks.
>> + *
>> + * The purpose of this mechanism is to handle filesystems affected by the agfl
>> + * header padding mismatch problem. A reset keeps the filesystem online with a
>> + * relatively minor free space accounting inconsistency rather than suffer the
>> + * inevitable crash from use of an invalid agfl block.
>> + */
>> +static void
>> +xfs_agfl_reset(
>> +     struct xfs_trans        *tp,
>> +     struct xfs_buf          *agbp,
>> +     struct xfs_perag        *pag)
>> +{
>> +     struct xfs_mount        *mp = tp->t_mountp;
>> +     struct xfs_agf          *agf = XFS_BUF_TO_AGF(agbp);
>> +
>> +     ASSERT(pag->pagf_agflreset);
>> +     trace_xfs_agfl_reset(mp, agf, 0, _RET_IP_);
>> +
>> +     xfs_warn(mp,
>> +            "WARNING: Reset corrupted AGFL on AG %u. %d blocks leaked. "
>> +            "Please unmount and run xfs_repair.",
>> +              pag->pag_agno, pag->pagf_flcount);
>> +
>> +     agf->agf_flfirst = 0;
>> +     agf->agf_fllast = cpu_to_be32(xfs_agfl_size(mp) - 1);
>> +     agf->agf_flcount = 0;
>> +     xfs_alloc_log_agf(tp, agbp, XFS_AGF_FLFIRST | XFS_AGF_FLLAST |
>> +                                 XFS_AGF_FLCOUNT);
>> +
>> +     pag->pagf_flcount = 0;
>> +     pag->pagf_agflreset = false;
>> +}
>> +
>> +/*
>>   * Decide whether to use this allocation group for this allocation.
>>   * If so, fix up the btree freelist's size.
>>   */
>> @@ -2123,6 +2212,10 @@ xfs_alloc_fix_freelist(
>>               }
>>       }
>>
>> +     /* reset a padding mismatched agfl before final free space check */
>> +     if (pag->pagf_agflreset)
>> +             xfs_agfl_reset(tp, agbp, pag);
>> +
>>       /* If there isn't enough total space or single-extent, reject it. */
>>       need = xfs_alloc_min_freelist(mp, pag);
>>       if (!xfs_alloc_space_available(args, need, flags))
>> @@ -2279,6 +2372,7 @@ xfs_alloc_get_freelist(
>>               agf->agf_flfirst = 0;
>>
>>       pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
>> +     ASSERT(!pag->pagf_agflreset);
>>       be32_add_cpu(&agf->agf_flcount, -1);
>>       xfs_trans_agflist_delta(tp, -1);
>>       pag->pagf_flcount--;
>> @@ -2390,6 +2484,7 @@ xfs_alloc_put_freelist(
>>               agf->agf_fllast = 0;
>>
>>       pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
>> +     ASSERT(!pag->pagf_agflreset);
>>       be32_add_cpu(&agf->agf_flcount, 1);
>>       xfs_trans_agflist_delta(tp, 1);
>>       pag->pagf_flcount++;
>> @@ -2597,6 +2692,7 @@ xfs_alloc_read_agf(
>>               pag->pagb_count = 0;
>>               pag->pagb_tree = RB_ROOT;
>>               pag->pagf_init = 1;
>> +             pag->pagf_agflreset = xfs_agfl_need_reset(mp, agf);
>>       }
>>  #ifdef DEBUG
>>       else if (!XFS_FORCED_SHUTDOWN(mp)) {
>> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
>> index 1808f56decaa..10b90bbc5162 100644
>> --- a/fs/xfs/xfs_mount.h
>> +++ b/fs/xfs/xfs_mount.h
>> @@ -353,6 +353,7 @@ typedef struct xfs_perag {
>>       char            pagi_inodeok;   /* The agi is ok for inodes */
>>       uint8_t         pagf_levels[XFS_BTNUM_AGF];
>>                                       /* # of levels in bno & cnt btree */
>> +     bool            pagf_agflreset; /* agfl requires reset before use */
>>       uint32_t        pagf_flcount;   /* count of blocks in freelist */
>>       xfs_extlen_t    pagf_freeblks;  /* total free blocks */
>>       xfs_extlen_t    pagf_longest;   /* longest free space */
>> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
>> index 945de08af7ba..a982c0b623d0 100644
>> --- a/fs/xfs/xfs_trace.h
>> +++ b/fs/xfs/xfs_trace.h
>> @@ -1477,7 +1477,7 @@ TRACE_EVENT(xfs_extent_busy_trim,
>>                 __entry->tlen)
>>  );
>>
>> -TRACE_EVENT(xfs_agf,
>> +DECLARE_EVENT_CLASS(xfs_agf_class,
>>       TP_PROTO(struct xfs_mount *mp, struct xfs_agf *agf, int flags,
>>                unsigned long caller_ip),
>>       TP_ARGS(mp, agf, flags, caller_ip),
>> @@ -1533,6 +1533,13 @@ TRACE_EVENT(xfs_agf,
>>                 __entry->longest,
>>                 (void *)__entry->caller_ip)
>>  );
>> +#define DEFINE_AGF_EVENT(name) \
>> +DEFINE_EVENT(xfs_agf_class, name, \
>> +     TP_PROTO(struct xfs_mount *mp, struct xfs_agf *agf, int flags, \
>> +              unsigned long caller_ip), \
>> +     TP_ARGS(mp, agf, flags, caller_ip))
>> +DEFINE_AGF_EVENT(xfs_agf);
>> +DEFINE_AGF_EVENT(xfs_agfl_reset);
>>
>>  TRACE_EVENT(xfs_free_extent,
>>       TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
>> --
>> 2.13.6
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by Dave Chiluk <chiluk+linuxxfs@indeed.com>

I'm also assuming this will get submitted back to the linux-stable
trees as the agfl packing change is already causing issues in the
stable trees.  If you do not intend to push it into the linux-stable
trees let me know and I'll take care of at least the major ones.

Thanks,
Dave
