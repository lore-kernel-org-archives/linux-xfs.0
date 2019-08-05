Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:37459 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728483AbfHEV7F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Aug 2019 17:59:05 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: Block device direct read EIO handling broken?
Date: Mon, 5 Aug 2019 21:59:00 +0000
Message-ID: <BYAPR04MB581644536C6EAEA36E3B4912E7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190805181524.GE7129@magnolia>
 <66bd785d-7598-5cc2-5e98-447fd128c153@kernel.dk>
 <36973a52-e876-fc09-7a63-2fc16b855f8d@kernel.dk>
 <BYAPR04MB5816246256B1333C048EB0A1E7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <474c560f-5de0-6082-67ac-f7c640d9b346@kernel.dk>
 <BYAPR04MB5816C3B24310C1E18F9E024CE7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <f3f98663-8f92-c933-c7c0-8db6635e6112@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On 2019/08/06 6:28, Jens Axboe wrote:=0A=
> On 8/5/19 2:27 PM, Damien Le Moal wrote:=0A=
>> On 2019/08/06 6:26, Jens Axboe wrote:=0A=
>>>> In any case, looking again at this code, it looks like there is a=0A=
>>>> problem with dio->size being incremented early, even for fragments=0A=
>>>> that get BLK_QC_T_EAGAIN, because dio->size is being used in=0A=
>>>> blkdev_bio_end_io(). So an incorrect size can be reported to user=0A=
>>>> space in that case on completion (e.g. large asynchronous no-wait dio=
=0A=
>>>> that cannot be issued in one go).=0A=
>>>>=0A=
>>>> So maybe something like this ? (completely untested)=0A=
>>>=0A=
>>> I think that looks pretty good, I like not double accounting with=0A=
>>> this_size and dio->size, and we retain the old style ordering for the=
=0A=
>>> ret value.=0A=
>>=0A=
>> Do you want a proper patch with real testing backup ? I can send that=0A=
>> later today.=0A=
> =0A=
> Yeah that'd be great, I like your approach better.=0A=
> =0A=
=0A=
Looking again, I think this is not it yet: dio->size is being referenced af=
ter=0A=
submit_bio(), so blkdev_bio_end_io() may see the old value if the bio compl=
etes=0A=
before dio->size increment. So the use-after-free is still there. And since=
=0A=
blkdev_bio_end_io() processes completion to user space only when dio->ref=
=0A=
becomes 0, adding an atomic_inc/dec(&dio->ref) over the loop would not help=
 and=0A=
does not cover the single BIO case. Any idea how to address this one ?=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
