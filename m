Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 84A2D7F50
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2014 19:28:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6441F30405F
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2014 17:28:41 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Hui56akoA9MhCd9G for <xfs@oss.sgi.com>;
	Mon, 21 Jul 2014 17:28:38 -0700 (PDT)
Date: Tue, 22 Jul 2014 10:23:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: new case to test inode allocations in
	post-growfs disk space
Message-ID: <20140722002322.GN4453@dastard>
References: <1405529554-31225-1-git-send-email-eguan@redhat.com>
	<20140721134638.GA45794@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140721134638.GA45794@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, Eryu Guan <eguan@redhat.com>, Boris Ranto <branto@redhat.com>, Eric Sandeen <esandeen@redhat.com>

On Mon, Jul 21, 2014 at 09:46:38AM -0400, Brian Foster wrote:
> On Thu, Jul 17, 2014 at 12:52:33AM +0800, Eryu Guan wrote:
> > Make sure inodes can be allocated in new space added by xfs_growfs.
> > 
> > Regression test for
> > xfs: allow inode allocations in post-growfs disk space
....
> > +# Create files to consume free inodes in background
> > +(
> > +	i=0
> > +	while [ $i -lt 1000 ]; do
> > +		mkdir $SCRATCH_MNT/testdir_$i
> > +		create_file $SCRATCH_MNT/testdir_$i &
> > +		let i=$i+1
> > +	done
> > +) >/dev/null 2>&1 &
> > +
> > +# Grow fs at the same time, at least x4
> > +# doubling or tripling the size couldn't reproduce
> > +$XFS_GROWFS_PROG -D $((dblocks * 4)) $SCRATCH_MNT >>$seqres.full
> > +
> 
> Even though this is still relatively small based on what people probably
> typically test, we're still making assumptions about the size of the
> scratch device.

_require_fs_space $SCRATCH_MNT <size>

solves that problem. And in places we require 10GB of space, so a
few hundred MB isn't an issue.


-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
