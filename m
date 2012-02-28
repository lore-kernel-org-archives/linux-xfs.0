Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1SDXFFe189629 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 07:33:16 -0600
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id nupgMQEV0WwkKHaO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Feb 2012 05:33:14 -0800 (PST)
Subject: Bug#661580: mkfs.xfs fails to detect correct sector size
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.661580.B.13304357449730@bugs.debian.org>
Date: Tue, 28 Feb 2012 10:28:50 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Message-ID: <20120228132850.GB6739@dhcp-32-204.gru.redhat.com>
References: <20120228074914.31280.78231.reportbug@frosties.localnet>
	<20120228091151.GA24717@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120228091151.GA24717@infradead.org>
Reply-To: Carlos Maiolino <cmaiolino@redhat.com>, 661580@bugs.debian.org
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
Cc: Debian Bug Tracking System <submit@bugs.debian.org>, 661580@bugs.debian.org, Goswin von Brederlow <goswin-v-b@web.de>

On Tue, Feb 28, 2012 at 04:11:51AM -0500, Christoph Hellwig wrote:
> Carlos, didn't you plan to look into this issue?
> 
> Goswin, how do you determin that mkfs is still doing unaligned I/O
> when forcing the large sevtor size?  Once we set the sector size XFS
> can't do I/O smaller than it.
> 
> On Tue, Feb 28, 2012 at 08:49:14AM +0100, Goswin von Brederlow wrote:

Yes, I was looking to it some time ago, but iirc it was already implemented and
I was just fixins some issues on the code already implemented. I just got a new
box and I'm recovering my backup (including code trees). I'll take a look on
this later today and let you know on which steps this is.

-- 
--Carlos


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
