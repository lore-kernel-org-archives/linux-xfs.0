Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5IEbNhk214777 for <xfs@oss.sgi.com>; Sat, 18 Jun 2011 09:37:24 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 23096DD14D6
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2011 07:37:22 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id q9FQQ92327ChA9FS for
	<xfs@oss.sgi.com>; Sat, 18 Jun 2011 07:37:22 -0700 (PDT)
Date: Sat, 18 Jun 2011 16:37:20 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: long hangs when deleting large directories (3.0-rc3)
Message-ID: <20110618143720.GA1703@x4.trippels.de>
References: <20110618141950.GA1685@x4.trippels.de>
	<20110618142456.GA26419@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110618142456.GA26419@infradead.org>
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
Cc: xfs@oss.sgi.com

On 2011.06.18 at 10:24 -0400, Christoph Hellwig wrote:
> On Sat, Jun 18, 2011 at 04:19:50PM +0200, Markus Trippelsdorf wrote:
> > Running the latest git kernel (3.0-rc3) my machine hangs for long
> > periods (1-2 sec) whenever I delete a large directory recursively on my
> > xfs partition. During the hang I cannot move the mouse pointer or use
> > the keyboard (but the music keeps playing without stuttering). A quick
> > way to reproduce is to "rm -fr" a kernel tree. 
> 
> Does this also happen when using the deadline I/O schedule, that is
> after a:
> 
> echo "deadline" > /sys/block/sda/queue/scheduler

Yes.

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
