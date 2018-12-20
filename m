Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51285 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727644AbeLTHJ2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Dec 2018 02:09:28 -0500
Date: Thu, 20 Dec 2018 08:09:27 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: COW improvements and always_cow support V3
Message-ID: <20181220070927.GB9803@lst.de>
References: <20181203222503.30649-1-hch@lst.de> <20181206010550.GN24487@magnolia> <20181206200930.GA31797@lst.de> <20181217175922.GI24487@magnolia> <20181218180551.GA15138@lst.de> <20181219004411.GW27208@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181219004411.GW27208@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Dec 18, 2018 at 04:44:11PM -0800, Darrick J. Wong wrote:
> FWIW one of my test vms seems to have hung in generic/323 with the xfs
> for-next and your patches applied:
> 
> MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1, /dev/sdf'
> MOUNT_OPTIONS='/dev/sdf /opt'

I've run generic/323 with those settings in a loop over night and
haven't reproduced it so far.
