Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from amazon.4net.rs ([159.69.148.70]:59876 "EHLO amazon.4net.rs"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731939AbeLQPFC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Dec 2018 10:05:02 -0500
From: Sinisa <sinisa@4net.rs>
Subject: Re: XFS and RAID10 with o2 layout
References: <d9fc0327-eef3-63bd-82a3-98545251bfe5@4net.rs>
 <20181212143056.GA23748@bfoster>
 <0a33a20d-5f49-7b34-3662-5b818c67621a@suse.com>
 <48ba331d-a896-f532-2c75-cf94ddf87b60@4net.rs>
Message-ID: <e0e43aff-f2f4-c8be-1876-1602f4887937@4net.rs>
Date: Mon, 17 Dec 2018 16:04:54 +0100
MIME-Version: 1.0
In-Reply-To: <48ba331d-a896-f532-2c75-cf94ddf87b60@4net.rs>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-raid@vger.kernel.org

5 hours of compilig later (old Athlon64 dual core), I was able to copy 9+GB 
without a glitch (under same conditions that were guaranteed to freeze in under 
2GB).

I'll run some more tests tomorrow, but this seems to have helped, thanks a lot!


Srdačan pozdrav / Best regards,
Siniša Bandin

On 12/17/18 10:31 AM, Sinisa wrote:
 > Thanks, I'll try to compile that ass soon as I get test machine back to 
openSUSE, during the day...
 >
 > Srdačan pozdrav / Best regards,
 > Siniša Bandin
 >
 > On 12/17/18 2:49 AM, Guoqing Jiang wrote:
 >> Hi,
 >>
 >> On 12/12/18 10:30 PM, Brian Foster wrote:
 >>>> [ 1463.760721] Call Trace:
 >>>> [ 1463.760731]  ? __schedule+0x29a/0x880
 >>>> [ 1463.760741]  ? wait_barrier+0xdd/0x170 [raid10]
 >>>> [ 1463.760746]  schedule+0x78/0x110
 >>>> [ 1463.760753]  wait_barrier+0xdd/0x170 [raid10]
 >>>> [ 1463.760761]  ? wait_woken+0x80/0x80
 >>>> [ 1463.760768]  raid10_write_request+0xf2/0x900 [raid10]
 >>>> [ 1463.760774]  ? wait_woken+0x80/0x80
 >>>> [ 1463.760778]  ? mempool_alloc+0x55/0x160
 >>>> [ 1463.760795]  ? md_write_start+0xa9/0x270 [md_mod]
 >>>> [ 1463.760801]  ? try_to_wake_up+0x44/0x470
 >>>> [ 1463.760810]  raid10_make_request+0xc1/0x120 [raid10]
 >>>> [ 1463.760816]  ? wait_woken+0x80/0x80
 >>>> [ 1463.760831]  md_handle_request+0x121/0x190 [md_mod]
 >>>> [ 1463.760851]  md_make_request+0x78/0x190 [md_mod]
 >>>> [ 1463.760860]  generic_make_request+0x1c6/0x470
 >>>> [ 1463.760870]  raid10_write_request+0x77a/0x900 [raid10]
 >>
 >> Seems bio is splitted, can you try about the change? Seems I didn't send it 
to mail list
 >> successfully.
 >>
 >> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
 >> index b98e746e7fc4..12cf8a04e839 100644
 >> --- a/drivers/md/raid10.c
 >> +++ b/drivers/md/raid10.c
 >> @@ -1209,7 +1209,9 @@ static void raid10_read_request(struct mddev *mddev, 
struct bio *bio,
 >>                 struct bio *split = bio_split(bio, max_sectors,
 >>                                               gfp, &conf->bio_split);
 >>                 bio_chain(split, bio);
 >> +               allow_barrier(conf);
 >>                 generic_make_request(bio);
 >> +               wait_barrier(conf);
 >>                 bio = split;
 >>                 r10_bio->master_bio = bio;
 >>                 r10_bio->sectors = max_sectors;
 >> @@ -1514,7 +1516,9 @@ static void raid10_write_request(struct mddev *mddev, 
struct bio *bio,
 >>                 struct bio *split = bio_split(bio, r10_bio->sectors,
 >>                                               GFP_NOIO, &conf->bio_split);
 >>                 bio_chain(split, bio);
 >> +               allow_barrier(conf);
 >>                 generic_make_request(bio);
 >> +               wait_barrier(conf);
 >>                 bio = split;
 >>                 r10_bio->master_bio = bio;
 >>         }
 >>
 >> And I updated opensuse bugzilla as well.
 >>
 >> Thanks,
 >> Guoqing
 >>
 >>>> [ 1463.760875]  ? wait_woken+0x80/0x80
 >>>> [ 1463.760879]  ? mempool_alloc+0x55/0x160
 >>>> [ 1463.760895]  ? md_write_start+0xa9/0x270 [md_mod]
 >>>> [ 1463.760904]  raid10_make_request+0xc1/0x120 [raid10]
 >>>> [ 1463.760910]  ? wait_woken+0x80/0x80
 >>>> [ 1463.760926]  md_handle_request+0x121/0x190 [md_mod]
 >>>> [ 1463.760931]  ? _raw_spin_unlock_irq+0x22/0x40
 >>>> [ 1463.760936]  ? finish_task_switch+0x74/0x260
 >>>> [ 1463.760954]  submit_flushes+0x21/0x40 [md_mod]
 >>>> [ 1463.760962]  process_one_work+0x1fd/0x420
 >>>> [ 1463.760970]  worker_thread+0x2d/0x3d0
 >>>> [ 1463.760976]  ? rescuer_thread+0x340/0x340
 >>>> [ 1463.760981]  kthread+0x112/0x130
 >>>> [ 1463.760986]  ? kthread_create_worker_on_cpu+0x40/0x40
 >>>> [ 1463.760992]  ret_from_fork+0x3a/0x50
 >>
 >
