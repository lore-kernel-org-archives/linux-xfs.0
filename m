Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:58295 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727542AbeHJSY0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Aug 2018 14:24:26 -0400
Subject: Re: [PATCH v2 2/2] [PATCH] xfs: Close race between direct IO and
 xfs_break_layouts()
References: <153374942137.42241.10539674028265137668.stgit@djiang5-desk3.ch.intel.com>
 <20180810154809.GD15083@magnolia>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <dc539a4d-7f9c-11c6-e63b-93ebb7f7ff9d@intel.com>
Date: Fri, 10 Aug 2018 08:54:00 -0700
MIME-Version: 1.0
In-Reply-To: <20180810154809.GD15083@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: tytso@mit.edu, jack@suse.cz, zwisler@kernel.org, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, lczerner@redhat.com, linux-ext4@vger.kernel.org, hch@lst.de



On 08/10/2018 08:48 AM, Darrick J. Wong wrote:
> On Wed, Aug 08, 2018 at 10:31:40AM -0700, Dave Jiang wrote:
>> This patch is the duplicate of ross's fix for ext4 for xfs.
>>
>> If the refcount of a page is lowered between the time that it is returned
>> by dax_busy_page() and when the refcount is again checked in
>> xfs_break_layouts() => ___wait_var_event(), the waiting function
>> xfs_wait_dax_page() will never be called.  This means that
>> xfs_break_layouts() will still have 'retry' set to false, so we'll stop
>> looping and never check the refcount of other pages in this inode.
>>
>> Instead, always continue looping as long as dax_layout_busy_page() gives us
>> a page which it found with an elevated refcount.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> Reviewed-by: Jan Kara <jack@suse.cz>
>> ---
>>
>> Sorry resend, forgot to add Jan's reviewed-by.
>>
>> v2:
>> - Rename parameter from did_unlock to retry (Jan)
>>
>>  fs/xfs/xfs_file.c |    9 ++++-----
>>  1 file changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index a3e7767a5715..cd6f0d8c4922 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -721,12 +721,10 @@ xfs_file_write_iter(
>>  
>>  static void
>>  xfs_wait_dax_page(
>> -	struct inode		*inode,
>> -	bool			*did_unlock)
>> +	struct inode		*inode)
>>  {
>>  	struct xfs_inode        *ip = XFS_I(inode);
>>  
>> -	*did_unlock = true;
>>  	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
>>  	schedule();
>>  	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
>> @@ -736,7 +734,7 @@ static int
>>  xfs_break_dax_layouts(
>>  	struct inode		*inode,
>>  	uint			iolock,
>> -	bool			*did_unlock)
>> +	bool			*retry)
> 
> Uhhh, this hunk doesn't apply.  xfs_break_dax_layouts doesn't have an
> iolock parameter anymore; was this not generated off of xfs for-next?

Sorry. It was generated against 4.18-rc8. I'll respin patch against xfs
for-next.

> 
> --D
> 
>>  {
>>  	struct page		*page;
>>  
>> @@ -746,9 +744,10 @@ xfs_break_dax_layouts(
>>  	if (!page)
>>  		return 0;
>>  
>> +	*retry = true;
>>  	return ___wait_var_event(&page->_refcount,
>>  			atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
>> -			0, 0, xfs_wait_dax_page(inode, did_unlock));
>> +			0, 0, xfs_wait_dax_page(inode));
>>  }
>>  
>>  int
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
