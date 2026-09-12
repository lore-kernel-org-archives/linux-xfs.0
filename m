Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08DB38A72F;
	Sat, 12 Sep 2026 07:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196631; cv=none; b=Re3xiaZGEid2pCAaEBi0JFNToh9zMwW84fb/MrB2XoKdZz0OutDLPhbHgUbTnbMfjdpp8D1ufJOdjgH4TYSE4PCQOFD3ng4GTcCYxhnaPhq1cjGO0n2TAglA7cIcGToHGKK+8vni2Do4aJZbh+evSFAVr+34+1bcfsnX8CLY5+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196631; c=relaxed/simple;
	bh=GiMTaWgb3BB6LAYXSwi1zqWets6P9YfXOSzrVDf0ffY=;
	h=Message-ID:Date:From:MIME-Version:To:CC:Subject:References:
	 In-Reply-To:Content-Type; b=IrmKsOK6tWnHz2jR+5WGuDQAe4oaPmRNlTh+uxrBIVNUKmidemQKZNdgPWJgsMNXRpp6uCB/JH2kgakPdme+ldC0Ts3gQDpTZbDLEd3AuEZjHDOmzsBv7fSu/IHCFOthULgz/MLeALM2XGBhbW8c+83DyqRnUvrhOCOcTY1pY+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=WzD+JkNa; arc=none smtp.client-ip=117.135.210.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="WzD+JkNa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:From:MIME-Version:To:Subject:
	Content-Type; bh=fXlYEH4Lq0PoWj6BWNlC67MzSdHGmdJyaYuDh4O+w9g=;
	b=WzD+JkNaZm2PR+hFbEmOnCqRCEDGWZxYF1iR3DYhsjbOKiTMpIooqCgds5d/b3
	FO8nmZ6lMzsK2aY3YQMPQFkTLfX3ubc/IFx4TDTmCgBABwQsVzv8HfP89B99iqWB
	Rr2q5ckJov99UfiajoEBw1MpIgPMs82FR36vESTvM3UnM=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wDXj_I0+aRqMAH_Aw--.2396S2;
	Sat, 12 Sep 2026 15:03:17 +0800 (CST)
Message-ID: <6AA4F918.7020309@126.com>
Date: Sat, 12 Sep 2026 15:02:48 +0800
From: Hongling Zeng <zhongling0719@126.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: Dave Chinner <dgc@kernel.org>
CC: Hongling Zeng <zenghongling@kylinos.cn>, cem@kernel.org, 
 darrick.wong@oracle.com, chandanrlinux@gmail.com, 
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: bound logged region access in inode buffer recovery
References: <20260907080450.314067-1-zenghongling@kylinos.cn> <ap8ucHIw-pKLhh9c@dread> <6A9F7022.6020206@126.com> <ap-sV2Cc5U5fNMmo@dread>
In-Reply-To: <ap-sV2Cc5U5fNMmo@dread>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXj_I0+aRqMAH_Aw--.2396S2
X-Coremail-Antispam: 1Uf129KBjvAXoW3Cw43tF4DCr15Kw4ktr4DXFb_yoW8GF43Ao
	WS9w4Iqw4UKr17CF1qkw18G3s3X3WS9rn3JrWjq34YvF4jqw4UAa4fGwnrZa9IyFW8uas7
	J348Jwn0yrZrXFn3n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUsdWrUUUUU
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBoBVPIGqk+TV3TgAA3h


在 2026年09月08日 14:33, Dave Chinner 写道:
> On Tue, Sep 08, 2026 at 10:17:06AM +0800, Hongling Zeng wrote:
>> 在 2026年09月08日 05:36, Dave Chinner 写道:
>>> On Mon, Sep 07, 2026 at 04:04:50PM +0800, Hongling Zeng wrote:
>>>> xlog_recover_do_inode_buffer() reads the logged di_next_unlinked field
>>>> from a log record buffer at a computed offset:
>>>>
>>>>           logged_nextp = item->ri_buf[item_index].iov_base +
>>>>                           next_unlinked_offset - reg_buf_offset;
>>>>           *buffer_nextp = *logged_nextp;
>>>>
>>>> The only protection against reading past the log record buffer are
>>>> ASSERT()s, which compile away on non-DEBUG kernels.  The existing
>>>> XFS_IS_CORRUPT(*logged_nextp == 0) check also dereferences the pointer
>>>> before validating that the computed offset lies within the logged region.
>>>>
>>>> A crafted log record can make the computed offset exceed iov_len, causing
>>>> an out-of-bounds read from the log record buffer during inode buffer
>>>> recovery.
>>>>
>>>> Convert the relevant ASSERT-only checks into runtime corruption checks and
>>>> verify that the logged di_next_unlinked field lies entirely within the log
>>>> iovec before dereferencing it.
>>>>
>>>> Fixes: 1094d3f12363 ("xfs: refactor log recovery buffer item dispatch for pass2 commit functions")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
>>> <sigh>
>>>
>>> I'm going to say what I've said before again here, and it applies to
>>> the BLF bitmap range checks patches you posted yesterday, too:
>>>
>>> Hacking the same types of region size and range checks into every
>>> log item type in an ad-hoc manner is not the right way to address
>>> these log item verification issues.
>>>
>>> We need to add a robust verification layer to the journal to verify
>>> all the journal level metadata (e.g. ophdrs, transaction headers,
>>> initial log item regions, per-log item type verification, etc) so
>>> that we check *all* the journal items for sanity before we use them.
>>>
>>> This is the same architecture we use for metadata (the verifier
>>> layer) and it applies to the journal for the same reasons and
>>> provides the same benefits (i.e. validate at first access, rest of
>>> the code can assume validity and not have to clutter logic with
>>> random validity checks to prevent bad behaviour.)
>>>
>>> The high level design doc and rough plan I put together last time I
>>> brought this up is in the patch below. If you're not willing or able
>>> to spent time and tokens on fixing this entire class of problems for
>>> everyone, then let please let me know ASAP.
>>>
>>> -Dave.
>>    Hi Dave,
>>
>>    Thanks for the detailed feedback. I understand the concern: the ad-hoc
>>    region checks I posted don't address log recovery validation
>>    systematically.
>>
>>    I'll withdraw the inode buffer and BLF bitmap patches and switch to
>>    the design-driven approach. I'll post your patch 5 first (the
>>    unchecked ri_buf[ri_cnt-1] in add_to_cont_trans(), the unbounded
>>    kvrealloc() there, the missing oh_len alignment check in
>>    process_data() - all reachable bugs, no restructuring), then work
>>    through the rest of Phase 1.
>>
>>    Three points to confirm before coding:
> Don't take the design doc as being complete or correct - it's a
> working document and really only serves as the initial high level
> plan I fleshed out.
>
> Indeed, I implemented a chunk of it yesterday afternoon (i.e.
> before I saw your patch this morning) and my findings change quite a
> bit of the generic infrastructure to make it handle the transaction
> header without having to special case it. So from that perspective,
> it's already out of date...
>
> I'll post what I have in the series later this afternoon so you can
> get up to speed.
>
>>    1. I don't see a write-side guarantee that a region is split at most
>>       once - xlog_write_partial() can emit multiple continuations. So
>>       beyond your patch 2 treating the header as a normal accumulated
>>       region, note that today a third fragment walks into
>>       ri_buf[ri_cnt-1] with ri_cnt == 0 / ri_buf == NULL. Correct?
> The iterator structure behind the item decoding should handle
> decoding regions split into an arbitrary number of ophdr regions
> without issue.
>
> That's kinda the point of it; ensure the region is
> fully extracted from the journal before we try to decode any of it.
> Hence we have to handle CONTINUE/WAS_CONT regions as partial
> additives until we get to the final WAS_CONT region that closes off
> the region as a whole.
>
>>    2. For the zero-length first fragment: if this is old-log
>>       compatibility only,
> Real thing, go look at xlog_write_get_iclog_space() and
> consider what happens when the lv_chain passed to xlog_write() gets
> it's first iclog with only space for two ophdrs left in it....
>
>>       I'd document it that way and keep the special
>>       handling as narrow as possible rather than introducing a generic
>>       anonymous item state. Note the doc's ri_in_continuation has no
>>       owner at that point since no item exists yet - narrow handling
>>       avoids that entirely.
> The special case handling for it is awful, and IMO needs to go away
> because it is actually buggy and makes it much harder to reason
> about what is a valid item in a transaction....
>
>>    3. For testing I'll cover each phase with crafted-log images and run
>>       xfstests.
> This is why I have been rewriting xfs_logprint in rust: so it has
> the same capabilities as xfs_db in terms of being able to walk,
> parse and modify individual items in the journal. i.e. to be able to
> explicitly fuzz the journal in a systematic, programmable and
> reproducable way and hence avoid the need for hundreds of corrupted
> images to test all the corner cases....
>
> And, FWIW, the iterator + generic item handling design of the
> validator for the kernel code is a fairly close translation of the
> layered generic item type verification my new rust logprint code
> already uses.
>
>>       My bigger worry is over-strict validation rejecting valid
>>       logs, which only shows up replaying real crash logs - what
>>       coverage do you expect there? And should the design doc go in
>>       first so the series can reference it?
> We have extensive journal recovery stress and validity tests in
> fstests (e.g. the recoveryloop group), and so I'm really not worried
> about structure verification being too strict. I'd much prefer to
> err on the "extremely strict" side right now, and loosen if needed.
> I don't think it will be an issue, because if the journal
> verification comes across improperly formatted items then it points
> to a runtime bug that needs to be fixed, not a journal recovery
> issue.
>
> i.e. I'd much prefer we have strict verification because that finds
> logic bugs on both sides during testing, that way they do not end up
> in production systems...
>
> -Dave.
>
Hi Dave,

I reviewed part of the series per commit and tested recovery behaviour 
against the current tip (ecf8aa53, "handle zero length continuation op
headers during recovery"). A few notes and two followup fixes are below.

1. Per-commit observations

  - 5b115b1 ("lift transaction header parsing out of the region
    assembly") says it is behaviour-preserving. That is true for normal
    streams, but not for pre-ad3e3693182b zero-length first fragments:
    those used to be skipped and are rejected until ecf8aa53 restores the
    handling. This is fine within the series, but the changelog may be
    misleading if the refactor is backported alone.

  - In the window [895f4c5, ecf8aa53), a skipped zero-length first
    fragment can leave trans->r_cur_item NULL; the following WAS_CONT
    continuation then dereferences it in xlog_recover_add_to_cont_trans().
    So that window oopses during recovery rather than failing cleanly.

  - In the window [895f4c5, ca71ea1f), a 1-3 byte op header length can
    reach xlog_recover_add_to_trans(), which reads ilf_type/ilf_size from
    a kvmalloc'd buffer shorter than 4 bytes. ASAN catches this as a heap
    over-read. ca71ea1f closes it with the op header length/alignment
    validation.

  - Minor doc/changelog nits: 895f4c5's changelog and the rst say the
    zero-length first fragment case is handled uniformly, but that is only
    true after ecf8aa53. Also, ecf8aa53's doc update says the r_cur_item
    guard is in "Patch 5", but it lands in ecf8aa53 itself.

2. Behaviour testing

We extracted the recovery functions from 857882e, 895f4c5 and ecf8aa53
into a small userspace harness with ASAN, and replayed crafted op record
streams through them: unsplit and split transaction headers, zero-length
first and middle fragments, short fragments, stray WAS_CONT records,
truncated item plus commit, and normal transactions.

A few results:

  - A 3-way transaction header split such as 4+4+8 is silently assembled
    incorrectly at 857882e: the continuation tail-copy path writes the
    middle fragment to the wrong offset, later fragments overwrite it, and
    recovery still succeeds with a corrupted r_theader. 895f4c5 fixes this.

  - A stray WAS_CONT continuation crashes via the empty-queue list walk
    already at 857882e, so that predates this series. ecf8aa53 turns it
    into -EFSCORRUPTED.

  - Zero-length middle continuation fragments now assemble correctly via
    the generic path. The old bespoke transaction-header path rejected
    them.

  - Well-formed streams behaved the same across the three commits.

I can send the full matrix if useful.

3. Two followup fixes

These are against ecf8aa53 and are independent. I am including them
inline for now since the final base is not settled; happy to post proper
patches once it is.

First, xlog_recover_commit_trans() walks r_itemq only and ignores
trans->r_cur_item. If a commit record arrives while an item is still
being rebuilt, that item is silently dropped and the transaction commits
less metadata than the log records describe. A transaction whose only
content never completed can also commit as if it were empty.

Reject commits with a pending r_cur_item. This also catches the
zero-length-opener sentinel case. I did not change XLOG_UNMOUNT_TRANS,
where dropping the partial transaction matches the existing skip
semantics.

---
  fs/xfs/xfs_log_recover.c | 15 +++++++++++++++
  1 file changed, 15 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d32b4de9215e..0ff898b71419 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2163,6 +2163,21 @@ xlog_recover_commit_trans(
         LIST_HEAD                       (ra_list);
         LIST_HEAD                       (done_list);

+       /*
+        * r_cur_item is queued only when its final fragment arrives.  If a
+        * commit record arrives while it is still set, recovery would 
otherwise
+        * drop the unfinished item and replay less metadata than the log
+        * records describe.  Treat that as a truncated transaction.
+        */
+       if (trans->r_cur_item) {
+               xfs_warn(log->l_mp, "%s: commit with incomplete item",
+                       __func__);
+               return -EFSCORRUPTED;
+       }
+
         #define XLOG_RECOVER_COMMIT_QUEUE_MAX 100

         hlist_del_init(&trans->r_list);

Second, xlog_recover_add_to_cont_trans() can grow the region under
assembly with kvrealloc on every continuation record. A corrupt log can
therefore grow a single region without a practical bound, and repeated
realloc/copy makes the work quadratic in the number of fragments.

Add a generic recovery-time cap. No writer-produced region should come
close to this; per-item limits can tighten it later.

---
  fs/xfs/libxfs/xfs_log_recover.h |  9 +++++++++
  fs/xfs/xfs_log_recover.c        | 14 ++++++++++++++
  2 files changed, 23 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h 
b/fs/xfs/libxfs/xfs_log_recover.h
index d2e128fca058..a6a29d5572be 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -149,6 +149,15 @@ extern const struct xlog_recover_item_ops 
xlog_rtcud_item_ops;

  #define XLOG_MAX_REGIONS_IN_ITEM   (XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK 
/ 2 + 1)

+/*
+ * Generic recovery-time cap for a single log region assembled from
+ * continuation op records.  This prevents corrupt continuation streams 
from
+ * growing a region without bound, or from driving unbounded 
realloc/copy work.
+ */
+#define XLOG_MAX_REGION_SIZE        (2 * XFS_MAX_BLOCKSIZE)
+
  /*
   * item headers are in ri_buf[0].  Additional buffers follow.
   */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d32b4de9215e..02d28b610850 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2405,9 +2405,23 @@ xlog_recover_add_to_cont_trans(
                 return -EFSCORRUPTED;
         }

         old_ptr = item->ri_buf[item->ri_cnt - 1].iov_base;
         old_len = item->ri_buf[item->ri_cnt - 1].iov_len;

+       /*
+        * Bound the region being assembled so a corrupt continuation stream
+        * cannot grow it without limit.
+        */
+       if (old_len > XLOG_MAX_REGION_SIZE - len) {
+               xfs_warn(log->l_mp,
+                       "%s: continuation region too large (%d > %d)",
+                       __func__, old_len + len, XLOG_MAX_REGION_SIZE);
+               return -EFSCORRUPTED;
+       }
+
         ptr = xlog_kvmalloc(old_len + len);
         memcpy(ptr, old_ptr, old_len);
         memcpy(ptr + old_len, dp, len);

Both fixes were checked in the harness: truncated-item+commit and
zero-length-opener+commit now fail cleanly, and continuation streams that
grow past the cap return -EFSCORRUPTED. A region grown to about 64KB
through continuations still assembles and commits normally.

4. Small cleanups

  - xlog_find_item_ops() is a first-match linear scan, so duplicate
    item_type entries would silently shadow later ones. The table is unique
    today, but a debug/build-time check would catch future mistakes.

  - xlog_recover_nregions() warns about a bad number of regions "in inode
    log format", but the helper is now generic for item types without
    ->validate_nregions. The warning should probably be made generic too.

Happy to run these cases through recoveryloop or the logprint-rust fuzzer
once that is ready.

Thanks,
Hongling


