Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 19:09:33 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA229SWT014054
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 19:09:30 -0700
Message-ID: <472A87FA.7000804@sandeen.net>
Date: Thu, 01 Nov 2007 21:14:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c
References: <06CCEA2EB1B80A4A937ED59005FA855101AED1BE@svits26.main.ad.rit.edu>
In-Reply-To: <06CCEA2EB1B80A4A937ED59005FA855101AED1BE@svits26.main.ad.rit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jay Sullivan <jpspgd@rit.edu>
Cc: xfs@oss.sgi.com

Jay Sullivan wrote:

> I ran xfs_repair -L on the FS and it could be mounted again, 

Was it not even mountable before this, or why did you use the -L flag? 
If the log is corrupted that points to more problems... perhaps you've 
had some power loss & your write caches evaporated, and lvm doesn't do 
barriers?

-eric
