Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1OLWw3F049615 for <xfs@OSS.SGI.com>; Wed, 24 Feb 2010 15:32:58 -0600
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EDBC01F3028
	for <xfs@OSS.SGI.com>; Wed, 24 Feb 2010 13:34:20 -0800 (PST)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id dZ0Fs7dPAS8JUiyn
	for <xfs@OSS.SGI.com>; Wed, 24 Feb 2010 13:34:20 -0800 (PST)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1NkOru-0000ZP-Rz
	for <xfs@OSS.SGI.com>; Wed, 24 Feb 2010 21:34:06 +0000
MIME-Version: 1.0
Message-ID: <19333.39755.63777.969923@tree.ty.sabi.co.uk>
Date: Wed, 24 Feb 2010 21:34:03 +0000
Subject: RE: xfs_growfs failure....
In-Reply-To: <E51793F9F4FAD54A8C1774933D8E500006B64A2793@sbapexch05>
References: <E51793F9F4FAD54A8C1774933D8E500006B64A2687@sbapexch05>
	<19333.23937.956036.716@tree.ty.sabi.co.uk>
	<E51793F9F4FAD54A8C1774933D8E500006B64A2793@sbapexch05>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux XFS <xfs@oss.sgi.com>

[ ... ]

>> It looks like that the filesystem was "grown" from ~92TiB to
>> ~114TiB on a storage device that is reported as ~103TiB
>> long. Again, very strange.

> cat /proc/partitions
> [snip]
> 253    61 107971596288 dm-61
> = ~100TB. 

That's the same as "limit=215943192576".

> -bash-3.1# lvdisplay
> --- Logical volume ---
>   LV Name                /dev/logfs-sessions/sessions
>   VG Name                logfs-sessions
>   LV UUID                32TRbe-OIDw-u4aH-fUmD-FLmU-5jRv-MaVYDg
>   LV Write Access        read/write
>   LV Status              available
>   # open                 0
>   LV Size                100.56 TB
>   Current LE             26360253
>   Segments               18
>   Allocation             inherit
>   Read ahead sectors     0
>   Block device           253:61

> --- Logical volume ---
>   LV Name                /dev/logfs-sessions/logdev
>   VG Name                logfs-sessions
>   LV UUID                cRDvJx-3QMS-VI7X-Oqj1-bGDA-ACki-quXpve
>   LV Write Access        read/write
>   LV Status              available
>   # open                 0
>   LV Size                5.00 GB
>   Current LE             1281
>   Segments               1
>   Allocation             inherit
>   Read ahead sectors     0
>   Block device           253:60


>> 112 AGs of 1TiB each - that confirms the grow succeeded and
>> it was able to write metadata to disk between 100 and 111 TiB
>> without errors being reported. That implies the block device
>> must have been that big at some point...

> There were never 110 TB; only 100 were ever there...so I am
> not clear on this point.

Not clear here too; because if the fs was grown to 110TB that
number must have come from somewhere.

[ ... ]

> These were the commands run: 
 
> pvcreate /dev/dm-50 /dev/dm-51 /dev/dm-52 /dev/dm-53 /dev/dm-54 /dev/dm-55
> vgextend logfs-sessions /dev/dm-50 /dev/dm-51 /dev/dm-52 /dev/dm-53 /dev/dm-54 /dev/dm-55
> lvextend -i 3 -I 512 -l +1406973 /dev/logfs-sessions/sessions /dev/dm-50 /dev/dm-51 /dev/dm-52
> lvextend -i 3 -I 512 -l +1406973 /dev/logfs-sessions/sessions /dev/dm-53 /dev/dm-54 /dev/dm-55

So you extended the LV twice, starting from 23,546,307 4MiB LEs
('dblocks=24111418368'), by 1,406,973 LEs each time.

That is consistent with the whole story, not at all obvious how
comes SB 0 got 'dblocks=29874379776' when 'dm-61' has 26360253
4MiB LEs equivalent to 26992899072 dblocks, for a difference of
11,255,784MiB. Especially as the size in SB0 tallies with the
number of AGs in it.

So far everything fine.

> xfs_growfs /u01 (which failed)
> xfs_growfs -d /u01 (which did not error out)
> touch /u01/a

> -bash-3.1# uname -a
> Linux xx.com 2.6.18-53.1.19.el5 #1 SMP Tue Apr 22 03:01:10 EDT 2008 x86_64 x86_64 x86_64 GNU/Linux

That seems to imply RH51, which is somewhat old.

> rpm -qa | grep xfs
> kmod-xfs-0.4-1.2.6.18_8.1.1.el5.centos.plus.1
> xfsprogs-2.8.20-1.el5.centos

BTW, I would use nowadays the 'elrepo' 'kmod' packages rather than
the CentOSPlus ones (even if the 'kmod-xfs' main version is the
same). And fortunately you are using 64b arch or else you'd never
be able able to 'fsck' the filesystem (it could still take weeks).

Also on my system I have 'xfsprogs-2.9.4-1.el5.centos' which is
rather newer. I wonder if there was some bug fix for 'growfs'
between 2.8.0 and 2.9.4.

> I've read about a case where Mr Chinner used xfd_db to set
> agcount and in some cases fix things up. Don't know if I am a
> candidate for that approach...

The good news from the SB dumps is that SB 2 is basically the
old one for the 90TB filesystem, and that growing the filesystem
does not actually change anything much in it, just the top level
metadata saying how big the filesystem is. It is likely that if
you revert to the SB 2 you should get back the 90TB version of
your filesystem untouched. Then you got to repair it anyhow, to
ensure that it is consistent, and that could take weeks.

The bad news is that for some reason 'growfs' thought the block
device was 110TB, and that's a problem, because perhaps that
strange number will surface again.

One wild guess is that something happened here:

  > xfs_growfs /u01 (which failed)
  > xfs_growfs -d /u01 (which did not error out)

during the first operation, given that you have an external log,
which *may* have caused trouble. Or else some 'growfs' bug in
2.8.0.

  BTW there is also that a 90-110TB single filesystem seems to me
  rather unwise, never mind one that spans linearly several block
  devices, which seems to me extremely avoidable (euphemism)
  unless the contents are entirely disposable.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
