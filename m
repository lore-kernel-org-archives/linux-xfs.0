Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:60490 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732163AbeHISrC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Aug 2018 14:47:02 -0400
Subject: Re: [PATCH v2 2/2] [PATCH] xfs: Close race between direct IO and
 xfs_break_layouts()
References: <153374910694.40645.17166196534680658204.stgit@djiang5-desk3.ch.intel.com>
 <153374915981.40645.3350205963852459041.stgit@djiang5-desk3.ch.intel.com>
 <20180809085706.GB5069@quack2.suse.cz>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <af6a4411-3362-66a2-5291-4006b56b5441@intel.com>
Date: Thu, 9 Aug 2018 09:21:25 -0700
MIME-Version: 1.0
In-Reply-To: <20180809085706.GB5069@quack2.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, darrick.wong@oracle.com, zwisler@kernel.org, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, lczerner@redhat.com, linux-ext4@vger.kernel.org, hch@lst.de



On 08/09/2018 01:57 AM, Jan Kara wrote:
> On Wed 08-08-18 10:26:36, Dave Jiang wrote:
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
> 
> I think I gave you my reviewed-by tag already for the previous version. But
> here it is again:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Yes you did. I forgot to append it when I sent it out the first time. I
resent it. :)

> 
> 								Honza
> 
>> ---
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
