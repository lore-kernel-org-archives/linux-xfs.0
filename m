Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BAFF97F94
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 13:32:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8C2AB304039
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 11:32:31 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id YLyat5LUwTWF7TJB for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 11:32:25 -0700 (PDT)
Subject: Re: [PATCH 2/3] xfs: create symlink proc/fs/xfs/stat to
	sys/fs/xfs/stats
References: <1441298187-29064-1-git-send-email-billodo@redhat.com>
	<1441298187-29064-3-git-send-email-billodo@redhat.com>
	<20150903175757.GB10397@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55E89239.60305@sandeen.net>
Date: Thu, 3 Sep 2015 13:32:25 -0500
MIME-Version: 1.0
In-Reply-To: <20150903175757.GB10397@birch.djwong.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>, billodo <billodo@redhat.com>
Cc: xfs@oss.sgi.com

On 9/3/15 12:57 PM, Darrick J. Wong wrote:
> On Thu, Sep 03, 2015 at 11:36:26AM -0500, billodo wrote:
>> As a part of the work to move xfs global stats from procfs to sysfs,
>> this patch creates the symlink from proc/fs/xfs/stat to sys/fs/xfs/stats.
>>
>> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
>> ---
>>  fs/xfs/xfs_stats.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
>> index 856cf57..ad435f1 100644
>> --- a/fs/xfs/xfs_stats.c
>> +++ b/fs/xfs/xfs_stats.c
>> @@ -244,9 +244,13 @@ xfs_init_procfs(void)
>>  	if (!proc_mkdir("fs/xfs", NULL))
>>  		goto out;
>>  
>> -	if (!proc_create("fs/xfs/stat", 0, NULL,
>> -			 &xfs_stat_proc_fops))
>> +	if (!proc_symlink("fs/xfs/stat", NULL,
>> +			  "/sys/fs/xfs/stats/stats"))
> 
> Uh.... is it actually guaranteed that sysfs is mounted on /sys now?
> 
> I sort of recall gregkh grumbling years ago that sysfs can be mounted anywhere,
> and that /proc shouldn't hardcode links to it.  But that's just handwaving on
> my part.

You can blame me for that idea.  At least one other driver does
do it, though; of_core_init():

proc_symlink("device-tree", NULL, "/sys/firmware/devicetree/base");

worst-case scenario, your "legacy" stats file will be a broken symlink...

-Eric

> --D
> 
>> +	{
>> +		printk(KERN_INFO "failed to created fs/xfs/stat symlink\n");
>>  		goto out_remove_xfs_dir;
>> +	}
>> +
>>  #ifdef CONFIG_XFS_QUOTA
>>  	if (!proc_create("fs/xfs/xqmstat", 0, NULL,
>>  			 &xqmstat_proc_fops))
>> -- 
>> 2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
