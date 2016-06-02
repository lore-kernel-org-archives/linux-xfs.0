Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B949D7CAE
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 22:33:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2C778AC002
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 20:32:58 -0700 (PDT)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id 5Gu63uzkpsask7AF
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Jun 2016 20:32:53 -0700 (PDT)
Received: from mail-yw0-f173.google.com ([209.85.161.173])
	by youngberry.canonical.com with esmtpsa
	(TLS1.0:RSA_AES_128_CBC_SHA1:16) (Exim 4.76)
	(envelope-from <ming.lei@canonical.com>) id 1b8JNM-0000LQ-4l
	for xfs@oss.sgi.com; Thu, 02 Jun 2016 03:32:52 +0000
Received: by mail-yw0-f173.google.com with SMTP id c127so38087532ywb.1
	for <xfs@oss.sgi.com>; Wed, 01 Jun 2016 20:32:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160601134816.GA20963@infradead.org>
References: <1464615294-9946-1-git-send-email-ming.lei@canonical.com>
	<1464615294-9946-6-git-send-email-ming.lei@canonical.com>
	<20160601134816.GA20963@infradead.org>
Date: Thu, 2 Jun 2016 11:32:51 +0800
Message-ID: <CACVXFVOJ-RDpu3yy1af3ZTo16-q4J6hsuV5d=6_0fi-i4b3ycw@mail.gmail.com>
Subject: Re: [PATCH v6 5/8] fs: xfs: replace BIO_MAX_SECTORS with BIO_MAX_PAGES
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "supporter:XFS FILESYSTEM" <xfs@oss.sgi.com>

On Wed, Jun 1, 2016 at 9:48 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, May 30, 2016 at 09:34:33PM +0800, Ming Lei wrote:
>> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
>> index e71cfbd..e5d713b 100644
>> --- a/fs/xfs/xfs_buf.c
>> +++ b/fs/xfs/xfs_buf.c
>> @@ -1157,9 +1157,7 @@ xfs_buf_ioapply_map(
>>
>>  next_chunk:
>>       atomic_inc(&bp->b_io_remaining);
>> -     nr_pages = BIO_MAX_SECTORS >> (PAGE_SHIFT - BBSHIFT);
>> -     if (nr_pages > total_nr_pages)
>> -             nr_pages = total_nr_pages;
>> +     nr_pages = min(total_nr_pages, BIO_MAX_PAGES);
>>
>>       bio = bio_alloc(GFP_NOIO, nr_pages);
>
> While I think this is a useful cleanup on it's own I think
> you'd make everyones life easier if bio_alloc simply clamped down
> the passed nr_pages value to the maximum allowed.

Yes, that looks a good cleanup, but need be careful because the
passed 'nr_pages' can be used after returning from bio_alloc() in
the current function, and it is easy to see this usage.

So we can do that in another patchset instead of this one.

Thanks,

> --
> To unsubscribe from this list: send the line "unsubscribe linux-block" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
