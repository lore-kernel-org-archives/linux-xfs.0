Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6DB4F7F47
	for <xfs@oss.sgi.com>; Thu, 17 Dec 2015 19:29:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2B8C5304048
	for <xfs@oss.sgi.com>; Thu, 17 Dec 2015 17:29:36 -0800 (PST)
Received: from heian.cn.fujitsu.com (cn.fujitsu.com [59.151.112.132]) by
	cuda.sgi.com with ESMTP id PRTxKv06izmEUBbW for
	<xfs@oss.sgi.com>; Thu, 17 Dec 2015 17:29:33 -0800 (PST)
Subject: Re: Ideas on unified real-ro mount option across all filesystems
References: <567212DA.8050808@cn.fujitsu.com> <567228EF.80007@redhat.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5673616C.1040706@cn.fujitsu.com>
Date: Fri, 18 Dec 2015 09:29:16 +0800
MIME-Version: 1.0
In-Reply-To: <567228EF.80007@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, fsdevel <linux-fsdevel@vger.kernel.org>, btrfs <linux-btrfs@vger.kernel.org>, kzak@redhat.com
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com



Eric Sandeen wrote on 2015/12/16 21:15 -0600:
> <xfs list address fixed>
>
> On 12/16/15 7:41 PM, Qu Wenruo wrote:
>> Hi,
>>
>> In a recent btrfs patch, it is going to add a mount option to disable
>> log replay for btrfs, just like "norecovery" for ext4/xfs.
>>
>> But in the discussion on the mount option name and use case, it seems
>> better to have an unified and fs independent mount option alias for
>> real RO mount
>>
>> Reasons:
>> 1) Some file system may have already used [no]"recovery" mount option
>>     In fact, btrfs has already used "recovery" mount option.
>>     Using "norecovery" mount option will be quite confusing for btrfs.
>
> Too bad btrfs picked those semantics when "norecovery" has existed on
> other filesystems for quite some time with a different meaning... :(
>
>> 2) More straight forward mount option
>>     Currently, to get real RO mount, for ext4/xfs, user must use -o
>>     ro,norecovery.
>>     Just ro won't ensure real RO, and norecovery can't be used alone.
>>     If we have a simple alias, it would be much better for user to use.
>>     (it maybe done just in user space mount)
>
> mount(8) simply says:
>
>         ro     Mount the filesystem read-only.
>
> and mount(2) is no more illustrative:
>
>         MS_RDONLY
>                Mount file system read-only.
>
> kernel code is no help, either:
>
> #define MS_RDONLY        1      /* Mount read-only */
>
> They say nothing about what, exactly, "read-only" means.  But since at least
> the early ext3 days, it means that you cannot write through the filesystem, not
> that the filesystem will leave the block device unmodified when it mounts.
>
> I have always interpreted it as simply "no user changes to the filesystem,"
> and that is clearly what the vfs does with the flag...
>
>>     Not to mention some fs (yeah, btrfs again) doesn't have "norecovery"
>>     but "nologreplay".
>
> well, again, btrfs picked unfortunate semantics, given the precedent set
> by other filesystems.
>
> f2fs, ext4, gfs2, nilfs2, and xfs all support "norecovery" - xfs since
> forever, ext4 & f2fs since 2009, etc.

I understand it's btrfs' fault.
Considering how many filesystems are already using "norecovery", it is 
almost a standard.

Not sure if it's possible to change the "recovery" mount option to other 
name for btrfs, but it seems using "norecovery" would be the best solution.

>
>> 3) A lot of user even don't now mount ro can still modify device
>>     Yes, I didn't know this point until I checked the log replay code of
>>     btrfs.
>>     Adding such mount option alias may raise some attention of users.
>
> Given that nothing in the documentation implies that the block device itself
> must remain unchanged on a read-only mount, I don't see any problem which
> needs fixing.  MS_RDONLY rejects user IO; that's all.

And thanks for the info provided by Karel, it's clear that at least 
mount(8) itself already has explain on what ro will do and what it won't do.

Thanks,
Qu
>
> If you want to be sure your block device rejects all IO for forensics or
> what have you, I'd suggest # blockdev --setro /dev/whatever prior to mount,
> and take it out of the filesystem's control.  Or better yet, making an
> image and not touching the original.
>
> -Eric
>
>> Any ideas about this?
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
