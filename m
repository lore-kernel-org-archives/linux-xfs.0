Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Jun 2008 20:55:17 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5A3t1in019648
	for <xfs@oss.sgi.com>; Mon, 9 Jun 2008 20:55:05 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 42BFA17A497D
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2008 20:55:55 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id aqZtYbTE8GsHSMzd for <xfs@oss.sgi.com>; Mon, 09 Jun 2008 20:55:55 -0700 (PDT)
Date: Tue, 10 Jun 2008 13:55:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: readdir() ordering guarantees on XFS
Message-ID: <20080610035547.GZ10720@disturbed>
References: <200806061634.13990.dizzy@roedu.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806061634.13990.dizzy@roedu.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: dizzy <dizzy@roedu.net>
Cc: xfs@oss.sgi.com

On Fri, Jun 06, 2008 at 04:34:13PM +0300, dizzy wrote:
> Hello
> 
> POSIX leaves unspecified the order of getting the entries with readdir(). This 
> is normal since different filesystems may implement their own techniques to 
> organize entries in a directory (linear, hash, various search trees, etc).
> 
> But if I can makes sure that several Linux machines will have the same FS (ie 
> XFS), mount options and same kernels can assume that traversing the same file 
> hierarchy structure (that is a file structure with the exact same directories 
> and files as names, structure, attributes, except maybe "ctime" which we 
> can't really control in Linux) can I expect that traversing using readdir() 
> will give me the entries in the exact same order?

No. For speed I suggest sorting the inode stat() calls in ascending
inode number order before issuing them. Also, perhaps you should
look at:

http://oss.oracle.com/~mason/acp/

To see if you can use similar techniques to speed directory
traversal.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
