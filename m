Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Mar 2008 11:06:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2LI6C3N021397
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 11:06:13 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73EE0FF89FA
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 11:06:45 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id cJGO5RCwKmz2AwyP for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 11:06:45 -0700 (PDT)
Date: Fri, 21 Mar 2008 14:06:43 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] cleanup root inode handling in xfs_fs_fill_super
Message-ID: <20080321180643.GC5433@josefsipek.net>
References: <20080319204724.GA24271@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319204724.GA24271@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Mar 19, 2008 at 09:47:24PM +0100, Christoph Hellwig wrote:
>  - rename rootvp to root for clarify
>  - remove useless vn_to_inode call
>  - check is_bad_inode before calling d_alloc_root
>  - use iput instead of VN_RELE in the error case
 
Looks good.

Josef 'Jeff' Sipek.

-- 
FORTUNE PROVIDES QUESTIONS FOR THE GREAT ANSWERS: #19
A:      To be or not to be.
Q:      What is the square root of 4b^2?
