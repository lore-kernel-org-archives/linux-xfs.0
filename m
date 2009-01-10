Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0AGRZss003096 for <xfs@oss.sgi.com>; Sat, 10 Jan 2009 10:27:35 -0600
Message-ID: <4968CC73.4070700@sandeen.net>
Date: Sat, 10 Jan 2009 10:27:31 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [xfs-masters] 2.6.29-rc: kernel BUG at fs/xfs/support/debug.c:108
References: <20090109044121.GA31280@orion>
	<20090109053858.GP9448@disturbed>	<a4423d670901091353s7ff12207gcb38eb093d77d401@mail.gmail.com>	<a4423d670901091418j5c7fdfb2oeba2f4640f8e29d0@mail.gmail.com>	<a4423d670901091511y68a53808rfaab8148526224c6@mail.gmail.com>	<a4423d670901100419s2ae106bexac1a538caf654153@mail.gmail.com>	<20090110143924.GA25900@infradead.org>
	<a4423d670901100709v1e7ce0bfs167547c5001787ac@mail.gmail.com>
In-Reply-To: <a4423d670901100709v1e7ce0bfs167547c5001787ac@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, kernel-testers@vger.kernel.org, xfs@oss.sgi.com

Alexander Beregalov wrote:
> 2009/1/10 Christoph Hellwig <hch@infradead.org>:

>> How big is the filesystem where you see this corruption? Maybe I could
>> reproduce it locally with a xfs_metadump image.
> 
> They are big enough, I have four such FS's for >200Gb

An xfs_metadump should not be so large, though.

But bisecting as hch suggested (keepin the "working" header for each
bisection point) would be great.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
