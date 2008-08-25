Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Aug 2008 11:56:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7PIulV3010797
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 11:56:47 -0700
Received: from mx1.myoutlookonlinE.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 613A7FB4CEA
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 11:58:09 -0700 (PDT)
Received: from mx1.myoutlookonlinE.com (mx1.myoutlookonline.com [69.25.74.52]) by cuda.sgi.com with ESMTP id mGYtVUL38pgCVOWT for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 11:58:09 -0700 (PDT)
From: Allan Haywood <ahaywood@datallegro.com>
Date: Mon, 25 Aug 2008 14:58:06 -0400
Subject: RE: XFS internal error
Message-ID: <C87F050B4C904F44803B22B2F1B67A4462A4D93F@BE181.mail.lan>
References: <470831E6.4030704@fastmail.co.uk>
 <20071008001452.GX995458@sgi.com> <20080310122216.GG14256@slop.flatline.de>
 <20080310223018.GA155407@sgi.com> <20080310225927.GP14256@slop.flatline.de>
 <20080310234539.GC155407@sgi.com> <20080311134746.GQ14256@slop.flatline.de>
 <20080312175050.GD14256@slop.flatline.de> <20080313000121.GU155407@sgi.com>
 <20080313071445.GA30874@slop.flatline.de>
 <20080313071744.GB30874@slop.flatline.de>
In-Reply-To: <20080313071744.GB30874@slop.flatline.de>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andreas Kotes <count@flatline.de>, David Chinner <dgc@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


Sorry for top posting on this reply, but I was wondering if there was any resolution to your problem below. We seem to be running into a similar problem. A few hours before the error in this thread occurred the filesystem was filled up to 100%, we had to clean things up to continue running.

Any additional information would be great.

Thanks.

-Allan Haywood

-----Original Message-----
From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] On Behalf Of Andreas Kotes
Sent: Thursday, March 13, 2008 12:18 AM
To: David Chinner
Cc: xfs@oss.sgi.com
Subject: Re: XFS internal error

Hello,

* Andreas Kotes <count@flatline.de> [20080313 08:14]:
> * David Chinner <dgc@sgi.com> [20080313 01:01]:
> > On Wed, Mar 12, 2008 at 06:50:50PM +0100, Andreas Kotes wrote:
> > > * Andreas Kotes <count-linux@flatline.de> [20080311 14:47]:
> > > > I basically build a PXE image which does an xfs_repair -L /dev/sda2 from
> > > > initrd - and the problem persists. Sigh. Exactly no change.
> >
> > Do you do this on every boot?
>
> no, I did this on a6b and a7b so far, where the problems I mentioned
> occur, and only after I saw these in-memory problems. in general, XFS
> proves to be realiable for us.
>
> would you recommend running an xfs_check before running an xfs_repair in
> case of problems?

oh, btw - running xfs_check doesn't work most of the time, as the log
usually contains entries, and isn't replayed before shutdown ..

I figure running this on every boot would leave me killing my log all of
the time, if the shutdown didn't leave time to write the changes to
disk? ;)

   Andreas

--
flatline IT services - Andreas Kotes - Tailored solutions for your IT needs
