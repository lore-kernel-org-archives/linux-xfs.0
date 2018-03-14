Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:40461 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933158AbeCNDH6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 23:07:58 -0400
Received: by mail-oi0-f54.google.com with SMTP id c12so1537013oic.7
        for <linux-xfs@vger.kernel.org>; Tue, 13 Mar 2018 20:07:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180312173552.GA30332@bfoster.bfoster>
References: <20180307192451.24196-1-bfoster@redhat.com> <20180308140354.pk25gd54cqjzbecs@odin.usersys.redhat.com>
 <20180309131628.GA3445@bfoster.bfoster> <20180309173318.GD18989@magnolia>
 <20180309183727.GA17046@bfoster.bfoster> <20180309190832.GH18989@magnolia>
 <20180309212031.GA19019@bfoster.bfoster> <20180309223757.GA4865@magnolia>
 <20180312131157.GA29810@bfoster.bfoster> <20180312173552.GA30332@bfoster.bfoster>
From: Dave Chiluk <chiluk+linuxxfs@indeed.com>
Date: Tue, 13 Mar 2018 22:07:27 -0500
Message-ID: <CAC=E7cXzyhJKGn2m2HGo6178R0_Ju_iMy4_wFBiYTd8wLVfhMw@mail.gmail.com>
Subject: Re: [PATCH RFC] xfs: convert between packed and unpacked agfls on-demand
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>

On Mon, Mar 12, 2018 at 12:35 PM, Brian Foster <bfoster@redhat.com> wrote:
>
> On Mon, Mar 12, 2018 at 09:11:58AM -0400, Brian Foster wrote:
> Here's a variant of that patch that does a reset. It's definitely much
> simpler. Thoughts?
>
> Brian
>
> --- 8< ---
>
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index c02781a4c091..7d313bb4677d 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2053,6 +2053,59 @@ xfs_alloc_space_available(
>         return true;
>  }
>
> +static bool
> +xfs_agf_verify_flcount(
> +       struct xfs_mount        *mp,
> +       struct xfs_agf          *agf)
> +{
> +       int                     f = be32_to_cpu(agf->agf_flfirst);
> +       int                     l = be32_to_cpu(agf->agf_fllast);
> +       int                     c = be32_to_cpu(agf->agf_flcount);
> +       int                     active = c;
> +       int                     agfl_size = XFS_AGFL_SIZE(mp);
> +
> +       if (!xfs_sb_version_hascrc(&mp->m_sb))
> +               return true;
> +
> +       if (c && l >= f)
> +               active = l - f + 1;
> +       else if (c)
> +               active = agfl_size - f + l + 1;
> +
> +       if (active != c)
> +               return false;
> +       if (f >= agfl_size || l >= agfl_size)
> +               return false;
> +
> +       return true;
> +}
> +
> +static void
> +xfs_agfl_reset(
> +       struct xfs_trans        *tp,
> +       struct xfs_buf          *agbp,
> +       struct xfs_perag        *pag)
> +{
> +       struct xfs_mount        *mp = tp->t_mountp;
> +       struct xfs_agf          *agf = XFS_BUF_TO_AGF(agbp);
> +
> +       if (!pag->pagf_needreset)
> +               return;
> +
> +       trace_xfs_agfl_reset(pag);
> +       xfs_warn(mp, "agfl reset agno %u flcount %d", pag->pag_agno,
> +                pag->pagf_flcount);
> +

Before completely leaking the entirety of the agfl couldn't we nicely
release and recover all blocks but the 119th first?  That way we'd
only be leaking the possibly problematic 119th item?  I understand we
would lose the benefit of being able to recover from otherwise corrupt
AGFLs.

If we are going to blindly leak blocks wouldn't an xfs_repair recover
these leaked blocks?  I think it would be perfectly fine to leak these
blocks if it means not crashing and then recover them at one's
convenience with an xfs_repair.

> +       agf->agf_flfirst = 0;
> +       agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
> +       agf->agf_flcount = 0;

Also I was under the impression that we should pre-allocate blocks in
the agfl for fast allocation of free b+tree nodes.  Wouldn't we want
to pre-allocate some blocks as would be done by xfs_repair (I have a
feeling someone is going to tell me where this happens elsewhere in
the codebase or can be handled at block run time with little ill
effect)?

If I'm correct in either case I'd appreciate a
Reviewed by: Dave Chiluk <chiluk+linuxxfs@indeed.com>

Thanks,
Dave


> +       xfs_alloc_log_agf(tp, agbp, XFS_AGF_FLFIRST | XFS_AGF_FLLAST |
> +                                   XFS_AGF_FLCOUNT);
> +
> +       pag->pagf_flcount = 0;
> +       pag->pagf_needreset = false;
> +}
> +
>  /*
