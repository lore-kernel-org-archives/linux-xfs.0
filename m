Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56371 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750767AbdEBHfC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2017 03:35:02 -0400
Date: Tue, 2 May 2017 00:35:01 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_alloc_ag_vextent_near() takes minutes to complete
Message-ID: <20170502073501.GB6679@infradead.org>
References: <49A20782FA8B4C82B0393E5BEF8A8754@alyakaslap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A20782FA8B4C82B0393E5BEF8A8754@alyakaslap>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alex Lyakas <alex@zadarastorage.com>
Cc: linux-xfs@vger.kernel.org

On Mon, May 01, 2017 at 03:37:23PM +0300, Alex Lyakas wrote:
> [resending to proper list]
> 
> Greetings XFS community,
> 
> We have an XFS instance mounted as "sync"
> (rw,sync,noatime,wsync,attr2,discard,inode64,prjquota 0 0). This instance is
> exposed via nfsd. Size is about 50TB.

Don't use the sync option ever.  In fact we probably should remove it.

> Kernel version is 3.18.19.

Which is extremely outdate.  Please try latest mainline, or at least
4.9-stable which is long term supported.
