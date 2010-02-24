Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1OIaKcA040940 for <xfs@oss.sgi.com>; Wed, 24 Feb 2010 12:36:20 -0600
Received: from SBAPEXCH05.ad.corp.expertcity.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA7F71F1B57
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2010 10:37:42 -0800 (PST)
Received: from SBAPEXCH05.ad.corp.expertcity.com
	(sbapexch05.ad.corp.expertcity.com [216.219.126.165]) by
	cuda.sgi.com with ESMTP id b38GoGmha356Bt7d for
	<xfs@oss.sgi.com>; Wed, 24 Feb 2010 10:37:42 -0800 (PST)
From: Joe Allen <Joe.Allen@citrix.com>
Date: Wed, 24 Feb 2010 10:37:30 -0800
Subject: RE: xfs_growfs failure....
Message-ID: <E51793F9F4FAD54A8C1774933D8E500006B64A2793@sbapexch05>
References: <E51793F9F4FAD54A8C1774933D8E500006B64A2687@sbapexch05>
	<19333.23937.956036.716@tree.ty.sabi.co.uk>
In-Reply-To: <19333.23937.956036.716@tree.ty.sabi.co.uk>
Content-Language: en-US
MIME-Version: 1.0
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
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>, Linux XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>

Thanks so much for the help interpreting. 
We are extremely grateful for your help. 
I have tried to include some more information you all suggest might help:


>> It looks like that the filesystem was "grown" from ~92TiB to
~114TiB on a storage device that is reported as ~103TiB
long. Again, very strange.

cat /proc/partitions
[snip]
253    61 107971596288 dm-61

= ~100TB. 

-bash-3.1# lvdisplay
--- Logical volume ---
  LV Name                /dev/logfs-sessions/sessions
  VG Name                logfs-sessions
  LV UUID                32TRbe-OIDw-u4aH-fUmD-FLmU-5jRv-MaVYDg
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                100.56 TB
  Current LE             26360253
  Segments               18
  Allocation             inherit
  Read ahead sectors     0
  Block device           253:61

--- Logical volume ---
  LV Name                /dev/logfs-sessions/logdev
  VG Name                logfs-sessions
  LV UUID                cRDvJx-3QMS-VI7X-Oqj1-bGDA-ACki-quXpve
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                5.00 GB
  Current LE             1281
  Segments               1
  Allocation             inherit
  Read ahead sectors     0
  Block device           253:60


>>112 AGs of 1TiB each - that confirms the grow succeeded and it was able to write metadata to disk 
>>between 100 and 111 TiB without errors being reported. That implies the block device must have been that big at some point...

There were never 110 TB; only 100 were ever there...so I am not clear on this point. 

>>My impression is that not enough history/context has been
>>provided to enable a good guess at what has happened and how to
>>undo the consequent damage.You suggested more context might help: 


These were the commands run: 
 
pvcreate /dev/dm-50 /dev/dm-51 /dev/dm-52 /dev/dm-53 /dev/dm-54 /dev/dm-55
vgextend logfs-sessions /dev/dm-50 /dev/dm-51 /dev/dm-52 /dev/dm-53 /dev/dm-54 /dev/dm-55
lvextend -i 3 -I 512 -l +1406973 /dev/logfs-sessions/sessions /dev/dm-50 /dev/dm-51 /dev/dm-52
lvextend -i 3 -I 512 -l +1406973 /dev/logfs-sessions/sessions /dev/dm-53 /dev/dm-54 /dev/dm-55
xfs_growfs  /u01 (which failed)
xfs_growfs -d /u01 (which did not error out)
touch /u01/a


I am sorry I don't have the output of the xfs_growfs command any longer. 
Very shortly after someone noticed the filesystem was essentially offline -- input output error. 
Tried unmounting but couldn't... got out of memory errors even when doing ls.  
Tried rebooting and now FS is off line. 

The FS was 90TB, the purpose of the exercise was to grow it to 100TB. 

This is:

-bash-3.1# uname -a
Linux xx.com 2.6.18-53.1.19.el5 #1 SMP Tue Apr 22 03:01:10 EDT 2008 x86_64 x86_64 x86_64 GNU/Linux

rpm -qa | grep xfs
kmod-xfs-0.4-1.2.6.18_8.1.1.el5.centos.plus.1
xfsprogs-2.8.20-1.el5.centos

I've read about a case where Mr Chinner used xfd_db to set agcount and in some cases fix things up.
Don't know if I am a candidate for that approach... 
If there is any information I can gather I am more than ready to do that. 




-----Original Message-----
From: xfs-bounces@oss.sgi.com [mailto:xfs-bounces@oss.sgi.com] On Behalf Of Peter Grandi
Sent: Wednesday, February 24, 2010 9:10 AM
To: Linux XFS
Subject: Re: xfs_growfs failure....

> I am in some difficulty here over a 100TB filesystem

Shrewd idea! Because 'fsck' takes no time and memory, so the
bigger the filesystem the better! ;-).

> that Is now unusable after a xfs_growfs command. [ ... ] 

Wondering how long it took to backup 100TB; but of course doing
a 'grow' is guaranteed to be error free, so there :-).

> attempt to access beyond end of device dm-61: rw=0,
> want=238995038208, limit=215943192576

It looks like the underlying DM logical volume is smaller than
the new size of the filesystem, which is strange as 'xfs_growfs'
is supposed to fetch the size of the underlying block device if
none is specified explicitly on the command line. The different
is about 10% or 10TB, so it is far from trivial.

Looking at the superblock dumps there are some pretty huge
discrepancies, 

  -bash-3.1# xfs_db -r -c 'sb 0' -c p /dev/logfs-sessions/sessions
  magicnum = 0x58465342
  blocksize = 4096
  dblocks = 29874379776
  rblocks = 0
  rextents = 0
  uuid = fc8bdf76-d962-43c1-ae60-b85f378978a6
  logstart = 0
  rootino = 2048
  rbmino = 2049
  rsumino = 2050
  rextsize = 384
  agblocks = 268435328
  agcount = 112
  [ ... ]
  -bash-3.1# xfs_db -r -c 'sb 2' -c p /dev/logfs-sessions/sessions
  magicnum = 0x58465342
  blocksize = 4096
  dblocks = 24111418368
  rblocks = 0
  rextents = 0
  uuid = fc8bdf76-d962-43c1-ae60-b85f378978a6
  logstart = 0
  rootino = 2048
  rbmino = 2049
  rsumino = 2050
  rextsize = 384
  agblocks = 268435328
  agcount = 90
  [ ... ]

The 'dblocks' field is rather different, even if the 'uuid' and
'agblocks' is the same, and 'agcount' is also rather different.
In SB 0 'dblocks' 29874379776 means size 238995038208, which is
value of 'want' above. The products of 'agcount' and 'agblocks'
fit with the sizes.

It looks like that the filesystem was "grown" from ~92TiB to
~114TiB on a storage device that is reported as ~103TiB
long. Again, very strange.

My impression is that not enough history/context has been
provided to enable a good guess at what has happened and how to
undo the consequent damage.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
