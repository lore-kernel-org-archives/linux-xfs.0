Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2E96A7F37
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 12:14:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1C5B68F8039
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 10:14:21 -0700 (PDT)
Received: from mail-ob0-f176.google.com (mail-ob0-f176.google.com
	[209.85.214.176]) by cuda.sgi.com with ESMTP id
	x0bM4kH7N4kEPr60 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 14 Jul 2013 10:14:19 -0700 (PDT)
Received: by mail-ob0-f176.google.com with SMTP id v19so12908203obq.7
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 10:14:19 -0700 (PDT)
Subject: Re: specify agsize?
Mime-Version: 1.0 (Apple Message framework v1085)
From: aurfalien <aurfalien@gmail.com>
In-Reply-To: <51E2CE83.9080003@sandeen.net>
Date: Sun, 14 Jul 2013 10:14:15 -0700
Message-Id: <24AC7E60-49D1-4D6E-8B6F-531C46CDCF53@gmail.com>
References: <6A14EB72-A699-47AF-937D-D6DA1CF12ACB@gmail.com>
	<51E2092D.7090409@sandeen.net>
	<9AB8D1D3-29D7-4C43-A624-37024CA4EFD9@gmail.com>
	<51E2CE83.9080003@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


On Jul 14, 2013, at 9:14 AM, Eric Sandeen wrote:

> On 7/13/13 11:20 PM, aurfalien wrote:
>> 
>> On Jul 13, 2013, at 7:13 PM, Eric Sandeen wrote:
>> 
>>> On 7/13/13 7:11 PM, aurfalien wrote:
>>>> Hello again,
>>>> 
>>>> I have a Raid 6 x16 disk array with 128k stripe size and a 512 byte block size.
>>>> 
>>>> So I do;
>>>> 
>>>> mkfs.xfs -f -l size=512m -d su=128k,sw=14 /dev/mapper/vg_doofus_data-lv_data
>>>> 
>>>> And I get;
>>>> 
>>>> meta-data=/dev/mapper/vg_doofus_data-lv_data isize=256    agcount=32, agsize=209428640 blks
>>>>        =                       sectsz=512   attr=2, projid32bit=0
>>>> data     =                       bsize=4096   blocks=6701716480, imaxpct=5
>>>>        =                       sunit=32     swidth=448 blks
>>>> naming   =version 2              bsize=4096   ascii-ci=0
>>>> log      =internal log           bsize=4096   blocks=131072, version=2
>>>>        =                       sectsz=512   sunit=32 blks, lazy-count=1
>>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>>> 
>>>> 
>>>> All is fine but I was recently made aware of tweaking agsize.
>>> 
>>> Made aware by what?  For what reason?
>> 
>> Autodesk has this software called Flame which requires very very fast
>> local storage using XFS. They have an entire write up on how to calc
>> proper agsize for optimal performance.
> 
> http://wikihelp.autodesk.com/Creative_Finishing/enu/2012/Help/05_Installation_Guides/Installation_and_Configuration_Guide_for_Linux_Workstations/0118-Advanced118/0194-Manually194/0199-Creating199
> 
> I guess?
> 
> That's quite a procedure!  And I have to say, a slightly strange one at first glance.
> 
> It'd be nice if they said what they were trying to accomplish rather than just giving you a long recipe.


Sorry to double reply to the same thread.

But the volume in question (regarding the Autodesk article) is used for very fast playback of image files.  So realtime performance for files of 2048x1556 resolution.  These files are being touched/retouched throughout the day by the person driving the Flame.

The fragmentation on these systems on a heavy day, meaning one were they are running at 98% full is about 5% on avg.  On any given day, the systems are about 80% full.

> In the end, I think they are trying to create 128AGs and maybe work around some mkfs corner case or other.
> 
>> I never mess with agsize but it is require  when creating the XFS
>> file system for use with Flame.  I realize its tailored for there
>> apps particular IO characteristics, so I'm curious about it.
> 
> In general more AGs allow more concurrency for some operations;
> it also will generally change how/where files in multiple directories get
> allocated.
> 
>>>> So I would like to mess around and iozone any diffs between the above
>>>> agcount of 32 and whatever agcount changes I may do.
>>> 
>>> Unless iozone is your machine's normal workload, that will probably prove to be uninteresting.
>> 
>> Well, it will give me a base line comparison of non tweaked agsize vs tweaked agsize.
> 
> Not necessarily, see above; I'm not sure what iozone invocation would
> show any effects from more or fewer AGs.  Anyway, iozone != flame, not
> by a long shot! :)
> 
>>>> I didn't see any mention of agsize/agcount on the XFS FAQ and would
>>>> like to know, based on the above, why does XFS think I have 32
>>>> allocation groups with the corresponding size?
>>> 
>>> It doesn't think so, it _knows_ so, because it made them itself.  ;)
>> 
>> Yea but based on what?
>> 
>> Why 32 at there current size?
> 
> see calc_default_ag_geometry()
> 
> Since you are in multidisk mode (you have stripe geometry) it uses more AGs for more AGs since it knows you have more spindles:
> 
>        } else if (dblocks > GIGABYTES(512, blocklog))
>                shift = 5;
> 
> 2^5 = 32
> 
> If you hadn't been in multidisk mode you would have gotten 25 AGs due to the max AG size of 1T.
> 
>>>> And are these optimal
>>>> numbers?
>>> 
>>> How high is up?
>>> 
>>> Here's the appropriate faq entry:
>>> 
>>> http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E
>> 
>> Problem is I run Centos so the line;
>> 
>> "As of kernel 3.2.12, the default i/o scheduler, CFQ, will defeat much of the parallelization in XFS. "
>> 
>> ... doesn't really apply.
> 
> Well, my point was that your original question, "are these optimal numbers?" included absolutely no context of your workload, so the best answer is yes - the default mkfs behavior is optimal for a generic, unspecified workload.
> 
> I don't have access to Autodesk Flame so I really don't know how it behaves or what an optimal tuning might be.
> 
> Anyway, I think the calc_default_ag_geometry() info above answered your original question of "why does XFS think I have 32 allocation groups with the corresponding size?" - that's simply the default mkfs algorithm when in multidisk mode, for a disk of this size.
> 
> -Eric
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
