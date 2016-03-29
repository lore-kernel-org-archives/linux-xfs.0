Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DF09A7CA0
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 03:53:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AD3548F8039
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 01:53:28 -0700 (PDT)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id TNvHKbjEwXK3XnIU
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Mar 2016 01:53:25 -0700 (PDT)
Received: from mail-yw0-f177.google.com ([209.85.161.177])
	by youngberry.canonical.com with esmtpsa
	(TLS1.0:RSA_AES_128_CBC_SHA1:16) (Exim 4.76)
	(envelope-from <ming.lei@canonical.com>) id 1akpOt-0004OG-O9
	for xfs@oss.sgi.com; Tue, 29 Mar 2016 08:53:23 +0000
Received: by mail-yw0-f177.google.com with SMTP id h65so10246392ywe.0
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 01:53:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160329072617.GB18920@infradead.org>
References: <1458627149-12988-1-git-send-email-ming.lei@canonical.com>
	<1458627149-12988-2-git-send-email-ming.lei@canonical.com>
	<20160329072617.GB18920@infradead.org>
Date: Tue, 29 Mar 2016 16:53:22 +0800
Message-ID: <CACVXFVOmyJJjuNNyH89VM3jwVJA0zkA1H-JZtHoX1stxov4C2A@mail.gmail.com>
Subject: Re: [PATCH 1/8] block: move bvec iterator into
	include/linux/bvec_iter.h
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
Cc: Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <boaz@plexistor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Lars Ellenberg <lars.ellenberg@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>, Anton Altaparmakov <anton@tuxera.com>, drbd-dev@lists.linbit.com

On Tue, Mar 29, 2016 at 3:26 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> --- a/include/linux/bio.h
>> +++ b/include/linux/bio.h
>> @@ -31,6 +31,7 @@
>>
>>  /* struct bio, bio_vec and BIO_* flags are defined in blk_types.h */
>>  #include <linux/blk_types.h>
>> +#include <linux/bvec_iter.h>
>>
>>  #define BIO_DEBUG
>>
>> @@ -40,10 +41,6 @@
>>  #define BIO_BUG_ON
>>  #endif
>>
>> -#define BIO_MAX_PAGES                256
>> -#define BIO_MAX_SIZE         (BIO_MAX_PAGES << PAGE_CACHE_SHIFT)
>> -#define BIO_MAX_SECTORS              (BIO_MAX_SIZE >> 9)
>
> I see no reason why these should be moved out of bio.h.

You are right, these should be kept in bio.h.

Thanks for your review!

>
> Otherwise this looks fine to me.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-block" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
