Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:36897 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729383AbfHEVIt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Aug 2019 17:08:49 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: Block device direct read EIO handling broken?
Date: Mon, 5 Aug 2019 21:08:47 +0000
Message-ID: <BYAPR04MB5816246256B1333C048EB0A1E7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190805181524.GE7129@magnolia>
 <66bd785d-7598-5cc2-5e98-447fd128c153@kernel.dk>
 <36973a52-e876-fc09-7a63-2fc16b855f8d@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On 2019/08/06 5:31, Jens Axboe wrote:=0A=
> On 8/5/19 11:31 AM, Jens Axboe wrote:=0A=
>> On 8/5/19 11:15 AM, Darrick J. Wong wrote:=0A=
>>> Hi Damien,=0A=
>>>=0A=
>>> I noticed a regression in xfs/747 (an unreleased xfstest for the=0A=
>>> xfs_scrub media scanning feature) on 5.3-rc3.  I'll condense that down=
=0A=
>>> to a simpler reproducer:=0A=
>>>=0A=
>>> # dmsetup table=0A=
>>> error-test: 0 209 linear 8:48 0=0A=
>>> error-test: 209 1 error=0A=
>>> error-test: 210 6446894 linear 8:48 210=0A=
>>>=0A=
>>> Basically we have a ~3G /dev/sdd and we set up device mapper to fail IO=
=0A=
>>> for sector 209 and to pass the io to the scsi device everywhere else.=
=0A=
>>>=0A=
>>> On 5.3-rc3, performing a directio pread of this range with a < 1M buffe=
r=0A=
>>> (in other words, a request for fewer than MAX_BIO_PAGES bytes) yields=
=0A=
>>> EIO like you'd expect:=0A=
>>>=0A=
>>> # strace -e pread64 xfs_io -d -c 'pread -b 1024k 0k 1120k' /dev/mapper/=
error-test=0A=
>>> pread64(3, 0x7f880e1c7000, 1048576, 0)  =3D -1 EIO (Input/output error)=
=0A=
>>> pread: Input/output error=0A=
>>> +++ exited with 0 +++=0A=
>>>=0A=
>>> But doing it with a larger buffer succeeds(!):=0A=
>>>=0A=
>>> # strace -e pread64 xfs_io -d -c 'pread -b 2048k 0k 1120k' /dev/mapper/=
error-test=0A=
>>> pread64(3, "XFSB\0\0\20\0\0\0\0\0\0\fL\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\=
0"..., 1146880, 0) =3D 1146880=0A=
>>> read 1146880/1146880 bytes at offset 0=0A=
>>> 1 MiB, 1 ops; 0.0009 sec (1.124 GiB/sec and 1052.6316 ops/sec)=0A=
>>> +++ exited with 0 +++=0A=
>>>=0A=
>>> (Note that the part of the buffer corresponding to the dm-error area is=
=0A=
>>> uninitialized)=0A=
>>>=0A=
>>> On 5.3-rc2, both commands would fail with EIO like you'd expect.  The=
=0A=
>>> only change between rc2 and rc3 is commit 0eb6ddfb865c ("block: Fix=0A=
>>> __blkdev_direct_IO() for bio fragments").=0A=
>>>=0A=
>>> AFAICT we end up in __blkdev_direct_IO with a 1120K buffer, which gets=
=0A=
>>> split into two bios: one for the first BIO_MAX_PAGES worth of data (1MB=
)=0A=
>>> and a second one for the 96k after that.=0A=
>>>=0A=
>>> I think the problem is that every time we submit a bio, we increase ret=
=0A=
>>> by the size of that bio, but at the time we do that we have no idea if=
=0A=
>>> the bio is going to succeed or not.  At the end of the function we do:=
=0A=
>>>=0A=
>>> 	if (!ret)=0A=
>>> 		ret =3D blk_status_to_errno(dio->bio.bi_status);=0A=
>>>=0A=
>>> Which means that we only pick up the IO error if we haven't already set=
=0A=
>>> ret.  I suppose that was useful for being able to return a short read,=
=0A=
>>> but now that we always increment ret by the size of the bio, we act lik=
e=0A=
>>> the whole buffer was read.  I tried a -rc2 kernel and found that 40% of=
=0A=
>>> the time I'd get an EIO and the rest of the time I got a short read.=0A=
>>>=0A=
>>> Not sure where to go from here, but something's not right...=0A=
>>=0A=
>> I'll take a look.=0A=
> =0A=
> How about this? The old code did:=0A=
> =0A=
> 	if (!ret)=0A=
> 		ret =3D blk_status_to_errno(dio->bio.bi_status);=0A=
> 	if (likely(!ret))=0A=
> 		ret =3D dio->size;=0A=
> =0A=
> where 'ret' was just tracking the error. With 'ret' now being the=0A=
> positive IO size, we should overwrite it if ret is >=3D 0, not just if=0A=
> it's zero.=0A=
> =0A=
> Also kill a use-after-free.=0A=
> =0A=
> diff --git a/fs/block_dev.c b/fs/block_dev.c=0A=
> index a6f7c892cb4a..67c8e87c9481 100644=0A=
> --- a/fs/block_dev.c=0A=
> +++ b/fs/block_dev.c=0A=
> @@ -386,6 +386,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_ite=
r *iter, int nr_pages)=0A=
>  =0A=
>  	ret =3D 0;=0A=
>  	for (;;) {=0A=
> +		ssize_t this_size;=0A=
>  		int err;=0A=
>  =0A=
>  		bio_set_dev(bio, bdev);=0A=
> @@ -433,13 +434,14 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_i=
ter *iter, int nr_pages)=0A=
>  				polled =3D true;=0A=
>  			}=0A=
>  =0A=
> +			this_size =3D bio->bi_iter.bi_size;=0A=
>  			qc =3D submit_bio(bio);=0A=
>  			if (qc =3D=3D BLK_QC_T_EAGAIN) {=0A=
>  				if (!ret)=0A=
>  					ret =3D -EAGAIN;=0A=
>  				goto error;=0A=
>  			}=0A=
> -			ret =3D dio->size;=0A=
> +			ret +=3D this_size;=0A=
>  =0A=
>  			if (polled)=0A=
>  				WRITE_ONCE(iocb->ki_cookie, qc);=0A=
> @@ -460,13 +462,14 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_i=
ter *iter, int nr_pages)=0A=
>  			atomic_inc(&dio->ref);=0A=
>  		}=0A=
>  =0A=
> +		this_size =3D bio->bi_iter.bi_size;=0A=
>  		qc =3D submit_bio(bio);=0A=
>  		if (qc =3D=3D BLK_QC_T_EAGAIN) {=0A=
>  			if (!ret)=0A=
>  				ret =3D -EAGAIN;=0A=
>  			goto error;=0A=
>  		}=0A=
> -		ret =3D dio->size;=0A=
> +		ret +=3D this_size;=0A=
>  =0A=
>  		bio =3D bio_alloc(gfp, nr_pages);=0A=
>  		if (!bio) {=0A=
> @@ -494,7 +497,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_ite=
r *iter, int nr_pages)=0A=
>  	__set_current_state(TASK_RUNNING);=0A=
>  =0A=
>  out:=0A=
> -	if (!ret)=0A=
> +	if (ret >=3D 0)=0A=
>  		ret =3D blk_status_to_errno(dio->bio.bi_status);=0A=
>  =0A=
>  	bio_put(&dio->bio);=0A=
> =0A=
=0A=
Jens,=0A=
=0A=
I would set "this_size" when dio->size is being incremented though, to avoi=
d=0A=
repeating it.=0A=
=0A=
		if (nowait)=0A=
			bio->bi_opf |=3D (REQ_NOWAIT | REQ_NOWAIT_INLINE);=0A=
=0A=
+		this_size =3D bio->bi_iter.bi_size;=0A=
-		dio->size +=3D bio->bi_iter.bi_size;=0A=
+		dio->size +=3D this_size;=0A=
		pos +=3D bio->bi_iter.bi_size;=0A=
=0A=
In any case, looking again at this code, it looks like there is a problem w=
ith=0A=
dio->size being incremented early, even for fragments that get BLK_QC_T_EAG=
AIN,=0A=
because dio->size is being used in blkdev_bio_end_io(). So an incorrect siz=
e can=0A=
be reported to user space in that case on completion (e.g. large asynchrono=
us=0A=
no-wait dio that cannot be issued in one go).=0A=
=0A=
So maybe something like this ? (completely untested)=0A=
=0A=
diff --git a/fs/block_dev.c b/fs/block_dev.c=0A=
index 75cc7f424b3a..77714e03c21e 100644=0A=
--- a/fs/block_dev.c=0A=
+++ b/fs/block_dev.c=0A=
@@ -349,7 +349,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter=
=0A=
*iter, int nr_pages)=0A=
        loff_t pos =3D iocb->ki_pos;=0A=
        blk_qc_t qc =3D BLK_QC_T_NONE;=0A=
        gfp_t gfp;=0A=
-       ssize_t ret;=0A=
+       ssize_t ret =3D 0;=0A=
=0A=
        if ((pos | iov_iter_alignment(iter)) &=0A=
            (bdev_logical_block_size(bdev) - 1))=0A=
@@ -386,6 +386,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter=
=0A=
*iter, int nr_pages)=0A=
=0A=
        ret =3D 0;=0A=
        for (;;) {=0A=
+               size_t this_size;=0A=
                int err;=0A=
=0A=
                bio_set_dev(bio, bdev);=0A=
@@ -421,7 +422,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter=
=0A=
*iter, int nr_pages)=0A=
                if (nowait)=0A=
                        bio->bi_opf |=3D (REQ_NOWAIT | REQ_NOWAIT_INLINE);=
=0A=
=0A=
-               dio->size +=3D bio->bi_iter.bi_size;=0A=
+               this_size =3D bio->bi_iter.bi_size;=0A=
                pos +=3D bio->bi_iter.bi_size;=0A=
=0A=
                nr_pages =3D iov_iter_npages(iter, BIO_MAX_PAGES);=0A=
@@ -435,11 +436,11 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_ite=
r=0A=
*iter, int nr_pages)=0A=
=0A=
                        qc =3D submit_bio(bio);=0A=
                        if (qc =3D=3D BLK_QC_T_EAGAIN) {=0A=
-                               if (!ret)=0A=
+                               if (!dio->size)=0A=
                                        ret =3D -EAGAIN;=0A=
                                goto error;=0A=
                        }=0A=
-                       ret =3D dio->size;=0A=
+                       dio->size +=3D this_size;=0A=
=0A=
                        if (polled)=0A=
                                WRITE_ONCE(iocb->ki_cookie, qc);=0A=
@@ -462,15 +463,15 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_ite=
r=0A=
*iter, int nr_pages)=0A=
=0A=
                qc =3D submit_bio(bio);=0A=
                if (qc =3D=3D BLK_QC_T_EAGAIN) {=0A=
-                       if (!ret)=0A=
+                       if (!dio->size)=0A=
                                ret =3D -EAGAIN;=0A=
                        goto error;=0A=
                }=0A=
-               ret =3D dio->size;=0A=
+               dio->size +=3D this_size;=0A=
=0A=
                bio =3D bio_alloc(gfp, nr_pages);=0A=
                if (!bio) {=0A=
-                       if (!ret)=0A=
+                       if (!dio->size)=0A=
                                ret =3D -EAGAIN;=0A=
                        goto error;=0A=
                }=0A=
@@ -496,10 +497,15 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_ite=
r=0A=
*iter, int nr_pages)=0A=
 out:=0A=
        if (!ret)=0A=
                ret =3D blk_status_to_errno(dio->bio.bi_status);=0A=
+       if (likely(!ret))=0A=
+               ret =3D dio->size;=0A=
=0A=
        bio_put(&dio->bio);=0A=
        return ret;=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
