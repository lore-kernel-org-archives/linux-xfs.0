Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 16:15:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m33NFPpW014081
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 16:15:26 -0700
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CFC32911238
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2008 16:16:02 -0700 (PDT)
Received: from postoffice2.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id DWby4aovattWZ0NY for <xfs@oss.sgi.com>; Thu, 03 Apr 2008 16:16:02 -0700 (PDT)
Subject: Re: xfs_check running out of memory
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <4f52331f0804031611u30e706ddk10aa7a4d011df6a2@mail.gmail.com>
References: <4f52331f0804031556n1f00e435g3273c516aacc5d95@mail.gmail.com>
	 <1207263793.21048.150.camel@edge.scott.net.au>
	 <4f52331f0804031611u30e706ddk10aa7a4d011df6a2@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 10:16:00 +1100
Message-Id: <1207264560.21048.153.camel@edge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Fong Vang <sudoyang@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, 2008-04-03 at 16:11 -0700, Fong Vang wrote:
> 
> if that's the case then why is it running out of memory?  This is a
> 6.5TB file systems with millions of files.  The system has 24GB of
> RAM.  It needs to hold everything in memory?

xfs_check has 3 per-fs-block arrays that are held all in memory, IIRC.
Use xfs_repair -n, which has been revamped to scale a whole lot better
than check.

-- 
Nathan
