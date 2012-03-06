Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q267UalD093727 for <xfs@oss.sgi.com>; Tue, 6 Mar 2012 01:30:36 -0600
Received: from mail.vlasiu.net (mail.vlasiu.net [213.157.175.46]) by
	cuda.sgi.com with ESMTP id 6bJTqCT4M0aDnKOU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 05 Mar 2012 23:30:33 -0800 (PST)
Date: Tue, 6 Mar 2012 09:30:23 +0200 (EET)
From: Gabriel VLASIU <gabriel@vlasiu.net>
Subject: Re: failed to set versionnum in AG 1
In-Reply-To: <20120305222807.GE3592@dastard>
Message-ID: <alpine.LRH.2.02.1203060909370.32267@mail.vlasiu.net>
References: <alpine.LRH.2.02.1203041803340.8964@mail.vlasiu.net>
	<20120305011032.GL5091@dastard>
	<alpine.LRH.2.02.1203050912001.10815@mail.vlasiu.net>
	<20120305222807.GE3592@dastard>
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

 Hi!

On Tue, 6 Mar 2012, Dave Chinner wrote:

> That's because the error you are getting is for setting the value
> into secondary superblocks, but the primary superblock has had the
> value set correctly.
I see.

> No, most definitely not. There's nothing wrong with your
> filesystems.
That's a very good news for me.

> So you're using the versions that detect inconsistencies correctly,
> and also write everythign consistently. So it's a problem from an
> old mkfs binary (2.9.x or 3.0.x) or caused by something you've done
> poking around with xfs_db.
I do not "poke" around filesystems with data. I use xfs in production 
since redhat 9. I do not know how old are the filesystems in question 
but some are probably more than 7-8 years old.
The only thing I set to those filesystem over the years is log2 attribute 
using xfs_admin (and the filesystem label). But since xfs_admin cannot set 
the ATTR2 I had to use xfs_db.

> "Once xfs_info reports attr=2 for the filesytem, you
> can remove the attr2 mount option..."
> 
> The attr2 feature bit will only get set when the attr2 format
> is first used, so if you're workload isn't causing attr2 format
> inodes to be created, the feature bit will not get set. Hence you
> need to leave the mount option set until xfs_info (which reads the
> superblock feature bits) reports it being set.
Oh... I see. Thank you.

> IOWs, if you have to resort to using xfs_db to set a feature bit,
> you are doing something wrong. xfs_admin and/or mount options give
> you control over all feature bits that are safe for user
> modification...
OK. I'll keep that in mind.

> There's nothing wrong with either of them, likewise there is nothing
> really wrong with your filesystem.
However, it would be nice if xfs_repair would correct secondary 
superblock too.

> > An most important: it's possible in the future to loose some data?
> 
> No.
OK. That's what it really matter.

> So, if you want to make everything absolutely consistent with xfs_db
> (seeing as something is inconsistenti as a result of either the age
> of the filesystems or the poking you've done) then you need to copy
> the sb_features2 field to sb_bad_features2 field in every secondary
> superblock. i.e. something like:
Thanks, but I think I'm going to skip this. In the future maybe I will 
try-it but not for now.


Thank you very much for your help.


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

iEYEARECAAYFAk9VvQ8ACgkQeWrbH+aEIG5+SgCfTGonFTC5exu67m1P6eU2PAPt
0IkAn3YFA3MZWsK8C4DSpFBNqIUxXWrU
=e+du
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
