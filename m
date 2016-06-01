Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7C4317CA6
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 07:38:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EB23BAC004
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 05:38:46 -0700 (PDT)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id wL6rmvARqbuY8eYZ
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Jun 2016 05:38:44 -0700 (PDT)
Received: from mail-yw0-f180.google.com ([209.85.161.180])
	by youngberry.canonical.com with esmtpsa
	(TLS1.0:RSA_AES_128_CBC_SHA1:16) (Exim 4.76)
	(envelope-from <ming.lei@canonical.com>) id 1b85Q2-0003hH-KG
	for xfs@oss.sgi.com; Wed, 01 Jun 2016 12:38:42 +0000
Received: by mail-yw0-f180.google.com with SMTP id h19so16728260ywc.0
	for <xfs@oss.sgi.com>; Wed, 01 Jun 2016 05:38:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160531155348.GA24840@redhat.com>
References: <1464615294-9946-1-git-send-email-ming.lei@canonical.com>
	<20160531155348.GA24840@redhat.com>
Date: Wed, 1 Jun 2016 20:38:41 +0800
Message-ID: <CACVXFVM9FqZFkMat_4ysJ8_vFd1FFnf6Bd9sHDDoCK=v93wViQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/8] block: prepare for multipage bvecs
From: Ming Lei <ming.lei@canonical.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Steven Whitehouse <swhiteho@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, NeilBrown <neilb@suse.com>, Jens Axboe <axboe@fb.com>, Joe Thornber <ejt@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Shaohua Li <shli@fb.com>, Tejun Heo <tj@kernel.org>, Keith Busch <keith.busch@intel.com>, "open list:XFS FILESYSTEM" <xfs@oss.sgi.com>, Kent Overstreet <kent.overstreet@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "open list:DRBD DRIVER" <drbd-dev@lists.linbit.com>

On Tue, May 31, 2016 at 11:53 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Mon, May 30 2016 at  9:34am -0400,
> Ming Lei <ming.lei@canonical.com> wrote:
>
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
>>
>> V6:
>>       - rebased on v4.7-rc1
>>       - add reviewed-by tag
>>       - mark BIO_MAX_SIZE as obsolete instead of removing because
>>       dm-tree adds one usage now
>
> Not sure what you're referring to here with "dm-tree" (since "dm-tree"
> doesn't exist).  But only direct user of "BIO_MAX_SIZE" in DM appears to

Looks it is from crypto tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6

> be dm-crypt.c.  Maybe you've identified some indirect use of
> BIO_MAX_SIZE?

I mean the recently introduced BIO_MAX_SIZE in -next tree:

https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/drivers/md/dm-crypt.c?id=4ed89c97b0706477b822ea2182827640c0cec486

> --
> To unsubscribe from this list: send the line "unsubscribe linux-block" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
