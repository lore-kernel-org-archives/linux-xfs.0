Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Feb 2007 06:35:42 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1KEZYm7001644
	for <xfs@oss.sgi.com>; Tue, 20 Feb 2007 06:35:35 -0800
Message-ID: <45DB0734.4060707@sandeen.net>
Date: Tue, 20 Feb 2007 08:35:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix bad quota inodes in the superblock causing xfs_repair
 to crash
References: <200702200753.SAA18328@larry.melbourne.sgi.com>
In-Reply-To: <200702200753.SAA18328@larry.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@melbourne.sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev@corp.sgi.com

Barry Naujok wrote:
> Thanks to Eric for generating bad images with fsfuzzer, bad quota inode
> values in the superblock caused xfs_repair to segfault. The patch checks the
> validity of the inodes before doing an internal lookup which assumes the
> numbers are valid before being called.
> 

Looks good to me Barry, thanks!  I'll see if I can find more corrupt 
images for you.  ;-)

-Eric
