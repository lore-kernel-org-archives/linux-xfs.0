Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1R8hqAO036616 for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 02:43:52 -0600
Received: from mail-bk0-f53.google.com (mail-bk0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id SXC3cZRV0UCE5B58
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 27 Feb 2012 00:43:50 -0800 (PST)
Received: by bkwj10 with SMTP id j10so1123982bkw.26
	for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 00:43:49 -0800 (PST)
Message-ID: <4F4B423E.2000409@gmail.com>
Date: Mon, 27 Feb 2012 09:43:42 +0100
From: kadafax@gmail.com
MIME-Version: 1.0
Subject: Re: XFS, empty files after a crash
References: <4F4387A7.2070009@gmail.com> <20120227010402.GR3592@dastard>
In-Reply-To: <20120227010402.GR3592@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Le 27/02/12 02:04, Dave Chinner a =E9crit :
> On Tue, Feb 21, 2012 at 01:01:43PM +0100, kfx wrote:
>> # du  myfile
>> 27460    myfile
>>
>> # du --apparent-size myfile
>> 0    myfile
>>
>> # xfs_bmap myfile
>> myfile: no extents
> That doesn't seem right:
>
> $ ls -l foobar
> -rw------- 1 root root 0 Feb 27 11:54 foobar
> $ du foobar
> 1024    foobar
> $ du --apparent-size foobar
> 0       foobar
> $ xfs_bmap foobar
> foobar:
> 	0: [0..2047]: 255169872..255171919
>
> So xfs_bmap can and does report extents beyond EOF.
>
> du uses the fstat(2) syscall to get the block count from the inode,
> so it's seeing an inode with a block count but no extents. Can you
> dump the inode via xfs_db like so:
>
> $ ls -i foobar
> 604424233 foobar
> $ sudo xfs_db -r -c "inode 604424233" -c p /dev/md0
> core.magic =3D 0x494e
> core.mode =3D 0100600
> core.version =3D 2
> .....
>
> And post the output?
[root@server 1_out]# du foobar
25840    foobar
[root@server 1_out]# du --apparent-size foobar
0    foobar
[root@server 1_out]# xfs_bmap foobar
foobar: no extents
[root@server 1_out]# ls -i foobar
114748 foobar
[root@server 1_out]# xfs_db -r -c "inode 114748" -c p /dev/sdc1
core.magic =3D 0x494e
core.mode =3D 0100644
core.version =3D 2
core.format =3D 2 (extents)
core.nlinkv2 =3D 1
core.onlink =3D 0
core.projid =3D 0
core.uid =3D 12488
core.gid =3D 12488
core.flushiter =3D 0
core.atime.sec =3D Tue Jan 24 14:50:52 2012
core.atime.nsec =3D 609667096
core.mtime.sec =3D Tue Jan 24 14:50:53 2012
core.mtime.nsec =3D 579672930
core.ctime.sec =3D Tue Jan 24 14:50:53 2012
core.ctime.nsec =3D 579672930
core.size =3D 0
core.nblocks =3D 6460
core.extsize =3D 0
core.nextents =3D 1
core.naextents =3D 0
core.forkoff =3D 0
core.aformat =3D 2 (extents)
core.dmevmask =3D 0
core.dmstate =3D 0
core.newrtbm =3D 0
core.prealloc =3D 0
core.realtime =3D 0
core.immutable =3D 0
core.append =3D 0
core.sync =3D 0
core.noatime =3D 0
core.nodump =3D 0
core.rtinherit =3D 0
core.projinherit =3D 0
core.nosymlinks =3D 0
core.extsz =3D 0
core.extszinherit =3D 0
core.nodefrag =3D 0
core.filestream =3D 0
core.gen =3D 1924597489
next_unlinked =3D null
u.bmx[0] =3D [startoff,startblock,blockcount,extentflag] =

0:[0,1881705728,6460,0]

After using the Nathaniel's advices and dd'ing the file:
[root@server recover]# ls -alh foobar
-rw-r--r-- 1 root root 26M Feb 24 10:39 /recover/foobar




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
