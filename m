Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jul 2008 01:15:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6E8FEB1007217
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 01:15:14 -0700
Received: from uplift.swm.pp.se (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B35762EAA0F
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 01:16:20 -0700 (PDT)
Received: from uplift.swm.pp.se (swm.pp.se [212.247.200.143]) by cuda.sgi.com with ESMTP id baZ1tc95x9DfGgwB for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 01:16:20 -0700 (PDT)
Date: Mon, 14 Jul 2008 10:16:19 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: xfs bug in 2.6.26-rc9
In-Reply-To: <20080714073035.GV29319@disturbed>
Message-ID: <alpine.DEB.1.10.0807141015010.30192@uplift.swm.pp.se>
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <20080711084248.GU29319@disturbed> <alpine.DEB.1.10.0807111215040.30192@uplift.swm.pp.se> <20080714073035.GV29319@disturbed>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, 14 Jul 2008, Dave Chinner wrote:

> Can you find the file it is failing on and run 'xfs_bmap -vvp <file>' to 
> just extract the extent map outside the context of xfs_fsr?

It's run twice without any errors now, so I guess I can't reproduce it 
anymore. If it happens again, how can I find out which file is causing the 
problem? I looked at the xfs_fsr man page and it didn't say much, would it 
help if I ran it in "-v" mode?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
