Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q21696Di084951 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 00:09:06 -0600
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id JfylGAASk0t69Sf5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Feb 2012 22:09:05 -0800 (PST)
Subject: Bug#661580: mkfs.xfs fails to detect correct sector size
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.661580.B.133058200210243@bugs.debian.org>
Date: Thu, 1 Mar 2012 01:06:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20120301060637.GA28009@infradead.org>
References: <20120228074914.31280.78231.reportbug@frosties.localnet>
	<20120228091151.GA24717@infradead.org>
	<4F4E82E6.3040505@sandeen.net> <87399tkmdf.fsf@frosties.localnet>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87399tkmdf.fsf@frosties.localnet>
Reply-To: Christoph Hellwig <hch@infradead.org>, 661580@bugs.debian.org
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
To: Goswin von Brederlow <goswin-v-b@web.de>, 661580@bugs.debian.org
Cc: Christoph Hellwig <hch@infradead.org>, Debian Bug Tracking System <submit@bugs.debian.org>, Eric Sandeen <sandeen@sandeen.net>, Carlos Maiolino <cmaiolino@redhat.com>

On Thu, Mar 01, 2012 at 04:53:32AM +0100, Goswin von Brederlow wrote:
> I'm asuming libblkid is used, otherwise a sectorsize of 512 would make
> no sense.
> 
> It might be that NBD advertises the geometry wrong, as in ft.sectorsize
> isn't set correctly. That would make that part at least a kernel bug.

Now that I've looked at nbd: I can't find any way to transfer the
physical or logical block size information to the nbd client.  How
do you try set it on the server?



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
