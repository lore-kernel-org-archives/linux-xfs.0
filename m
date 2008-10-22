Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 14:18:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9MLIp6l021424
	for <linux-xfs@oss.sgi.com>; Wed, 22 Oct 2008 14:18:51 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9033210D1503
	for <linux-xfs@oss.sgi.com>; Wed, 22 Oct 2008 14:20:36 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id S5iFDDgeqDDJFmm5 for <linux-xfs@oss.sgi.com>; Wed, 22 Oct 2008 14:20:36 -0700 (PDT)
Date: Thu, 23 Oct 2008 08:20:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: does XFS supports hole punching ?
Message-ID: <20081022212034.GQ18495@disturbed>
References: <5d96567b0810221040m17d73871iff00d56bf07479c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d96567b0810221040m17d73871iff00d56bf07479c2@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Raz <raziebe@gmail.com>
Cc: linux-xfs@oss.sgi.com

On Wed, Oct 22, 2008 at 07:40:26PM +0200, Raz wrote:
> I want to punch  a hole in an exiting file.

Yes. Check the man page for xfsctl(3) and read up on
XFS_IOC_FREESP64.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
