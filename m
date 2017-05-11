Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45849 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754863AbdEKHow (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2017 03:44:52 -0400
Date: Thu, 11 May 2017 00:44:51 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
Message-ID: <20170511074451.GD15626@infradead.org>
References: <20170509122219.31756-1-rgoldwyn@suse.de>
 <20170509122219.31756-6-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170509122219.31756-6-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although lifting the make_request limit is something a lot of users
would appreciate in the near future..
