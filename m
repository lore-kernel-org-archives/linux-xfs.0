Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 660907F75
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 05:21:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E46DBAC00A
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 03:20:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RcXL9aIRevQysb60 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2015 03:20:57 -0700 (PDT)
Date: Fri, 21 Aug 2015 18:20:53 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150821102053.GL17933@dhcp-13-216.nay.redhat.com>
References: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
	<20150813004435.GN3902@dastard>
	<20150813224415.GG4496@mtj.duckdns.org>
	<20150814111408.GB8710@quack.suse.cz>
	<20150817200254.GG21075@mtj.duckdns.org>
	<20150818091603.GA12317@quack.suse.cz>
	<20150818174718.GA15739@mtj.duckdns.org>
	<20150818195439.GB15739@mtj.duckdns.org>
	<20150818215611.GD3902@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150818215611.GD3902@dastard>
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com

On Wed, Aug 19, 2015 at 07:56:11AM +1000, Dave Chinner wrote:
> On Tue, Aug 18, 2015 at 12:54:39PM -0700, Tejun Heo wrote:
[snip]
> 
> I'd suggest looking at some of the XFS tracepoints during the test:
> 
> tracepoint			trigger
> xfs_file_buffered_write		once per write syscall
> xfs_file_sync			once per fsync per inode
> xfs_vm_writepage		every ->writepage call
> xfs_setfilesize			every IO completion that updates inode size
> 
> And it's probably best to also include all the writeback
> tracepoints, too, for context. That will tell you what inodes and
> what part of them are getting written back and when....

I finally reproduced generic/048 with both xfs and writeback tracepoints
enabled, please download the trace dat file and trace report file from

http://128.199.137.77/writeback/

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
