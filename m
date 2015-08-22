Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 253AC7FAA
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 23:46:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 147B0304032
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 21:46:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id v9oIwCYJlX7YrNnD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2015 21:46:16 -0700 (PDT)
Date: Sat, 22 Aug 2015 12:46:09 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150822044609.GM17933@dhcp-13-216.nay.redhat.com>
References: <20150813004435.GN3902@dastard>
	<20150813224415.GG4496@mtj.duckdns.org>
	<20150814111408.GB8710@quack.suse.cz>
	<20150817200254.GG21075@mtj.duckdns.org>
	<20150818091603.GA12317@quack.suse.cz>
	<20150818174718.GA15739@mtj.duckdns.org>
	<20150818195439.GB15739@mtj.duckdns.org>
	<20150818215611.GD3902@dastard>
	<20150821102053.GL17933@dhcp-13-216.nay.redhat.com>
	<20150822003025.GS3902@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150822003025.GS3902@dastard>
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

On Sat, Aug 22, 2015 at 10:30:25AM +1000, Dave Chinner wrote:
> On Fri, Aug 21, 2015 at 06:20:53PM +0800, Eryu Guan wrote:
[snip]
> 
> Eryu, can you try again, this time manually specifying the writeback
> tracepoints so you exclude the really noisy ones? You can also drop
> the xfs_file_buffered_write and xfs_file_fsync tracepoints as well,
> as we can see that the incoming side of the code is doing the right
> thing....

I excluded the writeback tracepoints you mentioned

writeback_mark_inode_dirty
writeback_dirty_inode_start
writeback_dirty_inode
writeback_dirty_page
writeback_write_inode

and left all other writeback tracepoints enabled, also dropped
xfs_file_buffered_write and xfs_file_fsync.

This time I can reproduce generic/048 quickly and please download the
trace info from below

http://128.199.137.77/writeback-v2/

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
