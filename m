Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 17:35:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5T0ZptL002745
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 17:35:53 -0700
Date: Fri, 29 Jun 2007 10:35:45 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Implement ioctl to mark AGs as "don't use/use"
Message-ID: <20070629003545.GE31489@sgi.com>
References: <1182939325.5313.12.camel@localhost> <20070628045049.GF989688@sgi.com> <46838CAE.9030808@linworks.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46838CAE.9030808@linworks.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ruben Porras <ruben.porras@linworks.de>
Cc: xfs@oss.sgi.com

On Thu, Jun 28, 2007 at 12:25:50PM +0200, Ruben Porras wrote:
> David Chinner wrote:
> Ok, thank you for the explanation, I think that now I got it right.
> Attached is a new patch.

Ok, I'll have a look in a little while ;)

> There is one question that I would like to ask: when you sketched the 
> xfs_alloc_set_flag_ag function, you put inside it the call to the 
> funcintion xfs_alloc_log_agf (see next code snippet).
> 
> STATIC void
> xfs_alloc_set_flag_ag(
> xfs_trans_t *tp,
> xfs_buf_t *agbp, /* buffer for a.g. freelist header */
> xfs_perag_t *pag,
> int flag)
> {
> xfs_agf_t *agf; /* a.g. freespace structure */
> 
> agf = XFS_BUF_TO_AGF(agbp);
> pag->pagf_flags |= flag;
> agf->agf_flags = cpu_to_be32(pag->pagf_flags);
> 
> xfs_alloc_log_agf(tp, agbp, XFS_AGF_FLAGS); <-- ***** FROM HERE
> }
> 
> is it required to do the transaction log right after the change or can it be
> done in the caller function right after calling xfs_alloc_set_flag_ag?
> 
> For example
> 
> caller(...)
> 
> {
> xfs_alloc_set_flag_ag(tp, bp, pag, XFS_AGFLAG_ALLOC_DENY);
> 
> <-- **** TO HERE
> 
> xfs_trans_set_sync(tp);
> xfs_trans_commit(tp, 0);
> }

Yes, you could do that but I don't think it make sense. We also
log the dirty buffer in th context in which it got dirtied, and
in this case it is xfs_alloc_set_flag_ag(). it also saves having
to rememeber that you ahve to call xfs_alloc_log_agf() after a
call to xfs_alloc_set_flag_ag(). If you need to change multiple flags,
batch them up and do a single xfs_alloc_set_flag_ag() call...

Cheers,

Dave.


-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
