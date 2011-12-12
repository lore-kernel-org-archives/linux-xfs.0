Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBCDD0eG098564 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 07:13:00 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F097F16EF0C1
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 05:12:56 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	YvAMvxS8WPJFgtTT for <xfs@oss.sgi.com>;
	Mon, 12 Dec 2011 05:12:56 -0800 (PST)
Date: Mon, 12 Dec 2011 08:12:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_repair gets stuck on phase3
Message-ID: <20111212131255.GA15481@infradead.org>
References: <CAENWQX0FgOrTiDVaictZkNfnpBR40DWrHsWrysPHDvdoqvcw5A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAENWQX0FgOrTiDVaictZkNfnpBR40DWrHsWrysPHDvdoqvcw5A@mail.gmail.com>
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
To: Pavol Zibrita <pavol.zibrita@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, Dec 11, 2011 at 09:20:14PM +0000, Pavol Zibrita wrote:
> I tried various option for xfs_repair, but when in phase 3, it just
> calculates and calculates and does nothing.
> CPU is used around 97%.
> 
> Examining the system with knoppix live cd.
> 
> Attaching logs with the outputs.
> log.log: xfs_repair
> p-log.log: with -P
> strace-log.log stracing xfs_repair
> 
> After using the -L option I can mount the fs, but there are still bugs on
> the filesystem I would like to fix.
> 
> Currently, I don't have any other 4TB of space I could move the data to
> make some more drastic changes
> like reformat or so.

As Dave mentioned my fix for loops in the unlinked inode list is a
likely candidate.  If you can prepare a dump of the metadata using the
xfs_metadump tool for me I can take a look.  If it indeed were the
unlinked inode lists we could also fix your issues fairly easily using
xfs_db.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
