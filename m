Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50077 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752035AbdBCUNo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Feb 2017 15:13:44 -0500
Date: Fri, 3 Feb 2017 21:13:42 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: update ctime and mtime on clone destinatation
        inodes
Message-ID: <20170203201342.GA8047@lst.de>
References: <20170203095715.7955-1-hch@lst.de> <20170203174541.GS9134@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170203174541.GS9134@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, amir73il@gmail.com

On Fri, Feb 03, 2017 at 09:45:41AM -0800, Darrick J. Wong wrote:
> Redundant is_dedupe tests here.
> 
> I also wonder if we really /want/ to emulate the existing btrfs
> behavior, which seems to be:
> 
> reflink: update mtime & ctime
> dedupe: do not update mtime or ctime
> 
> In particular, dedupe changes the inode metadata, which should qualify
> for a ctime update, right?

That depends on your metadata definition.  For Posix it's basically just
about stat data, and that doesn't change with dedupe.
