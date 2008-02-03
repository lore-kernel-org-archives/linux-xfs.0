Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Feb 2008 14:25:16 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m13MP9WE023401
	for <xfs@oss.sgi.com>; Sun, 3 Feb 2008 14:25:12 -0800
Date: Mon, 4 Feb 2008 09:25:25 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS oops in vanilla 2.6.24
Message-ID: <20080203222525.GX155407@sgi.com>
References: <fnqmbl$ubh$1@ultimate100.geggus.net> <1201778591.28547.291.camel@lappy> <20080203221326.GV155407@sgi.com> <20080203222034.GA7460@diesel.geggus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203222034.GA7460@diesel.geggus.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sven Geggus <lists@fuchsschwanzdomain.de>
Cc: xfs@oss.sgi.com

On Sun, Feb 03, 2008 at 11:20:34PM +0100, Sven Geggus wrote:
> David Chinner schrieb am Sonntag, den 03. Februar um 23:13 Uhr:
> 
> > How long after mount does this happen? Does it happen when listing a specific
> > directory? i.e. do you have a reproducable test case for it?
> 
> Well, it happens very soon after mounting the device. Typically when
> doing ls or something trivial like this. Unfortunately this is not
> really reproducable but it does happen reproducable on one specific
> device here sooner or later when booting into 2.6.24.

Ok. Can you use xfs_metadump to grab an image of the filesystem that you
are using to reproduce this and put it up somewhere on the web so I can
try to reproduce it locally?

> I run xfs-repair just to make shure that the filesystem is not
> corrupted. Works fine when booting 2.6.23.8 which I have been using
> before.

Good - that saves me from having to ask. ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
