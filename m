Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40760 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730888AbfGPAFI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Jul 2019 20:05:08 -0400
Subject: Re: [PATCH 2/2] xfs: sync up xfs_trans_inode with userspace
References: <68ef2df9-3f8e-6547-4e2b-181bce30ca3c@redhat.com>
 <112d2e52-c96c-af83-7e53-5fca12448c76@redhat.com>
 <20190715222209.GN7689@dread.disaster.area>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e1c3c8ea-cca7-90e8-256a-3137e1801d85@sandeen.net>
Date: Mon, 15 Jul 2019 19:05:05 -0500
MIME-Version: 1.0
In-Reply-To: <20190715222209.GN7689@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 7/15/19 5:22 PM, Dave Chinner wrote:
> On Fri, Jul 12, 2019 at 12:46:17PM -0500, Eric Sandeen wrote:
>> Add an XFS_ICHGTIME_CREATE case to xfs_trans_ichgtime() to keep in
>> sync with userspace.  (Currently no kernel caller sends this flag.)
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
>> index 93d14e47269d..a9ad90926b87 100644
>> --- a/fs/xfs/libxfs/xfs_trans_inode.c
>> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
>> @@ -66,6 +66,10 @@ xfs_trans_ichgtime(
>>  		inode->i_mtime = tv;
>>  	if (flags & XFS_ICHGTIME_CHG)
>>  		inode->i_ctime = tv;
>> +	if (flags & XFS_ICHGTIME_CREATE) {
>> +		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
>> +		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
>> +	}
> 
> Please use the same format as the rest of the function. i.e.
> 
> 	if (flags & XFS_ICHGTIME_CREATE)
> 		ip->i_d.di_crtime = tv;

        struct timespec64 tv;


        struct timespec64       i_atime;
        struct timespec64       i_mtime;
        struct timespec64       i_ctime;

...

        xfs_timestamp_t di_crtime;      /* time created */


bzzzzt.

will take a bit more work I think :(




> And convert userspace over to the same :P
> 
> Cheers,
> 
> Dave.
> 
