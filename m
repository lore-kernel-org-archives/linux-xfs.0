Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8E2EF7CA2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 10:53:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E8994AC001
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 08:53:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Q4db1aHwuCOEA8Ue (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 08:53:51 -0700 (PDT)
Date: Tue, 31 May 2016 11:53:49 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v6 0/8] block: prepare for multipage bvecs
Message-ID: <20160531155348.GA24840@redhat.com>
References: <1464615294-9946-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1464615294-9946-1-git-send-email-ming.lei@canonical.com>
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
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-block@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>, NeilBrown <neilb@suse.com>, Jens Axboe <axboe@fb.com>, Joe Thornber <ejt@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Shaohua Li <shli@fb.com>, Tejun Heo <tj@kernel.org>, Keith Busch <keith.busch@intel.com>, "open list:XFS FILESYSTEM" <xfs@oss.sgi.com>, Kent Overstreet <kent.overstreet@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "open list:DRBD DRIVER" <drbd-dev@lists.linbit.com>

On Mon, May 30 2016 at  9:34am -0400,
Ming Lei <ming.lei@canonical.com> wrote:

> 
> Hi,
> 
> Interests[1] have been shown in multipage bvecs, so this patchset
> try to prepare for the support and do two things:
> 
> 1) the 1st 4 patches use bvec iterator to implement iterate_bvec(),
> then we can drop the non-standard way for iterating bvec, which
> can be thought as a good cleanup for lib/iov_iter.c
> 
> 2) remove BIO_MAX_SECTORS and makre BIO_MAX_SIZE as obsolete, and
> now there is only one user for each. Once multipage bvecs is introduced,
> one bio may hold lots of sectors, and we should always use sort of
> BIO_MAX_VECS which should be introduced in future and is similiar
> with current BIO_MAX_PAGES.
> 
> The only functional change is iterate_bvec():lib/iov_iter.c
> 
> xfstests(-a auto) over loop aio is run for ext4/xfs to verify 
> the change and no regression found with this patchset.
> 
> V6:
> 	- rebased on v4.7-rc1
> 	- add reviewed-by tag
> 	- mark BIO_MAX_SIZE as obsolete instead of removing because
> 	dm-tree adds one usage now

Not sure what you're referring to here with "dm-tree" (since "dm-tree"
doesn't exist).  But only direct user of "BIO_MAX_SIZE" in DM appears to
be dm-crypt.c.  Maybe you've identified some indirect use of
BIO_MAX_SIZE?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
