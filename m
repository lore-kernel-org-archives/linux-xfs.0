Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40647 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751173AbdFEPIy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2017 11:08:54 -0400
Date: Mon, 5 Jun 2017 17:08:04 +0200
From: Greg KH <greg@kroah.com>
Subject: Re: 4.11-stable updates for XFS
Message-ID: <20170605150804.GA26743@kroah.com>
References: <20170603131511.25032-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170603131511.25032-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org

On Sat, Jun 03, 2017 at 03:14:48PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> below are backports up to (almost) 4.12-rc4 for XFS.  I've selected all
> clear bugfixes for reported bugs.  One patch is a little odd as it's a
> subset of a patch that went into mainline, which included a bit of
> infrastructure in addition to the new feature, and we only need the
> infrastructure for stable.  Also a fs/iomap.c fix for code only used
> by XFS is included.

Thanks for these, and the 4.9 backports.  I've now queued them all up
and taken a few of them where needed, for 4.4 and 3.18-stable trees, for
those poor people still stuck with those kernels :)

thanks,

greg k-h
