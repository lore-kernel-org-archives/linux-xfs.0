Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Jul 2008 03:17:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m64AHWXd015038
	for <xfs@oss.sgi.com>; Fri, 4 Jul 2008 03:17:34 -0700
Received: from bby1mta02.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 051072B6EA1
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2008 03:18:34 -0700 (PDT)
Received: from bby1mta02.pmc-sierra.bc.ca (bby1mta02.pmc-sierra.com [216.241.235.117]) by cuda.sgi.com with ESMTP id esAysl4yWohFJAJn for <xfs@oss.sgi.com>; Fri, 04 Jul 2008 03:18:34 -0700 (PDT)
Message-ID: <486DF8F0.5010700@pmc-sierra.com>
Date: Fri, 04 Jul 2008 15:48:24 +0530
From: Sagar Borikar <sagar_borikar@pmc-sierra.com>
MIME-Version: 1.0
Subject: Re: Xfs Access to block zero  exception and system crash
References: <20080628000516.GD29319@disturbed> <340C71CD25A7EB49BFA81AE8C8392667028A1CA7@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080629215647.GJ29319@disturbed> <20080630034112.055CF18904C4@bby1mta01.pmc-sierra.bc.ca> <4868B46C.9000200@pmc-sierra.com> <20080701064437.GR29319@disturbed> <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed> <486B13AD.2010500@pmc-sierra.com> <1214979191.6025.22.camel@verge.scott.net.au> <20080702065652.GS14251@build-svl-1.agami.com> <486B6062.6040201@pmc-sierra.com> <486C4F89.9030009@sandeen.net> <486C6053.7010503@pmc-sierra.com> <486CE9EA.90502@sandeen.net>
In-Reply-To: <486CE9EA.90502@sandeen.net>
Content-Type: multipart/mixed;
 boundary="------------000503030107080700050305"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------000503030107080700050305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



Eric Sandeen wrote:
> Sagar Borikar wrote:
>   
>> Eric Sandeen wrote:
>>     
>
>
>   
>>>> Eric, Could you please let me know about bits and pieces that we need to 
>>>> remember while back porting xfs to 2.6.18?
>>>> If you share patches which takes care of it, that would be great.
>>>>     
>>>>         
>>> http://sandeen.net/rhel5_xfs/xfs-2.6.25-for-rhel5-testing.tar.bz2
>>>
>>> should be pretty close.  It was quick 'n' dirty and it has some warts
>>> but would give an idea of what backporting was done (see patches/ and
>>> the associated quilt series; quilt push -a to apply them all)
>>>   
>>>       
>> Thanks a lot Eric. I'll go through it .I am actually trying another 
>> option of regularly defragmenting the file system under stress.
>>     
>
> Ok, but that won't get to the bottom of the problem.  It might alleviate
> it at best, but if I were shipping a product using xfs I'd want to know
> that it was properly solved.  :)
>
>   
Even we too don't want to leave it as it is.  I still am working on back 
porting the latest xfs code.
Your patches are helping a lot .
Just to check whether that issue lies with 2.6.18 or MIPS port, I tested 
it on 2.6.24 x86 platform.
Here we created a loop back device of 10 GB and mounted xfs on that.
What I observe that xfs_repair reports quite a few bad blocks and bad 
extents here as well.
So is developing bad blocks and extents  normal behavior in xfs which 
would be recovered
in background or is it a bug? I still didn't see the exception but the 
bad blocks and extents are
generated within 10 minutes or running the tests.
Attaching the log .
> The tarball above should give you almost everything you need to run your
> testcase with current xfs code on your older kernel to see if the bug
> persists or if it's been fixed upstream, in which case you have a
> relatively easy path to an actual solution that your customers can
> depend on.
>
>   
>> I wanted to understand couple of things for using xfs_fsr utility:
>>
>> 1. What should be the state of filesystem when I am running xfs_fsr. 
>> Ideally we should stop all io before running defragmentation.
>>     
>
> you can run in any state.  Some files will not get defragmented due to
> busy-ness or other conditions; look at the xfs_swap_extents() function
> in the kernel which is very well documented; some cases return EBUSY.
>   

>   
>> 2. How effective is the utility when ran on highly fragmented file 
>> system? I saw that if filesystem is 99.89% fragmented, the recovery is 
>> very slow. It took around 25 min to clean up 100GB JBOD volume and after 
>> that system was fragmented to 82%. So I was confused on how exactly the 
>> fragmentation works.
>>     
>
> Again read the code, but basically it tries to preallocate as much space
> as the file is currently using, then checks that it is more contiguous
> space than the file currently has and if so, it copies the data from old
> to new and swaps the new allocation for the old.  Note, this involves a
> fair amount of IO.
>
> Also don't get hung up on that fragmentation factor, at least not until
> you've read xfs_db code to see how it's reported, and you've thought
> about what that means.  For example: a 100G filesystem with 10 10G files
> each with 5x2G extents will report 80% fragmentation.  Now, ask
> yourself, is a 10G file in 5x2G extents "bad" fragmentation?
>
>   
Agreed  as in x86 too I see 99.12% fragmentation when I run above 
mentioned test. and xfs_fsr
doesn't help much even after freezing the file system.
>> Any pointers on probable optimum use of xfs_fsr?
>> 3. Any precautions I need to take when working with that from data 
>> consistency, robustness point of view? Any disadvantages?
>>     
>
> Anything which corrupts data is a bug, and I'm not aware of any such
> bugs in the defragmentation process.
>
>   
Assuming that we get some improvement by running   xfs_fsr, is it safe 
to run regularly
in some periodic interval the defragmentation utility?
>> 4. Any threshold for starting the defragmentation on xfs?
>>     
>
> Pretty well determined by your individual use case and requirements, I
> think.
>
> -Eric
>   
Thanks for the detailed response Eric.

Sagar

--------------000503030107080700050305
Content-Type: text/plain;
 name="xfs_repair_log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs_repair_log"

bad nblocks 13345 for inode 50331785, would reset to 19431
bad nextents 156 for inode 50331785, would reset to 251
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 1
        - agno = 0
entry "testfile" in shortform directory 132 references free inode 142
would have junked entry "testfile" in directory inode 132
entry "testfile" in shortform directory 138 references free inode 143
would have junked entry "testfile" in directory inode 138
entry "testfile" in shortform directory 140 references free inode 144
would have junked entry "testfile" in directory inode 140
bad nblocks 15848 for inode 141, would reset to 18634
bad nextents 269 for inode 141, would reset to 306
bad nblocks 18888 for inode 16777350, would reset to 19144
bad nextents 303 for inode 16777350, would reset to 309
bad nblocks 18704 for inode 16777351, would reset to 19144
bad nextents 291 for inode 16777351, would reset to 299
bad fwd (right) sibling pointer (saw 107678 should be NULLDFSBNO)
        in inode 142 ((null) fork) bmap btree block 236077307437232
would have cleared inode 142
bad fwd (right) sibling pointer (saw 1139882 should be NULLDFSBNO)
        in inode 143 ((null) fork) bmap btree block 4556402090352816
would have cleared inode 143
bad fwd (right) sibling pointer (saw 1138473 should be NULLDFSBNO)
        in inode 144 ((null) fork) bmap btree block 4564279060373680
would have cleared inode 144
bad nblocks 13825 for inode 145, would reset to 18503
bad nextents 221 for inode 145, would reset to 222
        - agno = 2
entry "testfile" in shortform directory 33595588 references free inode 33595593
would have junked entry "testfile" in directory inode 33595588
bad nblocks 18704 for inode 33595589, would reset to 19121
bad nextents 306 for inode 33595589, would reset to 314
bad nblocks 18704 for inode 33595590, would reset to 19432
bad nextents 302 for inode 33595590, would reset to 313
bad nblocks 18640 for inode 33595591, would reset to 19432
bad nextents 311 for inode 33595591, would reset to 317
bad nblocks 18888 for inode 33595592, would reset to 19432
bad nextents 312 for inode 33595592, would reset to 322
bad fwd (right) sibling pointer (saw 104113 should be NULLDFSBNO)
        in inode 33595593 ((null) fork) bmap btree block 9041060911947952
would have cleared inode 33595593
        - agno = 3
bad nblocks 18888 for inode 50331781, would reset to 19432
bad nextents 315 for inode 50331781, would reset to 324
bad nblocks 18888 for inode 50331782, would reset to 19432
bad nextents 326 for inode 50331782, would reset to 333
bad nblocks 18888 for inode 50331783, would reset to 19432
bad nblocks 18428 for inode 50331784, would reset to 19784
bad nextents 285 for inode 50331784, would reset to 306
bad nblocks 18704 for inode 16777352, would reset to 19144
bad nextents 311 for inode 16777352, would reset to 315
bad nblocks 13345 for inode 50331785, would reset to 19431
bad nextents 156 for inode 50331785, would reset to 251
bad nblocks 18888 for inode 16777353, would reset to 19144
bad nextents 318 for inode 16777353, would reset to 321
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - agno = 0
entry "testfile" in shortform directory inode 132 points to free inode 142would junk entry
entry "testfile" in shortform directory inode 138 points to free inode 143would junk entry
entry "testfile" in shortform directory inode 140 points to free inode 144would junk entry
        - agno = 1
        - agno = 2
entry "testfile" in shortform directory inode 33595588 points to free inode 33595593would junk entry
        - agno = 3
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.

        XFS_REPAIR Summary    Fri Jul  4 15:34:47 2008

Phase           Start           End             Duration
Phase 1:        07/04 15:34:00  07/04 15:34:04  4 seconds
Phase 2:        07/04 15:34:04  07/04 15:34:31  27 seconds
Phase 3:        07/04 15:34:31  07/04 15:34:47  16 seconds
Phase 4:        07/04 15:34:47  07/04 15:34:47
Phase 5:        Skipped
Phase 6:        07/04 15:34:47  07/04 15:34:47
Phase 7:        07/04 15:34:47  07/04 15:34:47

Total run time: 47 seconds

--------------000503030107080700050305--
