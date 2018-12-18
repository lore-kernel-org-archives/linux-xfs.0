Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42310 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726652AbeLRSGT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Dec 2018 13:06:19 -0500
Date: Tue, 18 Dec 2018 19:06:17 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] iomap: use SECTOR_SIZE instead of 512 in iomap_page
Message-ID: <20181218180617.GB15138@lst.de>
References: <1544739929-21651-1-git-send-email-sandeen@sandeen.net> <1544739929-21651-2-git-send-email-sandeen@sandeen.net> <20181215105155.GD1575@lst.de> <37aec6a5-d846-eca1-1708-bf80ea63c463@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37aec6a5-d846-eca1-1708-bf80ea63c463@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Dec 17, 2018 at 05:45:10PM -0600, Eric Sandeen wrote:
> Then we should hard code "512" in iomap_page_create I guess.  Just need
> consistency.

Fine with me.
