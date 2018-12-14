Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38446 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730405AbeLNStw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Dec 2018 13:49:52 -0500
Subject: Re: [PATCH] quota: Lock s_umount in exclusive mode for
 Q_XQUOTA{ON,OFF} quotactls.
References: <1ad62e88-7784-6de8-c03d-01295375e315@gmail.com>
 <20181214095613.GD8896@quack2.suse.cz>
From: Javier Barrio <javier.barrio.mart@gmail.com>
Message-ID: <8850e693-5f4d-4582-3bcd-f3a2bf3144c8@gmail.com>
Date: Fri, 14 Dec 2018 19:49:47 +0100
MIME-Version: 1.0
In-Reply-To: <20181214095613.GD8896@quack2.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

El 14/12/18 a las 10:56, Jan Kara escribió:

Hi,
>> This patch locks the superblock ->s_umount sem. in exclusive mode for all Q_XQUOTAON/OFF
>> quotactls too in addition to Q_QUOTAON/OFF.
> Thanks for the patch! It looks good to me but let me run it past XFS
> people. Looking at XFS code they definitely do not *need* s_umount in
> exclusive mode for Q_XQUOTAON/OFF (they have their private mutex for
> the exclusion). Shared mode they currently get is enough for them. But
> exclusive mode is fine for them as well AFAICT and it would be easier if
> all quota backends had the same locking rules wrt VFS locks. XFS guys, any
> objections to switching Q_XQUOTAON/OFF handlers from having s_umount locked
> for read to having it locked exclusive?
Thanks, great! I agree.

FWIW, XFS as of now *can* be called while holding s_umount exclusive with the
generic quotactl(Q_QUOTAON/OFF) commands, even though that code path is probably
not exercised in practice (from a quick look xfs-tests/xfs_quota etc always
use the Q_X* variants).

> 								Honza
>
>> AFAICT, other than ext4, only xfs and ocfs2 are affected by this change.
>> The VFS will now call in xfs_quota_* functions with s_umount held, which wasn't the case
>> before. This looks good to me but I can not say for sure. Ext4 and ocfs2 where already
>> beeing called with s_umount exclusive via quota_quotaon/off which is basically the same.
>>
>> Signed-off-by: Javier Barrio <javier.barrio.mart@gmail.com>
>> ---
>>
>> [ I'm not familiar with this code, please excuse me if this is not the right fix ]
>>
>>  fs/quota/quota.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
>> index f0cbf58ad4da..fd5dd806f1b9 100644
>> --- a/fs/quota/quota.c
>> +++ b/fs/quota/quota.c
>> @@ -791,7 +791,8 @@ static int quotactl_cmd_write(int cmd)
>>  /* Return true if quotactl command is manipulating quota on/off state */
>>  static bool quotactl_cmd_onoff(int cmd)
>>  {
>> -	return (cmd == Q_QUOTAON) || (cmd == Q_QUOTAOFF);
>> +	return (cmd == Q_QUOTAON) || (cmd == Q_QUOTAOFF) ||
>> +		 (cmd == Q_XQUOTAON) || (cmd == Q_XQUOTAOFF);
>>  }
>>  
>>  /*
>> -- 2.17.1
>>
>>
