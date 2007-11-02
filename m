Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 22:18:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA25IdK9012755
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 22:18:41 -0700
Date: Fri, 2 Nov 2007 16:18:34 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c
Message-ID: <20071102051834.GM995458@sgi.com>
References: <3A2120EF-3EB0-4CF1-8C4E-920B9688D51F@rit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3A2120EF-3EB0-4CF1-8C4E-920B9688D51F@rit.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jay Sullivan <jpspgd@rit.edu>
Cc: xfs@oss.sgi.com

On Thu, Nov 01, 2007 at 10:08:09PM -0400, Jay Sullivan wrote:
> (Sorry if this is a dupe to the list; it has been a long day.)
> 
> I have an XFS filesystem that has had the following happen twice in 3  
> months, both times an impossibly large block number was requested.   
....

Sure sign of a corrupted btree.

> I ran xfs_repair –L on the FS and it could be mounted again, but how  
> long until it happens a third time?

<shrug>

What was the problem that xfs_repair fixed?

BTW, why did you run xfs_repair -L?

Also, when it happens next, what does xfs_check tell you is broken?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
