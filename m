Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Jun 2007 16:08:58 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l55N8qWt006311
	for <xfs@oss.sgi.com>; Tue, 5 Jun 2007 16:08:54 -0700
Message-ID: <4665ED89.4090202@sgi.com>
Date: Wed, 06 Jun 2007 09:11:05 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: Reducing memory requirements for high extent xfs files
References: <200705301649.l4UGnckA027406@oss.sgi.com> <20070530225516.GB85884050@sgi.com> <4665E276.9020406@agami.com>
In-Reply-To: <4665E276.9020406@agami.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: David Chinner <dgc@sgi.com>, Michael Nishimoto <miken@stanfordalumni.org>, xfs@oss.sgi.com

Michael Nishimoto wrote:
>
>
> David Chinner wrote:
>> On Wed, May 30, 2007 at 09:49:38AM -0700, Michael Nishimoto wrote:
>>  > Hello,
>>  >
>>  > Has anyone done any work or had thoughts on changes required
>>  > to reduce the total memory footprint of high extent xfs files?
>>
>> We changed the way we do memory allocation to avoid needing
>> large contiguous chunks of memory a bit over a year ago;
>> that solved the main OOM problem we were getting reported
>> with highly fragmented files.
>>
>>  > Obviously, it is important to reduce fragmentation as files
>>  > are generated and to regularly defrag files, but both of these
>>  > alternatives are not complete solutions.
>>  >
>>  > To reduce memory consumption, xfs could bring in extents
>>  > from disk as needed (or just before needed) and could free
>>  > up mappings when certain extent ranges have not been recently
>>  > accessed.  A solution should become more aggressive about
>>  > reclaiming extent mapping memory as free memory becomes limited.
>>
>> Yes, it could, but that's a pretty major overhaul of the extent
>> interface which currently assumes everywhere that the entire
>> extent tree is in core.
>>
>> Can you describe the problem you are seeing that leads you to
>> ask this question? What's the problem you need to solve?
>>
>> Cheers,
>>
>> Dave.
>> -- 
>> Dave Chinner
>> Principal Engineer
>> SGI Australian Software Group
>
> I realize that this work won't be trivial which is why I asked if anyone
> has thought about all relevant issues.
>
> When using NFS over XFS, slowly growing files (can be ascii log files)
> tend to fragment quite a bit.  One system had several hundred files
> which required more than one page to store the extents.  Quite a few
> files had extent counts greater than 10k, and one file had 120k extents.
> Besides the memory consumption, latency to return the first byte of the
> file can get noticeable.
>
>   Michael
>
Hi Michael,

You could use XFS_XFLAG_EXTSIZE and XFS_XFLAG_RTINHERIT flags to
set extent hint size, which would reduce the file fragmentation in this 
scenario.
Please check xfcntl man page for more details.

Regards,
Vlad
/

/
