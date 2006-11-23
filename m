Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Nov 2006 15:56:30 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kANNuLaG003275
	for <xfs@oss.sgi.com>; Thu, 23 Nov 2006 15:56:22 -0800
Date: Fri, 24 Nov 2006 10:55:25 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS CORRUPTION 2.6.17.13?
Message-ID: <20061123235525.GD11034@melbourne.sgi.com>
References: <Pine.LNX.4.64.0611201459420.17165@p34.internal.lan> <1164231716.19915.68.camel@xenon.msp.redhat.com> <Pine.LNX.4.64.0611231139040.32343@p34.internal.lan> <20061123230744.GA11034@melbourne.sgi.com> <Pine.LNX.4.64.0611231816340.18083@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0611231816340.18083@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: David Chinner <dgc@sgi.com>, Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com

On Thu, Nov 23, 2006 at 06:18:00PM -0500, Justin Piszcz wrote:
> Ah,
> 
> I did not make a copy unfortunatley.

It was too much to hope for :/

> I used the default mkfs.xfs settings from Knoppix 4.0.2 I believe, 
> whatever version of xfsprogs it has for a 400GB drive.

Ok, so 256 byte inodes then. A single bad buffer write is possible
then.

> Any idea how it could have been 'trashed' in one way?  It appeared to 
> occur shortly after boot-up, which then a backup occurs (heavy I/O) to a 
> remote box via NFS.

No idea - I was hoping to get a clue by looking at the raw corrupted
data if you still had it around.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
