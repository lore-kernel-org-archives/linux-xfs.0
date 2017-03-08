Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43557 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbdCHPwH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2017 10:52:07 -0500
Date: Wed, 8 Mar 2017 07:51:58 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
Message-ID: <20170308155158.GB4353@infradead.org>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <20170228233610.25456-6-rgoldwyn@suse.de>
 <0d1ba678-69c0-16ce-6c3e-475cd8da203c@grimberg.me>
 <44cc02b1-f7ac-cbc6-6f09-726ae8225358@suse.de>
 <20170308152806.GA9288@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170308152806.GA9288@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, Sagi Grimberg <sagi@grimberg.me>, jack@suse.com, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Wed, Mar 08, 2017 at 04:28:06PM +0100, Jan Kara wrote:
> Well, that's not really good. If we cannot support this for both blk-mq and
> legacy block layer the feature will not be usable. So please work on blk-mq
> support as well.

Exactly.  In addition to that anything implementing a feature for the
legacy request request code but not blk-mq is grounds for an instant
NAK.
