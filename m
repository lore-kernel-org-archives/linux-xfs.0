Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Aug 2006 20:32:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k783VADW005009
	for <xfs@oss.sgi.com>; Mon, 7 Aug 2006 20:31:21 -0700
Date: Tue, 8 Aug 2006 13:30:05 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: XFS Bug null pointer dereference in xfs_free_ag_extent
Message-ID: <20060808133005.C2526901@wobbly.melbourne.sgi.com>
References: <44BF29CD.1000809@l4x.org> <44CB0BF7.6030204@idccenter.cn> <44CB1303.7010303@l4x.org> <20060731094424.E2280998@wobbly.melbourne.sgi.com> <44CDA156.6000105@idccenter.cn> <20060731165522.K2280998@wobbly.melbourne.sgi.com> <44CDB135.8080401@idccenter.cn> <20060731194310.A2301615@wobbly.melbourne.sgi.com> <44CDD5B9.8020608@idccenter.cn> <215036450607311849o43b1555br13ea2f3f20fb3b82@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <215036450607311849o43b1555br13ea2f3f20fb3b82@mail.gmail.com>; from lkmaillist@gmail.com on Tue, Aug 01, 2006 at 09:49:12AM +0800
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Joe Jin <lkmaillist@gmail.com>, "Tony.Ho" <linux@idccenter.cn>, jdi@l4x.org, Chris Seufert <seufert@gmail.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Tue, Aug 01, 2006 at 09:49:12AM +0800, Joe Jin wrote:
> >From the information, I think it caused by (args.agbp == NULL).
> get rid of, we'll find the call trace should panic:
> xfs_free_extent
> |_   xfs_free_ag_extent  => here args.agbp= NULL;
>         |_ xfs_btree_init_cursor()
>               |_ agf = XFS_BUF_TO_AGF(agbp);  => (xfs_agf_t
> *)XFS_BUF_PTR(arbp)
>                              |_ (xfs_caddr_t)((agbp)->b_addr) : but here,
> agbp is NULL
> so it caused the oops.

You've all reported this same issue - could any/all of you
try the patch here...
http://oss.sgi.com/archives/xfs/2006-08/msg00054.html

Let me know if that fixes it.  In particular, if you were able
to easily reproduce this before, I'd like to hear whether this
resolves things, as I've still not hit the bug myself.

cheers.

-- 
Nathan
