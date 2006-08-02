Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Aug 2006 18:28:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k721RMDW013054
	for <xfs@oss.sgi.com>; Tue, 1 Aug 2006 18:27:36 -0700
Date: Wed, 2 Aug 2006 11:26:30 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: XFS Bug null pointer dereference in xfs_free_ag_extent
Message-ID: <20060802112629.A2341636@wobbly.melbourne.sgi.com>
References: <44CB0BF7.6030204@idccenter.cn> <44CB1303.7010303@l4x.org> <20060731094424.E2280998@wobbly.melbourne.sgi.com> <44CDA156.6000105@idccenter.cn> <20060731165522.K2280998@wobbly.melbourne.sgi.com> <44CDB135.8080401@idccenter.cn> <20060731194310.A2301615@wobbly.melbourne.sgi.com> <44CDD5B9.8020608@idccenter.cn> <215036450607311849o43b1555br13ea2f3f20fb3b82@mail.gmail.com> <44CF0CDE.2080500@l4x.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44CF0CDE.2080500@l4x.org>; from jdi@l4x.org on Tue, Aug 01, 2006 at 10:12:14AM +0200
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Dittmer <jdi@l4x.org>, Joe Jin <lkmaillist@gmail.com>, kernel <linux@idccenter.cn>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Aug 01, 2006 at 10:12:14AM +0200, Jan Dittmer wrote:
> Joe Jin schrieb:
> >  From the information, I think it caused by (args.agbp == NULL).
> > get rid of, we'll find the call trace should panic:
> > xfs_free_extent
> > |_   xfs_free_ag_extent  => here args.agbp= NULL;
> >         |_ xfs_btree_init_cursor()
> >               |_ agf = XFS_BUF_TO_AGF(agbp);  => (xfs_agf_t 
> > *)XFS_BUF_PTR(arbp)
> >                              |_ (xfs_caddr_t)((agbp)->b_addr) : but 
> > here, agbp is NULL
> > so it caused the oops.
> > Non debug option, and the oops occured at xfs_btree_init_cursor().
> > 
> 
> Probably caused by this part of the diff from Nathan's earlier mail:

*nod* - that is my suspicion, be great if you guys with the
reproducible case could confirm/deny.. (assuming this is the
case we're hitting, you can also try changing the assignment
to NULL there to instead be "agbp", and see if that corrects
things for you once more).

> --- fs/xfs/xfs_alloc.c
> +++ fs/xfs/xfs_alloc.c
> 
> @@ -1951,8 +1951,14 @@ xfs_alloc_fix_freelist(
>   		 * the restrictions correctly.  Can happen for free calls
>   		 * on a completely full ag.
>   		 */
> -		if (targs.agbno == NULLAGBLOCK)
> +		if (targs.agbno == NULLAGBLOCK) {
> +			if (!(flags & XFS_ALLOC_FLAG_FREEING)) {
> +				xfs_trans_brelse(tp, agflbp);
> +				args->agbp = NULL;
> +				return 0;
> +			}
>   			break;
> +		}

cheers.

-- 
Nathan
