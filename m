Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 02 Jun 2007 17:26:04 -0700 (PDT)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l530PxWt002207
	for <xfs@oss.sgi.com>; Sat, 2 Jun 2007 17:26:00 -0700
Date: Sun, 3 Jun 2007 01:25:35 +0100 (BST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: Kernel 2.6.22-rc3 safe to migrate to?
In-Reply-To: <Pine.LNX.4.64.0706021855260.3376@p34.internal.lan>
Message-ID: <alpine.DEB.0.99.0706030115410.16496@sheep.housecafe.de>
References: <Pine.LNX.4.64.0706021723480.22318@p34.internal.lan>
 <4661F511.4070207@goop.org>
 <Pine.LNX.4.64.0706021855260.3376@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sat, 2 Jun 2007, Justin Piszcz wrote:
> On Sat, 2 Jun 2007, Jeremy Fitzhardinge wrote:
>> XFS currently has a data-corrupting bug, where files which were appended
>> by small amounts may lose their updates on umount - I see this
>> corrupting hg repos. There's a patch which works for me, and is in
>> 2.6.22-rc3-mm1, but it hasn't been merged upstream yet.

Just for the record, you mean this one:
http://lkml.org/lkml/2007/5/12/93   ..right? (haven't been bitten by 
this one...yet)

> Ah that's it- and USB appears to be broken as well, I'll stick with 2.6.21.3 
> for now.

Got any pointers? I'm using USB right now, one is i386 with 2.6.22-rc3, 
another one is powerpc, tracking -git and USB seems to work.

C.
-- 
BOFH excuse #15:

temporary routing anomaly
