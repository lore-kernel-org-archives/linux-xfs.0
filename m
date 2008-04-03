Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 16:21:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m33NLh1a019927
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 16:21:45 -0700
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 54A8591135F
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2008 16:22:19 -0700 (PDT)
Received: from postoffice2.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id aFcZpYhdYsOVlXx9 for <xfs@oss.sgi.com>; Thu, 03 Apr 2008 16:22:19 -0700 (PDT)
Subject: Re: xfs_check running out of memory
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <4f52331f0804031556n1f00e435g3273c516aacc5d95@mail.gmail.com>
References: <4f52331f0804031556n1f00e435g3273c516aacc5d95@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 10:03:13 +1100
Message-Id: <1207263793.21048.150.camel@edge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Fong Vang <sudoyang@gmail.com>
Cc: xfs@oss.sgi.com


On Thu, 2008-04-03 at 15:56 -0700, Fong Vang wrote:
> 
> 
> 
> 
> xfs_check on one of my 64-bit server keeps running out of memory
> checking a
> 6.5TB file system with millions of files.  xfsprogs is version 2.9.4
> One of
> the man pages online mentions a xfs_check64 version but I can't seem
> to find
> this anyway.  Where can I find this tool?
> 

Thats an IRIX remnant.  On 64 bit Linux systems, xfs_db
(and hence xfs_check) will be built as 64 bit binaries.

Use xfs_repair -n, xfs_check does not scale (and will
hopefully be replaced by xfs_repair -n someday).

-- 
Nathan
