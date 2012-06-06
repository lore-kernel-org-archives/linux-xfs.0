Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q56A6dx5198922 for <xfs@oss.sgi.com>; Wed, 6 Jun 2012 05:06:39 -0500
Received: from smtprelay05.ispgateway.de (smtprelay05.ispgateway.de
	[80.67.31.97]) by cuda.sgi.com with ESMTP id Eu6Jr9byWYvoL0cH
	for <xfs@oss.sgi.com>; Wed, 06 Jun 2012 03:06:38 -0700 (PDT)
Received: from [62.43.225.238] (helo=localhost)
	by smtprelay05.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <richard.ems@cape-horn-eng.com>)
	id 1ScD8O-0004O1-RX
	for xfs@oss.sgi.com; Wed, 06 Jun 2012 12:06:36 +0200
Message-ID: <4FCF2BAC.6050100@cape-horn-eng.com>
Date: Wed, 06 Jun 2012 12:06:36 +0200
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: Segmentation fault in xfs_db frag, xfsprogs-3.1.8
References: <4FCC77E1.4030600@cape-horn-eng.com>
	<20120605234528.GD22848@dastard>
In-Reply-To: <20120605234528.GD22848@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
Cc: xfs@oss.sgi.com

On 06/06/2012 01:45 AM, Dave Chinner wrote:
> No surprise if you have a large filesystem and the filesystem is
> changing while xfs_db is running. xfs_db is not coherent with
> mounted filesytems, and it is not recommended that you use it that
> way.s xfs-db is a debugging tool, not a filesystem state reporting
> tool.

Ok, thanks, didn't know that.
I would like to monitor the fragmentation value for all my mounted XFS.
I think I read in previous list messages that also other people are
using xfs_db this way. Or is there another way to get the fragmentation
value?


I found this segmentation fault error very strange, since I have been
using "echo frag | xfs_db -r" for months already on other big
filesystems - 2 x 17 TB, 1 x 25 TB, 1 x 20 TB - and NEVER got a
segmentation fault. All 4 filessystems are mounted read-write and are in
heavy IO use, nevertheless "echo frag | xfs_db -r" runs as expected (by
me), no one xfs_db run crashed with a segmentation fault at all for
months, running every weekend.
It also ran several times without giving any errors on this 80 TB XFS,
but then started to throw segmentation faults some weeks ago.


>> # mount | grep sdc
>> /dev/sdc on /backup/ES-6664 type xfs
>> (rw,noatime,attr2,nobarrier,inode64,logbufs=3D8,logbsize=3D256k,sunit=3D=
128,swidth=3D3712,noquota,_netdev)
>> /dev/sdc on /backup/ES-6664 type xfs
>> (ro,relatime,attr2,nobarrier,inode64,logbufs=3D8,logbsize=3D256k,sunit=
=3D128,swidth=3D3712,noquota,_netdev)
>>
>> The FS gets first mounted rw and then bind mounted ro on top of it.
> =

> That doesn't mean the filesystem is mount read only. The only way to
> ensure that is to remount it read only, because the bind mount
> doesn't force file descriptors that are already open to magically
> diasappear or become read-only.

Yes, thanks! I was just trying to show how the XFS was actually mounted,
and not stating that it was mounted read-only at all. Perhaps I should
have explained it better.


>> # echo frag | /opt/xfsprogs-3.1.8/sbin/xfs_db -r /dev/sdc
>> Segmentation fault
> =

> and if you clear caches before running xfs_db again?

I will try this. I unmounted the filesystem now and I am running frag,
but I will later try to reproduce the segmentation fault and then see if
clearing caches helps.

> =

>> Any clues?
> =

> Not really, but then again you are doing something that really isn't
> guaranteed to work properly in all cases. Build xfs_db from the
> latest tree and run it without stripping the binary (i.e. run it
> from the build tree), capture the core file and get a backtrace of
> where it failed from xfs_db. more than likely it will point to
> xfs_db having encountered something that is not entirely metadata
> anymore...


Many thanks Dave for all clarifications!



-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
