Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-eopbgr00127.outbound.protection.outlook.com ([40.107.0.127]:29508
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725957AbeLCJIx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Dec 2018 04:08:53 -0500
From: Albert Duato <albert@kumori.systems>
Subject: Re: How to avoid xfs_do_force_shutdown on xlog_iodone error
Date: Mon, 3 Dec 2018 09:08:40 +0000
Message-ID: <VI1P192MB02881322EC7B4A0624515B01A9AE0@VI1P192MB0288.EURP192.PROD.OUTLOOK.COM>
References: <VI1P192MB0288B67B92CE171B34ABBB1AA9D30@VI1P192MB0288.EURP192.PROD.OUTLOOK.COM>
 <VI1P192MB028894DF21C722001901A488A9D30@VI1P192MB0288.EURP192.PROD.OUTLOOK.COM>,<20181202160816.GD15501@infradead.org>
In-Reply-To: <20181202160816.GD15501@infradead.org>
Content-Language: es-ES
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

Thanks.

I didn't know about that command, but after reading its man and trying it,
it seems to require to freeze the XFS before a disconnection, and that's
nothing that could be predicted.

I should have said it on the initial mail, that the temporary disconnection=
s
are not scheduled, but arbitrary, as they depend on network availability.

As long as all operations were retried, network gaps would only cause
delays, but not fatal failures.

Is that something I can configure?

Thanks again,

Albert=
