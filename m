Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4RGTOEp198692 for <xfs@oss.sgi.com>; Wed, 27 May 2009 11:29:24 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CAD3C10197E3
	for <xfs@oss.sgi.com>; Wed, 27 May 2009 09:35:26 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id DZRc0JSOGTVP79Wh for <xfs@oss.sgi.com>;
	Wed, 27 May 2009 09:35:26 -0700 (PDT)
Message-ID: <4A1D6A64.7010305@sandeen.net>
Date: Wed, 27 May 2009 11:29:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Incorrect Free Space / xfs_growfs on RAID5 Volume ?
References: <BC442FE9-64FC-4F3C-A5AA-25C890AABD3C@fiton.is>	<4A1BE48F.9020107@dermichi.com>
	<59D949A6-71F6-4C4C-B5F9-B5B22B189771@fiton.is>
In-Reply-To: <59D949A6-71F6-4C4C-B5F9-B5B22B189771@fiton.is>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: =?windows-1252?Q?Svavar_=D6rn_Eysteinsson?= <svavar@fiton.is>
Cc: xfs@oss.sgi.com

Svavar =D6rn Eysteinsson wrote:
> Hi.
> =

> I read on http://www.carltonbale.com/2007/05/how-to-break-the-2tb-2-terab=
yte-file-system-limit/
> that if your kernel is compiled with CONFIG_LBD You can break the 2tb  =

> limit. Any facts on that ?

This lets the kernel track block devices which are more than 2^32
sectors large, but it does not change the fact that an msdos partition
table cannot have a partition this large.

> ****
> Breaking 2TB Option 2 - Use Linux with CONFIG_LBD enabled. Most Linux  =

> file systems are capable of partitions larger than 2 TB, as long as  =

> the Linux kernel itself is. (See this comparison of Linux file  =

> systems.) Most Linux distributions now have kernels compiled with  =

> CONFIG_LBD enabled (Ubuntu 6.10 does, for example.) As long as the  =

> kernel is configured/compiled properly, it is straight-forward to  =

> create a single 4TB EXT3 (or similar) partition.
> =

>      * To summarize: 1 RAID array of five 1TB Drives -> 1 RAID level 5  =

> Volume Set that is 4TB -> 1 EXT3 (or similar) Linux partition that is  =

> 4TB.
> ****
> =

> .... Is this maby out of my scope/setup ?
> =

> =

> Is there a simple way for me to check if my kernel has this option  =

> compiled in ?
> I'm running Fedora Core 6 with  2.6.27.7 #1 SMP Tue Nov 25 11:50:10  =

> GMT 2008 i686 i686 i386 GNU/Linux.

That's pretty old.... but it probably has it on.  I don't remember if
FC6 had config-* in /boot; if so you could just check there.  Otherwise
grab the src.rpm and work from there ...

> =

> And the FINAL question.... Is there any way for me to alter the raid  =

> volume, partitions to GPT or just format the /dev/sdb without loosing  =

> any data ?
> Maby it's just not possible without backup up data, and restore'ing ?

It is probably possible to put a new GPT table in place of the DOS
table, but you have to be careful.  The idea is that you need a GPT
table with a partition starting at exactly the same place, and with the
end in the correct (larger) place ... and the GPT table must all fit
before the first sector of the first partition.  With care, this usually
works.

-Eric

> =

> Thanks allot guys..
> =

> =

> Best regards,
> =

> Svavar - Reykjavik - Iceland
> =

> =

> =

> On 26.5.2009, at 12:46, Michael Weissenbacher wrote:
> =

>> Hi Svavar!
>>> Now the strange part. When I issue =93df -h=94 command it shows much  =

>>> smaller
>>> disk space added then it should have.
>> You have run into the 2TB limit for a DOS Paritition Table. You must  =

>> use GPT (GUID Partition Table) to overcome the limit. You can't use  =

>> fdisk for that since it has no GPT support. An alternative would be  =

>> parted [1]. I'm not sure how this can be done without data loss. An  =

>> alternative would be to not use partitions at all and create the XFS  =

>> directly on /dev/sdb.
>> This is not really an XFS issue but an partitioning issue.
>>
>> [1] http://www.gnu.org/software/parted/index.shtml
>>
>> hth,
>> Michael
> =

> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
