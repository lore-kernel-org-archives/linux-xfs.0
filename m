Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q257VmnT123804 for <xfs@oss.sgi.com>; Mon, 5 Mar 2012 01:31:49 -0600
Received: from mail.vlasiu.net (mail.vlasiu.net [213.157.175.46]) by
	cuda.sgi.com with ESMTP id pc69C5a04MAwBrOA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 04 Mar 2012 23:31:47 -0800 (PST)
Date: Mon, 5 Mar 2012 09:31:38 +0200 (EET)
From: Gabriel VLASIU <gabriel@vlasiu.net>
Subject: Re: failed to set versionnum in AG 1
In-Reply-To: <20120305011032.GL5091@dastard>
Message-ID: <alpine.LRH.2.02.1203050912001.10815@mail.vlasiu.net>
References: <alpine.LRH.2.02.1203041803340.8964@mail.vlasiu.net>
	<20120305011032.GL5091@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Dave!

On Mon, 5 Mar 2012, Dave Chinner wrote:

> > # xfs_db -x /dev/sdh1
> > xfs_db> version
> > versionnum [0xb4b4+0x8] = V4,ATTR,NLINK,ALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2
> 
> it already has the attr2 feature bit set.
Yes, it has. But another (old) partition does not have ATTR2 enabled. And 
the error is the same when I try to set ATTR2. And the funny thing is, 
after that, version report ATTR2 as set.

All my partitions have been created on RHEL5 (some are even older). On a 
new partition (created on RHEL6) I can set ATTR2 over and over again 
without any error reported. Should I backup everything, reformat all 
partitions and restore everything?

> > xfs_db> version attr2
> > writing all SBs
> > Superblock has mismatched features2 fields, skipping modification
> > failed to set versionnum in AG 1
> > versionnum [0xb4b4+0x8] = V4,ATTR,NLINK,ALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2
> 
> What version of xfs_db are you using?
3.1.1 and 3.1.7

> And why do you need to set the attr2 feature this way? It gets set
> automatically when it gets used because on recent kernels it is the
> default mount option. If you have an older kernel and need to turn
> attr2 on, then simply add the "attr2" field to the mount options on
> the filesystem. Once xfs_info reports attr=2 for the filesytem, you
> can remove the attr2 mount option...
Thank you, but I know that. In fact it was the first thing I tried: can 
the filesystem be be mounted if I add attr2 is in fstab. And I was able to 
do so. Still, ATTR2 was not reported for the partition I was talking 
above (without ATTR2 reported by version).

But that's not the point. I see an error message here "Superblock has 
>>mismatched<< features2 fields". And another one ">>failed<< to set 
versionnum in AG 1".
Still, xfs_repair does not see anything wrong with the filesystem. So 
who's wrong? xfs_repair or xfs_db?
An most important: it's possible in the future to loose some data?

Sincerely,
Gabriel

- -- 

// Gabriel VLASIU
//
// OpenGPG-KeyID      : 0xE684206E
// OpenGPG-Fingerprint: 0C3D 9F8B 725D E243 CB3C 8428 796A DB1F E684 206E
// OpenGPG-URL        : http://www.vlasiu.net/public.key


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk9Ua9oACgkQeWrbH+aEIG6x/QCeOrLQCVrVbBnzT5UXmKy8bwdK
u/YAn1P3G2L80MMvX0qD0Tf25fBLleX+
=BZVM
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
