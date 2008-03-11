Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Mar 2008 05:39:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2BCdLpd014335
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 05:39:22 -0700
Received: from rn-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 99346F626BE
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 05:39:49 -0700 (PDT)
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.189]) by cuda.sgi.com with ESMTP id 2ZO8NEDnyNIiVKKw for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 05:39:49 -0700 (PDT)
Received: by rn-out-0910.google.com with SMTP id a43so1585563rne.10
        for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 05:39:48 -0700 (PDT)
Message-ID: <1a4a774c0803110539s129fd2am86e933a03cdd1b18@mail.gmail.com>
Date: Tue, 11 Mar 2008 13:39:48 +0100
From: "=?ISO-8859-1?Q?Christian_R=F8snes?=" <christian.rosnes@gmail.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c
In-Reply-To: <20080311122103.GP155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <1a4a774c0803050553h7f6294cfq41c38f34ea92ceae@mail.gmail.com>
	 <1a4a774c0803070319j1eb8790ek3daae4a16b3e6256@mail.gmail.com>
	 <20080310000809.GU155407@sgi.com>
	 <1a4a774c0803100302y17530814wee7522aa0dfd7668@mail.gmail.com>
	 <1a4a774c0803100134k258e1bcfma95e7969bc44b2af@mail.gmail.com>
	 <20080310222135.GZ155407@sgi.com>
	 <1a4a774c0803110108u3f01813fs7f9540f886be055@mail.gmail.com>
	 <20080311093406.GN155407@sgi.com>
	 <1a4a774c0803110419n645da456leaedd98593300726@mail.gmail.com>
	 <20080311122103.GP155407@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 11, 2008 at 1:21 PM, David Chinner <dgc@sgi.com> wrote:
> On Tue, Mar 11, 2008 at 12:19:29PM +0100, Christian Røsnes wrote:
>  > On Tue, Mar 11, 2008 at 10:34 AM, David Chinner <dgc@sgi.com> wrote:
>  > >
>  > > On Tue, Mar 11, 2008 at 09:08:31AM +0100, Christian Røsnes wrote:
>  >
>  > >  > I'll try to add some printk statements to the codepaths you mentioned,
>  > >  > and see where it leads.
>  > >
>  > >  Definitely worth confirming this is where the error is coming from.
>  > >
>  >
>  >       if (tagno == agno) {
>  >                       printk("XFS: xfs_dialloc:0021\n");
>  >                       *inop = NULLFSINO;
>  >                       return noroom ? ENOSPC : 0;
>  >               }
>  >
>  > seems to be what triggers this inside xfs_dialloc.
>  >
>  > Here a trace which give some indication to the codepath taken inside
>  > xfs_dialloc (xfs_ialloc.c):
>
>  Yup, that's trying to allocate in each AG and failing. Almost certainly
>  the problem is the described alignment issue.
>
>  FYI, I'm travelling tomorrow so I won't really get a chance to look
>  at this more until thursday....
>

Ok. Thanks again for all your help so far in tracking this down.

Here's the codepath taken within xfs_ialloc_ag_alloc (xfs_ialloc.c):

mount:
/dev/sdb1 on /data type xfs (rw,noatime,logbufs=8,nobarrier)

# mkdir /data/test
mkdir: cannot create directory `/data/test': No space left on device

Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0001
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0003
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0004
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0007
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0008
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0011
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0012
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0014
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0015
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0016
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0017
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0020
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0021
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0001
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0003
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0004
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0007
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0008
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0011
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0012
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0014
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0015
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0016
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0017
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0020
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0021
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0001
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0003
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0004
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0007
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0008
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0011
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0012
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0014
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0015
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0016
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0017
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0020
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0021
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0001
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0003
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0004
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0007
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0008
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0011
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0012
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0014
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0015
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0016
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0017
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0020
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0021
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0001
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0003
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0004
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0007
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0008
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0011
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0012
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0014
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0015
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0016
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0017
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0020
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0021
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0001
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0003
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0004
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0007
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0008
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0011
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0012
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0014
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0015
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0016
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0017
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0020
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0021
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0001
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0003
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0004
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0007
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0008
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0011
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0012
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0014
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0015
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0016
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0017
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0020
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0021
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0001
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0003
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0004
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0007
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0008
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0011
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0012
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0014
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0015
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0016
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0017
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0020
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0021
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0001
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0003
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0004
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0007
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0008
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0011
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0012
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0014
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0015
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0016
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0017
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0020
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0021
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0001
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0003
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0004
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0007
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0008
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0011
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0012
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0014
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0015
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0016
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0017
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0020
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0021
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0001
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0003
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0004
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0007
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0008
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0011
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0012
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0014
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0015
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0016
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0017
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0020
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0021
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0001
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0003
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0004
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0007
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0008
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0011
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0012
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0014
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0015
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0016
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0017
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0020
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0021
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0001
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0003
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0004
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0007
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0008
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0011
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0012
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0014
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0015
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0016
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0017
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0020
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0021
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0001
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0003
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0004
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0007
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0008
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0011
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0012
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0014
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0015
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0016
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0017
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0020
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0021
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0001
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0003
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0004
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0007
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0008
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0011
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0012
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0014
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0015
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0016
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0017
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0020
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0021
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0001
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0003
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0004
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0007
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0008
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0011
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0012
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0014
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0015
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0016
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0017
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0020
Mar 11 13:27:44 linux kernel: XFS: xfs_ialloc_ag_alloc:0021
Mar 11 13:27:44 linux kernel: Filesystem "sdb1": XFS internal error
xfs_trans_cancel at line 1163 of file fs/xfs/xfs_trans.c.  Caller
0xc021a1f8
Mar 11 13:27:44 linux kernel: Pid: 5593, comm: mkdir Not tainted 2.6.24.3FC #10
Mar 11 13:27:44 linux kernel:  [<c0212860>] xfs_trans_cancel+0x5d/0xe6
Mar 11 13:27:44 linux kernel:  [<c021a1f8>] xfs_mkdir+0x45a/0x493
Mar 11 13:27:44 linux kernel:  [<c021a1f8>] xfs_mkdir+0x45a/0x493
Mar 11 13:27:44 linux kernel:  [<c01cbb8f>] xfs_acl_vhasacl_default+0x33/0x44
Mar 11 13:27:44 linux kernel:  [<c0222f58>] xfs_vn_mknod+0x165/0x243
Mar 11 13:27:44 linux kernel:  [<c0217d86>] xfs_access+0x2f/0x35
Mar 11 13:27:44 linux kernel:  [<c0223055>] xfs_vn_mkdir+0x12/0x14
Mar 11 13:27:44 linux kernel:  [<c016057b>] vfs_mkdir+0xa3/0xe2
Mar 11 13:27:44 linux kernel:  [<c0160644>] sys_mkdirat+0x8a/0xc3
Mar 11 13:27:44 linux kernel:  [<c016069c>] sys_mkdir+0x1f/0x23
Mar 11 13:27:44 linux kernel:  [<c01025ee>] syscall_call+0x7/0xb
Mar 11 13:27:44 linux kernel:  [<c03b0000>] proc_dodebug+0xc6/0x1e2
Mar 11 13:27:44 linux kernel:  =======================
Mar 11 13:27:44 linux kernel: xfs_force_shutdown(sdb1,0x8) called from
line 1164 of file fs/xfs/xfs_trans.c.  Return address = 0xc0212878
Mar 11 13:27:44 linux kernel: Filesystem "sdb1": Corruption of
in-memory data detected.  Shutting down filesystem: sdb1
Mar 11 13:27:44 linux kernel: Please umount the filesystem, and
rectify the problem(s)

/*
 * Allocate new inodes in the allocation group specified by agbp.
 * Return 0 for success, else error code.
 */
STATIC int				/* error code or 0 */
xfs_ialloc_ag_alloc(
	xfs_trans_t	*tp,		/* transaction pointer */
	xfs_buf_t	*agbp,		/* alloc group buffer */
	int		*alloc)
{
	xfs_agi_t	*agi;		/* allocation group header */
	xfs_alloc_arg_t	args;		/* allocation argument structure */
	int		blks_per_cluster;  /* fs blocks per inode cluster */
	xfs_btree_cur_t	*cur;		/* inode btree cursor */
	xfs_daddr_t	d;		/* disk addr of buffer */
	xfs_agnumber_t	agno;
	int		error;
	xfs_buf_t	*fbuf;		/* new free inodes' buffer */
	xfs_dinode_t	*free;		/* new free inode structure */
	int		i;		/* inode counter */
	int		j;		/* block counter */
	int		nbufs;		/* num bufs of new inodes */
	xfs_agino_t	newino;		/* new first inode's number */
	xfs_agino_t	newlen;		/* new number of inodes */
	int		ninodes;	/* num inodes per buf */
	xfs_agino_t	thisino;	/* current inode number, for loop */
	int		version;	/* inode version number to use */
	int		isaligned = 0;	/* inode allocation at stripe unit */
					/* boundary */

	args.tp = tp;
	args.mp = tp->t_mountp;
	printk("XFS: xfs_ialloc_ag_alloc:0001\n");

	/*
	 * Locking will ensure that we don't have two callers in here
	 * at one time.
	 */
	newlen = XFS_IALLOC_INODES(args.mp);
	if (args.mp->m_maxicount &&
	    args.mp->m_sb.sb_icount + newlen > args.mp->m_maxicount) {
		printk("XFS: xfs_ialloc_ag_alloc:0002\n");
		return XFS_ERROR(ENOSPC);
	}
	printk("XFS: xfs_ialloc_ag_alloc:0003\n");
	args.minlen = args.maxlen = XFS_IALLOC_BLOCKS(args.mp);
	/*
	 * First try to allocate inodes contiguous with the last-allocated
	 * chunk of inodes.  If the filesystem is striped, this will fill
	 * an entire stripe unit with inodes.
 	 */
	agi = XFS_BUF_TO_AGI(agbp);
	newino = be32_to_cpu(agi->agi_newino);
	args.agbno = XFS_AGINO_TO_AGBNO(args.mp, newino) +
			XFS_IALLOC_BLOCKS(args.mp);
	if (likely(newino != NULLAGINO &&
		  (args.agbno < be32_to_cpu(agi->agi_length)))) {
		printk("XFS: xfs_ialloc_ag_alloc:0004\n");
		args.fsbno = XFS_AGB_TO_FSB(args.mp,
				be32_to_cpu(agi->agi_seqno), args.agbno);
		args.type = XFS_ALLOCTYPE_THIS_BNO;
		args.mod = args.total = args.wasdel = args.isfl =
			args.userdata = args.minalignslop = 0;
		args.prod = 1;
		args.alignment = 1;
		/*
		 * Allow space for the inode btree to split.
		 */
		args.minleft = XFS_IN_MAXLEVELS(args.mp) - 1;
		if ((error = xfs_alloc_vextent(&args))) {
			printk("XFS: xfs_ialloc_ag_alloc:0005\n");
			return error;
		}
	} else {
		printk("XFS: xfs_ialloc_ag_alloc:0006\n");
		args.fsbno = NULLFSBLOCK;
	}

	if (unlikely(args.fsbno == NULLFSBLOCK)) {
		printk("XFS: xfs_ialloc_ag_alloc:0007\n");
		/*
		 * Set the alignment for the allocation.
		 * If stripe alignment is turned on then align at stripe unit
		 * boundary.
		 * If the cluster size is smaller than a filesystem block
		 * then we're doing I/O for inodes in filesystem block size
		 * pieces, so don't need alignment anyway.
		 */
		isaligned = 0;
		if (args.mp->m_sinoalign) {
			printk("XFS: xfs_ialloc_ag_alloc:0008\n");
			ASSERT(!(args.mp->m_flags & XFS_MOUNT_NOALIGN));
			args.alignment = args.mp->m_dalign;
			isaligned = 1;
		} else if (XFS_SB_VERSION_HASALIGN(&args.mp->m_sb) &&
			   args.mp->m_sb.sb_inoalignmt >=
			   XFS_B_TO_FSBT(args.mp,
			  	XFS_INODE_CLUSTER_SIZE(args.mp))) {
			printk("XFS: xfs_ialloc_ag_alloc:0009\n");
				args.alignment = args.mp->m_sb.sb_inoalignmt;
		}
		else {
			printk("XFS: xfs_ialloc_ag_alloc:0010\n");
			args.alignment = 1;
		}
		/*
		 * Need to figure out where to allocate the inode blocks.
		 * Ideally they should be spaced out through the a.g.
		 * For now, just allocate blocks up front.
		 */
		printk("XFS: xfs_ialloc_ag_alloc:0011\n");
		args.agbno = be32_to_cpu(agi->agi_root);
		args.fsbno = XFS_AGB_TO_FSB(args.mp,
				be32_to_cpu(agi->agi_seqno), args.agbno);
		/*
		 * Allocate a fixed-size extent of inodes.
		 */
		args.type = XFS_ALLOCTYPE_NEAR_BNO;
		args.mod = args.total = args.wasdel = args.isfl =
			args.userdata = args.minalignslop = 0;
		args.prod = 1;
		/*
		 * Allow space for the inode btree to split.
		 */
		args.minleft = XFS_IN_MAXLEVELS(args.mp) - 1;
		printk("XFS: xfs_ialloc_ag_alloc:0012\n");
		if ((error = xfs_alloc_vextent(&args))) {
			printk("XFS: xfs_ialloc_ag_alloc:0013\n");
			return error;
		}
		printk("XFS: xfs_ialloc_ag_alloc:0014\n");
	}
	printk("XFS: xfs_ialloc_ag_alloc:0015\n");

	/*
	 * If stripe alignment is turned on, then try again with cluster
	 * alignment.
	 */
	if (isaligned && args.fsbno == NULLFSBLOCK) {
		printk("XFS: xfs_ialloc_ag_alloc:0016\n");
		args.type = XFS_ALLOCTYPE_NEAR_BNO;
		args.agbno = be32_to_cpu(agi->agi_root);
		args.fsbno = XFS_AGB_TO_FSB(args.mp,
				be32_to_cpu(agi->agi_seqno), args.agbno);
		if (XFS_SB_VERSION_HASALIGN(&args.mp->m_sb) &&
			args.mp->m_sb.sb_inoalignmt >=
			XFS_B_TO_FSBT(args.mp, XFS_INODE_CLUSTER_SIZE(args.mp))) {
			printk("XFS: xfs_ialloc_ag_alloc:0017\n");
				args.alignment = args.mp->m_sb.sb_inoalignmt;
		}
		else {
			printk("XFS: xfs_ialloc_ag_alloc:0018\n");
			args.alignment = 1;
		}
		if ((error = xfs_alloc_vextent(&args))) {
			printk("XFS: xfs_ialloc_ag_alloc:0019\n");
			return error;
		}
	}
	printk("XFS: xfs_ialloc_ag_alloc:0020\n");

	if (args.fsbno == NULLFSBLOCK) {
		printk("XFS: xfs_ialloc_ag_alloc:0021\n");
		*alloc = 0;
		return 0;
	}
	printk("XFS: xfs_ialloc_ag_alloc:0022\n");
	ASSERT(args.len == args.minlen);
	/*
	 * Convert the results.
	 */
	newino = XFS_OFFBNO_TO_AGINO(args.mp, args.agbno, 0);
	/*
	 * Loop over the new block(s), filling in the inodes.
	 * For small block sizes, manipulate the inodes in buffers
	 * which are multiples of the blocks size.
	 */
	if (args.mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(args.mp)) {
		printk("XFS: xfs_ialloc_ag_alloc:0023\n");
		blks_per_cluster = 1;
		nbufs = (int)args.len;
		ninodes = args.mp->m_sb.sb_inopblock;
	} else {
		printk("XFS: xfs_ialloc_ag_alloc:0024\n");
		blks_per_cluster = XFS_INODE_CLUSTER_SIZE(args.mp) /
				   args.mp->m_sb.sb_blocksize;
		nbufs = (int)args.len / blks_per_cluster;
		ninodes = blks_per_cluster * args.mp->m_sb.sb_inopblock;
	}
	printk("XFS: xfs_ialloc_ag_alloc:0025\n");
	/*
	 * Figure out what version number to use in the inodes we create.
	 * If the superblock version has caught up to the one that supports
	 * the new inode format, then use the new inode version.  Otherwise
	 * use the old version so that old kernels will continue to be
	 * able to use the file system.
	 */
	if (XFS_SB_VERSION_HASNLINK(&args.mp->m_sb)) {
		printk("XFS: xfs_ialloc_ag_alloc:0026\n");
		version = XFS_DINODE_VERSION_2;
	}
	else {
		printk("XFS: xfs_ialloc_ag_alloc:0027\n");
		version = XFS_DINODE_VERSION_1;
	}

	for (j = 0; j < nbufs; j++) {
		printk("XFS: xfs_ialloc_ag_alloc:0028\n");
		/*
		 * Get the block.
		 */
		d = XFS_AGB_TO_DADDR(args.mp, be32_to_cpu(agi->agi_seqno),
				     args.agbno + (j * blks_per_cluster));
		fbuf = xfs_trans_get_buf(tp, args.mp->m_ddev_targp, d,
					 args.mp->m_bsize * blks_per_cluster,
					 XFS_BUF_LOCK);
		ASSERT(fbuf);
		ASSERT(!XFS_BUF_GETERROR(fbuf));
		/*
		 * Set initial values for the inodes in this buffer.
		 */
		xfs_biozero(fbuf, 0, ninodes << args.mp->m_sb.sb_inodelog);
		for (i = 0; i < ninodes; i++) {
			printk("XFS: xfs_ialloc_ag_alloc:0029\n");
			free = XFS_MAKE_IPTR(args.mp, fbuf, i);
			free->di_core.di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
			free->di_core.di_version = version;
			free->di_next_unlinked = cpu_to_be32(NULLAGINO);
			xfs_ialloc_log_di(tp, fbuf, i,
				XFS_DI_CORE_BITS | XFS_DI_NEXT_UNLINKED);
		}
		xfs_trans_inode_alloc_buf(tp, fbuf);
		printk("XFS: xfs_ialloc_ag_alloc:0030\n");
	}
	printk("XFS: xfs_ialloc_ag_alloc:0031\n");
	be32_add(&agi->agi_count, newlen);
	be32_add(&agi->agi_freecount, newlen);
	agno = be32_to_cpu(agi->agi_seqno);
	down_read(&args.mp->m_peraglock);
	args.mp->m_perag[agno].pagi_freecount += newlen;
	up_read(&args.mp->m_peraglock);
	agi->agi_newino = cpu_to_be32(newino);
	/*
	 * Insert records describing the new inode chunk into the btree.
	 */
	cur = xfs_btree_init_cursor(args.mp, tp, agbp, agno,
			XFS_BTNUM_INO, (xfs_inode_t *)0, 0);
	for (thisino = newino;
	     thisino < newino + newlen;
	     thisino += XFS_INODES_PER_CHUNK) {
		printk("XFS: xfs_ialloc_ag_alloc:0032\n");
		if ((error = xfs_inobt_lookup_eq(cur, thisino,
				XFS_INODES_PER_CHUNK, XFS_INOBT_ALL_FREE, &i))) {
			printk("XFS: xfs_ialloc_ag_alloc:0033\n");
			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
			return error;
		}
		printk("XFS: xfs_ialloc_ag_alloc:0034\n");
		ASSERT(i == 0);
		if ((error = xfs_inobt_insert(cur, &i))) {
			printk("XFS: xfs_ialloc_ag_alloc:0035\n");
			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
			return error;
		}
		ASSERT(i == 1);
		printk("XFS: xfs_ialloc_ag_alloc:0036\n");
	}
	printk("XFS: xfs_ialloc_ag_alloc:0037\n");
	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
	/*
	 * Log allocation group header fields
	 */
	xfs_ialloc_log_agi(tp, agbp,
		XFS_AGI_COUNT | XFS_AGI_FREECOUNT | XFS_AGI_NEWINO);
	/*
	 * Modify/log superblock values for inode count and inode free count.
	 */
	xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, (long)newlen);
	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, (long)newlen);
	*alloc = 1;
	printk("XFS: xfs_ialloc_ag_alloc:0038\n");
	return 0;
}




Christian
