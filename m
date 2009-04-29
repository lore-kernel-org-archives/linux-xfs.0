Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3THxAkL172833 for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 12:59:13 -0500
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66901145CF5E
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 11:02:34 -0700 (PDT)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com
	[208.42.117.202]) by cuda.sgi.com with ESMTP id
	ot2Si9kAREGpkJBy for <xfs@oss.sgi.com>;
	Wed, 29 Apr 2009 11:02:34 -0700 (PDT)
Message-ID: <49F89549.8090505@thebarn.com>
Date: Wed, 29 Apr 2009 12:58:33 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: crashes with xfs_fsr in 2.6.25-2-amd64 and 2.6.26-1-amd64 (debian)
	(f'up)
References: <20090428032406.GA14234@schmorp.de>
	<49F88E73.7060403@houseofnate.net>
In-Reply-To: <49F88E73.7060403@houseofnate.net>
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
To: "Nathaniel W. Turner" <nate@houseofnate.net>, xfs-oss <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Nathaniel W. Turner wrote:
> Hi Marc,
>
> Marc Lehmann wrote:
>> It also happens to the same filesystem each time (maybe because
>> it does the heavy I/O),a and it is also the same filesystem where
>> xfs_repair hangs in an endless loop often (but not always). (see
>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=525880)
>>
>> The filesystem was created a month or so ago using blocksize of 512
>> and
>> lazy-count=1, but I have many of those xfs filesystems.
>>
>> Since this is a production system and I have no backup abilities, I
>> have
>> to no choice but to reformat the disk now.
>>  
> I'm not sure about the root cause of your crash,
The crash is probably due to a bad inode, the file system needs to be
repaired.
> but I just wanted to mention that before you blow away this
> filesystem, you should probably try repairing it with a recent
> version of xfs_repair (like 3.0.0).
> ftp://oss.sgi.com/projects/xfs/cmd_tars/
That is a good suggestion, 2.9.8 is quite old at this point.
xfs_check might also be useful as it might point to the problem inode.
>
> Also, I have seen similar problems to those described in Debian bug
> 525880 with xfs_repair not making progress (although I'm running
> 32-bit), and adding "-P" to the xfs_repair invocation helped in many
> cases.
>
> Cheers,
> nate
>

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJ+JVJNRmM+OaGhBgRAilEAJ9jBvIqlvMtlog0Oyeeb0BPbaMrowCfXmTE
2Pk4UxofSyr1zq6Dfuq8aDk=
=L9qB
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
