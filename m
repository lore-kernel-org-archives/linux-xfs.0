Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7C0C433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 09:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56761613BF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 09:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235138AbhEUJEi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 May 2021 05:04:38 -0400
Received: from relay.herbolt.com ([37.46.208.54]:50706 "EHLO relay.herbolt.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232533AbhEUJEh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 May 2021 05:04:37 -0400
Received: from ip-78-102-244-147.net.upcbroadband.cz (ip-78-102-244-147.net.upcbroadband.cz [78.102.244.147])
        by relay.herbolt.com (Postfix) with ESMTPSA id 673611034149;
        Fri, 21 May 2021 11:03:12 +0200 (CEST)
Received: from mail.herbolt.com (http-server-2.local.lc [172.168.31.10])
        by mail.herbolt.com (Postfix) with ESMTPSA id 02EE2D34A0A;
        Fri, 21 May 2021 11:03:11 +0200 (CEST)
MIME-Version: 1.0
Date:   Fri, 21 May 2021 11:03:11 +0200
From:   lukas@herbolt.com
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC v2] xfs: Print XFS UUID on mount and umount events.
In-Reply-To: <20210520152323.GW9675@magnolia>
References: <20210519152247.1853357-1-lukas@herbolt.com>
 <20210520152323.GW9675@magnolia>
User-Agent: Roundcube Webmail/1.4.3
Message-ID: <1c29341ea9b5e362cd3252887ad01879@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> Are you going to wire up fs uuid logging for the other filesystems that
> support them?
Well, I wasn't planning to but I can take a look on other FS as well
Ext4 and Btrfs for start.

> What happens w.r.t. uuid disambiguation if someone uses a nouuid mount
> to mount a filesystem with the same uuid as an already-mounted xfs?

I a not sure I understand the "nouuid mount". I don't think there can
be XFS with empty uuid value in SB. And printing the message is 
independent
on the mount method (mount UUID="" ...; mount /dev/sdX ...;).


On 20.05.2021 17:23, Darrick J. Wong wrote:
> On Wed, May 19, 2021 at 05:22:48PM +0200, Lukas Herbolt wrote:
>> As of now only device names are printed out over __xfs_printk().
>> The device names are not persistent across reboots which in case
>> of searching for origin of corruption brings another task to properly
>> identify the devices. This patch add XFS UUID upon every mount/umount
>> event which will make the identification much easier.
> 
> A few questions....
> 
> Are you going to wire up fs uuid logging for the other filesystems that
> support them?
> 
> What happens w.r.t. uuid disambiguation if someone uses a nouuid mount
> to mount a filesystem with the same uuid as an already-mounted xfs?
> 
> The changes themselves look ok, but I'm wondering what the use case is
> here.
> 
> --D
> 
>> 
>> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
>> ---
>> V2: Drop void casts and fix long lines
>> 
>>  fs/xfs/xfs_log.c   | 10 ++++++----
>>  fs/xfs/xfs_super.c |  2 +-
>>  2 files changed, 7 insertions(+), 5 deletions(-)
>> 
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index 06041834daa31..8f4f671fd80d5 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -570,12 +570,14 @@ xfs_log_mount(
>>  	int		min_logfsbs;
>> 
>>  	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY)) {
>> -		xfs_notice(mp, "Mounting V%d Filesystem",
>> -			   XFS_SB_VERSION_NUM(&mp->m_sb));
>> +		xfs_notice(mp, "Mounting V%d Filesystem %pU",
>> +			   XFS_SB_VERSION_NUM(&mp->m_sb),
>> +			   &mp->m_sb.sb_uuid);
>>  	} else {
>>  		xfs_notice(mp,
>> -"Mounting V%d filesystem in no-recovery mode. Filesystem will be 
>> inconsistent.",
>> -			   XFS_SB_VERSION_NUM(&mp->m_sb));
>> +"Mounting V%d filesystem %pU in no-recovery mode. Filesystem will be 
>> inconsistent.",
>> +			   XFS_SB_VERSION_NUM(&mp->m_sb),
>> +			   &mp->m_sb.sb_uuid);
>>  		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
>>  	}
>> 
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index e5e0713bebcd8..a4b8a5ad8039f 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -1043,7 +1043,7 @@ xfs_fs_put_super(
>>  	if (!sb->s_fs_info)
>>  		return;
>> 
>> -	xfs_notice(mp, "Unmounting Filesystem");
>> +	xfs_notice(mp, "Unmounting Filesystem %pU", &mp->m_sb.sb_uuid);
>>  	xfs_filestream_unmount(mp);
>>  	xfs_unmountfs(mp);
>> 
>> --
>> 2.31.1
>> 
