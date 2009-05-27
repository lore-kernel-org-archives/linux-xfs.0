Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4R9Q0gI186039 for <xfs@oss.sgi.com>; Wed, 27 May 2009 04:26:01 -0500
Received: from atlas.fiton.is (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96C972B144C
	for <xfs@oss.sgi.com>; Wed, 27 May 2009 02:26:12 -0700 (PDT)
Received: from atlas.fiton.is ([62.145.135.105]) by cuda.sgi.com with ESMTP id
	9mjryZMON4PE4xGs for <xfs@oss.sgi.com>;
	Wed, 27 May 2009 02:26:12 -0700 (PDT)
Received: from localhost ([127.0.0.1]) by atlas.fiton.is
	(using TLSv1/SSLv3 with cipher AES128-SHA (128 bits))
	for xfs@oss.sgi.com; Wed, 27 May 2009 09:26:55 +0000
Message-Id: <59D949A6-71F6-4C4C-B5F9-B5B22B189771@fiton.is>
From: =?ISO-8859-1?Q?Svavar_=D6rn_Eysteinsson?= <svavar@fiton.is>
In-Reply-To: <4A1BE48F.9020107@dermichi.com>
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: Incorrect Free Space / xfs_growfs on RAID5 Volume ?
Date: Wed, 27 May 2009 09:26:10 +0000
References: <BC442FE9-64FC-4F3C-A5AA-25C890AABD3C@fiton.is>
	<4A1BE48F.9020107@dermichi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi.

I read on http://www.carltonbale.com/2007/05/how-to-break-the-2tb-2-terabyt=
e-file-system-limit/
that if your kernel is compiled with CONFIG_LBD You can break the 2tb  =

limit. Any facts on that ?

****
Breaking 2TB Option 2 - Use Linux with CONFIG_LBD enabled. Most Linux  =

file systems are capable of partitions larger than 2 TB, as long as  =

the Linux kernel itself is. (See this comparison of Linux file  =

systems.) Most Linux distributions now have kernels compiled with  =

CONFIG_LBD enabled (Ubuntu 6.10 does, for example.) As long as the  =

kernel is configured/compiled properly, it is straight-forward to  =

create a single 4TB EXT3 (or similar) partition.

     * To summarize: 1 RAID array of five 1TB Drives -> 1 RAID level 5  =

Volume Set that is 4TB -> 1 EXT3 (or similar) Linux partition that is  =

4TB.
****

.... Is this maby out of my scope/setup ?


Is there a simple way for me to check if my kernel has this option  =

compiled in ?
I'm running Fedora Core 6 with  2.6.27.7 #1 SMP Tue Nov 25 11:50:10  =

GMT 2008 i686 i686 i386 GNU/Linux.


And the FINAL question.... Is there any way for me to alter the raid  =

volume, partitions to GPT or just format the /dev/sdb without loosing  =

any data ?
Maby it's just not possible without backup up data, and restore'ing ?


Thanks allot guys..


Best regards,

Svavar - Reykjavik - Iceland



On 26.5.2009, at 12:46, Michael Weissenbacher wrote:

> Hi Svavar!
>> Now the strange part. When I issue =93df -h=94 command it shows much  =

>> smaller
>> disk space added then it should have.
>
> You have run into the 2TB limit for a DOS Paritition Table. You must  =

> use GPT (GUID Partition Table) to overcome the limit. You can't use  =

> fdisk for that since it has no GPT support. An alternative would be  =

> parted [1]. I'm not sure how this can be done without data loss. An  =

> alternative would be to not use partitions at all and create the XFS  =

> directly on /dev/sdb.
> This is not really an XFS issue but an partitioning issue.
>
> [1] http://www.gnu.org/software/parted/index.shtml
>
> hth,
> Michael


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
