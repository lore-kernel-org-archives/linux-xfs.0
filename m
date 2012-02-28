Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1SJs7lG214977 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 13:54:08 -0600
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id FRE7u04hry8uMja5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Feb 2012 11:54:06 -0800 (PST)
Subject: Bug#661580: mkfs.xfs fails to detect correct sector size
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.661580.B661580.133045862012212@bugs.debian.org>
From: Goswin von Brederlow <goswin-v-b@web.de>
References: <20120228074914.31280.78231.reportbug@frosties.localnet>
	<20120228091151.GA24717@infradead.org>
Date: Tue, 28 Feb 2012 20:19:54 +0100
In-Reply-To: <20120228091151.GA24717@infradead.org> (Christoph Hellwig's
	message of "Tue, 28 Feb 2012 04:11:51 -0500")
Message-ID: <87399ug3z9.fsf@frosties.localnet>
MIME-Version: 1.0
Reply-To: Goswin von Brederlow <goswin-v-b@web.de>, 661580@bugs.debian.org
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Debian Bug Tracking System <submit@bugs.debian.org>, Carlos Maiolino <cmaiolino@redhat.com>, 661580@bugs.debian.org, Goswin von Brederlow <goswin-v-b@web.de>

Christoph Hellwig <hch@infradead.org> writes:

> Carlos, didn't you plan to look into this issue?
>
> Goswin, how do you determin that mkfs is still doing unaligned I/O
> when forcing the large sevtor size?  Once we set the sector size XFS
> can't do I/O smaller than it.

I'm writing a nbd-server that uses async IO via libaio (the linux kernel
AIO interface). This has some alignment requirements so I set nbd to use
a 4k blocksize and added asserts that all requests are page aligned
(both offset and size of the request). That worked fine for dd and
mkfs.ext4 but fails on mount in general or mkfs.xfs.

So next I added a printf("WARNING: unaligned read/write") and handled
unaligned access in the server to see how extensive the problem is. With
ext4 I get ONE single read request of 512 Byte on mount and everything
else properly 4k aligned. With xfs I get a ton of them.

If you want I can add a log of the read/write requests a mkfs.xfs and
mount generates.

MfG
        Goswin


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
