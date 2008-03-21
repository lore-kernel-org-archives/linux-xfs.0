Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Mar 2008 11:03:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2LI3A2i021089
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 11:03:12 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C9E86D051B
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 11:03:42 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id jy4eiIOPoQZbSrgp for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 11:03:42 -0700 (PDT)
Date: Fri, 21 Mar 2008 14:03:38 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] kill mrlock_t
Message-ID: <20080321180338.GB5433@josefsipek.net>
References: <20080320093940.GA28966@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320093940.GA28966@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thu, Mar 20, 2008 at 10:39:40AM +0100, Christoph Hellwig wrote:
> XFS inodes are locked via the xfs_ilock family of functions which
> internally use a rw_semaphore wrapper into an abstraction called
> mrlock_t.  The mrlock_t should be purely internal to xfs_ilock functions
> but leaks through to the callers via various lock state asserts.
> 
> This patch:
> 
>  - adds new xfs_isilocked abstraction to make the lock state asserts
>    fits into the xfs_ilock API family
>  - opencodes the mrlock wrappers in the xfs_ilock family of functions
>  - makes the state tracking debug-only and merged into a single state
>    word
>  - remove superflous flags to the xfs_ilock family of functions
> 
> This kills 8 bytes per inode for non-debug builds, which would e.g.
> be the space for ACL caching on 32bit systems.
 
Nice. I do NOT see anything obviously wrong with the patch.

Josef 'Jeff' Sipek.

-- 
"Memory is like gasoline. You use it up when you are running. Of course you
get it all back when you reboot..."; Actual explanation obtained from the
Micro$oft help desk. 
