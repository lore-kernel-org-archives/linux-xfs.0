Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:60844 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbeHJVyR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Aug 2018 17:54:17 -0400
Subject: Re: [PATCH v2 2/2] [PATCH] xfs: Close race between direct IO and
 xfs_break_layouts()
References: <153374942137.42241.10539674028265137668.stgit@djiang5-desk3.ch.intel.com>
 <be8603ab-ccb2-3f0d-4dbf-7935fc3ed357@redhat.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <c4580e0d-e403-88a4-0e3a-7be8d0489f09@intel.com>
Date: Fri, 10 Aug 2018 12:23:04 -0700
MIME-Version: 1.0
In-Reply-To: <be8603ab-ccb2-3f0d-4dbf-7935fc3ed357@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jack@suse.cz, zwisler@kernel.org
Cc: linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, lczerner@redhat.com, linux-ext4@vger.kernel.org, hch@lst.de



On 08/10/2018 11:31 AM, Eric Sandeen wrote:
> On 8/8/18 12:31 PM, Dave Jiang wrote:
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
> 
> Hi Dave, does this have a testcase?  Have you seen the issue using Ross's
> xfstest generic/503 or is there some other test?  Apologies if I missed
> prior discussion on a testcase or race frequency...

I do not have a testcase. I know Ross replicated it on ext4. And Jan
asked to create the same fix with XFS when he reviewed Ross's fix for ext4.

> 
> Thanks,
> -Eric
> 
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
