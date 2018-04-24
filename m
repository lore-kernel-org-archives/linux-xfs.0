Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35844 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750739AbeDXPcu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Apr 2018 11:32:50 -0400
Subject: Re: [PATCH] [RFC] iomap: Use FUA for pure data O_DSYNC DIO writes
References: <20180301014144.28892-1-david@fromorbit.com>
 <CAA9_cmebHisbzU9CHVpq77UrtCTev_yT=3_SWhUX5oZNOJZwcw@mail.gmail.com>
 <CY4PR21MB074130B753A5BF81332A5171B8D20@CY4PR21MB0741.namprd21.prod.outlook.com>
 <20180313051037.GC18129@dastard>
 <BN6PR21MB074023CEF5DE1B70D0AA2363B8D20@BN6PR21MB0740.namprd21.prod.outlook.com>
 <20180313161242.GA11168@lst.de>
 <BN6PR21MB0740E78F2E7945B563BC71A8B8D20@BN6PR21MB0740.namprd21.prod.outlook.com>
 <20180319160650.mavedzwienzgwgqi@quack2.suse.cz>
 <BN6PR21MB074023968CDB8780FE9443A2B8D40@BN6PR21MB0740.namprd21.prod.outlook.com>
 <20180322143559.pmwwwz4gic4wkq7r@quack2.suse.cz>
 <BN6PR21MB0740C697371D948B83E6D23FB8A90@BN6PR21MB0740.namprd21.prod.outlook.com>
 <BN6PR21MB0740003BBFCD4B6854A695D5B8880@BN6PR21MB0740.namprd21.prod.outlook.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c4e22caa-bc53-8122-493f-8bc1d1fb8080@suse.com>
Date: Tue, 24 Apr 2018 18:32:45 +0300
MIME-Version: 1.0
In-Reply-To: <BN6PR21MB0740003BBFCD4B6854A695D5B8880@BN6PR21MB0740.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Robert Dorr <rdorr@microsoft.com>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Scott Konersmann <scottkon@microsoft.com>, Slava Oks <slavao@microsoft.com>, Jasraj Dange <jasrajd@microsoft.com>, Michael Nelson <micn@microsoft.com>



On 24.04.2018 17:09, Robert Dorr wrote:
> Hope you are feeling better.
> 
> 1. How can we effect similar changes in ext4?
> 2. How do we get these changes pushed into all common release builds for both xfs or ext4 optimizations?
> 
> We are seeing dramatic performance increases with the xfs fixes.   https://bugzilla.redhat.com/show_bug.cgi?id=1548524
> 
> 4 socket, TPCC
> 9,108 – Old kernel
> 36,618 – Patched kernel
> 
> 2 socket, TPCC
> 9,606 - Old kernel
> 18,840 - Patched kernel
> 
> --------------------------------------------------------------------------------------------------
> -- Times in milli-seconds
> -- wt=SQL writethrough setting
> -- awt=SQL alternatewritethrough setting
> -- -T3979=SQL open with Fua behavior
> -- -T3982=SQL opens without Fua and use fsync (forced flush) behavior
> --------------------------------------------------------------------------------------------------
> --
> --	Linux patched kernel for XFS FUA opts
> --  SQL Server 2017 CU6
> --  blktrace active
> --  Centos7 - 4proc, 8GB ram running on Hyper-V
> --  Win10, 8proc, 32GB ram host
> --  Samsung SSD drive
> --  Clean SQL Server restarts
> --------------------------------------------------------------------------------------------------
> --  PATCHED KERNEL 4.16.x
> --	     								Create DB Inserts Checkpoint Options
> --  ----------------------------------- --------- ------- ---------- -----------------------------------
> --  Default (-T3982 = forced flush)		3787      29814   47		 O_DIRECT and fsync from SQL
> --  -T3979 and wt=1 awt=1			    4224	  25880   30         O_DIRECT and specialized fdatasync  (Best without FUA is ~10x slower than FUA)
> --
> --  -T3979 and wt=0						2860	  2570	  13		 O_DIRECT 
> --  -T3979 and wt=1 awt=0				4204	  2573	  17		 O_DIRECT | O_DSYNC - Inserts and checkpoint on allocated space nears O_DIRECT only  <--- !!! DESIRED BEHAVIOR !!!
> --  -T3979 and wt=1 awt=0 NO STAMP		4127	  2823	  17		 O_DIRECT | O_DSYNC - Issues internal flushs for 1st writes, create faster but inserts slower
> --
> --  UNPATCHED KERNEL 3.x
> --	     								Create DB Inserts Checkpoint Options
> --  ----------------------------------- --------- ------- ---------- -----------------------------------
> --  Default (-T3982 = forced flush)		3097      29700   26		 O_DIRECT and fsync from SQL
> --  -T3979 and wt=1 awt=1			    4210	  25800   27         O_DIRECT and specialized fdatasync
> --
> --  -T3979 and wt=0						2880	  2134	  6			 O_DIRECT 
> --  -T3979 and wt=1 awt=0 		        4443	  25290	  42		 O_DIRECT | O_DSYNC
> --  -T3979 and wt=1 awt=0 NO STAMP		4120	  25680	  40		 O_DIRECT | O_DSYNC
> --
> 

So these number should be taken with a VERY BIG grain of salt. Not
because the change is not valid but because at the very least you are
comparing kernel 3.x with latest 4.16. It's unlikely that this report
will be the thing that tips the scaler to either "implement" or "not"
that for ext4. But at the very least show number for the same kernel
with the only difference being the patch.


> 
> 
> 
> -----Original Message-----
> From: Robert Dorr 
> Sent: Thursday, March 22, 2018 7:38 AM
> To: Jan Kara <jack@suse.cz>
> Cc: Christoph Hellwig <hch@lst.de>; Dave Chinner <david@fromorbit.com>; Dan Williams <dan.j.williams@intel.com>; linux-xfs@vger.kernel.org; linux-fsdevel <linux-fsdevel@vger.kernel.org>; Theodore Ts'o <tytso@mit.edu>; Matthew Wilcox <mawilcox@microsoft.com>; Scott Konersmann <scottkon@microsoft.com>; Slava Oks <slavao@microsoft.com>; Jasraj Dange <jasrajd@microsoft.com>; Michael Nelson <micn@microsoft.com>
> Subject: RE: [PATCH] [RFC] iomap: Use FUA for pure data O_DSYNC DIO writes
> 
> Sorry to hear that.  Get well soon.
> 
> Thanks for the response.
> 
> 
> -----Original Message-----
> From: Jan Kara <jack@suse.cz>
> Sent: Thursday, March 22, 2018 9:36 AM
> To: Robert Dorr <rdorr@microsoft.com>
> Cc: Jan Kara <jack@suse.cz>; Christoph Hellwig <hch@lst.de>; Dave Chinner <david@fromorbit.com>; Dan Williams <dan.j.williams@intel.com>; linux-xfs@vger.kernel.org; linux-fsdevel <linux-fsdevel@vger.kernel.org>; Theodore Ts'o <tytso@mit.edu>; Matthew Wilcox <mawilcox@microsoft.com>; Scott Konersmann <scottkon@microsoft.com>; Slava Oks <slavao@microsoft.com>; Jasraj Dange <jasrajd@microsoft.com>; Michael Nelson <micn@microsoft.com>
> Subject: Re: [PATCH] [RFC] iomap: Use FUA for pure data O_DSYNC DIO writes
> 
> On Mon 19-03-18 16:14:16, Robert Dorr wrote:
>> Awesome news on the spin.   
>>
>> Are you going to be able to make changes to EXT4 to accommodate 
>> REQ_FUA without generic_write_flush to improve performance like was done for xfs?
> 
> I'm currently on a sick leave so I'm slow on replies. Sorry. I don't see a reason why ext4 could not have the same optimization as XFS for that case of direct IO. However I'm not sure when I get to implementing that.
> 
> 								Honza
> 
>> -----Original Message-----
>> From: Jan Kara <jack@suse.cz>
>> Sent: Monday, March 19, 2018 11:07 AM
>> To: Robert Dorr <rdorr@microsoft.com>
>> Cc: Christoph Hellwig <hch@lst.de>; Dave Chinner 
>> <david@fromorbit.com>; Dan Williams <dan.j.williams@intel.com>; 
>> linux-xfs@vger.kernel.org; linux-fsdevel 
>> <linux-fsdevel@vger.kernel.org>; Jan Kara <jack@suse.cz>; Theodore 
>> Ts'o <tytso@mit.edu>; Matthew Wilcox <mawilcox@microsoft.com>; Scott 
>> Konersmann <scottkon@microsoft.com>; Slava Oks <slavao@microsoft.com>; 
>> Jasraj Dange <jasrajd@microsoft.com>; Michael Nelson 
>> <micn@microsoft.com>
>> Subject: Re: [PATCH] [RFC] iomap: Use FUA for pure data O_DSYNC DIO 
>> writes
>>
>> On Tue 13-03-18 18:52:57, Robert Dorr wrote:
>>> I tried the RWF_ODSYNC and xfs seems to honor properly but it causes
>>> ext4 to go spin out a single CPU and hang the system. 😊
>>
>> Yeah, that's a bug in generic direct IO code that I've just recently 
>> fixed
>> (d9c10e5b8863 "direct-io: Fix sleep in atomic due to sync AIO" in 4.16-rc4).
>>
>> 								Honza
>>
>>>
>>>
>>> -----Original Message-----
>>> From: Christoph Hellwig <hch@lst.de>
>>> Sent: Tuesday, March 13, 2018 11:13 AM
>>> To: Robert Dorr <rdorr@microsoft.com>
>>> Cc: Dave Chinner <david@fromorbit.com>; Dan Williams 
>>> <dan.j.williams@intel.com>; linux-xfs@vger.kernel.org; Christoph 
>>> Hellwig <hch@lst.de>; linux-fsdevel <linux-fsdevel@vger.kernel.org>; 
>>> Jan Kara <jack@suse.cz>; Theodore Ts'o <tytso@mit.edu>; Matthew 
>>> Wilcox <mawilcox@microsoft.com>; Scott Konersmann 
>>> <scottkon@microsoft.com>; Slava Oks <slavao@microsoft.com>; Jasraj 
>>> Dange <jasrajd@microsoft.com>; Michael Nelson <micn@microsoft.com>
>>> Subject: Re: [PATCH] [RFC] iomap: Use FUA for pure data O_DSYNC DIO 
>>> writes
>>>
>>>> I think the answer is the iomap* logic makes sure to issue generic_write_sync for O_DSYNC W1 after W1 is completed by hardware and then waits for completion of the flush request (REQ_PREFLUSH) before W1 is returned to the AIO completion ring, preventing io_getevents from processing W1 before the flush occurs and completes.   I just need proper confirmation from the experts on this code that this is the expected behavior.
>>>
>>> Yes. that is the case.
>>>
>>>> For SQL Server using O_DIRECT | O_DSYNC on current kernels is very performance impacting.   Instead we enable a mode for SQL that opens O_DIRECT only and issues fsync/fdatasync when we are hardening log files or checkpointing data files.   This reduces the write, flush, write, flush pattern allowing for write, write, write, ... then flush as we only issue flush requests when required to maintain the data integrity boundaries of SQL Server.  The performance is significantly better then the device flush for each write as you can imagine.
>>>>
>>>> Testing shows the FUA enhancement is better then the write, flush pattern.   For SQL Server we want to dynamically open with O_DIRECT | O_DSYNC when REQ_FUA can be properly used and open with O_DIRECT and leverage SQL Server's alternate flush scheme when running on older kernel or a system that does not support FUA (SATA, IDE, ...)
>>>
>>> There is no really good way to figure this out except for benchmarking, given that the FUA use an implementation detail.
>>>
>>> Btw, another feature that might be interesting to you is the RWF_DSYNC flag to the pwritev2 syscall, which allows to apply O_DSYNC semantics on a per-I/O basis instead of using it at open time.
>> --
>> Jan Kara <jack@suse.com>
>> SUSE Labs, CR
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���"��^n�r���z���h����&���G���h�(�階�ݢj"���m�����z�ޖ���f���h���~�mml==
> 
