Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2C0kfT3226699 for <xfs@oss.sgi.com>; Sun, 11 Mar 2012 19:46:41 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	pbe2AwhIGxvHTcy1 for <xfs@oss.sgi.com>;
	Sun, 11 Mar 2012 17:46:38 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1S6tPI-0005LD-Hp
	for xfs@oss.sgi.com; Mon, 12 Mar 2012 11:46:36 +1100
Date: Mon, 12 Mar 2012 11:46:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests - unchecked mount failures
Message-ID: <20120312004636.GW5091@dastard>
References: <20120309132828.GI4334@twin.jikos.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120309132828.GI4334@twin.jikos.cz>
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
To: xfs@oss.sgi.com

On Fri, Mar 09, 2012 at 02:28:28PM +0100, David Sterba wrote:
> Hi,
> 
> I've encountered a bad situation when a failed mount in test 269 did not stop
> the test and continued to use the mount point and exhausted space on the root
> partition. A quick grep revealed that there are more tests with unchecked
> _scratch_mount calls.
>
> The underlying problem with failed mount was observed when the mount comes in a
> quick sequence after mount,

Sorry, what? Do you mean mount after mkfs? 

> I saw it with btrfs, and don't know if it affects
> other filesystems.

If btrfs is failing to mount because it happens too soon after mkfs,
then that's a btrfs bug, not a xfstests problem.

> So, either all callers should check the return value or _scratch_mount
> calls _fail.

Some tests expect _scratch_mount to fail, so you can't change how
_scratch_mount behaves....

> I'd go for the latter as it will make it more resilient
> against unintentional ommision of checking the retval in new tests and
> reviewer does not have keep that in mind.

I think it is fine to assume that you can mount a filesystem that
you just run mkfs on. If you are testing something that you expect
failure, then sure, check the return, but immeidately after mkfs
(that will fail the test if it fails) it is reasonable to assume
that mount will work.

Of course, if you want to add return value checking to all the
current unchecked callers of _scratch_mount then send a patch
for review. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
