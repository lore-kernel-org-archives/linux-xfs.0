Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Nov 2006 10:10:54 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kADIAlaG008780
	for <xfs@oss.sgi.com>; Mon, 13 Nov 2006 10:10:47 -0800
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 548D4D1D011F
	for <xfs@oss.sgi.com>; Mon, 13 Nov 2006 10:09:58 -0800 (PST)
Message-ID: <4558B4DC.3050406@sandeen.net>
Date: Mon, 13 Nov 2006 12:09:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: RHEL 4 Compatible Kernel Module Code
References: <1163434210.25484.14.camel@houuc8>
In-Reply-To: <1163434210.25484.14.camel@houuc8>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Stephen C. Rigler" <srigler@marathonoil.com>
Cc: xfs@oss.sgi.com

Stephen C. Rigler wrote:
> Greetings,
> 
> We are using CentOS 4.4 along with the RHEL 4 compatible kernel modules
> (downloadable here:
> http://mirror.centos.org/centos/4.4/centosplus/x86_64/RPMS/).
> 
> According to the CentOS mailing list, the person at SGI who had been
> backporting the xfs code for RHEL4/CentOS4 has left the company.
> 
> Are there any plans to continue this work?  It seems like we are getting
> bit by this bug: http://oss.sgi.com/bugzilla/show_bug.cgi?id=410 but it
> doesn't look like the fix has been backported to the RHEL4 kernel
> module.

Hot topic today; see my reply on the centos list and other recent
threads on this list :)  I am planning to update the rpm package to
include some bugfixes soon, but it may not help your problems.

I had been tracking the sles9 xfs codebase as a fairly stable,
bugfix-only xfs codebase for this era of kernels; at this point I don't
-think- the extent changes you mentioned are in the sles9 codebase...
sgi guys?

It looks like you actually got a double-whammy; you probably have a very
fragmented file, which caused a large memory allocation on read, which
recursed into the filesystem, thereby blowing your stack (on x86_64!)
near as I can tell.  finding & defragging the fragmented source files
may be your best bet for now. To avoid it in the future, perhaps you can
use preallocation, if you have any control over the app which is writing
these.

For those interested, the original bug report was:
 http://lists.centos.org/pipermail/centos/2006-November/072221.html

-Eric
