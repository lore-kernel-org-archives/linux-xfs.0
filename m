Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Sep 2006 19:05:26 -0700 (PDT)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8F259Zd016517
	for <xfs@oss.sgi.com>; Thu, 14 Sep 2006 19:05:19 -0700
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with SMTP id k8E1vFnx024243
	for <xfs@oss.sgi.com>; Wed, 13 Sep 2006 20:57:17 -0500
Message-Id: <200609140157.LAA22186@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: Bug#387057: xfsprogs: repeated xfs_repair does not fix the filesystem
Date: Thu, 14 Sep 2006 12:03:28 +1000
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <87zmd4jdzz.fsf@tac.ki.iif.hu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Ferenc Wagner' <wferi@niif.hu>
Cc: xfs@oss.sgi.com

 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Ferenc Wagner
> Sent: Wednesday, 13 September 2006 7:46 PM
> To: Nathan Scott
> Cc: 387057@bugs.debian.org; xfs@oss.sgi.com
> Subject: Re: Bug#387057: xfsprogs: repeated xfs_repair does 
> not fix the filesystem
> 
> 
> Still, xfs_check reported:
> => link count mismatch for inode 400254 (name ?), nlink 0, counted 2
> => link count mismatch for inode 4239409 (name ?), nlink 0, counted 2
> => link count mismatch for inode 8388736 (name ?), nlink 39, 
> counted 38
> 
> Further runs of xfs_repair didn't bring any change.  On the root
> filesystem the results are much the same, but xfs_check reports:
> => sb_ifree 3042, counted 3041
> 
> I read that xfs_check is being obsoleted in the future, but not sure
> which program to trust.  Are my filesystems healthy or not?

This has been reported before, can you try running an older xfsprogs before
2.8.10 and see how that goes? I think with the dir2 fixes, the nlink stuff
might be a tad broken. I'll also look into it from my end.

Barry.
