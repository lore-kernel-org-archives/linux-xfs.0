Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:49145 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731711AbfHFHFG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 03:05:06 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: Block device direct read EIO handling broken?
Date: Tue, 6 Aug 2019 07:05:03 +0000
Message-ID: <BYAPR04MB5816811245DDC55429D6D146E7D50@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190805181524.GE7129@magnolia>
 <66bd785d-7598-5cc2-5e98-447fd128c153@kernel.dk>
 <36973a52-e876-fc09-7a63-2fc16b855f8d@kernel.dk>
 <BYAPR04MB5816246256B1333C048EB0A1E7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <474c560f-5de0-6082-67ac-f7c640d9b346@kernel.dk>
 <BYAPR04MB5816C3B24310C1E18F9E024CE7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <f3f98663-8f92-c933-c7c0-8db6635e6112@kernel.dk>
 <BYAPR04MB581644536C6EAEA36E3B4912E7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <BYAPR04MB5816C7D04915AF7B656F900BE7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <BYAPR04MB5816D1AB6B586FAD664F8D79E7D50@BYAPR04MB5816.namprd04.prod.outlook.com>
 <43435418-9d70-ec33-1f2d-c95fb986979c@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On 2019/08/06 13:09, Jens Axboe wrote:=0A=
> On 8/5/19 5:05 PM, Damien Le Moal wrote:=0A=
>> On 2019/08/06 7:05, Damien Le Moal wrote:=0A=
>>> On 2019/08/06 6:59, Damien Le Moal wrote:=0A=
>>>> On 2019/08/06 6:28, Jens Axboe wrote:=0A=
>>>>> On 8/5/19 2:27 PM, Damien Le Moal wrote:=0A=
>>>>>> On 2019/08/06 6:26, Jens Axboe wrote:=0A=
>>>>>>>> In any case, looking again at this code, it looks like there is a=
=0A=
>>>>>>>> problem with dio->size being incremented early, even for fragments=
=0A=
>>>>>>>> that get BLK_QC_T_EAGAIN, because dio->size is being used in=0A=
>>>>>>>> blkdev_bio_end_io(). So an incorrect size can be reported to user=
=0A=
>>>>>>>> space in that case on completion (e.g. large asynchronous no-wait =
dio=0A=
>>>>>>>> that cannot be issued in one go).=0A=
>>>>>>>>=0A=
>>>>>>>> So maybe something like this ? (completely untested)=0A=
>>>>>>>=0A=
>>>>>>> I think that looks pretty good, I like not double accounting with=
=0A=
>>>>>>> this_size and dio->size, and we retain the old style ordering for t=
he=0A=
>>>>>>> ret value.=0A=
>>>>>>=0A=
>>>>>> Do you want a proper patch with real testing backup ? I can send tha=
t=0A=
>>>>>> later today.=0A=
>>>>>=0A=
>>>>> Yeah that'd be great, I like your approach better.=0A=
>>>>>=0A=
>>>>=0A=
>>>> Looking again, I think this is not it yet: dio->size is being referenc=
ed after=0A=
>>>> submit_bio(), so blkdev_bio_end_io() may see the old value if the bio =
completes=0A=
>>>> before dio->size increment. So the use-after-free is still there. And =
since=0A=
>>>> blkdev_bio_end_io() processes completion to user space only when dio->=
ref=0A=
>>>> becomes 0, adding an atomic_inc/dec(&dio->ref) over the loop would not=
 help and=0A=
>>>> does not cover the single BIO case. Any idea how to address this one ?=
=0A=
>>>>=0A=
>>>=0A=
>>> May be add a bio_get/put() over the 2 places that do submit_bio() would=
 work,=0A=
>>> for all cases (single/multi BIO, sync & async). E.g.:=0A=
>>>=0A=
>>> +                       bio_get(bio);=0A=
>>>                          qc =3D submit_bio(bio);=0A=
>>>                          if (qc =3D=3D BLK_QC_T_EAGAIN) {=0A=
>>>                                  if (!dio->size)=0A=
>>>                                          ret =3D -EAGAIN;=0A=
>>> +                               bio_put(bio);=0A=
>>>                                  goto error;=0A=
>>>                          }=0A=
>>>                          dio->size +=3D bio_size;=0A=
>>> +                       bio_put(bio);=0A=
>>>=0A=
>>> Thoughts ?=0A=
>>>=0A=
>>=0A=
>> That does not work since the reference to dio->size in=0A=
>> blkdev_bio_end_io() depends on atomic_dec_and_test(&dio->ref) which=0A=
>> counts the BIO fragments for the dio (+1 for async multi-bio case). So=
=0A=
>> completion of the last bio can still reference the old value of=0A=
>> dio->size.=0A=
>>=0A=
>> Adding a bio_get/put() on dio->bio ensures that dio stays around, but=0A=
>> does not prevent the use of the wrong dio->size. Adding an additional=0A=
>> atomic_inc/dec(&dio->ref) would prevent that, but we would need to=0A=
>> handle dio completion at the end of __blkdev_direct_IO() if all BIO=0A=
>> fragments already completed at that point. That is a lot more plumbing=
=0A=
>> needed, relying completely on dio->ref for all cases, thus removing=0A=
>> the dio->multi_bio management.=0A=
>>=0A=
>> Something like this:=0A=
> =0A=
> Don't like this, as it adds unnecessary atomics for the sync case.=0A=
> What's wrong with just adjusting dio->size if we get BLK_QC_T_EAGAIN?=0A=
> It's safe to do so, since we're doing the final put later. We just can't=
=0A=
> do it for the normal case of submit_bio() succeeding. Kill the new 'ret'=
=0A=
> usage and return to what we had as well, it's more readable too imho.=0A=
> =0A=
> Totally untested...=0A=
> =0A=
> diff --git a/fs/block_dev.c b/fs/block_dev.c=0A=
> index a6f7c892cb4a..131e2e0582a6 100644=0A=
> --- a/fs/block_dev.c=0A=
> +++ b/fs/block_dev.c=0A=
> @@ -349,7 +349,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_ite=
r *iter, int nr_pages)=0A=
>  	loff_t pos =3D iocb->ki_pos;=0A=
>  	blk_qc_t qc =3D BLK_QC_T_NONE;=0A=
>  	gfp_t gfp;=0A=
> -	ssize_t ret;=0A=
> +	int ret;=0A=
>  =0A=
>  	if ((pos | iov_iter_alignment(iter)) &=0A=
>  	    (bdev_logical_block_size(bdev) - 1))=0A=
> @@ -386,8 +386,6 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_ite=
r *iter, int nr_pages)=0A=
>  =0A=
>  	ret =3D 0;=0A=
>  	for (;;) {=0A=
> -		int err;=0A=
> -=0A=
>  		bio_set_dev(bio, bdev);=0A=
>  		bio->bi_iter.bi_sector =3D pos >> 9;=0A=
>  		bio->bi_write_hint =3D iocb->ki_hint;=0A=
> @@ -395,10 +393,8 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_it=
er *iter, int nr_pages)=0A=
>  		bio->bi_end_io =3D blkdev_bio_end_io;=0A=
>  		bio->bi_ioprio =3D iocb->ki_ioprio;=0A=
>  =0A=
> -		err =3D bio_iov_iter_get_pages(bio, iter);=0A=
> -		if (unlikely(err)) {=0A=
> -			if (!ret)=0A=
> -				ret =3D err;=0A=
> +		ret =3D bio_iov_iter_get_pages(bio, iter);=0A=
> +		if (unlikely(ret)) {=0A=
>  			bio->bi_status =3D BLK_STS_IOERR;=0A=
>  			bio_endio(bio);=0A=
>  			break;=0A=
> @@ -421,7 +417,6 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_ite=
r *iter, int nr_pages)=0A=
>  		if (nowait)=0A=
>  			bio->bi_opf |=3D (REQ_NOWAIT | REQ_NOWAIT_INLINE);=0A=
>  =0A=
> -		dio->size +=3D bio->bi_iter.bi_size;=0A=
>  		pos +=3D bio->bi_iter.bi_size;=0A=
>  =0A=
>  		nr_pages =3D iov_iter_npages(iter, BIO_MAX_PAGES);=0A=
> @@ -433,13 +428,13 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_i=
ter *iter, int nr_pages)=0A=
>  				polled =3D true;=0A=
>  			}=0A=
>  =0A=
> +			dio->size +=3D bio->bi_iter.bi_size;=0A=
>  			qc =3D submit_bio(bio);=0A=
>  			if (qc =3D=3D BLK_QC_T_EAGAIN) {=0A=
> -				if (!ret)=0A=
> -					ret =3D -EAGAIN;=0A=
> +				dio->size -=3D bio->bi_iter.bi_size;=0A=
=0A=
ref after free of bio here. Easy to fix though. Also, with this, the bio_en=
dio()=0A=
call within submit_bio() for the EAGAIN failure will see a dio->size too la=
rge,=0A=
including this failed bio. So this does not work.=0A=
=0A=
One thing I do not 100% sure is the nowait case with a fragmented dio: if t=
he=0A=
processing stops on a BLK_QC_T_EAGAIN, the code in blkdev_bio_end_io() will=
=0A=
complete the iocb with -EAGAIN, while this code (submission path) will retu=
rn=0A=
the amount of submitted bytes for the dio (short read or write). So for now=
ait=0A=
&& is_sync case, this means that preadv2/pwritev2 would always get -EAGAIN=
=0A=
instead of the partial read/write achieved. For the nowait && !is_sync case=
,=0A=
similarly, aio_return() would always return -EAGAIN too even if a partial=
=0A=
read/write was done. Or am I missing something ? Checking again the man pag=
es,=0A=
this does not look like the described behavior.=0A=
=0A=
If this analysis is correct, I think the proper fix cannot be done only in=
=0A=
__blkdev_direct_IO(). blkdev_bio_end_io() needs to change too. Basically, I=
=0A=
think the "dio->size -=3D bio->bi_iter.bi_size" needs to go into=0A=
blkdev_bio_end_io() and a test added to see if dio->size is 0 (then complet=
e=0A=
with -EAGAIN) or not (then partial completion).=0A=
Starting testing something now with these changes in blkdev_bio_end_io().=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
