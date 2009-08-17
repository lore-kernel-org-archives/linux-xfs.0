Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7HEOw7D074999 for <xfs@oss.sgi.com>; Mon, 17 Aug 2009 09:25:09 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A49281BBF144
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2009 07:25:43 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id GASeFguLprwVTBZ7 for
	<xfs@oss.sgi.com>; Mon, 17 Aug 2009 07:25:43 -0700 (PDT)
Date: Mon, 17 Aug 2009 10:25:22 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.30.4 XFS(..?) regression (happened again)
In-Reply-To: <20090816022331.GA2309@infradead.org>
Message-ID: <alpine.DEB.2.00.0908171024380.12533@p34.internal.lan>
References: <alpine.DEB.2.00.0908080422440.12329@p34.internal.lan>
	<00980BBF-1206-4BEF-A8AE-B4A8DAE7EC27@sgi.com>
	<alpine.DEB.2.00.0908090605080.16485@p34.internal.lan>
	<alpine.DEB.2.00.0908110624420.22426@p34.internal.lan>
	<20090816022331.GA2309@infradead.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Sat, 15 Aug 2009, Christoph Hellwig wrote:

> All your traces seem to have in common that you're block on locks hold
> by processed doing I/O.  Especially a lot of page locks which are
> controlled by the VM and not the filesystem.  Can you try with commit
> 8aa7e847d834ed937a9ad37a0f2ad5b8584c1ab0 from 2.6.31-rc applied, or
> better directly 2.6.3-rc6?
>
> I would be surprised if this is something inside XFS, but running with
> CONFIG_XFS_DEBUG never hurts.
>

Christoph,

Thanks, running with DEBUG and 2.6.31-rc6.

CONFIG_XFS_DEBUG=y

So far the problem has not surfaced, but it normally takes 24-48 hours.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
