Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54166 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbeLBQIU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Dec 2018 11:08:20 -0500
Date: Sun, 2 Dec 2018 08:08:16 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: How to avoid xfs_do_force_shutdown on xlog_iodone error
Message-ID: <20181202160816.GD15501@infradead.org>
References: <VI1P192MB0288B67B92CE171B34ABBB1AA9D30@VI1P192MB0288.EURP192.PROD.OUTLOOK.COM>
 <VI1P192MB028894DF21C722001901A488A9D30@VI1P192MB0288.EURP192.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1P192MB028894DF21C722001901A488A9D30@VI1P192MB0288.EURP192.PROD.OUTLOOK.COM>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Albert Duato <albert@kumori.systems>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

You can try an xfs_freeze first and the unfreeze later after your
reconnected.  However unplugging and replugging a usb stick is generally
not just going to smoothly work, so I don't think that is a valid
equivalent.
