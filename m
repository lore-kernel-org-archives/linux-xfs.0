Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n11GgTet195173 for <xfs@oss.sgi.com>; Sun, 1 Feb 2009 10:42:30 -0600
Date: Sun, 1 Feb 2009 11:41:30 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [xfs-masters] [PATCH] fs: Add new pre-allocation ioctls to vfs
	for compatibility with legacy xfs ioctls
Message-ID: <20090201164130.GA32276@infradead.org>
References: <20090130171423.f99c88d0.akpm@linux-foundation.org>
	<200901310248.42820.arnd@arndb.de> <49856FE6.8020601@panasas.com>
	<Pine.LNX.4.64.0902011104320.20875@anakin>
	<49857BEB.30404@panasas.com>
	<Pine.LNX.4.64.0902011151180.20875@anakin>
	<4985966D.8040402@panasas.com> <4985C1B0.8060905@sandeen.net>
	<4985CCFA.4070008@panasas.com> <4985CF66.6090409@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4985CF66.6090409@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Arnd Bergmann <arnd@arndb.de>, mfasheh@suse.com, Ankit Jain <me@ankitjain.org>, linux-kernel@vger.kernel.org, joel.becker@oracle.com, hch@infradead.org, xfs-masters@oss.sgi.com, Geert Uytterhoeven <geert@linux-m68k.org>, viro@zeniv.linux.org.uk, Boaz Harrosh <bharrosh@panasas.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

The structures have been defined exactly like that in XFS (and ocfs2)
before, and there are similar cases in other ioctls handlers.

If anyone feels like changing this in some way feel free to wade through
the endless discussions about the pros and cons for it, but I think
doing it in context of this patch is not helpful.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
