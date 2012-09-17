Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8HGKDPO183019 for <xfs@oss.sgi.com>; Mon, 17 Sep 2012 11:20:13 -0500
Date: Mon, 17 Sep 2012 11:21:20 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: given a pointer to xfs_inode_t, how to determine path?
Message-ID: <20120917162120.GG25175@sgi.com>
References: <50574709.9000301@genband.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50574709.9000301@genband.com>
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
To: Chris Friesen <chris.friesen@genband.com>
Cc: Alex Elder <elder@kernel.org>, xfs@oss.sgi.com

Hi Chris,

On Mon, Sep 17, 2012 at 09:51:37AM -0600, Chris Friesen wrote:
> We're running 2.6.27 (upgrading not currently possible, embedded product).
>
> We had a situation arise where we could see in stack traces that a
> number of tasks were stuck in vn_iowait().  That function takes a
> pointer to xfs_inode_t.  Given that, would it be possible to work
> backwards to determine a filesystem path corresponding to that
> inode?  I realize it would likely only go back to the head of the
> filesystem, but that would be fine.

Yep, it's possible.

echo t > /proc/sysrq-trigger won't give you the full stack, but you may be able
to get an idea of what is going on, well enough to make some guesses as to the
culprit.  That's probably your best first step.

If you have crash installed:

1) disassemble vn_iowait and find out which register the xfs_inode_t pointer is in.
2) print out the full stacks of all the processes in the system. 'bt -f', I think.
3) grep for the xfs_inode_t pointer on those stacks.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
