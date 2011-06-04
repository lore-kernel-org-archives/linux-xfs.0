Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p54EJonp084573 for <xfs@oss.sgi.com>; Sat, 4 Jun 2011 09:19:51 -0500
Received: from ZenIV.linux.org.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0800349E3EE
	for <xfs@oss.sgi.com>; Sat,  4 Jun 2011 07:19:48 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id EMO7wjsWixEWUzwH for
	<xfs@oss.sgi.com>; Sat, 04 Jun 2011 07:19:48 -0700 (PDT)
Date: Sat, 4 Jun 2011 15:19:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 08/12] superblock: introduce per-sb cache shrinker
	infrastructure
Message-ID: <20110604141940.GW11521@ZenIV.linux.org.uk>
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
	<1306998067-27659-9-git-send-email-david@fromorbit.com>
	<20110604004231.GV11521@ZenIV.linux.org.uk>
	<20110604015212.GD561@dastard>
	<20110604140848.GA20404@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110604140848.GA20404@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sat, Jun 04, 2011 at 10:08:48AM -0400, Christoph Hellwig wrote:
> On Sat, Jun 04, 2011 at 11:52:12AM +1000, Dave Chinner wrote:
> > I wanted to put it early on in the unmount path so that the shrinker
> > was guaranteed to be gone before evict_inodes() was called. That
> > would mean that it is obviously safe to remove the iprune_sem
> > serialisation in that function.
> 
> The iprune_sem removal is fine as soon as you have a per-sb shrinker
> for the inodes which keeps an active reference on the superblock until
> all the inodes are evicted.

I really don't like that.  Stuff keeping active refs, worse yet doing that
asynchronously...  Shrinkers should *not* do that.  Just grab a passive
ref (i.e. bump s_count), try grab s_umount (shared) and if that thing still
has ->s_root while we hold s_umount, go ahead.  Unregister either at the
end of generic_shutdown_super() or from deactivate_locked_super(), between
the calls of ->kill_sb() and put_filesystem().

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
