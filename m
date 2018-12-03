Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60008 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbeLCJLC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 04:11:02 -0500
Date: Mon, 3 Dec 2018 01:10:52 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: How to avoid xfs_do_force_shutdown on xlog_iodone error
Message-ID: <20181203091052.GA26446@infradead.org>
References: <VI1P192MB0288B67B92CE171B34ABBB1AA9D30@VI1P192MB0288.EURP192.PROD.OUTLOOK.COM>
 <VI1P192MB028894DF21C722001901A488A9D30@VI1P192MB0288.EURP192.PROD.OUTLOOK.COM>
 <20181202160816.GD15501@infradead.org>
 <VI1P192MB02881322EC7B4A0624515B01A9AE0@VI1P192MB0288.EURP192.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1P192MB02881322EC7B4A0624515B01A9AE0@VI1P192MB0288.EURP192.PROD.OUTLOOK.COM>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Albert Duato <albert@kumori.systems>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Mon, Dec 03, 2018 at 09:08:40AM +0000, Albert Duato wrote:
> Thanks.
> 
> I didn't know about that command, but after reading its man and trying it,
> it seems to require to freeze the XFS before a disconnection, and that's
> nothing that could be predicted.
> 
> I should have said it on the initial mail, that the temporary disconnections
> are not scheduled, but arbitrary, as they depend on network availability.
> 
> As long as all operations were retried, network gaps would only cause
> delays, but not fatal failures.
> 
> Is that something I can configure?

No, you can't.  The only think you can do is to make sure I/Os
don't get completed on a disconnect.  Other protocols like SCSI or NBD
at usually try to reconnect and only fail the I/O if that fails.  You'd
either have to fix that in nbd, or try some nasty workarounds like
creating a dm-multipath device with a single path on top of you nbd
device and set the queue_if_no_path option.
