Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 05 Nov 2006 19:26:05 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kA63Q0aG001490
	for <xfs@oss.sgi.com>; Sun, 5 Nov 2006 19:26:01 -0800
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C6FA7D1BD719
	for <xfs@oss.sgi.com>; Sun,  5 Nov 2006 19:25:14 -0800 (PST)
Message-ID: <454EAB19.6060901@sandeen.net>
Date: Sun, 05 Nov 2006 21:25:13 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mount failed after xfs_growfs beyond 16 TB
References: <20061102172608.GA27769@pc51072.physik.uni-regensburg.de> <20061103004142.GI8394166@melbourne.sgi.com> <454B5833.9030008@sandeen.net> <FFDFD6610F310171562D474B@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <FFDFD6610F310171562D474B@timothy-shimmins-power-mac-g5.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Christian Guggenberger <christian.guggenberger@physik.uni-regensburg.de>, xfs@oss.sgi.com

Timothy Shimmin wrote:
> Good idea, Eric.
> I've created a pv.
> I noticed this was taken from xfs_mount_validate_sb() for the dblocks test.

yep

> I guess it would be nice to abstract this test in a macro for use in 
> multiple places.

yep, it'd just need to be refactored a bit to support data only & rt only (for 
growfs), while mount wants to check both at the same time.

-Eric

> 
> Cheers,
> Tim.
