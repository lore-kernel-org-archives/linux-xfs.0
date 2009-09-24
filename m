Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8NNxSDP045739 for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 18:59:28 -0500
Received: from x.digitalelves.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EED8E4781E5
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 17:00:46 -0700 (PDT)
Received: from x.digitalelves.com (v-209-98-77-55.ip.visi.com [209.98.77.55])
	by cuda.sgi.com with ESMTP id iTmzAugjCIBlgZYD for
	<xfs@oss.sgi.com>; Wed, 23 Sep 2009 17:00:46 -0700 (PDT)
Message-ID: <4ABAB6AD.6080604@thebarn.com>
Date: Wed, 23 Sep 2009 19:00:45 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: problems with xfs_growfs after lvextend
References: <4ABA8D56.2040101@phy.duke.edu> <4ABA9523.60909@thebarn.com>
	<Pine.LNX.4.64.0909231918400.14750@login2.phy.duke.edu>
In-Reply-To: <Pine.LNX.4.64.0909231918400.14750@login2.phy.duke.edu>
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
To: Jimmy Dorff <jdorff@phy.duke.edu>
Cc: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jimmy Dorff wrote:
> On Wed, 23 Sep 2009, Russell Cattelan wrote:
>> The good new is you can easily restore the the values of the
>> primary super block from one of the other superblocks using the
>> xfs_db cmd.
>>
>> The bad news is that if you have run repair you may have messed
>> things up.
>>
>> basically pull up xfs_db
>>> sb 0 p
>> ... output ..
>>> sb 1 p
>> ... output ...
>>
>> Send us the result of that and we can figure out which values
>> need to be restored.
>
> Here you go. Thanks for your help!
Ok good things look ok.
run xfs_db -x to put it into expert mode
use the write cmd to modify your sb 0 values back to what they were.

> sb 0 w dblocks = 1610612736 w agcount = 32

That should get the file system back into a state xfs_repair can
understand.
I would run xfs_repair -n and see what is says about things.
The old last AG might have been resized out to a full AG if it was a
partial AG previously
xfs_epair should be able to fix that up, but again run it with -n
first to see what is will do.

Once things are back to normal update your xfs kernel module and
re-run the grow cmd
and you should be in good shape.

- -Russell

>
> xfs_db> sb 0 xfs_db> p magicnum = 0x58465342 blocksize = 4096
> dblocks = 8053063680 rblocks = 0 rextents = 0 uuid =
> bada0c85-0739-4fdb-99fb-6bb7777eb4d0 logstart = 1073741828 rootino
> = 128 rbmino = 129 rsumino = 130 rextsize = 1 agblocks = 50331648
> agcount = 160 rbmblocks = 0 logblocks = 32768 versionnum = 0x3084
> sectsize = 512 inodesize = 256 inopblock = 16 fname =
> "DATA\000\000\000\000\000\000\000\000" blocklog = 12 sectlog = 9
> inodelog = 8 inopblog = 4 agblklog = 26 rextslog = 0 inprogress = 0
>  imax_pct = 25 icount = 103936 ifree = 269 fdblocks = 6499724269
> frextents = 0 uquotino = 0 gquotino = 0 qflags = 0 flags = 0
> shared_vn = 0 inoalignmt = 2 unit = 0 width = 0 dirblklog = 0
> logsectlog = 0 logsectsize = 0 logsunit = 0 features2 = 0
> bad_features2 = 0 xfs_db> sb 1 xfs_db> p magicnum = 0x58465342
> blocksize = 4096 dblocks = 1610612736 rblocks = 0 rextents = 0 uuid
> = bada0c85-0739-4fdb-99fb-6bb7777eb4d0 logstart = 1073741828
> rootino = 128 rbmino = 129 rsumino = 130 rextsize = 1 agblocks =
> 50331648 agcount = 32 rbmblocks = 0 logblocks = 32768 versionnum =
> 0x3084 sectsize = 512 inodesize = 256 inopblock = 16 fname =
> "DATA\000\000\000\000\000\000\000\000" blocklog = 12 sectlog = 9
> inodelog = 8 inopblog = 4 agblklog = 26 rextslog = 0 inprogress = 0
>  imax_pct = 25 icount = 103936 ifree = 269 fdblocks = 57273829
> frextents = 0 uquotino = 0 gquotino = 0 qflags = 0 flags = 0
> shared_vn = 0 inoalignmt = 2 unit = 0 width = 0 dirblklog = 0
> logsectlog = 0 logsectsize = 0 logsunit = 0 features2 = 0
> bad_features2 = 0

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFKurasNRmM+OaGhBgRAt4YAJ9aHdZF3iX5hjcrcm6FqS/avk+bBQCfft0U
HTAySeS7kYxNvmnwsmalgKw=
=f80e
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
