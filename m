Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E59247F37
	for <xfs@oss.sgi.com>; Sat, 13 Jul 2013 21:13:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6D106AC003
	for <xfs@oss.sgi.com>; Sat, 13 Jul 2013 19:13:08 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id w5eKQ5xVbUZa7WPV for <xfs@oss.sgi.com>;
	Sat, 13 Jul 2013 19:13:03 -0700 (PDT)
Message-ID: <51E2092D.7090409@sandeen.net>
Date: Sat, 13 Jul 2013 21:13:01 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: specify agsize?
References: <6A14EB72-A699-47AF-937D-D6DA1CF12ACB@gmail.com>
In-Reply-To: <6A14EB72-A699-47AF-937D-D6DA1CF12ACB@gmail.com>
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
To: aurfalien <aurfalien@gmail.com>
Cc: xfs@oss.sgi.com

On 7/13/13 7:11 PM, aurfalien wrote:
> Hello again,
> 
> I have a Raid 6 x16 disk array with 128k stripe size and a 512 byte block size.
> 
> So I do;
> 
> mkfs.xfs -f -l size=512m -d su=128k,sw=14 /dev/mapper/vg_doofus_data-lv_data
> 
> And I get;
> 
> meta-data=/dev/mapper/vg_doofus_data-lv_data isize=256    agcount=32, agsize=209428640 blks
>          =                       sectsz=512   attr=2, projid32bit=0
> data     =                       bsize=4096   blocks=6701716480, imaxpct=5
>          =                       sunit=32     swidth=448 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=131072, version=2
>          =                       sectsz=512   sunit=32 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
> All is fine but I was recently made aware of tweaking agsize.

Made aware by what?  For what reason?

> So I would like to mess around and iozone any diffs between the above
> agcount of 32 and whatever agcount changes I may do.

Unless iozone is your machine's normal workload, that will probably prove to be uninteresting.

> I didn't see any mention of agsize/agcount on the XFS FAQ and would
> like to know, based on the above, why does XFS think I have 32
> allocation groups with the corresponding size?

It doesn't think so, it _knows_ so, because it made them itself.  ;)

> And are these optimal
> numbers?

How high is up?

Here's the appropriate faq entry:

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

-Eric
 
> Thanks in advance,
> 
> - aurf
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
