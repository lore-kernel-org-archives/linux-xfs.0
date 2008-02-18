Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 14:50:42 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1IMoVEt032636
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 14:50:34 -0800
Date: Tue, 19 Feb 2008 09:50:43 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Data safety horror stories?
Message-ID: <20080218225043.GQ155407@sgi.com>
References: <1202748389.28320.1236240801@webmail.messagingengine.com> <20080211171209.GA7567@teal.hq.k1024.org> <1202764989.11126.1236296081@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202764989.11126.1236296081@webmail.messagingengine.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Felix E. Klee" <felix.klee@inka.de>
Cc: Iustin Pop <iusty@k1024.org>, xfs-oss <xfs@oss.sgi.com>

On Mon, Feb 11, 2008 at 10:23:09PM +0100, Felix E. Klee wrote:
> Hi Justin,
> 
> thanks for the info!
> 
> On Mon, 11 Feb 2008 18:12:09 +0100, "Iustin Pop" <iusty@k1024.org> said:
> > No, XFS will not lose any data that the application has committed to
> > the disk.
> 
> OK, but just to make sure: The following FAQ entry refers only to
> *newly* created files - right?
> 
> http://oss.sgi.com/projects/xfs/faq.html#nulls

No - it can affect an file where the write is extending the file.
The NULLs problem should be very rare now - we've fixed the common
causes of this problem....

> > Improperly written applications and/or improperly configured systems
> > might have issues with recently written files losing data.
> 
> Again, just to make sure that I understood you correctly: Could you name
> an example?

I suggest watching the video of this talk from the 2007 linux.conf.au:

http://lca2007.linux.org.au/talk/278.html

It's all about how applications do stupid stuff that can lose data.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
