Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57000 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751054AbdIMQzr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Sep 2017 12:55:47 -0400
Date: Wed, 13 Sep 2017 18:55:46 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [BUG] xfs/104 triggered NULL pointer dereference in iomap
        based dio
Message-ID: <20170913165546.GA18388@lst.de>
References: <20170913105823.GD8034@eguan.usersys.redhat.com> <8010113.2DyTjQuL2r@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8010113.2DyTjQuL2r@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Does it work fine if you call sb_init_dio_done_wq unconditionally?
