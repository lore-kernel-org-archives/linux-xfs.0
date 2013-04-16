Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 56DE67F56
	for <linux-xfs@oss.sgi.com>; Tue, 16 Apr 2013 11:25:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 378A38F8081
	for <linux-xfs@oss.sgi.com>; Tue, 16 Apr 2013 09:25:31 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	9in5OlXXJC2EK5rB for <linux-xfs@oss.sgi.com>;
	Tue, 16 Apr 2013 09:25:29 -0700 (PDT)
Date: Wed, 17 Apr 2013 02:25:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair misses an fs error?
Message-ID: <20130416162557.GD13938@destitution>
References: <k5gu3axace.ln2@goaway.wombat.san-francisco.ca.us>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <k5gu3axace.ln2@goaway.wombat.san-francisco.ca.us>
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
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-xfs@oss.sgi.com

On Mon, Apr 15, 2013 at 04:47:32PM -0700, Keith Keller wrote:
> Hi all,
> 
> I recently had a filesystem stop, and went through the usual umount,
> mount, umount, xfs_repair path.  xfs_repair didn't find any errors, but
> I noticed that I was still getting some strange issues where a file in a
> directory didn't have an inode and was resulting in IO errors.  Thinking
> to address the problem later, I moved the directory to a different
> location on the filesystem so that future backups could proceed
> normally.
> 
> Later, in an attempt to collect log errors, I re-ran xfs_repair on the
> filesystem.  It then found errors and corrected them, and on remount, I
> found that the directory in question was repaired and no longer had a
> file entry with no inode.  (So I can't reproduce that output; I didn't
> save it, thinking that the second xfs_repair wouldn't fix the issue, and
> I'd generate it again before posting.)
> 
> Has anyone else seen a situation where xfs_repair misses a filesystem
> problem, but then finds it if a file or directory is moved?  And more

Not recently. What version of xfs_repair are you using?

> generally, is there a way to use xfs_db or similar to try to find other
> inodes that might be causing similar problems?

xfs_repair -n is the usual way to find broken stuff without
modifying anything....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
