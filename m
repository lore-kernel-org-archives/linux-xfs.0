Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Mar 2008 02:02:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2E92GAb011701
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 02:02:18 -0700
Received: from wx-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FA55F9C3AD
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 02:02:45 -0700 (PDT)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.230]) by cuda.sgi.com with ESMTP id tyjzxecJBNkfAsBV for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 02:02:45 -0700 (PDT)
Received: by wx-out-0506.google.com with SMTP id s9so3919374wxc.32
        for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 02:02:44 -0700 (PDT)
Message-ID: <1a4a774c0803140202r1ce10755hf1b679a02f30e7de@mail.gmail.com>
Date: Fri, 14 Mar 2008 10:02:44 +0100
From: "=?ISO-8859-1?Q?Christian_R=F8snes?=" <christian.rosnes@gmail.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c
In-Reply-To: <20080313145349.GJ95344431@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080311122103.GP155407@sgi.com> <20080312232425.GR155407@sgi.com>
	 <1a4a774c0803130114l3927051byd54cd96cdb0efbe7@mail.gmail.com>
	 <20080313090830.GD95344431@sgi.com>
	 <1a4a774c0803130214x406a4eb9wfb8738d1f503663f@mail.gmail.com>
	 <20080313092139.GF95344431@sgi.com>
	 <1a4a774c0803130227l2fdf4861v21183b9bd3e7ce8d@mail.gmail.com>
	 <20080313113634.GH95344431@sgi.com>
	 <1a4a774c0803130446x609b9cb2mf3da323183c35606@mail.gmail.com>
	 <20080313145349.GJ95344431@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Thu, Mar 13, 2008 at 3:53 PM, David Chinner <dgc@sgi.com> wrote:

>  The patch below fixes the shutdown for me. Can you give it a go?
>
>
>  Cheers,
>
>  Dave.
>  --
>  Dave Chinner
>  Principal Engineer
>  SGI Australian Software Group
>
>
>  ---
>   fs/xfs/xfs_ialloc.c |    7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
>  Index: 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c
>  ===================================================================
>  --- 2.6.x-xfs-new.orig/fs/xfs/xfs_ialloc.c      2008-03-13 13:07:24.000000000 +1100
>  +++ 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c   2008-03-14 01:40:21.926153338 +1100
>  @@ -167,7 +167,12 @@ xfs_ialloc_ag_alloc(
>
>                 args.mod = args.total = args.wasdel = args.isfl =
>                         args.userdata = args.minalignslop = 0;
>                 args.prod = 1;
>  -               args.alignment = 1;
>  +               if (xfs_sb_version_hasalign(&args.mp->m_sb) &&
>
> +                       args.mp->m_sb.sb_inoalignmt >=
>  +                       XFS_B_TO_FSBT(args.mp, XFS_INODE_CLUSTER_SIZE(args.mp)))
>  +                               args.alignment = args.mp->m_sb.sb_inoalignmt;
>  +               else
>  +                       args.alignment = 1;
>
>
>                 /*
>                  * Allow space for the inode btree to split.
>                  */
>

Yes. This patch fixes the shutdown problem for me too.

Once again, thanks.

Christian
