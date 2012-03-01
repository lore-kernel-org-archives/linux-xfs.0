Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2190I8l095162 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 03:00:18 -0600
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id 1UKk3oS6BoNhLlzu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 01:00:17 -0800 (PST)
Subject: Bug#661580: mkfs.xfs fails to detect correct sector size
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.661580.B661580.133059221410476@bugs.debian.org>
From: Goswin von Brederlow <goswin-v-b@web.de>
References: <20120228074914.31280.78231.reportbug@frosties.localnet>
	<20120228091151.GA24717@infradead.org> <4F4E82E6.3040505@sandeen.net>
	<87399tkmdf.fsf@frosties.localnet>
	<20120301060637.GA28009@infradead.org>
Date: Thu, 01 Mar 2012 09:56:13 +0100
In-Reply-To: <20120301060637.GA28009@infradead.org> (Christoph Hellwig's
	message of "Thu, 1 Mar 2012 01:06:37 -0500")
Message-ID: <8762eo3djm.fsf@frosties.localnet>
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
Cc: Debian Bug Tracking System <submit@bugs.debian.org>, Eric Sandeen <sandeen@sandeen.net>, Carlos Maiolino <cmaiolino@redhat.com>, 661580@bugs.debian.org, Goswin von Brederlow <goswin-v-b@web.de>

Christoph Hellwig <hch@infradead.org> writes:

> On Thu, Mar 01, 2012 at 04:53:32AM +0100, Goswin von Brederlow wrote:
>> I'm asuming libblkid is used, otherwise a sectorsize of 512 would make
>> no sense.
>> 
>> It might be that NBD advertises the geometry wrong, as in ft.sectorsize
>> isn't set correctly. That would make that part at least a kernel bug.
>
> Now that I've looked at nbd: I can't find any way to transfer the
> physical or logical block size information to the nbd client.  How
> do you try set it on the server?

I don't. The protocol doesn't (yet) have an option for this. There are a
number of new options planed for the new handshake protocol but the nbd
maintainer hasn't had time to implement them yet.

What I do is set the blocksize = 4096 on the nbd-client commandline
knowing that that is what the server expects.

MfG
        Goswin


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
