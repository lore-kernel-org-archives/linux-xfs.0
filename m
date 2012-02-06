Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16DLYuV135089 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 07:21:34 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id weDKtPVzIrHURGu3 for <xfs@oss.sgi.com>;
	Mon, 06 Feb 2012 05:21:32 -0800 (PST)
Message-ID: <4F2FD3DC.3030301@sandeen.net>
Date: Mon, 06 Feb 2012 07:21:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair segfaults with ag_stride option
References: <4F293FCC.7010101@rhul.ac.uk>
	<20120202124248.GA12107@infradead.org>
	<4F2F23F3.9000402@rhul.ac.uk> <4F2F6C00.5050108@sandeen.net>
	<4F2FB72B.9010209@rhul.ac.uk>
In-Reply-To: <4F2FB72B.9010209@rhul.ac.uk>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Tom Crane <T.Crane@rhul.ac.uk>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 2/6/12 5:19 AM, Tom Crane wrote:
> Eric Sandeen wrote:

...

>> Newer tools are fine to use on older filesystems, there should be no
>>   
> 
> Good!
> 
>> issue there.
>>
>> running fsr can cause an awful lot of IO, and a lot of file reorganization.
>> (meaning, they will get moved to new locations on disk, etc).
>>
>> How bad is it, really?  How did you arrive at the 40% number?  Unless
>>   
> 
> xfs_db -c frag -r <block device>

which does:

                answer = (double)(extcount_actual - extcount_ideal) * 100.0 /
                         (double)extcount_actual;

If you work it out, if every file was split into only 2 extents, you'd have
"50%" - and really, that's not bad.  40% is even less bad.

> Some users on our compute farm with large jobs (lots of I/O) find they take longer than with some of our other scratch arrays hosted on other machines.  We also typically find many nfsd tasks in an uninterruptible wait state (sync_page), waiting for data to be copied in from the FS.

So fragmentation may not be the problem... 

-Eric

>> you see perf problems which you know you can attribute to fragmentation,
>> I might not worry about it.
>>
>> You can also check the fragmentation of individual files with the
>> xfs_bmap tool.
>>
>> -Eric
>>   
> 
> Thanks for your advice.
> Cheers
> Tom.
> 
>>  
>>> Tom.
>>>
>>> Christoph Hellwig wrote:
>>>    
>>>> Hi Tom,
>>>>
>>>> On Wed, Feb 01, 2012 at 01:36:12PM +0000, Tom Crane wrote:
>>>>  
>>>>      
>>>>> Dear XFS Support,
>>>>>    I am attempting to use xfs_repair to fix a damaged FS but always
>>>>> get a segfault if and only if -o ag_stride is specified. I have
>>>>> tried ag_stride=2,8,16 & 32.  The FS is approx 60T. I can't find
>>>>> reports of this particular problem on the mailing list archive.
>>>>> Further details are;
>>>>>
>>>>> xfs_repair version 3.1.7, recently downloaded via git repository.
>>>>> uname -a
>>>>> Linux store3 2.6.18-274.17.1.el5 #1 SMP Wed Jan 11 11:10:32 CET 2012
>>>>> x86_64 x86_64 x86_64 GNU/Linux
>>>>>             
>>>> Thanks for the detailed bug report.
>>>>
>>>> Can you please try the attached patch?
>>>>
>>>>         
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>     
>>
>>   
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
