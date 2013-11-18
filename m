Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AC5F529E04
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 16:28:30 -0600 (CST)
Date: Mon, 18 Nov 2013 16:28:26 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/5] xfs: open code inc_inode_iversion when logging an
	inode
Message-ID: <20131118222826.GJ1935@sgi.com>
References: <1383280040-21979-1-git-send-email-david@fromorbit.com>
	<1383280040-21979-3-git-send-email-david@fromorbit.com>
	<528A8C90.3010401@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <528A8C90.3010401@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Mon, Nov 18, 2013 at 03:54:24PM -0600, Eric Sandeen wrote:
> On 10/31/13, 11:27 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Michael L Semon reported that generic/069 runtime increased on v5
> > superblocks by 100% compared to v4 superblocks. his perf-based
> > analysis pointed directly at the timestamp updates being done by the
> > write path in this workload. The append writers are doing 4-byte
> > writes, so there are lots of timestamp updates occurring.
> > 
> > The thing is, they aren't being triggered by timestamp changes -
> > they are being triggered by the inode change counter needing to be
> > updated. That is, every write(2) system call needs to bump the inode
> > version count, and it does that through the timestamp update
> > mechanism. Hence for v5 filesystems, test generic/069 is running 3
> > orders of magnitude more timestmap update transactions on v5
> > filesystems due to the fact it does a huge number of *4 byte*
> > write(2) calls.
> > 
> > This isn't a real world scenario we really need to address - anyone
> > doing such sequential IO should be using fwrite(3), not write(2).
> > i.e. fwrite(3) buffers the writes in userspace to minimise the
> > number of write(2) syscalls, and the problem goes away.
> > 
> > However, there is a small change we can make to improve the
> > situation - removing the expensive lock operation on the change
> > counter update.  All inode version counter changes in XFS occur
> > under the ip->i_ilock during a transaction, and therefore we
> > don't actually need the spin lock that provides exclusive access to
> > it through inc_inode_iversion().
> > 
> > Hence avoid the lock and just open code the increment ourselves when
> > logging the inode.
> 
> Well, ok.  Maybe worth a note about why the unlocked read is 99.9999% ok...
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Ah, sorry Eric, I didn't realize you were still reviewing this guy.  I pulled
him in a bit earlier in the day.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
