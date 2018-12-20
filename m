Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45032 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730330AbeLTSdW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Dec 2018 13:33:22 -0500
Subject: Re: [PATCH] quota: Lock s_umount in exclusive mode for
 Q_XQUOTA{ON,OFF} quotactls.
References: <1ad62e88-7784-6de8-c03d-01295375e315@gmail.com>
 <20181214095613.GD8896@quack2.suse.cz>
 <20181220082021.GA27845@quack2.suse.cz>
From: Javier Barrio <javier.barrio.mart@gmail.com>
Message-ID: <ca7483c8-986c-95c1-7224-9e299083b8f8@gmail.com>
Date: Thu, 20 Dec 2018 19:33:17 +0100
MIME-Version: 1.0
In-Reply-To: <20181220082021.GA27845@quack2.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On 20/12/18 9:20, Jan Kara wrote:
> On Fri 14-12-18 10:56:13, Jan Kara wrote:
>> On Thu 13-12-18 01:06:29, Javier Barrio wrote:
>>> Commit 1fa5efe3622db58cb8c7b9a50665e9eb9a6c7e97 (ext4: Use generic
>>> helpers for quotaon and quotaoff) made possible to call
>>> quotactl(Q_XQUOTAON/OFF) on ext4 filesystems with sysfile quota support.
>>> This leads to calling dquot_enable/disable without s_umount held in excl.
>>> mode, because quotactl_cmd_onoff checks only for Q_QUOTAON/OFF.
>>>
>>> The following WARN_ON_ONCE triggers (in this case for dquot_enable, ext4,
>>> latest Linus' tree):
>>>
>>> [  155.036847] WARNING: CPU: 0 PID: 2343 at fs/quota/dquot.c:2469 dquot_enable+0x34/0xb9
>>
>> ...
>>
>>> This patch locks the superblock ->s_umount sem. in exclusive mode for all Q_XQUOTAON/OFF
>>> quotactls too in addition to Q_QUOTAON/OFF.
>>
>> Thanks for the patch! It looks good to me but let me run it past XFS
>> people. Looking at XFS code they definitely do not *need* s_umount in
>> exclusive mode for Q_XQUOTAON/OFF (they have their private mutex for
>> the exclusion). Shared mode they currently get is enough for them. But
>> exclusive mode is fine for them as well AFAICT and it would be easier if
>> all quota backends had the same locking rules wrt VFS locks. XFS guys, any
>> objections to switching Q_XQUOTAON/OFF handlers from having s_umount locked
>> for read to having it locked exclusive?
> 
> Since there were no objections and the patch passed quota xfstests for XFS,
> I've added it to my tree and will push it to Linus in the coming merge
> window.
> 
> 								Honza
> 

Thank you!


	Javier
