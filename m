Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr002msb.fastweb.it ([85.18.95.86]:42406 "EHLO
        mr002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753984AbdKOURp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 15:17:45 -0500
Subject: Re: Disabling barriers on NVC-backed HDD
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 15 Nov 2017 21:17:13 +0100
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20171115194700.GA6228@infradead.org>
References: <8b91c685e344bdc5d084b11fab1d50af@assyoma.it>
 <20171115173100.GD5119@magnolia> <20171115194700.GA6228@infradead.org>
Message-ID: <442aa3b110e7cf10c8920dfe2159e41f@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, g.danti@assyoma.it

Il 15-11-2017 20:47 Christoph Hellwig ha scritto:
> And in that case it will report WCE=0 and Linux won't even flush.
> As is the case for typical enterprise disks.

Good point. Based on what I read here[1], page n.4, it *seems* that 
Seagate AWC (advanced write cache) enabled drives report WCD (write 
cache disabled) to the host OS.

I think this is the key parameter to watch: if the HDD vendor is 
confident enough to report WCE=0/WCD, than it should be safe running 
without barriers (after all, in this case Linux *will* disable barrier 
by default).

Thank you Christoph for pointing that.
Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
