Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 10:58:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5IHw5jr013796
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 10:58:05 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C1C6A247BD1
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 10:59:03 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id H0kLNQkUwhYvPRgY for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 10:59:03 -0700 (PDT)
Message-ID: <48594CE6.1080209@sandeen.net>
Date: Wed, 18 Jun 2008 12:59:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: is the flush-on-close-after-truncate still needed?
References: <4859415B.3000009@sandeen.net> <200806181049.07812.dchinner@agami.com>
In-Reply-To: <200806181049.07812.dchinner@agami.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <dchinner@agami.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Wednesday 18 June 2008 10:09 am, Eric Sandeen wrote:
>> After Lachlan's fix to separate on-disk and in-memory sizes, and only
>> update on-disk when data is on-disk
>> (http://www.linux.sgi.com/archives/xfs/2007-05/msg00020.html) is the
>> XFS_ITRUNCATED flag / flush-on-close-after-truncate still needed?
> 
> Yes, because waiting 30s before writing back /etc/fstab after it
> has been modified will result in lots of bug reports of /etc/fstab
> being zero length after a crash instead of being full of NULLs.
> We have had very few reports of zero length files or files with
> NULLs since this change was made (regardless of the file size 
> update ordering changes). i.e. if we remove this code then the
> common case where NULL files occurred will return - only this
> time as zero length files.

Ah, right.  Ok, thanks!

-Eric

> Cheers,
> 
> Dave.
> 
