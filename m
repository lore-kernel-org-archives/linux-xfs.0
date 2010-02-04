Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o14FSuod061237 for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 09:28:57 -0600
Date: Thu, 4 Feb 2010 10:30:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/4] wsync export option
Message-ID: <20100204153006.GC22014@infradead.org>
References: <20100203233755.17677.96582.stgit@case>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100203233755.17677.96582.stgit@case>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Feb 03, 2010 at 05:44:24PM -0600, Ben Myers wrote:
> The following series is adds a 'wsync' export option to nfsd.  It is intended
> to be used on XFS with the wsync mount option.  When you already have a
> synchronous log there is no need to sync metadata separately.

You don't need the xfs wsync option, as the existing write_inode
calls or your new fsync calls are doing the same as the wsync mount
option, just from a higher layer.  The wsync option causes the log
to be synchronously forced up to the log sequence number of the commit
for the metadata operation, that is make all the operations affected
by it synchronous.  That's exactly what we'll do using fsync (actually
right now we force the whole log, but I have a patch to optimize it
to only force nuntil the last commit lsn), and approqimately the
same as we do using write_inode, just a lot less efficiently.

> This is barely tested, YMMV, I could have this all wrong, etc, etc.  Here are
> some very unscientific measurements taken over gigabit ethernet.
> 
> # time tar -xvf /mnt2/quilt-0.47.tar > /dev/null
> 
> No XFS wsync, no NFS wsync:
> 0m13.177s	0m13.301s	0m13.528s
> 
> XFS wsync set, no NFS wsync:
> 0m13.019s	0m13.232s	0m13.094s
> 
> XFS wsync set, NFS wsync set:
> 0m8.361s	0m8.400s	0m8.301s
> 
> Curious to hear if this is a reasonable thing to do.  Suggestions welcome.

I think it's reasonable.  What might be even better it to have an
export operation call out into the filesystem so that we can force wsync
and not let nfsd deal with it at all.  There is a fair chance that the
filesystem can do the sync more efficiently.

And btw, not directly related to your patch, but getting rid of this
write_inode call defintively makes the usage of ->write_inode more
regular.  From generic code we mostly use it for full inode writeback
in writeback_single_inode, and one other special case in
generic_detach_inode if a filesystem is unmounting.  Only having
writeback_single_inode and fs code use it will make this call much
more predictable for the filesystem.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
