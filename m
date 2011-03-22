Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2M8iu9Q007512 for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 03:45:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7BDB613EBFBC
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 01:47:56 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id uOpBi85dk9UbZbR7 for
	<xfs@oss.sgi.com>; Tue, 22 Mar 2011 01:47:56 -0700 (PDT)
Date: Tue, 22 Mar 2011 04:47:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.39-rc0: xfs: kernel BUG at mm/page_alloc.c:738
Message-ID: <20110322084755.GA14129@infradead.org>
References: <AANLkTincs+MyYf+2tt2Y3LMQdmF8PUAxKMxMXuKB72hZ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTincs+MyYf+2tt2Y3LMQdmF8PUAxKMxMXuKB72hZ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Mar 21, 2011 at 04:34:46AM +0300, Alexander Beregalov wrote:
> Hi
> 
> Steps to reproduce:
> run xfs_fsr on xfs device
> 
> arch is x86 UP, kernel is 2.6.38-06507-ga952baa
> 
> kernel BUG at mm/page_alloc.c:738!
> invalid opcode: 0000 [#1]
> last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
> Modules linked in: hwmon_vid sata_sil i2c_nforce2

I don't really see anything XFS-specific in here.  The page allocator
is unhappy, and we get there through the generic read code, which just
has a tiny xfs wrapper.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
