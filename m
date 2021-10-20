Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D6A6C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 13:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E913A61374
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 13:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhJTNdC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 09:33:02 -0400
Received: from sandeen.net ([63.231.237.45]:53440 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230179AbhJTNdC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Oct 2021 09:33:02 -0400
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D92384919;
        Wed, 20 Oct 2021 08:29:32 -0500 (CDT)
Message-ID: <45acd361-0983-1b37-d93d-c5ac1029399c@sandeen.net>
Date:   Wed, 20 Oct 2021 08:30:45 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>
References: <e5d00665-ff40-cd6a-3c5c-a022341c3344@sandeen.net>
 <20211019204418.GZ2361455@dread.disaster.area>
 <6f7d8d49-909a-f9f3-273c-8641eedb5ea2@sandeen.net>
 <20211020113605.ayzm2cxrexxjr5yl@andromeda.lan>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Small project: Make it easier to upgrade root fs (i.e. to
 bigtime)
In-Reply-To: <20211020113605.ayzm2cxrexxjr5yl@andromeda.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/20/21 6:36 AM, Carlos Maiolino wrote:
> On Tue, Oct 19, 2021 at 04:04:14PM -0500, Eric Sandeen wrote:
>> On 10/19/21 3:44 PM, Dave Chinner wrote:
>>> On Tue, Oct 19, 2021 at 10:18:31AM -0500, Eric Sandeen wrote:
>>>> Darrick taught xfs_admin to upgrade filesystems to bigtime and inobtcount, which is
>>>> nice! But it operates via xfs_repair on an unmounted filesystem, so it's a bit tricky
>>>> to do for the root fs.
>>>>
>>>> It occurs to me that with the /forcefsck and /fsckoptions files[1], we might be able
>>>> to make this a bit easier. i.e. touch /forcefsck and add "-c bigtime=1" to /fsckoptions,
>>>> and then the initrd/initramfs should run xfs_repair with -c bigtime=1 and do the upgrade.
>>>
>>> Does that happen before/after swap is enabled?
> 
> IIRC in general, it follows the /etc/fstab mount order, and to access that,
> rootfs should be mounted, and, (also IIRC), the rootfs is mounted RO, and then
> remounted RW once the boot pre-reqs are read, but I can confirm that.
> 
>>
>>> Also, ISTR historical problems with doing initrd based root fs
>>> operations because it's not uncommon for the root filesystem to fail
>>> to cleanly unmount on shutdown.  i.e. it can end up not having the
>>> unmount record written because shutdown finishes with the superblock
>>> still referenced. Hence the filesystem has to be mounted and the log
>>> replayed before repair can be run on it....
>>>
> 
> I suppose this is already true nowadays? If /forcefsck exists, we are already
> running fsck the on the rootfs, so, I wonder what happens nowadays, as I haven't
> tried to use /forcefsck. But anyway, I don't think the behavior will be much
> different from the current one. I should check what happens today..
> 
>>>> Does anyone see a problem with this?  If not, would anyone like to
>>>> take this on as a small project?
> 
> If nobody has any objections, I'll be happy to work on this :)

Sure, go for it. Talking to Darrick yesterday, we were wondering how swap is
handled in the initramfs.  If you haven't mounted root, you don't have fstab
to find swap. But blkid *could* identify all swap partitions anyway. I doubt
it does that.

The other thing I wondered about was checking system memory, and limiting
repair to use that much with -m. If it's not available, would it fail more
gracefully than OOMing halfway through?

if this all feels to crazy, I'm ok with not going forward but it seems worth
investigating, because operations like this on the root fs can be a real pain.

-Eric
