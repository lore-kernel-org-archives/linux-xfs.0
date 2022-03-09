Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3622EC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 18:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiCISXE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 13:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236876AbiCISXC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 13:23:02 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6DD5E639A
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 10:22:02 -0800 (PST)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 596AA4836;
        Wed,  9 Mar 2022 12:20:49 -0600 (CST)
Message-ID: <95ed03a8-e49b-d109-baba-86a190345102@sandeen.net>
Date:   Wed, 9 Mar 2022 12:22:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Content-Language: en-US
To:     David Dal Ben <dalben@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <esandeen@redhat.com>, linux-xfs@vger.kernel.org
References: <CALwRca2+UsEZMPwiCtecM87HVVMs27SdawdWXns+PU7+S-DFaQ@mail.gmail.com>
 <CALwRca3yS2q4XYr5aFaPWxNcGsYRFDWeU9je1q31KGguTeX6Rw@mail.gmail.com>
 <YiYIO2lJf123LA2c@B-P7TQMD6M-0146.local>
 <CALwRca2bZD5tXmL5kzCdL97LpqWGVhYXMNSWSvqn=FkMuMrbjQ@mail.gmail.com>
 <9f957f7a-0f08-9cb4-d8ff-76440a488184@redhat.com>
 <CALwRca2Xdp8F_xjXSFXxO-Ra96W685o2qY1xoo=Ko9OWF4oRvw@mail.gmail.com>
 <20220307233132.GA661808@dread.disaster.area>
 <YiaajBcdSgOyIamT@B-P7TQMD6M-0146.local>
 <CALwRca0TqcKnBkLm=sOjQdvagBjd12m_7uYOhkMt8LjxsmiEtA@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Inconsistent "EXPERIMENTAL online shrink feature in use. Use at
 your own risk" alert
In-Reply-To: <CALwRca0TqcKnBkLm=sOjQdvagBjd12m_7uYOhkMt8LjxsmiEtA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

So a weird thing here is that I think your logs show the xfs_growfs command
happening immediately after mount, and it doesn't have any size specified, 
so I can't tell if the intent was to shrink - but I don't think so:

Mar  6 19:59:21 tdm emhttpd: shcmd (81): mkdir -p /mnt/disk1
Mar  6 19:59:21 tdm emhttpd: shcmd (82): mount -t xfs -o noatime /dev/md1 /mnt/disk1
Mar  6 19:59:21 tdm kernel: SGI XFS with ACLs, security attributes, no debug enabled
Mar  6 19:59:21 tdm kernel: XFS (md1): Mounting V5 Filesystem
Mar  6 19:59:21 tdm kernel: XFS (md1): Ending clean mount
Mar  6 19:59:21 tdm emhttpd: shcmd (83): xfs_growfs /mnt/disk1
Mar  6 19:59:21 tdm kernel: xfs filesystem being mounted at /mnt/disk1 supports timestamps until 2038 (0x7fffffff)
Mar  6 19:59:21 tdm root: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: No space left on device
Mar  6 19:59:21 tdm root: meta-data=/dev/md1               isize=512  agcount=32, agsize=137330687 blks
Mar  6 19:59:21 tdm root:          =                       sectsz=512  attr=2, projid32bit=1
Mar  6 19:59:21 tdm root:          =                       crc=1  finobt=1, sparse=1, rmapbt=0
Mar  6 19:59:21 tdm root:          =                       reflink=1  bigtime=0 inobtcount=0
Mar  6 19:59:21 tdm root: data     =                       bsize=4096  blocks=4394581984, imaxpct=5
Mar  6 19:59:21 tdm root:          =                       sunit=1  swidth=32 blks
Mar  6 19:59:21 tdm root: naming   =version 2              bsize=4096  ascii-ci=0, ftype=1
Mar  6 19:59:21 tdm root: log      =internal log           bsize=4096  blocks=521728, version=2
Mar  6 19:59:21 tdm root:          =                       sectsz=512  sunit=1 blks, lazy-count=1
Mar  6 19:59:21 tdm root: realtime =none                   extsz=4096  blocks=0, rtextents=0
Mar  6 19:59:21 tdm emhttpd: shcmd (83): exit status: 1
Mar  6 19:59:21 tdm kernel: XFS (md1): EXPERIMENTAL online shrink feature in use. Use at your own risk!


We issue the EXPERIMENTAL message if the block delta is <= 0 (I'm not sure why
it's done if delta == 0 and I wonder if it should instead be < 0).

But maybe unraid isn't really trying to shrink, it's just doing an unconditional
growfs post-mount to ensure it's using the whole device (unnecessary, but should
be safe.)

I'm wondering if we have some path through xfs_growfs_data_private() that calculates
a delta < 0 unintentionally, or if we get there with delta == 0 and generate the
warning message.

However, if I recreate a filesystem with exactly your geometry:
# mkfs.xfs -b size=4096 -dfile,name=fsfile,agcount=32,size=4394581984b,su=4k,sw=32  -m inobtcount=0,bigtime=0
meta-data=fsfile                 isize=512    agcount=32, agsize=137330687 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=4394581984, imaxpct=5
         =                       sunit=1      swidth=32 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

and then mount it and point xfs_growfs at it with no args, I get no errors.
So I am still stumped...

-Eric

On 3/7/22 6:04 PM, David Dal Ben wrote:
> OK, thanks.  I'll take this up with the Unraid tech team directly.
> Thanks for the advice and pointers.
> 
> On Tue, 8 Mar 2022 at 07:51, Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>
>> On Tue, Mar 08, 2022 at 10:31:32AM +1100, Dave Chinner wrote:
>>> On Tue, Mar 08, 2022 at 06:46:58AM +0800, David Dal Ben wrote:
>>>> This is where I get out of my depth. I added the drives to unraid, it
>>>> asked if I wanted to format them, I said yes, when that was completed
>>>> I started migrating data.
>>>>
>>>> I didn't enter any XFS or disk commands from the CLI.
>>>
>>> Is there any sort of verbose logging you can turn on from the
>>> applicance web interface?
>>>
>>>>
>>>> What I can tell you is that there are a couple of others who have
>>>> reported this alert on the Unraid forums, all seem to have larger
>>>> disks, over 14tb.
>>>
>>> I'd suggest that you ask Unraid to turn off XFS shrinking support in
>>> the 6.10 release. It's not ready for production release, and
>>> enabling it is just going to lead to user problems like this.
>>>
>>> Indeed, this somewhat implies that Unraid haven't actually tested
>>> shrink functionality at all, because otherwise the would have
>>> noticed just how limited the current XFS shrink support is and
>>> understood that it simply cannot be used in a production environment
>>> yet.
>>>
>>> IOWs, if Unraid want to support shrink in their commercial products
>>> right now, their support engineers need to be testing, triaging and
>>> reporting shrink problems to upstream and telling us exactly what is
>>> triggering those issues. Whilst the operations and commands they are
>>> issuing remains hidden from Unraid users, there's not a huge amount
>>> we can do upstream to triage the issue...
>>
>> I'm not sure if it can reproduce on other distribution or it's just a
>> specific behavior with unraid distribution, and it seems that this
>> distribution needs to be paid with $ to get more functionality, so I
>> assume it has a professional support team which can investigate more,
>> at least on the userspace side.
>>
>> In the beginning, we've discussed informally if we needed to add
>> another "-S" option to xfs_growfs to indicate the new shrink behavior
>> for users. And the conclusion was unnecessary. And I think for the case
>> mentioned in the original thread, it didn't actually do anything.
>>
>> Thanks,
>> Gao Xiang
>>
>>> Cheers,
>>>
>>> Dave.
>>> --
>>> Dave Chinner
>>> david@fromorbit.com
> 
