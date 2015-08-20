Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 308817F54
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 11:55:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 027AF8F804C
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 09:55:42 -0700 (PDT)
Received: from mail-pa0-f41.google.com (mail-pa0-f41.google.com
	[209.85.220.41]) by cuda.sgi.com with ESMTP id aU8lBJh2lLoGIwF1
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 20 Aug 2015 09:55:40 -0700 (PDT)
Received: by pacdd16 with SMTP id dd16so23665256pac.2
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 09:55:39 -0700 (PDT)
Date: Thu, 20 Aug 2015 09:55:37 -0700
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150820165537.GA2044@mtj.duckdns.org>
References: <20150813224415.GG4496@mtj.duckdns.org>
	<20150814111408.GB8710@quack.suse.cz>
	<20150817200254.GG21075@mtj.duckdns.org>
	<20150818091603.GA12317@quack.suse.cz>
	<20150818174718.GA15739@mtj.duckdns.org>
	<20150818195439.GB15739@mtj.duckdns.org>
	<20150818215611.GD3902@dastard>
	<20150820061224.GG17933@dhcp-13-216.nay.redhat.com>
	<20150820143626.GI17933@dhcp-13-216.nay.redhat.com>
	<20150820143735.GJ17933@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150820143735.GJ17933@dhcp-13-216.nay.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

Hello, Eryu.  Thanks a lot for the trace.

So, this is from the end of the trace from the failed test.

...
    kworker/u8:1-1563  [002] 22016.987530: xfs_writepage:        dev 253:6 ino 0xef64fe pgoff 0x9ff000 size 0xa00000 offset 0 length 0 delalloc 1 unwritten 0
     kworker/2:1-49    [002] 22017.373595: xfs_setfilesize:      dev 253:6 ino 0xef6504 isize 0xa00000 disize 0x0 offset 0x0 count 10481664
...

Maybe I'm misunderstanding the code but all xfs_writepage() calls are
from unbound workqueues - the writeback workers - while
xfs_setfilesize() are from bound workqueues, so I wondered why that
was and looked at the code and the setsize functions are run off of a
separate work item which is queued from the end_bio callback and I
can't tell who would be waiting for them.  Dave, what am I missing?

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
