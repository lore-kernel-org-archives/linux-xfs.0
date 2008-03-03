Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Mar 2008 03:23:32 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m25BNC0D004294
	for <xfs@oss.sgi.com>; Wed, 5 Mar 2008 03:23:13 -0800
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 195C7655182
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2008 03:23:38 -0800 (PST)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id lhBubU0wHu92GdqJ for <xfs@oss.sgi.com>; Wed, 05 Mar 2008 03:23:38 -0800 (PST)
Date: Mon, 3 Mar 2008 15:31:43 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: disappearing xfs partition
Message-ID: <20080303203143.GA21086@josefsipek.net>
References: <e03b90ae0803030514v585249ecjf93af325287b59f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e03b90ae0803030514v585249ecjf93af325287b59f@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeff Breidenbach <jeff@jab.org>
Cc: xfs@oss.sgi.com

On Mon, Mar 03, 2008 at 05:14:38AM -0800, Jeff Breidenbach wrote:
...
> # dpkg -l xfsprogs
> Desired=Unknown/Install/Remove/Purge/Hold
> | Status=Not/Installed/Config-f/Unpacked/Failed-cfg/Half-inst/t-aWait/T-pend
> |/ Err?=(none)/Hold/Reinst-required/X=both-problems (Status,Err: uppercase=bad)
> ||/ Name           Version        Description
> +++-==============-==============-============================================
> ii  xfsprogs       2.9.5-1        Utilities for managing the XFS filesystem

As others have already pointed out, the problem you have is not with XFS,
but probably with udev.

You may want to upgrade your xfsprogs. Version 2.9.5 has a buggy mkfs (the
fs it makes uses only about 3/4 of the partition).

Josef 'Jeff' Sipek.

-- 
Computer Science is no more about computers than astronomy is about
telescopes.
		- Edsger Dijkstra
