Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 191517CA0
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 11:06:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CEF348F8033
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 09:06:08 -0700 (PDT)
Received: from mail-io0-f182.google.com (mail-io0-f182.google.com
	[209.85.223.182]) by cuda.sgi.com with ESMTP id
	cZYuGEftKC0TCyWc (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 09 Jun 2016 09:06:06 -0700 (PDT)
Received: by mail-io0-f182.google.com with SMTP id 5so42025415ioy.1
	for <xfs@oss.sgi.com>; Thu, 09 Jun 2016 09:06:06 -0700 (PDT)
Subject: Re: [PATCH v6 0/8] block: prepare for multipage bvecs
References: <1464615294-9946-1-git-send-email-ming.lei@canonical.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <575993EA.3010005@kernel.dk>
Date: Thu, 9 Jun 2016 10:06:02 -0600
MIME-Version: 1.0
In-Reply-To: <1464615294-9946-1-git-send-email-ming.lei@canonical.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, NeilBrown <neilb@suse.com>, Sagi Grimberg <sagig@mellanox.com>, Steven Whitehouse <swhiteho@redhat.com>, linux-block@vger.kernel.org, Joe Thornber <ejt@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Shaohua Li <shli@fb.com>, Tejun Heo <tj@kernel.org>, Keith Busch <keith.busch@intel.com>, "open list:XFS FILESYSTEM" <xfs@oss.sgi.com>, Kent Overstreet <kent.overstreet@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "open list:DRBD DRIVER" <drbd-dev@lists.linbit.com>

On 05/30/2016 07:34 AM, Ming Lei wrote:
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

Added patches 1-7, still waiting for an answer on my reply to #8.

-- 
Jens Axboe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
