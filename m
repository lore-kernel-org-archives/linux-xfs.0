Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A92297CA0
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 21:44:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6D9C48F8033
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 19:44:42 -0700 (PDT)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id zPuYDNbusCE4vH2Q
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 09 Jun 2016 19:44:37 -0700 (PDT)
Received: from mail-yw0-f173.google.com ([209.85.161.173])
	by youngberry.canonical.com with esmtpsa
	(TLS1.0:RSA_AES_128_CBC_SHA1:16) (Exim 4.76)
	(envelope-from <ming.lei@canonical.com>) id 1bBCR2-00075J-9V
	for xfs@oss.sgi.com; Fri, 10 Jun 2016 02:44:36 +0000
Received: by mail-yw0-f173.google.com with SMTP id z186so36952788ywd.2
	for <xfs@oss.sgi.com>; Thu, 09 Jun 2016 19:44:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <575993EA.3010005@kernel.dk>
References: <1464615294-9946-1-git-send-email-ming.lei@canonical.com>
	<575993EA.3010005@kernel.dk>
From: Ming Lei <ming.lei@canonical.com>
Date: Fri, 10 Jun 2016 10:44:34 +0800
Message-ID: <CACVXFVMbvqyEeX4NsuZLANCCQyxwr2_cjLrLT8tR9LUZkwejdg@mail.gmail.com>
Subject: Re: [PATCH v6 0/8] block: prepare for multipage bvecs
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
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Steven Whitehouse <swhiteho@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, NeilBrown <neilb@suse.com>, Jens Axboe <axboe@fb.com>, Joe Thornber <ejt@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Shaohua Li <shli@fb.com>, Tejun Heo <tj@kernel.org>, Keith Busch <keith.busch@intel.com>, "open list:XFS FILESYSTEM" <xfs@oss.sgi.com>, Kent Overstreet <kent.overstreet@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "open list:DRBD DRIVER" <drbd-dev@lists.linbit.com>

On Fri, Jun 10, 2016 at 12:06 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 05/30/2016 07:34 AM, Ming Lei wrote:
>>
>> Hi,
>>
>> Interests[1] have been shown in multipage bvecs, so this patchset
>> try to prepare for the support and do two things:
>>
>> 1) the 1st 4 patches use bvec iterator to implement iterate_bvec(),
>> then we can drop the non-standard way for iterating bvec, which
>> can be thought as a good cleanup for lib/iov_iter.c
>>
>> 2) remove BIO_MAX_SECTORS and makre BIO_MAX_SIZE as obsolete, and
>> now there is only one user for each. Once multipage bvecs is introduced,
>> one bio may hold lots of sectors, and we should always use sort of
>> BIO_MAX_VECS which should be introduced in future and is similiar
>> with current BIO_MAX_PAGES.
>>
>> The only functional change is iterate_bvec():lib/iov_iter.c
>>
>> xfstests(-a auto) over loop aio is run for ext4/xfs to verify
>> the change and no regression found with this patchset.
>
>
> Added patches 1-7, still waiting for an answer on my reply to #8.

Thanks for adding patches 1-7, and now I just found the added
BIO_MAX_SIZE usage in dm-crypt.c is droped from next, so it is
safe to kill it now.

I will send a new patch #8 against for-4.8/core.

Thanks,
Ming

>
> --
> Jens Axboe
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-block" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
