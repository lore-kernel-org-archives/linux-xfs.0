Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n61Kpr8c037292 for <xfs@oss.sgi.com>; Wed, 1 Jul 2009 15:51:54 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 31084338DC2
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2009 13:52:25 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id nCRjoqoXLVw6mXLi for
	<xfs@oss.sgi.com>; Wed, 01 Jul 2009 13:52:25 -0700 (PDT)
Message-ID: <4A4BCC89.10202@sandeen.net>
Date: Wed, 01 Jul 2009 15:52:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Seg fault during xfs repair (segmentation fault / segv)
References: <4A4A596D.8030800@ssec.wisc.edu>
	<4A4A5C4E.7030605@sandeen.net>	<4A4A7D44.7040009@ssec.wisc.edu>
	<4A4BBECC.8000308@sandeen.net> <4A4BC83A.3080401@sandeen.net>
	<4A4BCC44.7050302@ssec.wisc.edu>
In-Reply-To: <4A4BCC44.7050302@ssec.wisc.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jesse Stroik <jstroik@ssec.wisc.edu>
Cc: xfs@oss.sgi.com

Jesse Stroik wrote:
> Eric,
> 
> Thanks for addressing the issue with xfs_repair.
> 
> 
>> that's one crunchy filesystem you've got there; what happened to it?
> 
> 
> It's not entirely clear -- the JBOD and SAS controller seem to have 
> gotten into inconsistent states and I was observing a few SCSI errors 
> for those particular LUNs.  While the system was exhibiting the SCSI 
> errors, the user of this file system (and a few others like it on the 
> host) noticed file corruption when reading/writing certain files, then 
> spontaneous corruption after making copies of the files.
> 
> I'll take a look at the new xfs_check and see what happens.
> 
> Best,
> Jesse
> 

Turns out that it runs to completion, but another run still finds
corruption.  And a debug build trips asserts, so I guess there are still
issues.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
