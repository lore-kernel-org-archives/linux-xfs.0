Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B1CB77F7C
	for <xfs@oss.sgi.com>; Wed,  8 Apr 2015 11:14:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A10FC8F8068
	for <xfs@oss.sgi.com>; Wed,  8 Apr 2015 09:13:59 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id E8cJkRi91pvcA291 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 08 Apr 2015 09:13:57 -0700 (PDT)
Date: Wed, 8 Apr 2015 18:13:55 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2][v2] blk-plug: don't flush nested plug lists
Message-ID: <20150408161355.GA16052@lst.de>
References: <1428347694-17704-1-git-send-email-jmoyer@redhat.com>
	<1428347694-17704-2-git-send-email-jmoyer@redhat.com>
	<x49wq1nrcoe.fsf_-_@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49wq1nrcoe.fsf_-_@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, linux-aio@kvack.org, Miklos Szeredi <mszeredi@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Ming Lei <tom.leiming@gmail.com>, Ming Lei <ming.lei@canonical.com>, Trond Myklebust <trond.myklebust@primarydata.com>, Jianyu Zhan <nasa4836@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-kernel@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, target-devel@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, Mark Rustad <mark.d.rustad@intel.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-scsi@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, linux-raid@vger.kernel.org, cluster-devel@redhat.com, Mel Gorman <mgorman@suse.de>, Suleiman Souhlal <suleiman@google.com>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, Changman Lee <cm224.lee@samsung.com>, Rik van Riel <riel@redhat.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, xfs@oss.sgi.com, Fabian Frederick <fabf@skynet.be>, Joe Perches <joe@perches.com>, Alexander Viro <viro@zeniv.linux.org.uk>, xen-devel@lists.xenproject.org, Jaegeuk Kim <jaegeuk@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Jens Axboe <axboe@kernel.dk>, Michal Hocko <mhocko@suse.cz>, linux-nfs@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Wang Sheng-Hui <shhuiw@gmail.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>, linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Weston Andros Adamson <dros@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Roger Pau Monn?? <roger.pau@citrix.com>

This looks good, but without the blk_finish_plug argument we're bound
to grow programming mistakes where people forget it.  Any chance we
could have annotations similar to say rcu_read_lock/rcu_read_unlock
or the spinlocks so that sparse warns about it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
