Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0F8lCxY023643 for <xfs@oss.sgi.com>; Thu, 15 Jan 2009 02:47:12 -0600
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 774561801F27
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2009 00:47:06 -0800 (PST)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net
	[203.16.214.57]) by cuda.sgi.com with ESMTP id ls9eLWLcY5IqYNG3
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2009 00:47:06 -0800 (PST)
Date: Thu, 15 Jan 2009 19:47:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090115084700.GD8071@disturbed>
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
	<20090112151133.GA24852@infradead.org>
	<496C2D69.2010301@sgi.com> <20090114221655.GX8071@disturbed>
	<496E89E4.9070004@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <496E89E4.9070004@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jan 15, 2009 at 11:57:08AM +1100, Lachlan McIlroy wrote:
> Dave Chinner wrote:
> > On Tue, Jan 13, 2009 at 04:58:01PM +1100, Lachlan McIlroy wrote:
> >> Christoph Hellwig wrote:
> >>> On Mon, Jan 12, 2009 at 06:14:36AM -0500, Mikulas Patocka wrote:
> >>>> Hi
> >>>>
> >>>> I discovered a bug in XFS in delayed allocation.
> >>>>
> >>>> When you take a small partition (52MB in my case) and copy many small 
> >>>> files on it (source code) that barely fits there, you get -ENOSPC. 
> >>>> Then sync the partition, some free space pops up, click "retry" in MC 
> >>>> an the copy continues. They you get again -ENOSPC, you must sync, 
> >>>> click "retry" and go on. And so on few times until the source code 
> >>>> finally fits on the XFS partition.
> >>>>
> >>>> This misbehavior is apparently caused by delayed allocation, delayed  
> >>>> allocation does not exactly know how much space will be occupied by 
> >>>> data, so it makes some upper bound guess. Because free space count is 
> >>>> only a guess, not the actual data being consumed, XFS should not 
> >>>> return -ENOSPC on behalf of it. When the free space overflows, XFS 
> >>>> should sync itself, retry allocation and only return -ENOSPC if it 
> >>>> fails the second time, after the sync.
> >> This sounds like a problem with speculative allocation - delayed allocations
> >> beyond eof.  Even if we write a small file, say 4k, a 64k chunk of delayed
> >> allocation will be credited to the file. 
> > 
> > The second retry occurs without speculative EOF allocation. That's
> > what the BMAPI_SYNC flag does....
> By then it's too late.  There could already be many files with delayed
> allocations beyond eof that are unneccesarily consuming space.

Yes:

> > That being said, it can't truncate away pre-existing speculative
> > allocations on other files, which is why there is a global flush
> > and wait before the third retry.....

> I suspect
> that when those files are flushed some are not able to convert the full
> delayed allocation in one extent and only convert what is needed to write
> out data.  The remaining unused delayed allocation is released and that's
> why the freespace is going up and down.

It takes time to flush several thousand files. The 500ms
sleep hack is probably not a long enough delay when there are lots
of small files to flush that haven't had their speculative
allcoation truncations removed.

I suspect that xfs_release() might not be truncating the speculative
EOF allocation on file close when the inode has no extents yet:

1190         if (ip->i_d.di_nlink != 0) {
1191                 if ((((ip->i_d.di_mode & S_IFMT) == S_IFREG) &&
1192                      ((ip->i_size > 0) || (VN_CACHED(VFS_I(ip)) > 0 ||
1193                        ip->i_delayed_blks > 0)) &&
1194   >>>>>>>>>          (ip->i_df.if_flags & XFS_IFEXTENTS))  &&
1195                     (!(ip->i_d.di_flags &
1196                                 (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))) {
1197                         error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_LOCK);
1198                         if (error)
1199                                 return error;
1200                 }
1201         }

I think that check will prevent truncation of the speculative
allocation on new files that haven't been flushed or had allocation
done on them yet. That'll be the cause of the buildup, I think...

It's interesting that the only consideration for EOF truncation on
file close is when there extents in the inode itself, not when in
btree format....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
