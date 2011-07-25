Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PKQjaJ037427 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 15:26:46 -0500
Date: Mon, 25 Jul 2011 16:26:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/12 v3] Remove number of macros from xfs_buf.h
Message-ID: <20110725202638.GA18704@infradead.org>
References: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<1311615418.2914.57.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311615418.2914.57.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

On Mon, Jul 25, 2011 at 12:36:58PM -0500, Alex Elder wrote:
> I forgot to mention before that I got some
> feedback that removing these macros affects
> portability to other platforms (BSD specifically).

Personally I don't really like the way how the BSD port bolted the XFS
buffer use onto the BSD buffer cache.  While the BSD buffer cache is
quite a bit closer to the original IRIX buffer cache model than the 
Linux buffer cache, I think trying to reuse it is just as bad an idea as
partially using the Linux page cache.  Russell might be able to chime
in on the current state of the FreeBSD XFS port, but last time I checked
it was in a pretty minimal state, thus not even exercising the nasty
sides of the buffer cache.  If it wants to be full blown it should just
adadpt and use the current xfs_buf.c code, which really isn't that
Linux specific - sure it uses the Linux memory allocators, shrinkers
and the rbtree library, but it's a standalone piece of code with it's
own algorithms that have proven to be much better than the existing
generic OS buffer caches but catering to the specific XFS needs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
