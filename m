Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33320 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729428AbfCOQv6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Mar 2019 12:51:58 -0400
Subject: Re: [PATCH 07/36] xfs_io: actually check copy file range helper
 return values
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259746648.31886.15984241616376190830.stgit@magnolia>
 <53e2bd63-6bd1-648a-d9dd-020b42565e6d@sandeen.net>
 <20190315025638.GD4929@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6d0275dc-cc56-b62d-16df-dbf65951eb20@sandeen.net>
Date: Fri, 15 Mar 2019 11:51:56 -0500
MIME-Version: 1.0
In-Reply-To: <20190315025638.GD4929@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Anna Schumaker <Anna.Schumaker@Netapp.com>, Christoph Hellwig <hch@lst.de>



On 3/14/19 9:56 PM, Darrick J. Wong wrote:
> On Thu, Mar 14, 2019 at 09:12:11PM -0500, Eric Sandeen wrote:
>> On 3/14/19 4:04 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> We need to check the return value of copy_src_filesize and
>>> copy_dst_truncate because either could return -1 due to fstat/ftruncate
>>> failure.
>>>
>>> Fixes: 628e112afdd98c5 ("xfs_io: implement 'copy_range' command")
>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>> Reviewed-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>
>> I see this has reviews already, but I'm not conviced 1 is the right
>> return on error.
>>
>> i.e. the error condition just prior returns 0:
>>
>>         fd = openfile(argv[optind], NULL, IO_READONLY, 0, NULL);
>>         if (fd < 0)
>>                 return 0;
>>
>> but OTOH if copy_file_range_cmd() fails we return nonzero.  Argh.
>>
>> Is there a rhyme or reason here that I'm missing?  Is it broken now
>> so just do a coinflip on the new return for now?
> 
> Pretty much. :(
> 
> I don't really care if you change the return value, I just thought it
> was bad form not to check the syscall/helper return values at all.

Yeah no argument there.  Ok, so this function already returns inconsistently,
I'll worry about that later (I hope)

Thanks,
-Eric
