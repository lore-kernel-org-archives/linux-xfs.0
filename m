Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA3Ejf4H166901 for <xfs@oss.sgi.com>; Tue, 3 Nov 2009 08:45:42 -0600
Received: from pu01.news-service.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60F3514D3398
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2009 06:45:54 -0800 (PST)
Received: from pu01.news-service.com (ns1.news-service.com [195.114.240.3]) by
	cuda.sgi.com with ESMTP id F9sky96e7DklJESI for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2009 06:45:54 -0800 (PST)
Message-ID: <4AF0422D.1070104@news-service.com>
Date: Tue, 03 Nov 2009 15:46:05 +0100
From: Patrick Schreurs <patrick@news-service.com>
MIME-Version: 1.0
Subject: Re: 2.6.31 xfs_fs_destroy_inode: cannot reclaim
References: <20091007011926.GB32032@infradead.org>	<4AD18C8D.90808@news-service.com>	<20091012233854.GA29446@infradead.org>	<20091019011600.GO9464@discord.disaster>	<20091019035426.GB18296@infradead.org>	<20091020034048.GA9464@discord.disaster>	<89c4f90c0910210245h4691cd82hd1d63f5ed72fb2e3@mail.gmail.com>	<20091022085937.GA2039@infradead.org>	<89c4f90c0910270341r7833f490g60810f2817eb0950@mail.gmail.com>	<89c4f90c0910280519k759230c1r7b1586932ac792f7@mail.gmail.com>
	<20091030101601.GA11142@infradead.org>
In-Reply-To: <20091030101601.GA11142@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Tommy van Leeuwen <tommy@news-service.com>, Bas Couwenberg <bas@news-service.com>, XFS List <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Wed, Oct 28, 2009 at 01:19:44PM +0100, Tommy van Leeuwen wrote:
>> Another one just seconds ago. Might be more usefull then the last 2.
> 
> Ist this one also with COFNIG_XFS_DEBUG enabled?  May assert should have
> hit the condition we're seing in that one earlier.

Sorry for the delay. Yes, XFS_DEBUG was enabled on these servers.

> Anyway, it still looks like we can get inodes that are partially
> or fully torn down before entering ->destroy_inode.  I'll try to figure
> out why.

We're back to 2.6.28 at the moment. Please advice if we can do anything 
to assist.

Any clue why we seem to be the only one hitting this problem? It might 
have something to do with the short term data retention on these 
particular servers. All partitions are always 100% full and data is only 
kept for a couple of days.

Thanks for looking into this.

-Patrick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
