Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:42279 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728885AbfHEV15 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Aug 2019 17:27:57 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: Block device direct read EIO handling broken?
Date: Mon, 5 Aug 2019 21:27:54 +0000
Message-ID: <BYAPR04MB5816C3B24310C1E18F9E024CE7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190805181524.GE7129@magnolia>
 <66bd785d-7598-5cc2-5e98-447fd128c153@kernel.dk>
 <36973a52-e876-fc09-7a63-2fc16b855f8d@kernel.dk>
 <BYAPR04MB5816246256B1333C048EB0A1E7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <474c560f-5de0-6082-67ac-f7c640d9b346@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On 2019/08/06 6:26, Jens Axboe wrote:=0A=
>> In any case, looking again at this code, it looks like there is a=0A=
>> problem with dio->size being incremented early, even for fragments=0A=
>> that get BLK_QC_T_EAGAIN, because dio->size is being used in=0A=
>> blkdev_bio_end_io(). So an incorrect size can be reported to user=0A=
>> space in that case on completion (e.g. large asynchronous no-wait dio=0A=
>> that cannot be issued in one go).=0A=
>>=0A=
>> So maybe something like this ? (completely untested)=0A=
> =0A=
> I think that looks pretty good, I like not double accounting with=0A=
> this_size and dio->size, and we retain the old style ordering for the=0A=
> ret value.=0A=
=0A=
Do you want a proper patch with real testing backup ? I can send that later=
 today.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
