Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5KGUefP124220
	for <linux-xfs@oss.sgi.com>; Sat, 20 Jun 2009 11:30:41 -0500
Received: from pu01.news-service.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7628F30E373
	for <linux-xfs@oss.sgi.com>; Sat, 20 Jun 2009 09:31:05 -0700 (PDT)
Received: from pu01.news-service.com (ns1.news-service.com [195.114.240.3]) by
	cuda.sgi.com with ESMTP id GwD6pThHGONgOW24 for
	<linux-xfs@oss.sgi.com>; Sat, 20 Jun 2009 09:31:05 -0700 (PDT)
Message-ID: <4A3D0EC5.8080308@news-service.com>
Date: Sat, 20 Jun 2009 18:31:01 +0200
From: Patrick Schreurs <patrick@news-service.com>
MIME-Version: 1.0
Subject: Re: 2.6.30 panic - xfs_fs_destroy_inode
References: <4A392213.4020200@news-service.com>
	<4A3960A0.8090707@sandeen.net>	<4A39F2E6.5020205@news-service.com>	<4A3CB765.8040600@news-service.com>
	<7028E3E6-033A-416D-B046-286520CA457A@sandeen.net>
In-Reply-To: <7028E3E6-033A-416D-B046-286520CA457A@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>, Tommy van Leeuwen <tommy@news-service.com>

Just had another one. It's likely we'll have to downgrade to 2.6.28.x.

These servers have 28 SCSI disks mounted separately (JBOD). The workload 
is basically i/o load (90% read, 10% write) from these disks. The 
servers are not extreme busy (overloaded).

xfs_info from a random disk:

sb02:~# xfs_info /dev/sdb
meta-data=/dev/sdb               isize=256    agcount=4, agsize=18310547 
blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=73242187, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

As you can see we use lazy-count=1. Mount options aren't very exotic: 
rw,noatime,nodiratime

We are seeing these panic's on at least 3 different servers.

If you have any hints on how to investigate, we would greatly appreciate 
it.

-Patrick

Eric Sandeen wrote:
> Others aren't hitting this, what sort of workload are you running when 
> you hit it?
> 
> I have not had time to look at it yet but some sort of testcase may 
> greatly help.
> 
> -Eric
> 
> On Jun 20, 2009, at 5:18 AM, Patrick Schreurs <patrick@news-service.com> 
> wrote:
> 
>> Unfortunately another panic. See attachment.
>>
>> Would love to receive some advice on this issue.
>>
>> Thanks in advance.
>>
>> -Patrick
>>
>> Patrick Schreurs wrote:
>>> Eric Sandeen wrote:
>>>> Patrick Schreurs wrote:
>>>>> Hi all,
>>>>>
>>>>> We are experiencing kernel panics on servers running 2.6.29(.1) and 
>>>>> 2.6.30. I've included two attachments to demonstrate.
>>>>>
>>>>> The error is:
>>>>> Kernel panic - not syncing: xfs_fs_destroy_inode: cannot reclaim ...
>>>>>
>>>>> OS is 64bit Debian lenny.
>>>>>
>>>>> Is this a known issue? Any comments on this?
>>>>
>>>> It's not known to me, was this a recent upgrade?  (IOW, did it start
>>>> with .29(.1)?
>>> We've seen this on 2 separate servers. It probably happened more 
>>> often, but we didn't captured the panic message. One server was 
>>> running 2.6.29.1, the other server was running 2.6.30. Currently 
>>> we've updated all similar servers to 2.6.30.
>>> If we can provide you with more details to help fix this issue, 
>>> please let us know.
>>> -Patrick
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>> <sb06-20090619.png>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
