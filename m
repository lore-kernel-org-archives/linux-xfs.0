Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:10129 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729413AbfHFLcY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 07:32:24 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: Block device direct read EIO handling broken?
Date: Tue, 6 Aug 2019 11:32:21 +0000
Message-ID: <BYAPR04MB5816841E346E2FAA6A8ED7E2E7D50@BYAPR04MB5816.namprd04.prod.outlook.com>
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
 <20190806002353.GC7777@dread.disaster.area>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On 2019/08/06 9:25, Dave Chinner wrote:=0A=
> On Tue, Aug 06, 2019 at 12:05:51AM +0000, Damien Le Moal wrote:=0A=
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
>>>                         qc =3D submit_bio(bio);=0A=
>>>                         if (qc =3D=3D BLK_QC_T_EAGAIN) {=0A=
>>>                                 if (!dio->size)=0A=
>>>                                         ret =3D -EAGAIN;=0A=
>>> +                               bio_put(bio);=0A=
>>>                                 goto error;=0A=
>>>                         }=0A=
>>>                         dio->size +=3D bio_size;=0A=
>>> +                       bio_put(bio);=0A=
>>>=0A=
>>> Thoughts ?=0A=
>>>=0A=
>>=0A=
>> That does not work since the reference to dio->size in blkdev_bio_end_io=
()=0A=
>> depends on atomic_dec_and_test(&dio->ref) which counts the BIO fragments=
 for the=0A=
>> dio (+1 for async multi-bio case). So completion of the last bio can sti=
ll=0A=
>> reference the old value of dio->size.=0A=
> =0A=
> Didn't we fix this same use-after-free in iomap_dio_rw() in commit=0A=
> 4ea899ead278 ("iomap: fix a use after free in iomap_dio_rw")?=0A=
=0A=
Not so similar in this case with raw block device dio. But I will look more=
 into=0A=
it for inspiration. Thank you for the pointer.=0A=
=0A=
> =0A=
> Cheers,=0A=
> =0A=
> Dave.=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
