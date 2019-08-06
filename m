Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:61606 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728851AbfHFAFx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Aug 2019 20:05:53 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: Block device direct read EIO handling broken?
Date: Tue, 6 Aug 2019 00:05:51 +0000
Message-ID: <BYAPR04MB5816D1AB6B586FAD664F8D79E7D50@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190805181524.GE7129@magnolia>
 <66bd785d-7598-5cc2-5e98-447fd128c153@kernel.dk>
 <36973a52-e876-fc09-7a63-2fc16b855f8d@kernel.dk>
 <BYAPR04MB5816246256B1333C048EB0A1E7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <474c560f-5de0-6082-67ac-f7c640d9b346@kernel.dk>
 <BYAPR04MB5816C3B24310C1E18F9E024CE7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <f3f98663-8f92-c933-c7c0-8db6635e6112@kernel.dk>
 <BYAPR04MB581644536C6EAEA36E3B4912E7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <BYAPR04MB5816C7D04915AF7B656F900BE7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On 2019/08/06 7:05, Damien Le Moal wrote:=0A=
> On 2019/08/06 6:59, Damien Le Moal wrote:=0A=
>> On 2019/08/06 6:28, Jens Axboe wrote:=0A=
>>> On 8/5/19 2:27 PM, Damien Le Moal wrote:=0A=
>>>> On 2019/08/06 6:26, Jens Axboe wrote:=0A=
>>>>>> In any case, looking again at this code, it looks like there is a=0A=
>>>>>> problem with dio->size being incremented early, even for fragments=
=0A=
>>>>>> that get BLK_QC_T_EAGAIN, because dio->size is being used in=0A=
>>>>>> blkdev_bio_end_io(). So an incorrect size can be reported to user=0A=
>>>>>> space in that case on completion (e.g. large asynchronous no-wait di=
o=0A=
>>>>>> that cannot be issued in one go).=0A=
>>>>>>=0A=
>>>>>> So maybe something like this ? (completely untested)=0A=
>>>>>=0A=
>>>>> I think that looks pretty good, I like not double accounting with=0A=
>>>>> this_size and dio->size, and we retain the old style ordering for the=
=0A=
>>>>> ret value.=0A=
>>>>=0A=
>>>> Do you want a proper patch with real testing backup ? I can send that=
=0A=
>>>> later today.=0A=
>>>=0A=
>>> Yeah that'd be great, I like your approach better.=0A=
>>>=0A=
>>=0A=
>> Looking again, I think this is not it yet: dio->size is being referenced=
 after=0A=
>> submit_bio(), so blkdev_bio_end_io() may see the old value if the bio co=
mpletes=0A=
>> before dio->size increment. So the use-after-free is still there. And si=
nce=0A=
>> blkdev_bio_end_io() processes completion to user space only when dio->re=
f=0A=
>> becomes 0, adding an atomic_inc/dec(&dio->ref) over the loop would not h=
elp and=0A=
>> does not cover the single BIO case. Any idea how to address this one ?=
=0A=
>>=0A=
> =0A=
> May be add a bio_get/put() over the 2 places that do submit_bio() would w=
ork,=0A=
> for all cases (single/multi BIO, sync & async). E.g.:=0A=
> =0A=
> +                       bio_get(bio);=0A=
>                         qc =3D submit_bio(bio);=0A=
>                         if (qc =3D=3D BLK_QC_T_EAGAIN) {=0A=
>                                 if (!dio->size)=0A=
>                                         ret =3D -EAGAIN;=0A=
> +                               bio_put(bio);=0A=
>                                 goto error;=0A=
>                         }=0A=
>                         dio->size +=3D bio_size;=0A=
> +                       bio_put(bio);=0A=
> =0A=
> Thoughts ?=0A=
> =0A=
=0A=
That does not work since the reference to dio->size in blkdev_bio_end_io()=
=0A=
depends on atomic_dec_and_test(&dio->ref) which counts the BIO fragments fo=
r the=0A=
dio (+1 for async multi-bio case). So completion of the last bio can still=
=0A=
reference the old value of dio->size.=0A=
=0A=
Adding a bio_get/put() on dio->bio ensures that dio stays around, but does =
not=0A=
prevent the use of the wrong dio->size. Adding an additional=0A=
atomic_inc/dec(&dio->ref) would prevent that, but we would need to handle d=
io=0A=
completion at the end of __blkdev_direct_IO() if all BIO fragments already=
=0A=
completed at that point. That is a lot more plumbing needed, relying comple=
tely=0A=
on dio->ref for all cases, thus removing the dio->multi_bio management.=0A=
=0A=
Something like this:=0A=
=0A=
diff --git a/fs/block_dev.c b/fs/block_dev.c=0A=
index a6f7c892cb4a..51d36baa367c 100644=0A=
--- a/fs/block_dev.c=0A=
+++ b/fs/block_dev.c=0A=
@@ -279,7 +279,6 @@ struct blkdev_dio {=0A=
        };=0A=
        size_t                  size;=0A=
        atomic_t                ref;=0A=
-       bool                    multi_bio : 1;=0A=
        bool                    should_dirty : 1;=0A=
        bool                    is_sync : 1;=0A=
        struct bio              bio;=0A=
@@ -295,15 +294,14 @@ static int blkdev_iopoll(struct kiocb *kiocb, bool wa=
it)=0A=
        return blk_poll(q, READ_ONCE(kiocb->ki_cookie), wait);=0A=
 }=0A=
=0A=
-static void blkdev_bio_end_io(struct bio *bio)=0A=
+static inline void blkdev_get_dio(struct blkdev_dio *dio)=0A=
 {=0A=
-       struct blkdev_dio *dio =3D bio->bi_private;=0A=
-       bool should_dirty =3D dio->should_dirty;=0A=
-=0A=
-       if (bio->bi_status && !dio->bio.bi_status)=0A=
-               dio->bio.bi_status =3D bio->bi_status;=0A=
+       atomic_inc(&dio->ref);=0A=
+}=0A=
=0A=
-       if (!dio->multi_bio || atomic_dec_and_test(&dio->ref)) {=0A=
+static void blkdev_put_dio(struct blkdev_dio *dio)=0A=
+{=0A=
+       if (atomic_dec_and_test(&dio->ref)) {=0A=
                if (!dio->is_sync) {=0A=
                        struct kiocb *iocb =3D dio->iocb;=0A=
                        ssize_t ret;=0A=
@@ -316,15 +314,25 @@ static void blkdev_bio_end_io(struct bio *bio)=0A=
                        }=0A=
=0A=
                        dio->iocb->ki_complete(iocb, ret, 0);=0A=
-                       if (dio->multi_bio)=0A=
-                               bio_put(&dio->bio);=0A=
                } else {=0A=
                        struct task_struct *waiter =3D dio->waiter;=0A=
=0A=
                        WRITE_ONCE(dio->waiter, NULL);=0A=
                        blk_wake_io_task(waiter);=0A=
                }=0A=
+               bio_put(&dio->bio);=0A=
        }=0A=
+}=0A=
+=0A=
+static void blkdev_bio_end_io(struct bio *bio)=0A=
+{=0A=
+       struct blkdev_dio *dio =3D bio->bi_private;=0A=
+       bool should_dirty =3D dio->should_dirty;=0A=
+=0A=
+       if (bio->bi_status && !dio->bio.bi_status)=0A=
+               dio->bio.bi_status =3D bio->bi_status;=0A=
+=0A=
+       blkdev_put_dio(dio);=0A=
=0A=
        if (should_dirty) {=0A=
                bio_check_pages_dirty(bio);=0A=
@@ -349,7 +357,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter=
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
@@ -366,17 +374,24 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_ite=
r=0A=
*iter, int nr_pages)=0A=
=0A=
        dio =3D container_of(bio, struct blkdev_dio, bio);=0A=
        dio->is_sync =3D is_sync =3D is_sync_kiocb(iocb);=0A=
-       if (dio->is_sync) {=0A=
+       if (dio->is_sync)=0A=
                dio->waiter =3D current;=0A=
-               bio_get(bio);=0A=
-       } else {=0A=
+       else=0A=
                dio->iocb =3D iocb;=0A=
-       }=0A=
=0A=
        dio->size =3D 0;=0A=
-       dio->multi_bio =3D false;=0A=
        dio->should_dirty =3D is_read && iter_is_iovec(iter);=0A=
=0A=
+       /*=0A=
+        * Get an extra reference on the first bio to ensure that the dio=
=0A=
+        * structure which is embedded into the first bio stays around for =
AIOs=0A=
+        * and while we are still doing dio->size accounting in the loop be=
low.=0A=
+        * For dio->is_sync case, the extra reference is released on exit o=
f=0A=
+        * this function.=0A=
+        */=0A=
+       bio_get(bio);=0A=
+       blkdev_get_dio(dio);=0A=
+=0A=
        /*=0A=
         * Don't plug for HIPRI/polled IO, as those should go straight=0A=
         * to issue=0A=
@@ -386,6 +401,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter=
=0A=
*iter, int nr_pages)=0A=
=0A=
        ret =3D 0;=0A=
        for (;;) {=0A=
+               size_t bio_size;=0A=
                int err;=0A=
=0A=
                bio_set_dev(bio, bdev);=0A=
@@ -421,7 +437,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter=
=0A=
*iter, int nr_pages)=0A=
                if (nowait)=0A=
                        bio->bi_opf |=3D (REQ_NOWAIT | REQ_NOWAIT_INLINE);=
=0A=
=0A=
-               dio->size +=3D bio->bi_iter.bi_size;=0A=
+               bio_size =3D bio->bi_iter.bi_size;=0A=
                pos +=3D bio->bi_iter.bi_size;=0A=
=0A=
                nr_pages =3D iov_iter_npages(iter, BIO_MAX_PAGES);=0A=
=0A=
@@ -435,42 +451,30 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_ite=
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
+                       dio->size +=3D bio_size;=0A=
=0A=
                        if (polled)=0A=
                                WRITE_ONCE(iocb->ki_cookie, qc);=0A=
                        break;=0A=
                }=0A=
=0A=
-               if (!dio->multi_bio) {=0A=
-                       /*=0A=
-                        * AIO needs an extra reference to ensure the dio=
=0A=
-                        * structure which is embedded into the first bio=
=0A=
-                        * stays around.=0A=
-                        */=0A=
-                       if (!is_sync)=0A=
-                               bio_get(bio);=0A=
-                       dio->multi_bio =3D true;=0A=
-                       atomic_set(&dio->ref, 2);=0A=
-               } else {=0A=
-                       atomic_inc(&dio->ref);=0A=
-               }=0A=
+               blkdev_get_dio(dio);=0A=
=0A=
                qc =3D submit_bio(bio);=0A=
                if (qc =3D=3D BLK_QC_T_EAGAIN) {=0A=
-                       if (!ret)=0A=
+                       if (!dio->size)=0A=
                                ret =3D -EAGAIN;=0A=
                        goto error;=0A=
                }=0A=
-               ret =3D dio->size;=0A=
+               dio->size +=3D bio_size;=0A=
=0A=
                bio =3D bio_alloc(gfp, nr_pages);=0A=
                if (!bio) {=0A=
-                       if (!ret)=0A=
+                       if (!dio->size)=0A=
                                ret =3D -EAGAIN;=0A=
                        goto error;=0A=
                }=0A=
@@ -496,8 +500,10 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter=
=0A=
*iter, int nr_pages)=0A=
 out:=0A=
        if (!ret)=0A=
                ret =3D blk_status_to_errno(dio->bio.bi_status);=0A=
+       if (likely(!ret))=0A=
+               ret =3D dio->size;=0A=
=0A=
-       bio_put(&dio->bio);=0A=
+       blkdev_put_dio(dio);=0A=
        return ret;=0A=
 error:=0A=
        if (!is_poll)=0A=
=0A=
I think that works for all cases. Starting tests. Let me know if you think =
this=0A=
is not appropriate.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
