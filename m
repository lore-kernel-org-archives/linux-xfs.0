Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3848A7CA0
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 17:22:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F13268F8033
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 15:22:37 -0700 (PDT)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id vjZA4fxEYEAnHiga
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Apr 2016 15:22:35 -0700 (PDT)
Received: from mail-yw0-f176.google.com ([209.85.161.176])
	by youngberry.canonical.com with esmtpsa
	(TLS1.0:RSA_AES_128_CBC_SHA1:16) (Exim 4.76)
	(envelope-from <ming.lei@canonical.com>) id 1aqpek-0005Ia-1V
	for xfs@oss.sgi.com; Thu, 14 Apr 2016 22:22:34 +0000
Received: by mail-yw0-f176.google.com with SMTP id i84so119137511ywc.2
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 15:22:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <570FA4F7.6020301@kernel.dk>
References: <1460634438-26530-1-git-send-email-ming.lei@canonical.com>
	<570FA4F7.6020301@kernel.dk>
Date: Fri, 15 Apr 2016 06:22:33 +0800
Message-ID: <CACVXFVN5ifhRiyW8ovugYrwVE_p8DOsLXW_fZ95WV0+54w0mGw@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] block: prepare for multipage bvecs
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
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:XFS FILESYSTEM" <xfs@oss.sgi.com>, Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>, Shaohua Li <shli@fb.com>, Tejun Heo <tj@kernel.org>, Keith Busch <keith.busch@intel.com>, Kent Overstreet <kent.overstreet@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "open list:DRBD DRIVER" <drbd-dev@lists.linbit.com>

On Thu, Apr 14, 2016 at 10:11 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 04/14/2016 05:46 AM, Ming Lei wrote:
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
>> 2) remove BIO_MAX_SECTORS & BIO_MAX_SIZE, and now there is only
>> one user for each. Once multipage bvecs is introduced, one bio
>> may hold lots of sectors, and we should always use sort of BIO_MAX_VECS
>> which should be introduced in future and is similiar with current
>> BIO_MAX_PAGES.
>>
>> xfstests(-a auto) have been run over ext4/xfs and no regression found
>> by this patchset.
>
>
> We've had too many disasters in the block layer the last few series, I'm
> making the 4.7 round a nice and small one. I don't mind taking prep patches
> for the multipage bvecs, if they are simple and clean, but that's about the
> extent of it.
>
> Just a heads up.

Jens, thanks for your response, and understood your concerns.

Please hold on this patchset, and I will check it further and make it
better.

Thanks,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
