Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Dec 2006 22:32:23 -0800 (PST)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.233.200])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBJ6WGqw028254
	for <xfs@oss.sgi.com>; Mon, 18 Dec 2006 22:32:18 -0800
Subject: Re: [PATCH] incorrect direct io error handling
References: <000101c722de$9fdca4b0$e834030a@amr.corp.intel.com>
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Tue, 19 Dec 2006 09:31:15 +0300
In-Reply-To: <000101c722de$9fdca4b0$e834030a@amr.corp.intel.com> (Kenneth W. Chen's message of "Mon, 18 Dec 2006 11:56:36 -0800")
Message-ID: <87lkl4tn0s.fsf@sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Cc: 'Dmitriy Monakhov' <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org, devel@openvz.org, Andrew Morton <akpm@osdl.org>, xfs@oss.sgi.com

"Chen, Kenneth W" <kenneth.w.chen@intel.com> writes:

> Dmitriy Monakhov wrote on Monday, December 18, 2006 5:23 AM
>> This patch is result of discussion started week ago here:
>> http://lkml.org/lkml/2006/12/11/66
>> changes from original patch:
>>  - Update wrong comments about i_mutex locking.
>>  - Add BUG_ON(!mutex_is_locked(..)) for non blkdev. 
>>  - vmtruncate call only for non blockdev
>> LOG:
>> If generic_file_direct_write() has fail (ENOSPC condition) inside 
>> __generic_file_aio_write_nolock() it may have instantiated
>> a few blocks outside i_size. And fsck will complain about wrong i_size
>> (ext2, ext3 and reiserfs interpret i_size and biggest block difference as error),
>> after fsck will fix error i_size will be increased to the biggest block,
>> but this blocks contain gurbage from previous write attempt, this is not 
>> information leak, but its silence file data corruption. This issue affect 
>> fs regardless the values of blocksize or pagesize.
>> We need truncate any block beyond i_size after write have failed , do in simular
>> generic_file_buffered_write() error path. If host is !S_ISBLK i_mutex always
>> held inside generic_file_aio_write_nolock() and we may safely call vmtruncate().
>> Some fs (XFS at least) may directly call generic_file_direct_write()with 
>> i_mutex not held. There is no general scenario in this case. This fs have to 
>> handle generic_file_direct_write() error by its own specific way (place).      
>
>
> I'm puzzled that if ext2 is able to instantiate some blocks, then why does it
> return no space error?  Where is the error coming from?
generic_file_aio_write_nolock()
 ->generic_file_direct_write()
   ->generic_file_direct_IO()
     ->ext2_direct_IO(WRITE,...)
       ->blockdev_direct_IO( ....,ext2_get_block,...)
