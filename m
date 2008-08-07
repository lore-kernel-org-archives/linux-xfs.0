Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Aug 2008 10:42:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m77HgkM0020196
	for <xfs@oss.sgi.com>; Thu, 7 Aug 2008 10:42:47 -0700
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D84CE124C9CF
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2008 10:44:00 -0700 (PDT)
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.173]) by cuda.sgi.com with ESMTP id d8cXTcvhG1L73thw for <xfs@oss.sgi.com>; Thu, 07 Aug 2008 10:44:00 -0700 (PDT)
Received: by wf-out-1314.google.com with SMTP id 26so480661wfd.32
        for <xfs@oss.sgi.com>; Thu, 07 Aug 2008 10:44:00 -0700 (PDT)
Message-ID: <cc7060690808071043r659aea9fn4e28959b3a62081e@mail.gmail.com>
Date: Thu, 7 Aug 2008 23:13:59 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: TAKE 981498 - Use KM_NOFS for debug trace buffers
In-Reply-To: <20080806201957.GQ21635@disturbed>
MIME-Version: 1.0
References: <20080806061553.A8D8958C52A4@chook.melbourne.sgi.com>
	 <cc7060690808061012x43511581m15c794e72129becc@mail.gmail.com>
	 <20080806201957.GQ21635@disturbed>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>, Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com

On Thu, Aug 7, 2008 at 1:49 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Aug 06, 2008 at 10:42:15PM +0530, Bhagi rathi wrote:
> > I couldn't get a chance to read the diff's completely. If I click on
> > Lachlan's url for diff's, I couldn't access them. It looks to me that
> > the issue is not just with trace buffers. It can extend to xfs_iformat
> > as well. The same dead-lock can spring via
> >
> > xfs_iread -> xfs_iformat -> xfs_iformat_extents -> xfs_iext_add ->
> > xfs_iext_inline_to_direct -> which can do kmem_alloc with
> > KM_SLEEP flag.
>
> Fixed already:
>
>
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-2.6.git;a=commit;h=8c6266658cb76e282c14cb92f8ba5a1c674f4928
>

 Thanks Dave. However, My concern is just not one allocation. We
 need to clean all allocations that can re-enter to file-system.
 I see that this issue exists in attributes format for i_afp allocations.
 It may exist with local format of data and attributes too.

 xfs_iread->xfs_iformat->xfs_iformat_local.

 Are we safe that we fixed all these real problems by looking
 into possible allocations that will enter into file-system? The
 problem with trace buffers is telling us to clean this code path.

 By the way, I browse the source code from lxr.linux.no.
 If I have to browse the latest xfs source code with linux
 kernel that is used at SGI, how can I do that?

 Cheers,
 Bhagi.

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>


[[HTML alternate version deleted]]
