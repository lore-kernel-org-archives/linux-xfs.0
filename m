Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jan 2008 09:29:22 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0NHTGM3011719
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 09:29:19 -0800
Received: from mail.purevideo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16AB2550649
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 09:29:36 -0800 (PST)
Received: from mail.purevideo.com (mail.purevideo.com [208.50.29.149]) by cuda.sgi.com with ESMTP id ymPyvpD3IyvOZwuC for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 09:29:36 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Repairing a possibly incomplete xfs_growfs command?
Date: Wed, 23 Jan 2008 09:24:17 -0800
Message-ID: <9CE70E6ED2C2F64FB5537A2973FA4F02535973@pvn-3001.purevideo.local>
In-Reply-To: <op.t5c3ubfg3jf8g2@pc-bnaujok.melbourne.sgi.com>
References: <9CE70E6ED2C2F64FB5537A2973FA4F0253595A@pvn-3001.purevideo.local> <20080117234604.GG155407@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253595B@pvn-3001.purevideo.local> <20080119004018.GH155407@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253596D@pvn-3001.purevideo.local> <op.t5c3ubfg3jf8g2@pc-bnaujok.melbourne.sgi.com>
From: "Mark Magpayo" <mmagpayo@purevideo.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com

> 
> Was it stuck on Phase 6 all that time? With only 1GB of RAM (from your
> meminfo output) and 18TB filesystem, Phases 3 and 4 will take a very
> long time due to swapping.

It's been stuck on Phase 6 since I came back to check on it on Monday.  


> 
> Phase 6 in your scenario should be relatively quick and light on
> memory usage (500MB as reported in your other email).
> 
> It is feasible it is deadlocked by trying to double-access a buffer,
> or access a buffer that wasn't released. This is an unlikely scenario,
> but it is possible.

Could I break out of the process here?  Seems like most of the repair
work has been done...  Then again, I imagine traversing the filesystem
is a pretty important step.

Are there any more phases after this by the way?

Thanks,

Mark
