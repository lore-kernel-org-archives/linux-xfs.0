Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr001msb.fastweb.it ([85.18.95.85]:39001 "EHLO
        mr001msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753984AbdKOUS6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 15:18:58 -0500
Subject: Re: Disabling barriers on NVC-backed HDD
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 15 Nov 2017 21:18:31 +0100
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <442aa3b110e7cf10c8920dfe2159e41f@assyoma.it>
References: <8b91c685e344bdc5d084b11fab1d50af@assyoma.it>
 <20171115173100.GD5119@magnolia> <20171115194700.GA6228@infradead.org>
 <442aa3b110e7cf10c8920dfe2159e41f@assyoma.it>
Message-ID: <e7d6cada4330c02c86e5159ef987c0d9@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, g.danti@assyoma.it

Il 15-11-2017 21:17 Gionatan Danti ha scritto:
> Il 15-11-2017 20:47 Christoph Hellwig ha scritto:
>> And in that case it will report WCE=0 and Linux won't even flush.
>> As is the case for typical enterprise disks.
> 
> Good point. Based on what I read here[1], page n.4, it *seems* that
> Seagate AWC (advanced write cache) enabled drives report WCD (write
> cache disabled) to the host OS.
> 
> I think this is the key parameter to watch: if the HDD vendor is
> confident enough to report WCE=0/WCD, than it should be safe running
> without barriers (after all, in this case Linux *will* disable barrier
> by default).
> 
> Thank you Christoph for pointing that.
> Regards.

Sorry, I forgot the link: 
https://www.seagate.com/files/www-content/product-content/enterprise-performance-savvio-fam/enterprise-performance-15k-hdd/_cross-product/_shared/doc/enchanced-cache-advantage-tp691.1-1610us.pdf

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
