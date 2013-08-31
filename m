Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CB9FE7F37
	for <xfs@oss.sgi.com>; Sat, 31 Aug 2013 01:14:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9EADA8F8052
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 23:14:26 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	JTHUPPRc6Sldt6IN for <xfs@oss.sgi.com>;
	Fri, 30 Aug 2013 23:14:24 -0700 (PDT)
Date: Sat, 31 Aug 2013 16:14:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: inode buffers may not be valid during recovery
	readahead
Message-ID: <20130831061420.GY12779@dastard>
References: <1377567577-24312-1-git-send-email-david@fromorbit.com>
	<20130830181520.GD1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130830181520.GD1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 30, 2013 at 01:15:20PM -0500, Ben Myers wrote:
> Dave,
> 
> On Tue, Aug 27, 2013 at 11:39:37AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > CRC enabled filesystems fail log recovery with 100% reliability on
> > xfstests xfs/085 with the following failure:
> 
> Unfortunately I have not been able to hit this one... not sure why.
> 
> > XFS (vdb): Mounting Filesystem
> > XFS (vdb): Starting recovery (logdev: internal)
> > XFS (vdb): Corruption detected. Unmount and run xfs_repair
> > XFS (vdb): bad inode magic/vsn daddr 144 #0 (magic=0)
> > XFS: Assertion failed: 0, file: fs/xfs/xfs_inode_buf.c, line: 95
> > 
> > The problem is that the inode buffer has not been recovered before
> > the readahead on the inode buffer is issued. The checkpoint being
> > recovered actually allocates the inode chunk we are doing readahead
> > from, so what comes from disk during readahead is essentially
> > random and the verifier barfs on it.
> > 
> > This inode buffer readahead problem affects non-crc filesystems,
> > too, but xfstests does not trigger it at all on such
> > configurations....
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> I've been mulling this one over for a bit, and I'm not quite sure this
> is correct:
> 
> My feeling is that in light of commit 9222a9cf, if we do take part of a
> buffer back in time, the write verifier should fail.

I don't see the connection between 9222a9cf ("xfs: don't shutdown
log recovery on validation errors") and this issue. 9222a9cf works
around are a longstanding architectural deficiency of log
recovery, while this is a completely new problem introduced by the
inode buffer readahead in log recovery.

> I think for a v2
> inode the read and write verifiers should both be disabled for the
> duration of recovery.

Why? It's an architectural requirement that the underlying buffer we
are replaying inodes into already contains inodes. I mean, what's
the first thing xlog_recover_inode_pass2() does?

        /*
         * Make sure the place we're flushing out to really looks
         * like an inode!
         */
        if (unlikely(dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))) {
                xfs_alert(mp,
        "%s: Bad inode magic number, dip = 0x%p, dino bp = 0x%p, ino = %Ld",
                        __func__, dip, bp, in_f->ilf_ino);
                XFS_ERROR_REPORT("xlog_recover_inode_pass2(1)",
                                 XFS_ERRLEVEL_LOW, mp);
                error = EFSCORRUPTED;
                goto out_release;
        }

i.e. running the verifier on inode buffer reads during log recovery
is exactly the right thing to be doing....

Readahead doesn't change this, either. It just introduces a new
ordering issue we need to handle.

> For v3 inodes, I suspect the current situation
> where we do use write verifiers is broken in the same way, at least
> until we pull in 'xfs: prevent transient corrupt states during log
> recovery', which, as you say, won't fix the problem for the v2 inode.

Again - that fix has no connection to this readahead bug. It's the
fix for v5 filesystems that was mentioned in 9222a9cf, and is needed
regardless of whether we are doing readahead or not.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
