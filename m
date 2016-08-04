Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0FA497CA0
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 00:47:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AA87D304032
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 22:47:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SXPt9uWtO9SaJNOL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 22:47:12 -0700 (PDT)
Subject: Re: [PATCH 37/45] drivers: use req op accessor
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
	<1465155145-10812-38-git-send-email-mchristi@redhat.com>
	<CAOxpaSUMsgfTYsL0bL6VCnwxz7bpgpKO-ZfC5J8dFG9PN-hzvg@mail.gmail.com>
	<87fbe31f-27b3-ff7a-e381-34fc1aad337e@redhat.com>
	<CAJVOszAd9Eu88P2=QoNVArd0jwDH7KRe=OB82tCNMpjfv9B4KA@mail.gmail.com>
From: Mike Christie <mchristi@redhat.com>
Message-ID: <57A2D6D7.8040807@redhat.com>
Date: Thu, 4 Aug 2016 00:47:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAJVOszAd9Eu88P2=QoNVArd0jwDH7KRe=OB82tCNMpjfv9B4KA@mail.gmail.com>
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
To: Shaun Tancheff <shaun.tancheff@seagate.com>
Cc: philipp.reisner@linbit.com, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com, linux-scsi@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, konrad.wilk@oracle.com, XFS Developers <xfs@oss.sgi.com>, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, osd-dev@open-osd.org, Ross Zwisler <zwisler@gmail.com>, Jens Axboe <axboe@fb.com>, LKML <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lars.ellenberg@linbit.com, linux-btrfs@vger.kernel.org

On 08/03/2016 07:30 PM, Shaun Tancheff wrote:
> On Wed, Aug 3, 2016 at 6:47 PM, Mike Christie <mchristi@redhat.com> wrote:
>> On 08/03/2016 05:33 PM, Ross Zwisler wrote:
>>> On Sun, Jun 5, 2016 at 1:32 PM,  <mchristi@redhat.com> wrote:
>>>> From: Mike Christie <mchristi@redhat.com>
>>>>
>>>> The req operation REQ_OP is separated from the rq_flag_bits
>>>> definition. This converts the block layer drivers to
>>>> use req_op to get the op from the request struct.
>>>>
>>>> Signed-off-by: Mike Christie <mchristi@redhat.com>
>>>> ---
>>>>  drivers/block/loop.c              |  6 +++---
>>>>  drivers/block/mtip32xx/mtip32xx.c |  2 +-
>>>>  drivers/block/nbd.c               |  2 +-
>>>>  drivers/block/rbd.c               |  4 ++--
>>>>  drivers/block/xen-blkfront.c      |  8 +++++---
>>>>  drivers/ide/ide-floppy.c          |  2 +-
>>>>  drivers/md/dm.c                   |  2 +-
>>>>  drivers/mmc/card/block.c          |  7 +++----
>>>>  drivers/mmc/card/queue.c          |  6 ++----
>>>
>>> Dave Chinner reported a deadlock with XFS + DAX, which I reproduced
>>> and bisected to this commit:
>>>
>>> commit c2df40dfb8c015211ec55f4b1dd0587f875c7b34
>>> Author: Mike Christie <mchristi@redhat.com>
>>> Date:   Sun Jun 5 14:32:17 2016 -0500
>>> drivers: use req op accessor
>>>
>>> Here are the steps to reproduce the deadlock with a BRD ramdisk:
>>>
>>> mkfs.xfs -f /dev/ram0
>>> mount -o dax /dev/ram0 /mnt/scratch
>>
>> When using ramdisks, we need the attached patch like in your other bug
>> report. I think it will fix some hangs people are seeing.
>>
>> I do not think that it should cause the failure to run issue you saw
>> when doing generic/008 and ext2.
>>
> 
> I think the translation in loop.c is suspicious here:
> 
>     "if use DIO && not (a flush_flag or discard_flag)"
> should translate to:
>     "if use DIO && not ((a flush_flag) || op == discard)"
> 
> But in the patch I read:
>     "if use DIO && ((not a flush_flag) || op == discard)
> 
> Which would have DIO && discards follow the AIO path?
> 
> So I would humbly suggest something like the following
>     (on top of commit c2df40dfb8c015211ec55f4b1dd0587f875c7b34):
> [Please excuse the messed up patch format ... gmail eats tabs]
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index b9b737c..0754d83 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1659,8 +1659,9 @@ static int loop_queue_rq(struct blk_mq_hw_ctx *hctx,
>         if (lo->lo_state != Lo_bound)
>                 return -EIO;
> 
> -       if (lo->use_dio && (!(cmd->rq->cmd_flags & REQ_FLUSH) ||
> -           req_op(cmd->rq) == REQ_OP_DISCARD))
> +       if (lo->use_dio && !(
> +           (cmd->rq->cmd_flags & REQ_FLUSH) ||
> +            req_op(cmd->rq) == REQ_OP_DISCARD))
>                 cmd->use_aio = true;
>         else
>                 cmd->use_aio = false;
> 

You are right. The translation was bad and your code above is correct.

I think we need my patch in the other mail though too, because for the
rw_page user case if WB_SYNC_ALL is set, then the IO gets sent down as a
read instead of a write.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
