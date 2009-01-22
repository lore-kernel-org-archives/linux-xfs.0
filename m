Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0MKCais107168 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 14:12:37 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DF06184F0C7
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 12:11:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AAhqv2vYPSRqUOaO for
	<xfs@oss.sgi.com>; Thu, 22 Jan 2009 12:11:52 -0800 (PST)
Date: Thu, 22 Jan 2009 15:11:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: List corruption with corrupted xfs image
Message-ID: <20090122201149.GA13282@infradead.org>
References: <20090122091255.GB29546@alice>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090122091255.GB29546@alice>
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
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: xfs@oss.sgi.com

On Thu, Jan 22, 2009 at 10:12:55AM +0100, Eric Sesterhenn wrote:
> Hi,
> 
> with the image at http://www.cccmz.de/~snakebyte/xfs.42.img.bz2
> and the following commands:
> 
>   mount -o loop -t xfs xfs.42.img /media/test
>   touch /media/test/file >/dev/null 2>&1
>   ln -s /media/test/file /media/test/fileb >/dev/null 2>&1
>   mkdir /media/test/dir1 >/dev/null 2>&1
>   cp /media/test/file /media/test/dir1 >/dev/null 2>&1
>   umount /media/test
> 
> I get a list corruption and dead box

The oops is in code we don't have around anymore in 2.6.29-rc, but I'll
give it a try on more recent code.

Thanks a lot!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
