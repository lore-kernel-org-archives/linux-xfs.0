Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 000857F55
	for <xfs@oss.sgi.com>; Sat, 13 Jul 2013 23:20:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B3EC08F8033
	for <xfs@oss.sgi.com>; Sat, 13 Jul 2013 21:20:35 -0700 (PDT)
Received: from mail-oa0-f49.google.com (mail-oa0-f49.google.com
	[209.85.219.49]) by cuda.sgi.com with ESMTP id FJJIA7NGfPpcX95E
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Jul 2013 21:20:34 -0700 (PDT)
Received: by mail-oa0-f49.google.com with SMTP id n9so14431698oag.8
	for <xfs@oss.sgi.com>; Sat, 13 Jul 2013 21:20:33 -0700 (PDT)
Subject: Re: specify agsize?
Mime-Version: 1.0 (Apple Message framework v1085)
From: aurfalien <aurfalien@gmail.com>
In-Reply-To: <51E2092D.7090409@sandeen.net>
Date: Sat, 13 Jul 2013 21:20:29 -0700
Message-Id: <9AB8D1D3-29D7-4C43-A624-37024CA4EFD9@gmail.com>
References: <6A14EB72-A699-47AF-937D-D6DA1CF12ACB@gmail.com>
	<51E2092D.7090409@sandeen.net>
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


On Jul 13, 2013, at 7:13 PM, Eric Sandeen wrote:

> On 7/13/13 7:11 PM, aurfalien wrote:
>> Hello again,
>> 
>> I have a Raid 6 x16 disk array with 128k stripe size and a 512 byte block size.
>> 
>> So I do;
>> 
>> mkfs.xfs -f -l size=512m -d su=128k,sw=14 /dev/mapper/vg_doofus_data-lv_data
>> 
>> And I get;
>> 
>> meta-data=/dev/mapper/vg_doofus_data-lv_data isize=256    agcount=32, agsize=209428640 blks
>>         =                       sectsz=512   attr=2, projid32bit=0
>> data     =                       bsize=4096   blocks=6701716480, imaxpct=5
>>         =                       sunit=32     swidth=448 blks
>> naming   =version 2              bsize=4096   ascii-ci=0
>> log      =internal log           bsize=4096   blocks=131072, version=2
>>         =                       sectsz=512   sunit=32 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>> 
>> 
>> All is fine but I was recently made aware of tweaking agsize.
> 
> Made aware by what?  For what reason?

Autodesk has this software called Flame which requires very very fast local storage using XFS.  They have an entire write up on how to calc proper agsize for optimal performance.

I never mess with agsize but it is required when creating the XFS file system for use with Flame.  I realize its tailored for there apps particular IO characteristics, so I'm curious about it. 

>> So I would like to mess around and iozone any diffs between the above
>> agcount of 32 and whatever agcount changes I may do.
> 
> Unless iozone is your machine's normal workload, that will probably prove to be uninteresting.

Well, it will give me a base line comparison of non tweaked agsize vs tweaked agsize.

>> I didn't see any mention of agsize/agcount on the XFS FAQ and would
>> like to know, based on the above, why does XFS think I have 32
>> allocation groups with the corresponding size?
> 
> It doesn't think so, it _knows_ so, because it made them itself.  ;)

Yea but based on what?

Why 32 at there current size?

>> And are these optimal
>> numbers?
> 
> How high is up?
> 
> Here's the appropriate faq entry:
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

Problem is I run Centos so the line;

"As of kernel 3.2.12, the default i/o scheduler, CFQ, will defeat much of the parallelization in XFS. "

... doesn't really apply.

- aurf
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
