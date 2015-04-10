Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0FA977FA4
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 16:50:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 00121304039
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 14:50:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3EYr7V7q6vfSxxhe (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Apr 2015 14:50:17 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/2][v2] blk-plug: don't flush nested plug lists
References: <1428347694-17704-1-git-send-email-jmoyer@redhat.com>
	<1428347694-17704-2-git-send-email-jmoyer@redhat.com>
	<x49wq1nrcoe.fsf_-_@segfault.boston.devel.redhat.com>
	<20150408230203.GG15810@dastard>
Date: Fri, 10 Apr 2015 17:50:06 -0400
In-Reply-To: <20150408230203.GG15810@dastard> (Dave Chinner's message of "Thu,
	9 Apr 2015 09:02:03 +1000")
Message-ID: <x498udzlkkx.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
Cc: Vladimir Davydov <vdavydov@parallels.com>, linux-aio@kvack.org, Miklos Szeredi <mszeredi@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Ming Lei <tom.leiming@gmail.com>, Ming Lei <ming.lei@canonical.com>, Trond Myklebust <trond.myklebust@primarydata.com>, Jianyu Zhan <nasa4836@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-kernel@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, target-devel@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, Mark Rustad <mark.d.rustad@intel.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-scsi@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, linux-raid@vger.kernel.org, cluster-devel@redhat.com, Mel Gorman <mgorman@suse.de>, Suleiman Souhlal <suleiman@google.com>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, Changman Lee <cm224.lee@samsung.com>, Rik van Riel <riel@redhat.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, xfs@oss.sgi.com, Fabian Frederick <fabf@skynet.be>, Joe Perches <joe@perches.com>, Alexander Viro <viro@zeniv.linux.org.uk>, xen-devel@lists.xenproject.org, Jaegeuk Kim <jaegeuk@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Jens Axboe <axboe@kernel.dk>, Michal Hocko <mhocko@suse.cz>, linux-nfs@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Wang Sheng-Hui <shhuiw@gmail.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>, linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Weston Andros Adamson <dros@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Roger Pau Monn?? <roger.pau@citrix.com>

Dave Chinner <david@fromorbit.com> writes:

> On Tue, Apr 07, 2015 at 02:55:13PM -0400, Jeff Moyer wrote:
>> The way the on-stack plugging currently works, each nesting level
>> flushes its own list of I/Os.  This can be less than optimal (read
>> awful) for certain workloads.  For example, consider an application
>> that issues asynchronous O_DIRECT I/Os.  It can send down a bunch of
>> I/Os together in a single io_submit call, only to have each of them
>> dispatched individually down in the bowels of the dirct I/O code.
>> The reason is that there are blk_plug-s instantiated both at the upper
>> call site in do_io_submit and down in do_direct_IO.  The latter will
>> submit as little as 1 I/O at a time (if you have a small enough I/O
>> size) instead of performing the batching that the plugging
>> infrastructure is supposed to provide.
>
> I'm wondering what impact this will have on filesystem metadata IO
> that needs to be issued immediately. e.g. we are doing writeback, so
> there is a high level plug in place and we need to page in btree
> blocks to do extent allocation. We do readahead at this point,
> but it looks like this change will prevent the readahead from being
> issued by the unplug in xfs_buf_iosubmit().

I'm not ignoring you, Dave, I'm just doing some more investigation and
testing.  It's taking longer than I had hoped.

-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
