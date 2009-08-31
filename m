Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7VCWmnu097210 for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 07:33:04 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E4AE0410516
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 05:33:23 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id aqPNTWsVDHCStduB for
	<xfs@oss.sgi.com>; Mon, 31 Aug 2009 05:33:23 -0700 (PDT)
Date: Mon, 31 Aug 2009 08:30:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs compat_ioctl?
Message-ID: <20090831123010.GA2368@infradead.org>
References: <4A9B759B.7020401@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A9B759B.7020401@msgid.tls.msk.ru>
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
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Aug 31, 2009 at 11:02:51AM +0400, Michael Tokarev wrote:
> Hello!
>
> I tried to resize an xfs filesystem on 64bit 2.6.30 kernel
> using 32bit userland, and that does not work, in dmesg I see:
>
> ioctl32(xfs_growfs:24426): Unknown cmd fd(3) cmd(400c586e){t:'X';sz:12} arg(ffa56df4) on /mnt
> ioctl32(xfs_growfs:24427): Unknown cmd fd(3) cmd(400c586e){t:'X';sz:12} arg(ff991254) on /mnt
>
> so apparently there's no compat_ioctl layer for these ioctls.
>
> Are there any plans to add these? :)

Are you sure you're testing 2.6.30?  The copat ioctls were added in
2.6.28.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
