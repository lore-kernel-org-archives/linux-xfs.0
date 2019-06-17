Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40712 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbfFQJO2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jun 2019 05:14:28 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: same page merging leak fix v4
Date: Mon, 17 Jun 2019 11:14:10 +0200
Message-Id: <20190617091412.15923-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc: David Gibson <david@gibson.dropbear.id.au>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org

Hi Jens, hi Ming,

this is the tested and split version of what I think is the better
fix for the get_user_pages page leak, as it leaves the intelligence
in the callers instead of in bio_try_to_merge_page.

Changes since v2:
 - pass a proper same_page variable from the passthrough path

Changes since v1:
 - drop patches not required for 5.2
 - added Reviewed-by tags
