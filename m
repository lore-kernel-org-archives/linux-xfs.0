Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9QJ03Yp250696 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 14:00:03 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 6ZG1Fpxy9eqpAgGy for <xfs@oss.sgi.com>;
	Fri, 26 Oct 2012 12:01:49 -0700 (PDT)
Message-ID: <508ADE1C.40208@sandeen.net>
Date: Fri, 26 Oct 2012 14:01:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Enabling quota on XFS filesystem with many files hangs
References: <20121026191540.ca9ee64db2a51e7166b7fadc@mjh.name>
In-Reply-To: <20121026191540.ca9ee64db2a51e7166b7fadc@mjh.name>
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
To: =?ISO-8859-1?Q?Milan_Holz=E4pfel?= <listen@mjh.name>
Cc: xfs@oss.sgi.com

On 10/26/12 12:15 PM, Milan Holz=E4pfel wrote:
> Hello all, =

> =

> I have an XFS filesystem of size 1.2 TiB with 101 GiB free space and 14
> million inodes in use. Quotas are disabled on the filesystem. I try to
> enable user and group quotas by mounting with
> =

> mount /dev/xfs_device /mnt -o uquota,gquota
> =

> I first tried this with the 3.2.0 Kernel from Ubuntu 12.04 and hit an
> OOM [1, 2]. In [1], it is said that the OOM is fixed in 3.5, so I tried
> 3.5.7 and 3.6.3 from http://kernel.ubuntu.com/~kernel-ppa/mainline/ (I
> believe these are vanilla kernel.org kernels compiled with Ubuntu's
> configuration). =

> =

> With 3.5.7 and 3.6.3, the OOM does not occur. For some time after
> issuing the mount command, there is much I/O activity with xfs_inode
> in /proc/slabinfo growing up to ~ 500k entries, which is just fine. At
> some point, the I/O activity stops, but the mount does not terminate.
> The system is completely idle. (The mount was the only activity on the
> system.) =

> =

> In dmesg, I find
> =

> INFO: task mount:8806 blocked for more than 120 seconds.

And then what?  Probably a backtrace, right?

sysrq-w to get hung tasks or sysrq-t to get all task traces might
help.

The sysrqs are one of the things suggested in:
http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_=
reporting_a_problem.3F

Thanks,
-Eric

> in regular intervals. =

> =

> Can you help me with this? Thanks in advance. =

> =

> Regards,
> Milan Holz=E4pfel
> =

> =

> =

> [1]: http://oss.sgi.com/archives/xfs/2012-06/msg00362.html
> [2]: http://oss.sgi.com/archives/xfs/2012-09/msg00260.html
> =

> =

> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
