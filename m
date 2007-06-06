Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Jun 2007 18:58:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l561wFWt019745
	for <xfs@oss.sgi.com>; Tue, 5 Jun 2007 18:58:17 -0700
Message-ID: <4666153C.9050409@sgi.com>
Date: Wed, 06 Jun 2007 12:00:28 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: Reducing memory requirements for high extent xfs files
References: <200705301649.l4UGnckA027406@oss.sgi.com> <20070530225516.GB85884050@sgi.com> <4665E276.9020406@agami.com> <20070606013601.GR86004887@sgi.com>
In-Reply-To: <20070606013601.GR86004887@sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Michael Nishimoto <miken@agami.com>, Michael Nishimoto <miken@stanfordalumni.org>, xfs@oss.sgi.com

David Chinner wrote:
> On Tue, Jun 05, 2007 at 03:23:50PM -0700, Michael Nishimoto wrote:
>   
>> David Chinner wrote:
>>     
>>> On Wed, May 30, 2007 at 09:49:38AM -0700, Michael Nishimoto wrote:
>>>       
>>>> Hello,
>>>>
>>>> Has anyone done any work or had thoughts on changes required
>>>> to reduce the total memory footprint of high extent xfs files?
>>>>         
> .....
>   
>>> Yes, it could, but that's a pretty major overhaul of the extent
>>> interface which currently assumes everywhere that the entire
>>> extent tree is in core.
>>>
>>> Can you describe the problem you are seeing that leads you to
>>> ask this question? What's the problem you need to solve?
>>>       
>> I realize that this work won't be trivial which is why I asked if anyone
>> has thought about all relevant issues.
>>
>> When using NFS over XFS, slowly growing files (can be ascii log files)
>> tend to fragment quite a bit.
>>     
>
> Oh, that problem.
>
> The issue is that allocation beyond EOF (the normal way we prevent
> fragmentation in this case) gets truncated off on file close.
>
> Even NFS request is processed by doing:
>
> 	open
> 	write
> 	close
>
> And so XFS truncates the allocation beyond EOF on close. Hence
> the next write requires a new allocation and that results in
> a non-contiguous file because the adjacent blocks have already
> been used....
>
> Options:
>
> 	- NFS server open file cache to avoid the close.
> 	- add detection to XFS to determine if the called is
> 	  an NFS thread and don't truncate on close.
> 	- use preallocation.
> 	- preallocation on the file once will result in the
> 	  XFS_DIFLAG_PREALLOC being set on the inode and it
> 	  won't truncate on close.
> 	- append only flag will work in the same way as the
> 	  prealloc flag w.r.t preventing truncation on close.
> 	- run xfs_fsr
>
> Note - i don't think extent size hints alone will help as they
> don't prevent EOF truncation on close.
>   
Dave,

I think extent hint should help in this situation. Here is an example
of writing 4 chars in a file with extent hint of 16Kb. The file ends
up with size of 4 and 8 basic blocks (512 bytes each) allocation in
one extent.

emu:/mnt/scratch1/temp # xfs_io -c "extsize 16384" -f foo
emu:/mnt/scratch1/temp # ls -al foo
-rw------- 1 root root 0 2007-06-06 12:33 foo
emu:/mnt/scratch1/temp # xfs_bmap -l -v foo
foo: no extents
emu:/mnt/scratch1/temp # echo "abc" > foo
emu:/mnt/scratch1/temp # ls -al foo
-rw------- 1 root root 4 2007-06-06 12:35 foo
emu:/mnt/scratch1/temp # xfs_bmap -l -v foo
foo:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..7]:          326088..326095    0 (326088..326095)     8

Just a warning that the extent hint works at the moment only for
contiguous files. There are problems for sparse files (with holes)
and extent hint.

Regards,
Vlad
