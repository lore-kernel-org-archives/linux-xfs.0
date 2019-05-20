Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49836 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbfETGEP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 02:04:15 -0400
Date: Mon, 20 May 2019 08:03:53 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/20] xfs: stop using XFS_LI_ABORTED as a parameter
 flag
Message-ID: <20190520060353.GC31977@lst.de>
References: <20190517073119.30178-1-hch@lst.de> <20190517073119.30178-3-hch@lst.de> <20190517140447.GB7888@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517140447.GB7888@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 10:04:48AM -0400, Brian Foster wrote:
> Just FYI.. this function passes abort to xfs_trans_committed_bulk(),
> which also looks like it could be changed from int to bool. That aside:

True.
