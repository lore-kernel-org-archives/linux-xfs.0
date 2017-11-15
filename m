Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr002msb.fastweb.it ([85.18.95.86]:46938 "EHLO
        mr002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753292AbdKOU1s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 15:27:48 -0500
Subject: Re: Disabling barriers on NVC-backed HDD
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Wed, 15 Nov 2017 21:27:21 +0100
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <e7d6cada4330c02c86e5159ef987c0d9@assyoma.it>
References: <8b91c685e344bdc5d084b11fab1d50af@assyoma.it>
 <20171115173100.GD5119@magnolia> <20171115194700.GA6228@infradead.org>
 <442aa3b110e7cf10c8920dfe2159e41f@assyoma.it>
 <e7d6cada4330c02c86e5159ef987c0d9@assyoma.it>
Message-ID: <fb4469d15c91569db79abb34396e7272@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, g.danti@assyoma.it

Il 15-11-2017 21:18 Gionatan Danti ha scritto:
> Sorry, I forgot the link:
> https://www.seagate.com/files/www-content/product-content/enterprise-performance-savvio-fam/enterprise-performance-15k-hdd/_cross-product/_shared/doc/enchanced-cache-advantage-tp691.1-1610us.pdf

Ok, it seems that for Seagate drives the real document to read is that 
one[1]. Quoting:

"When WCE=0, Advanced provides NVC-protected write caching over the 
portion of the DRAM used to coalesce writes. Write data only goes into 
NVC when there is an unexpected power loss to the drive. The NVC has 
90-day data retention. When WCE=1, a Advanced Caching drive will operate 
on writes like a standard drive–writes in cache are not protected by NVC 
and may be lost with power loss."

In short:
- WCE=1 -> entire cache enabled -> powerloss = dataloss;
- WCE=0 -> small write cache segment enabled -> powerloss = nodataloss.

Unfortunately, I can not find anything on that regard about HGST's 
MediaCache...

Regards.

[1] 
https://www.seagate.com/www-content/product-content/enterprise-performance-savvio-fam/ent-perf-10k-hdd-v9-skybolt/en-us/docs/100818015c.pdf

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
