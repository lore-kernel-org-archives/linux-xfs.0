Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 20 Oct 2006 10:17:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9KHHTaG014010
	for <xfs@oss.sgi.com>; Fri, 20 Oct 2006 10:17:30 -0700
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F3169D19E967
	for <xfs@oss.sgi.com>; Fri, 20 Oct 2006 10:16:45 -0700 (PDT)
Message-ID: <45390473.3080904@sandeen.net>
Date: Fri, 20 Oct 2006 12:16:35 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_ncheck gives outdated and partial result
References: <200610200858.08718.daniele@interline.it>
In-Reply-To: <200610200858.08718.daniele@interline.it>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Daniele P." <daniele@interline.it>
Cc: xfs@oss.sgi.com

Daniele P. wrote:
> Hi All,
> I'm here to ask a couple of question regarding xfs_ncheck.
> I'm using xfs_db version 2.6.20
> 
> The first question is:
> Is it right that I have to unmount/mount the filesystem before
> using it (1), or to get the partial right (3) answer?
> And why it's print only the first file name for inodes pointed
> by multiple files (2)?

I think Lachlan had good answers to your questions... I'm curious, are
you using xfs_ncheck on a mounted filesystem for any particular reason?
 It seems that maybe if you are concerned about the out-of-date info on
a mounted filesystem, maybe you are attempting to use this from a script
or something as part of a larger tool, and that may not be a good idea
in general.  xfs_ncheck, a wrapper around xfs_db, reads the block device
directly, and nothing in the kernel guarantees consistency between the
block device address space and the filesystem address space.

-Eric
