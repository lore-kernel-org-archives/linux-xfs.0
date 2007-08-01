Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 01 Aug 2007 05:56:03 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l71Ctpbm018177
	for <xfs@oss.sgi.com>; Wed, 1 Aug 2007 05:55:55 -0700
Date: Wed, 1 Aug 2007 14:55:54 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] stop using uio in the readlink code
Message-ID: <20070801125554.GA27199@lst.de>
References: <20070729211354.GB12824@lst.de> <20070801054142.GT31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801054142.GT31489@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Aug 01, 2007 at 03:41:42PM +1000, David Chinner wrote:
> Do we really need to copy this code? I guess it doesn't really
> matter that much but it would be nice not to have to copy an
> exported vfs function just because we don't have a dentry...

I was wondering whether to send a patch to fix and export the VFS
function afterwards, but I really don't want a an xfs patch like
this to have a VFS change depency to start with.  Especially as I
want to change the name of the helper in namei.c aswell - the vfs_
prefix is completely wrong.
