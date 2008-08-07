Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Aug 2008 10:44:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m77HiHxb020607
	for <xfs@oss.sgi.com>; Thu, 7 Aug 2008 10:44:17 -0700
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AAA4937390E
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2008 10:45:32 -0700 (PDT)
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.171]) by cuda.sgi.com with ESMTP id 47c72dCY1VKms56T for <xfs@oss.sgi.com>; Thu, 07 Aug 2008 10:45:32 -0700 (PDT)
Received: by wf-out-1314.google.com with SMTP id 26so481152wfd.32
        for <xfs@oss.sgi.com>; Thu, 07 Aug 2008 10:45:32 -0700 (PDT)
Message-ID: <cc7060690808071045id85c6b4s787401fe88acfa5e@mail.gmail.com>
Date: Thu, 7 Aug 2008 23:15:31 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: TAKE 981498 - Use KM_NOFS for debug trace buffers
In-Reply-To: <20080806210355.GS21635@disturbed>
MIME-Version: 1.0
References: <20080806061553.A8D8958C52A4@chook.melbourne.sgi.com>
	 <cc7060690808061012x43511581m15c794e72129becc@mail.gmail.com>
	 <20080806201957.GQ21635@disturbed> <20080806202746.GC6119@disturbed>
	 <20080806210355.GS21635@disturbed>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>, Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com

On Thu, Aug 7, 2008 at 2:33 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Aug 07, 2008 at 06:27:46AM +1000, Dave Chinner wrote:
> > On Thu, Aug 07, 2008 at 06:19:57AM +1000, Dave Chinner wrote:
> > > On Wed, Aug 06, 2008 at 10:42:15PM +0530, Bhagi rathi wrote:
> > > > I couldn't get a chance to read the diff's completely. If I click on
> > > > Lachlan's url for diff's, I couldn't access them. It looks to me that
> > > > the issue is not just with trace buffers. It can extend to
> xfs_iformat
> > > > as well. The same dead-lock can spring via
> > > >
> > > > xfs_iread -> xfs_iformat -> xfs_iformat_extents -> xfs_iext_add ->
> > > > xfs_iext_inline_to_direct -> which can do kmem_alloc with
> > > > KM_SLEEP flag.
> > >
> > > Fixed already:
> > >
> > >
> >
> > Hmmm. where did that url go? Try again:
>
> Ok, something is stripping URLs out of emails. I just sent that URL
> to myself and it wasn't stripped so it's not my mail infrastructure
> that is doing it.
>
> Did someone "upgrade" the spam filters on oss.sgi.com or the
> barracuda overnight?
>
> The link - minus the "http://" bit is:
>
>
> oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-2.6.git;a=commit;h=8c6266658cb76e282c14cb92f8ba5a1c674f4928
>

 The above just worked fine for me. Lachlan's  URL still have the same
issue.

 Cheers,
 Bhagi.

>
> <http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-2.6.git;a=commit;h=8c6266658cb76e282c14cb92f8ba5a1c674f4928>
>
> let's see if that gets stripped....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>


[[HTML alternate version deleted]]
