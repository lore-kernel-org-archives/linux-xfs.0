Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5IEP0eA214326 for <xfs@oss.sgi.com>; Sat, 18 Jun 2011 09:25:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 671EA14F2AC0
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2011 07:24:57 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	skICgMBRpWZpnOQG for <xfs@oss.sgi.com>;
	Sat, 18 Jun 2011 07:24:57 -0700 (PDT)
Date: Sat, 18 Jun 2011 10:24:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: long hangs when deleting large directories (3.0-rc3)
Message-ID: <20110618142456.GA26419@infradead.org>
References: <20110618141950.GA1685@x4.trippels.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110618141950.GA1685@x4.trippels.de>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: xfs@oss.sgi.com

On Sat, Jun 18, 2011 at 04:19:50PM +0200, Markus Trippelsdorf wrote:
> Running the latest git kernel (3.0-rc3) my machine hangs for long
> periods (1-2 sec) whenever I delete a large directory recursively on my
> xfs partition. During the hang I cannot move the mouse pointer or use
> the keyboard (but the music keeps playing without stuttering). A quick
> way to reproduce is to "rm -fr" a kernel tree. 

Does this also happen when using the deadline I/O schedule, that is
after a:

echo "deadline" > /sys/block/sda/queue/scheduler

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
