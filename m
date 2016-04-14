Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4804B7CA1
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 09:11:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0AAEE8F8318
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 07:11:07 -0700 (PDT)
Received: from mail-ig0-f179.google.com (mail-ig0-f179.google.com
	[209.85.213.179]) by cuda.sgi.com with ESMTP id
	dDicQUY1ryJj7fpo (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Apr 2016 07:11:06 -0700 (PDT)
Received: by mail-ig0-f179.google.com with SMTP id ui10so91854846igc.1
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 07:11:06 -0700 (PDT)
Subject: Re: [PATCH v4 0/8] block: prepare for multipage bvecs
References: <1460634438-26530-1-git-send-email-ming.lei@canonical.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <570FA4F7.6020301@kernel.dk>
Date: Thu, 14 Apr 2016 08:11:03 -0600
MIME-Version: 1.0
In-Reply-To: <1460634438-26530-1-git-send-email-ming.lei@canonical.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, "open list:XFS FILESYSTEM" <xfs@oss.sgi.com>, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Shaohua Li <shli@fb.com>, Tejun Heo <tj@kernel.org>, Keith Busch <keith.busch@intel.com>, Kent Overstreet <kent.overstreet@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "open list:DRBD DRIVER" <drbd-dev@lists.linbit.com>

On 04/14/2016 05:46 AM, Ming Lei wrote:
> Hi,
>
> Interests[1] have been shown in multipage bvecs, so this patchset
> try to prepare for the support and do two things:
>
> 1) the 1st 4 patches use bvec iterator to implement iterate_bvec(),
> then we can drop the non-standard way for iterating bvec, which
> can be thought as a good cleanup for lib/iov_iter.c
>
> 2) remove BIO_MAX_SECTORS & BIO_MAX_SIZE, and now there is only
> one user for each. Once multipage bvecs is introduced, one bio
> may hold lots of sectors, and we should always use sort of BIO_MAX_VECS
> which should be introduced in future and is similiar with current
> BIO_MAX_PAGES.
>
> xfstests(-a auto) have been run over ext4/xfs and no regression found
> by this patchset.

We've had too many disasters in the block layer the last few series, I'm 
making the 4.7 round a nice and small one. I don't mind taking prep 
patches for the multipage bvecs, if they are simple and clean, but 
that's about the extent of it.

Just a heads up.

-- 
Jens Axboe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
