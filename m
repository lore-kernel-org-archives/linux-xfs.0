Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0HBk3Q5009287 for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 05:46:03 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCCEFF18C44
	for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 03:47:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id o01YpHHxmtGaD9UC for
	<xfs@oss.sgi.com>; Sun, 17 Jan 2010 03:47:01 -0800 (PST)
Date: Sun, 17 Jan 2010 06:46:58 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: usage of xfsctrl for embedded development / uuid question
Message-ID: <20100117114658.GA10994@infradead.org>
References: <5340782.170001263558076439.JavaMail.www@wsfrf1111>
	<20100115124617.GJ28498@discord.disaster>
	<4B50D9F9.1010809@fnac.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B50D9F9.1010809@fnac.net>
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
To: Paul Chavent <paul.chavent@fnac.net>
Cc: xfs@oss.sgi.com

On Fri, Jan 15, 2010 at 10:11:21PM +0100, Paul Chavent wrote:
>> It's a wrapper around ioctl(). You can call ioctl() directly
>> on not need xfsctl at all...
>
> Right, but i found nowhere the structures and the definition of XFS_IOC_* in the headers "exported" by the kernel.
>
> So i have two solutions :
> (1) i add -I/path_to_the_kernel_sources/fs to the cflags of my project.
> (2) i install those headers in my sysroot.
>
> I thought that those solutions where worst that only install headers from the xfsprogs package.

You can just install the xfsprogs headers only by doing it yourself or
filtering the installed files in your package manager.  I'm not sure
it's really worth it to support this special environment in the xfsprogs
build system.

>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
