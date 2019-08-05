Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37539 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730516AbfHEV2w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Aug 2019 17:28:52 -0400
Received: by mail-pf1-f195.google.com with SMTP id 19so40271887pfa.4
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 14:28:51 -0700 (PDT)
Subject: Re: Block device direct read EIO handling broken?
References: <20190805181524.GE7129@magnolia>
 <66bd785d-7598-5cc2-5e98-447fd128c153@kernel.dk>
 <36973a52-e876-fc09-7a63-2fc16b855f8d@kernel.dk>
 <BYAPR04MB5816246256B1333C048EB0A1E7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <474c560f-5de0-6082-67ac-f7c640d9b346@kernel.dk>
 <BYAPR04MB5816C3B24310C1E18F9E024CE7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f3f98663-8f92-c933-c7c0-8db6635e6112@kernel.dk>
Date: Mon, 5 Aug 2019 14:28:48 -0700
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB5816C3B24310C1E18F9E024CE7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On 8/5/19 2:27 PM, Damien Le Moal wrote:
> On 2019/08/06 6:26, Jens Axboe wrote:
>>> In any case, looking again at this code, it looks like there is a
>>> problem with dio->size being incremented early, even for fragments
>>> that get BLK_QC_T_EAGAIN, because dio->size is being used in
>>> blkdev_bio_end_io(). So an incorrect size can be reported to user
>>> space in that case on completion (e.g. large asynchronous no-wait dio
>>> that cannot be issued in one go).
>>>
>>> So maybe something like this ? (completely untested)
>>
>> I think that looks pretty good, I like not double accounting with
>> this_size and dio->size, and we retain the old style ordering for the
>> ret value.
> 
> Do you want a proper patch with real testing backup ? I can send that
> later today.

Yeah that'd be great, I like your approach better.

-- 
Jens Axboe
