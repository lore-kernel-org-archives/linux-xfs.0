Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52711 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729029AbeLOKv5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 15 Dec 2018 05:51:57 -0500
Date: Sat, 15 Dec 2018 11:51:55 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] iomap: use SECTOR_SIZE instead of 512 in iomap_page
Message-ID: <20181215105155.GD1575@lst.de>
References: <1544739929-21651-1-git-send-email-sandeen@sandeen.net> <1544739929-21651-2-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1544739929-21651-2-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph@sandeen.net, Hellwig@sandeen.net, hch@lst.de

On Thu, Dec 13, 2018 at 04:25:27PM -0600, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> because iomap_page_create initializes the uptodate bitmap using the macro,
> not the open-coded value.

I find the use of SECTOR_SIZE rather confusing, especially as often
the sector size might actually be something else.  It also forces
us to pull in another huge header file.
