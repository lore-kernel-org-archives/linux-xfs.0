Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3B6DF7F37
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 17:44:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 28EE08F804B
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 15:44:49 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id l9hAIDminpYKdb8n (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 15:44:48 -0800 (PST)
Date: Thu, 28 Nov 2013 23:44:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: inode_permission NULL pointer dereference in 3.13-rc1
Message-ID: <20131128234441.GQ10323@ZenIV.linux.org.uk>
References: <20131124140413.GA19271@infradead.org>
	<20131124152758.GL10323@ZenIV.linux.org.uk>
	<20131125160648.GA4933@infradead.org>
	<20131126131134.GM10323@ZenIV.linux.org.uk>
	<20131126141253.GA28062@infradead.org>
	<20131127064351.GN10323@ZenIV.linux.org.uk>
	<20131127100906.GA19740@infradead.org>
	<20131128162618.GO10323@ZenIV.linux.org.uk>
	<20131128212301.GP10323@ZenIV.linux.org.uk>
	<20131128225102.GS10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131128225102.GS10988@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com

On Fri, Nov 29, 2013 at 09:51:02AM +1100, Dave Chinner wrote:

> > Looks like adding if (!nd->inode) { a bunch of printks } in the end of
> > path_init() makes the sucker disappear (so far 2 times out of 2, and
> > with a test run taking a bit under two hours, well...)  The plain
> > WARN_ON(!nd->inode) in that place triggers just fine.
> 
> I usually find that when printk() makes race conditions go away,
> switching to tracepoints works better. It's still not as good as
> reliable as when the debug is not there, but it seems to perturb
> race conditions a lot less.

Actually, I've just got the output from this run, and it's really interesting.
We get path_init() setting NULL nd->inode for open() of "/dev/ptmx" (from
/sbin/startpar).  And what we have at the time we get to link_path_walk() is
	* LOOKUP_RCU | LOOKUP_FOLLOW | LOOKUP_PARENT | LOOKUP_JUMPED in
nd->flags (as expected)
	* current->fs->root, current->fs->pwd and nd->path being the same
vfsmount/dentry pair.
	* dentry in question has ->d_sb->s_id containing "sda1", as expected
for root fs.
	* ->mnt_root of that vfsmount being equal to dentry
So far, so good, right?
	* d_count(dentry) is -128
	* dentry->d_inode is NULL

In other words, what we get is an extra dput() somewhere.  The trouble is,
all likely places I'm seeing in the "RCU'd vfsmounts" seem to be OK...
In theory, we might be hitting a _missing_ dput(), with counter wrapping
around, but that doesn't seem likely...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
