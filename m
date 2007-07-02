Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Jul 2007 08:26:56 -0700 (PDT)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l62FQltL007800
	for <xfs@oss.sgi.com>; Mon, 2 Jul 2007 08:26:52 -0700
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-lvm] 2.6.22-rc5 XFS fails after hibernate/resume
Date: Mon, 2 Jul 2007 17:12:49 +0200
References: <46744065.6060605@dgreaves.com> <200707021608.56616.rjw@sisk.pl> <46890C7A.5040008@dgreaves.com>
In-Reply-To: <46890C7A.5040008@dgreaves.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707021712.50323.rjw@sisk.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: Tejun Heo <htejun@gmail.com>, David Chinner <dgc@sgi.com>, David Robinson <zxvdr.au@gmail.com>, LVM general discussion and development <linux-lvm@redhat.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>, LinuxRaid <linux-raid@vger.kernel.org>

On Monday, 2 July 2007 16:32, David Greaves wrote:
> Rafael J. Wysocki wrote:
> > On Monday, 2 July 2007 12:56, Tejun Heo wrote:
> >> David Greaves wrote:
> >>>> Tejun Heo wrote:
> >>>>> It's really weird tho.  The PHY RDY status changed events are coming
> >>>>> from the device which is NOT used while resuming
> >>> There is an obvious problem there though Tejun (the errors even when sda
> >>> isn't involved in the OS boot) - can I start another thread about that
> >>> issue/bug later? I need to reshuffle partitions so I'd rather get the
> >>> hibernate working first and then go back to it if that's OK?
> >> Yeah, sure.  The problem is that we don't know whether or how those two
> >> are related.  It would be great if there's a way to verify memory image
> >> read from hibernation is intact.  Rafael, any ideas?
> > 
> > Well, s2disk has an option to compute an MD5 checksum of the image during
> > the hibernation and verify it while reading the image.
> (Assuming you mean the mainline version)
> 
> Sounds like a good think to try next...
> Couldn't see anything on this in ../Documentation/power/*
> How do I enable it?

Add 'compute checksum = y' to the s2disk's configuration file.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
