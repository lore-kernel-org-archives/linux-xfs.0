Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Aug 2007 07:59:50 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7VExi4p001946
	for <linux-xfs@oss.sgi.com>; Fri, 31 Aug 2007 07:59:47 -0700
Message-ID: <46D8277E.3000402@sandeen.net>
Date: Fri, 31 Aug 2007 09:36:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS Fails Quality Assurance Tests on ARM
References: <fb8s9c$t02$1@sea.gmane.org>
In-Reply-To: <fb8s9c$t02$1@sea.gmane.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Byron Bradley <byron.bbradley@gmail.com>
Cc: linux-xfs@oss.sgi.com

Byron Bradley wrote:

> esandeen in #xfs pointed me towards this bug,
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=414932 , and suggested
> that I compare the size and offset of stucts between x86 and ARM. After
> modifying over 40 structs to give them the same offsets as x86 the problem
> is still present. I have already tried the patch by Greg Ungerer from 2004
> but again this didn't change anything. I also tried compiling the kernel
> and userspace tools with an 8-bit structure size boundary but it made no
> difference.
> 
> Further details of my attempts are at
> http://www.linkstationwiki.net/index.php/Buffalo_ARM9_Kernel_Port#XFS_Arm_Issues
> . I will keep this up to date until we find a solution.

Can you put information up there about the structure alignment problems
you found, and the patch you tried?

-Eric

> Anybody got any ideas of how we fix this?
> 
> Thanks,
> 
