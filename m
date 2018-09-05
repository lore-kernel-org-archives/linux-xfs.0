Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37946 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727704AbeIFCaU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Sep 2018 22:30:20 -0400
Subject: Re: [PATCH] xfs: don't fail dax mount w/ reflink if dax gets disabled
References: <d4e84fa3-6cf5-4ea1-d61c-e1c74f2b0d06@redhat.com>
 <20180905215414.GY5631@dastard>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <f8da45ae-4e07-55a2-f206-7d9280fcf836@redhat.com>
Date: Wed, 5 Sep 2018 16:58:10 -0500
MIME-Version: 1.0
In-Reply-To: <20180905215414.GY5631@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 9/5/18 4:54 PM, Dave Chinner wrote:
> On Wed, Sep 05, 2018 at 11:24:45AM -0500, Eric Sandeen wrote:
>> Today, we can get an interesting result when mounting a reflink filesystem
>> with -o dax on a device that doesn't support it:
>>
>> XFS (sda1): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
>> XFS (sda1): DAX unsupported by block device. Turning off DAX.
>> XFS (sda1): DAX and reflink cannot be used together!
>>
>> <fail mount>
>>
>> If we're willing to silently turn off DAX due to incompatibility with the
>> block device, it makes no sense to then fail the mount due to
>> incompatibility with the filesystem format.  So, skip this check if we
>> already decided to turn off DAX and proceed.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index 207ee30..c85c432 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -1677,8 +1677,7 @@ struct proc_xfs_info {
>>  			xfs_alert(mp,
>>  			"DAX unsupported by block device. Turning off DAX.");
>>  			mp->m_flags &= ~XFS_MOUNT_DAX;
>> -		}
>> -		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
>> +		} else if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> 
> Shouldn't this be:
> 
> 		if ((mp->m_flags & XFS_MOUNT_DAX) &&
> 		    xfs_sb_version_hasreflink(&mp->m_sb)) {
> 
>>  			xfs_alert(mp,
>>  		"DAX and reflink cannot be used together!");
>>  			error = -EINVAL;
> 
> I.e. separate the reflink check form the initial mount option check
> which may turn the mount option off?

Yes, I considered doing it that way too.  (either way works, right?)

> I suspect we need to be more harsh are rejecting mounts with -o dax
> on devices DAX isn't supported on. This mount option is going into
> production systems - it's not just for "testing" as the comments all
> claim. i Things will break in production systems if DAX isn't
> enabled and they are expecting it to be enabled.
> 
> Combine that with block devices that can change their DAX support
> without warning (see recent thread about dm dax behaviour), and
> we've got a landmine that looks like "DAX works, I reboot, now DAX
> doesn't work and I got no errors".
> 
> So perhaps this needs more thought w.r.t to rejection when -o dax is
> used on non-dax devices.

Yeah, I agree.  If we want to go the route of hard fail on -o dax on
unsupported devices, then we should make that change, and my patch
shouldn't be applied.

-Eric
