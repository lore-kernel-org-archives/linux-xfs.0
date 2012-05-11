Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4BEVa8v035985
	for <linux-xfs@oss.sgi.com>; Fri, 11 May 2012 09:31:37 -0500
Received: from mailgw1.uni-kl.de (mailgw1.uni-kl.de [131.246.120.220]) by
	cuda.sgi.com with ESMTP id RCAfd8Mwp7IriYVy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Fri, 11 May 2012 07:31:35 -0700 (PDT)
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id
	q4BEVWAr028400
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-xfs@oss.sgi.com>; Fri, 11 May 2012 16:31:32 +0200
Message-ID: <4FAD22BD.7010007@itwm.fraunhofer.de>
Date: Fri, 11 May 2012 16:31:25 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
Subject: Re: [PATCH] bio allocation failure due to bio_get_nr_vecs()
References: <jognqm$o21$1@dough.gmane.org>
	<4FABF01E.7080303@itwm.fraunhofer.de>
	<4FAD18D4.3090102@itwm.fraunhofer.de>
	<x49sjf6vml5.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49sjf6vml5.fsf@segfault.boston.devel.redhat.com>
Content-Type: multipart/mixed; boundary="------------080007060100060203010907"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, sandeen@sandeen.net, linux-xfs@oss.sgi.com, Tejun Heo <tj@kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>

This is a multi-part message in MIME format.
--------------080007060100060203010907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 05/11/2012 04:06 PM, Jeff Moyer wrote:
> Bernd Schubert<bernd.schubert@itwm.fraunhofer.de>  writes:
>
>> diff --git a/fs/bio.c b/fs/bio.c
>> index e453924..84da885 100644
>> --- a/fs/bio.c
>> +++ b/fs/bio.c
>> @@ -505,9 +505,14 @@ EXPORT_SYMBOL(bio_clone);
>>   int bio_get_nr_vecs(struct block_device *bdev)
>>   {
>>   	struct request_queue *q = bdev_get_queue(bdev);
>> -	return min_t(unsigned,
>> +	int nr_pages;
>
> Looks like a corrupt patch.

What do you actually mean? Issue by thunderbird? I just saved the mail 
in my sent folder and it looks? Just to be sure, patch attached.


Thanks,
Bernd

--------------080007060100060203010907
Content-Type: text/x-patch;
 name="fix-bio-nrvec.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix-bio-nrvec.patch"

bio: bio_get_nr_vecs() must not return more than BIO_MAX_PAGES

From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

The number of bio_get_nr_vecs() is passed down via bio_alloc() to
bvec_alloc_bs(), which fails the bio allocation if
nr_iovecs > BIO_MAX_PAGES. For the underlying caller this causes an
unexpected bio allocation failure.
Limiting to queue_max_segments() is not sufficiet, as max_segments
also might be very large.

bvec_alloc_bs(gfp_mask, nr_iovecs, ) => NULL when nr_iovecs  > BIO_MAX_PAGES
bio_alloc_bioset(gfp_mask, nr_iovecs, ...)
bio_alloc(GFP_NOIO, nvecs)
xfs_alloc_ioend_bio()


Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
---
 fs/bio.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/bio.c b/fs/bio.c
index e453924..84da885 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -505,9 +505,14 @@ EXPORT_SYMBOL(bio_clone);
 int bio_get_nr_vecs(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
-	return min_t(unsigned,
+	int nr_pages;
+
+	nr_pages = min_t(unsigned,
 		     queue_max_segments(q),
 		     queue_max_sectors(q) / (PAGE_SIZE >> 9) + 1);
+
+	return min_t(unsigned, nr_pages, BIO_MAX_PAGES);
+
 }
 EXPORT_SYMBOL(bio_get_nr_vecs);
 

--------------080007060100060203010907
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------080007060100060203010907--
