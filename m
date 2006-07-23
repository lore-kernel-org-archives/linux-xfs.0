Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 22 Jul 2006 20:37:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6N3b2DW009496
	for <xfs@oss.sgi.com>; Sat, 22 Jul 2006 20:37:02 -0700
Message-ID: <44C2EEC5.4020804@sandeen.net>
Date: Sat, 22 Jul 2006 22:36:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Userspace cp and ls utility
References: <44C0B0E4.7020403@l4x.org>
In-Reply-To: <44C0B0E4.7020403@l4x.org>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Dittmer <jdi@l4x.org>
Cc: xfs@oss.sgi.com

Jan Dittmer wrote:
> Are there utilities for xfs which are able to ls and
> cp from an _unmounted_ xfs volume? I fear that by
> mounting the volume - even ro - I would lose even more
> data.
> Or can I achieve such an effect with other xfs related
> utilities?

Mounting ro should be fine - if you also mount with "norecovery" then truly no 
IO should happen.  If you're really paranoid, find a utility to mark the block 
device itself as read-only, then you've taken it out of the filesystem's hands 
completely.

You could also try xfs_copy, it makes a copy of the filesystem and works on the 
underlying device, with the filesystem unmounted.  There's a man page for it.

-Eric
