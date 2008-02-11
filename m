Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Feb 2008 14:03:33 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1BM3Mnc016077
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 14:03:26 -0800
Date: Tue, 12 Feb 2008 09:03:39 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Data safety horror stories?
Message-ID: <20080211220339.GZ155407@sgi.com>
References: <1202748389.28320.1236240801@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202748389.28320.1236240801@webmail.messagingengine.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Felix E. Klee" <felix.klee@inka.de>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Feb 11, 2008 at 05:46:29PM +0100, Felix E. Klee wrote:
> I heard that, in case of a power failure, XFS may lose data, even data
> that was already existing on the disk. For example, I heard horror
> stories of files being overwritten with zeros.
> 
> Are those stories true?
> 
> If so:
> 
> * Do you recommend not using XFS on devices that may frequently fail due
>   to power failure?

Depends on how much you care about your system and data.

I use XFS on write-cache enabled SATA drives without barriers with
no UPS (yes, it's unsafe!) and I lose power at least once a week.  I
haven't had a data loss or corruption in over two years and tens of
power failures.... 

> * Is it possible to find out what files have been damaged?

Not easily.

> If not,
>   will only files be affected that have been changed during the last
>   couple of hours?

Last few seconds before the power fail, actually.

> * Are there options to increase data safety? Should one run a regular
>   "sync" in a cron job?

If you are truly paranoid - turn off drive caching and mount with
the 'wsync' option.

> * Is it unsafe to use XFS in a virtual machine which may sometimes be
>   terminated without proper shutdown?

I do that all the time, too. Corruption is rare and usually
as a result of some bug in the code I'm testing ;)

> I currently am using XFS under Ubuntu 7.10 (Kernel 2.6.22), running in a
> virtual machine (VMware) under Windows.  The XFS file system is in a
> native partition on a second HDD.

Should be just fine. If you are really concerned - test it.

Cheers,

Dave.
> 
> -- 
> Felix E. Klee
> Jabber/Google Talk: feklee@jabber.org, SIP: 9779619@sipgate.de
> ICQ: 158124695, Yahoo!: feklee, AIM: felix.klee@inka.de
> Gizmo: felixklee, Skype: felix.klee
> 

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
