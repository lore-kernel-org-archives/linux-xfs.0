Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Aug 2008 16:44:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7BNisD4024621
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 16:44:55 -0700
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 077BA383C3C
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 16:46:10 -0700 (PDT)
Received: from postoffice2.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id DQHRjJZfUflgPzxY for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 16:46:10 -0700 (PDT)
Subject: Re: xfs_quota: Getting back disk space usage of a single directory
From: Nathan Scott <nscott@aconex.com>
In-Reply-To: <48A001FF.8030701@advantage-interactive.com>
References: <48A001FF.8030701@advantage-interactive.com>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 09:44:28 +1000
Message-Id: <1218498268.4794.3.camel@verge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Asfand Yar Qazi <asfand_yar.qazi@advantage-interactive.com>
Cc: xfs@oss.sgi.com

On Mon, 2008-08-11 at 10:10 +0100, Asfand Yar Qazi wrote:
> 
> 
> 
> 
> Hi,
> 
> If I have an XFS mount that contains many directories, each one 
> project-quotaed, how can I use xfs_quota to get back the amount of 
> quota used by just one directory?

Your question doesnt actually make sense... I assume you mean:
- you have recursively set different project IDs on multiple
top level directories
- you would like to know space used by just one directory tree
(project)?

> I know I can use xfs_quota -x -c quot -p /blah to get back quota
> usages 
> for all projects in that mount, but I want to get back just one.

Definately don't use the "quot" command, that simply bulkstats the
entire filesystem and reports on space used.  Use the "quota" or
"report" commands with the particular directory tree (project) you
are interested in.

cheers.

--
Nathan
