Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43126 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751783AbdBBRsO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Feb 2017 12:48:14 -0500
Date: Thu, 2 Feb 2017 18:47:23 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: update ctime and mtime on clone destinatation
        inodes
Message-ID: <20170202174723.GA7760@lst.de>
References: <20170202162456.20574-1-hch@lst.de> <20170202174547.GN9134@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170202174547.GN9134@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Feb 02, 2017 at 09:45:47AM -0800, Darrick J. Wong wrote:
> On Thu, Feb 02, 2017 at 05:24:56PM +0100, Christoph Hellwig wrote:
> > We're changing both metadata and data, so we need to update the
> > timestamps.   This follows existing btrfs behavior.
> 
> /me wonders, should the mtime change if we're deduping?  We're
> definitely changing metadata, but we shouldn't be making any
> user-visible changes to the file data.

Good point - we're hitting this from the dedup path as well.
I think we should not be updating mtime for dedupe.
