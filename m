Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 May 2008 06:45:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4KDjCX2022397
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 06:45:12 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9DF7F18FBF2
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 06:46:01 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 5F5QVrhzyrwMSbVD for <xfs@oss.sgi.com>; Tue, 20 May 2008 06:46:01 -0700 (PDT)
Message-ID: <4832D617.3030005@sandeen.net>
Date: Tue, 20 May 2008 08:45:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Adapted specfile to make kernel-module-xfs rpm build for a RHEL4
 largesmp kernel
References: <4832C9DD.6090700@erasmusmc.nl>
In-Reply-To: <4832C9DD.6090700@erasmusmc.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: m.vandenhout@erasmusmc.nl
Cc: xfs@oss.sgi.com

Mirjam van den Hout - van Vroonhoven wrote:
> Hello XFS team,
> 
> In order to make XFS work on Redhat Enterprise Linux 4, using the stock 
> RH largesmp kernel (our server has 16 CPU's) I had to adapt the spec 
> file for the kernel-module-xfs source rpm you offer for download at
> ftp://oss.sgi.com/projects/xfs/download/testing/RHEL4/kernel-module-xfs-2.6.9-22.EL-0.1-1.src.rpm
> 
> The issue is that largesmp was not recognized as a kernel type, and with 
> the original specfile an RPM was build with a dependency
> "requires kernel-smp = 2.6.9-67.0.1.ELlarge" where the dependency should 
> have been "requires kernel-largesmp = 2.6.9-67.0.1".
> 
> The fix was to add "largesmp" to the list of defined kernel_type at the 
> top of the .spec file. I also fixed a typo in this list (default instead 
> of deault). The new fixed spec file (kernel-module-xfs.spec), the 
> original spec file (kernel-module-xfs.spec.orig) and a diff between the 
> two (kernel-module-xfs.spec.patch are attached to this email.
> 
> For other users, it might be useful to include this in the next release.

SGI doesn't really maintain those; the xfs kernel modules in the
centosplus repository
(http://mirror.centos.org/centos/4/centosplus/Readme.txt) are probably a
better place to start, as they have some active users and a bit of
maintenance.

(IMHO a fair amount of stuff on the xfs ftp site is so outdated it
should be removed....)

-Eric

> 
> 				Kind regards,
> 
> 					Mirjam van den Hout
> 
