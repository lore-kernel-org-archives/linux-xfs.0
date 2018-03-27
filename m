Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:33605 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751249AbeC0APY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Mar 2018 20:15:24 -0400
Content-Type: text/plain;
        charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [PATCH] xfs: use hardlimit as sub-fs size if both hard/soft
 limits are set
From: "cgxu519@gmx.com" <cgxu519@gmx.com>
In-Reply-To: <20180326192259.GU4818@magnolia>
Date: Tue, 27 Mar 2018 08:14:43 +0800
Content-Transfer-Encoding: 8BIT
Message-Id: <557EEFE2-2D95-4386-95A9-168E82D5AEA0@gmx.com>
References: <1521954996-203628-1-git-send-email-cgxu519@gmx.com>
 <20180326192259.GU4818@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, linux-xfs@vger.kernel.org, bfoster@redhat.com, sandeen@sandeen.net, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>

在 2018年3月27日，上午3:22，Darrick J. Wong <darrick.wong@oracle.com> 写道：
> 
> On Sun, Mar 25, 2018 at 01:16:36PM +0800, Chengguang Xu wrote:
>> In current implementation, we size the fs(sub-fs via project quota) at
>> the soft limit and simply call it 100% used if the limit is exceeded.
>> It is reasonable when only a soft limit is set, but we should use the
>> hard limit if both hard/soft limits are set, so that quota-df reflects
>> the usage information more accurately.
> 
> This is the followup patch to "xfs: adjust size/used/avail information
> for quota-df", correct?

Yes，right.

> 
> I also wonder, statvfs is a weird interface since there's no way to send
> back usage information, just blocks/free/avail.  Isn't it more
> appropriate to use xfs_quota to find out the usage, hard limit, and soft
> limit of a directory?

The initial motivation of the patch is for adjusting avail in quota-df when
avail of total filesystem is less than avail of project quota.

I think even if we use xfs_quota, but there is no way to know that information,
so could we add avail field to xfs_quota?


Thanks,
Chengguang.


> 
>> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
>> ---
>> fs/xfs/xfs_qm_bhv.c | 12 ++++++------
>> 1 file changed, 6 insertions(+), 6 deletions(-)
>> 
>> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
>> index 2be6d27..43b0fe8 100644
>> --- a/fs/xfs/xfs_qm_bhv.c
>> +++ b/fs/xfs/xfs_qm_bhv.c
>> @@ -35,9 +35,9 @@
>> {
>> 	uint64_t		limit;
>> 
>> -	limit = dqp->q_core.d_blk_softlimit ?
>> -		be64_to_cpu(dqp->q_core.d_blk_softlimit) :
>> -		be64_to_cpu(dqp->q_core.d_blk_hardlimit);
>> +	limit = dqp->q_core.d_blk_hardlimit ?
>> +		be64_to_cpu(dqp->q_core.d_blk_hardlimit) :
>> +		be64_to_cpu(dqp->q_core.d_blk_softlimit);
> 
> Ok, so now we report hard limit for f_blocks over the soft limit.  So if
> this is the state of the filesystem:
> 
> # xfs_quota -xc 'report -ahp'
> Project quota on /opt (/dev/sdf)
>                        Blocks              
> Project ID   Used   Soft   Hard Warn/Grace   
> ---------- --------------------------------- 
> #0              0      0      0  00 [------]
> vms            3M     2M     3M  00 [7 days]
> 
> Then the df output goes from:
> 
> # df /opt/b
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sdf        2.0M  2.0M     0 100% /opt
> 
> to this:
> 
> # df /opt/b
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sdf        3.0M  3.0M     0 100% /opt
> 
> That makes to me, but as it /does/ change the behavior of an existing
> user-visible interface, I would like to know more about the current
> behavior.  Dave/Christoph, do you recall why df reports the project
> quota soft limit?
> 
> ----
> 
> Just for fun let's try the same on ext4...
> 
> $ dd if=/dev/zero >> /opt/b/a
> ^C4129977+0 records in
> 4129977+0 records out
> 2114548224 bytes (2.1 GB, 2.0 GiB) copied, 23.9179 s, 88.4 MB/s
> 
> $ sudo xfs_quota -fxc 'report -ahp' /opt
> Project quota on /opt (/dev/sdf)
>                        Blocks              
> Project ID   Used   Soft   Hard Warn/Grace   
> ---------- --------------------------------- 
> #0            20K      0      0  00 [------]
> vms          2.0G     2M     3M  00 [-none-]
> 
> <facepalm>
> 
> Only 1000x over soft quota...
> 
> $ df /opt/b
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sdf         13G  2.8G  8.9G  24% /opt
> 
> I guess we're going to need a couple more tests, then?  One to check
> that we enforce project quotas, and another to check what we're
> reporting via df?
> 
> --D
> 
>> 	if (limit && statp->f_blocks > limit) {
>> 		statp->f_blocks = limit;
>> 		statp->f_bfree = statp->f_bavail =
>> @@ -45,9 +45,9 @@
>> 			 (statp->f_blocks - dqp->q_res_bcount) : 0;
>> 	}
>> 
>> -	limit = dqp->q_core.d_ino_softlimit ?
>> -		be64_to_cpu(dqp->q_core.d_ino_softlimit) :
>> -		be64_to_cpu(dqp->q_core.d_ino_hardlimit);
>> +	limit = dqp->q_core.d_ino_hardlimit ?
>> +		be64_to_cpu(dqp->q_core.d_ino_hardlimit) :
>> +		be64_to_cpu(dqp->q_core.d_ino_softlimit);
>> 	if (limit && statp->f_files > limit) {
>> 		statp->f_files = limit;
>> 		statp->f_ffree =
>> -- 
>> 1.8.3.1
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

