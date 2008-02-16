Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Feb 2008 23:19:38 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1G7JWcC004136
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 23:19:34 -0800
Date: Sat, 16 Feb 2008 08:19:39 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] use generic ACL code
Message-ID: <20080216071939.GA10578@lst.de>
References: <20080207083222.GA14317@lst.de> <47B3C701.6090409@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B3C701.6090409@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com, a.gruenbacher@computer.org

On Thu, Feb 14, 2008 at 03:43:45PM +1100, Timothy Shimmin wrote:
> Hi Christoph,
> 
> Been going thru some v4 acl code but a couple of comments:
> 
> (1) it looks like you decided that an xfs_iget_acl and xfs_iset_acl
> (basing on the ext3 code of Andreas)
> are not worth it and you'd prefer to do the code directly.

I was actually looking at jfs because I was involved with the creation
of that code and it seemed a tad cleaner than ext2/ext3.  I'm not
sure we want the helpers, but we might need the locking in there.
