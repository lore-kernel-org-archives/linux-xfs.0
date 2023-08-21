Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 943D7EE4993
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Aug 2023 13:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235203AbjHUNHr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Aug 2023 09:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbjHUNHr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Aug 2023 09:07:47 -0400
X-Greylist: delayed 64206 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Aug 2023 06:07:45 PDT
Received: from smtp-outbound4.duck.com (smtp-outbound4.duck.com [20.67.222.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460FA8F
        for <linux-xfs@vger.kernel.org>; Mon, 21 Aug 2023 06:07:45 -0700 (PDT)
MIME-Version: 1.0
Subject: Re: Moving existing internal journal log to an external device
 (success?)
References: <E4E991B0-4CAA-4E7A-9AC8-531346EDAEC4.1@smtp-inbound1.duck.com>
 <ZOKQTTxcanMX86Sx@dread.disaster.area>
 <B4C72D86-4CD6-415D-802E-7A225C868E57.1@smtp-inbound1.duck.com>
Content-Type: text/plain;
        charset=US-ASCII;
        format=flowed
Content-Transfer-Encoding: 7bit
To:     Dave Chinner <david@fromorbit.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Received: by smtp-inbound1.duck.com; Mon, 21 Aug 2023 09:07:43 -0400
Message-ID: <4F83C26B-1841-440B-8A51-0F2BD1EFC825.1@smtp-inbound1.duck.com>
Date:   Mon, 21 Aug 2023 09:07:43 -0400
From:   fk1xdcio@duck.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=duck.com; h=From:
 Date: Message-ID: Cc: To: Content-Transfer-Encoding: Content-Type:
 References: Subject: MIME-Version; q=dns/txt; s=postal-KpyQVw;
 t=1692623264; bh=+QboT3nUINaf6vgGjUpw7CR0XePAFS19LseiJWbUj+w=;
 b=Y9vF7tn0pY0QCiiO4TZfemj/tBMvfIy5d8noWoOM7fUDnt9uCTgzpQXZaYH4B8UYF7L5gZIoE
 VBLjzqwrjqFf4ULyFVA/M4Afq6t4VhwBFw+0trVUjJnyfXh0slz33AWvcBvUrUwnqFLrufjiJyV
 aqR0ii9pClvcP+vI7JlmQvo=
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-08-20 18:14, Dave Chinner wrote:
> On Sun, Aug 20, 2023 at 03:37:38PM -0400, fk1xdcio@duck.com wrote:
>> Does this look like a sane method for moving an existing internal log 
>> to an
>> external device?
>> 
>> 3 drives:
>>    /dev/nvme0n1p1  2GB  Journal mirror 0
>>    /dev/nvme1n1p1  2GB  Journal mirror 1
>>    /dev/sda1       16TB XFS
>> 
>> # mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/nvme0n1p1
>> /dev/nvme1n1p2
>> # mkfs.xfs /dev/sda1
>> # xfs_logprint -C journal.bin /dev/sda1
>> # cat journal.bin > /dev/md0
>> # xfs_db -x /dev/sda1
>> 
>> xfs_db> sb
>> xfs_db> write -d logstart 0
>> xfs_db> quit
>> 
>> # mount -o logdev=/dev/md0 /dev/sda1 /mnt
> 
> So you are physically moving the contents of the log whilst the
> filesystem is unmounted and unchanging.
> 
>> -------------------------
>> 
>> It seems to "work" and I tested with a whole bunch of data.
> 
> You'll get ENOSPC earlier than you think, because you just leaked
> the old log space (needs to be marked free space). There might be
> other issues, but you get to keep all the broken bits to yourself if
> you find them.

It's 2GB out of terabytes so I don't really care about the space but the 
"other issues" is a problem.


> You can probably fix that by running xfs_repair, but then....
> 
>> I was also able
>> to move the log back to internal without issue (set logstart back to 
>> what it
>> was originally). I don't know enough about how the filesystem layout 
>> works
>> to know if this will eventually break.
> 
> .... this won't work.
> 
> i.e. you can move the log back to the original position because you
> didn't mark the space the old journal used as free, so the filesytem
> still thinks it is in use by something....

The space being leaked is fine but xfs_repair is an issue. I did some 
testing and yes, if I run xfs_repair on one of these filesystems with a 
moved log it causes all sorts of problems. In fact it doesn't seem to 
work at all. Big problem.


>> *IF* this works, why can't xfs_growfs do it?
> 
> "Doctor, I can perform an amputation with a tornique and a chainsaw,
> why can't you do that?"
> ,,,
> -Dave.


Yes, I understand. I was thinking more of an offline utility for doing 
this but I see why that can't be done in growfs.

So I guess it doesn't really work. This is why I ask the experts. I'll 
keep experimenting because due to the requirements of needing to 
physically move disks around, being able to move the log back and forth 
from internal to external would be extremely helpful.

Thanks!
