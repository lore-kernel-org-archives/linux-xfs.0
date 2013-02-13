Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B28237FC5
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 11:38:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 90F8B8F8059
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 09:38:57 -0800 (PST)
Received: from srvmail.3sr-grenoble.fr (3sr-srvmail.ampere.inpg.fr
	[147.171.64.82]) by cuda.sgi.com with ESMTP id 2UOPgyF59eTExGyq
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 09:38:56 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by srvmail.3sr-grenoble.fr (Postfix) with SMTP id 434E028A0A9
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 18:38:55 +0100 (CET)
Received: from [147.171.84.252] (hamaika.3sr.grenoble-inp.fr [147.171.84.252])
	by srvmail.3sr-grenoble.fr (Postfix) with ESMTPSA id 286A828A0A3
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 18:38:55 +0100 (CET)
Resent-To: xfs@oss.sgi.com
Resent-Message-Id: <511BCFAF.403@3sr-grenoble.fr>
Message-ID: <511BCD11.20907@3sr-grenoble.fr>
Date: Wed, 13 Feb 2013 18:27:45 +0100
From: =?ISO-8859-1?Q?R=E9mi_Cailletaud?= <remi.cailletaud@3sr-grenoble.fr>
MIME-Version: 1.0
Subject: Re: problem after growing
References: <511BC78B.6070205@3sr-grenoble.fr> <511BCB41.4060804@sandeen.net>
In-Reply-To: <511BCB41.4060804@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>

Le 13/02/2013 18:20, Eric Sandeen a =E9crit :
> On 2/13/13 11:04 AM, R=E9mi Cailletaud wrote:
>> Hi,
>>
>> I face a strange and scary issue. I just grow a xfs filesystem (44To), a=
nd no way to mount it anymore :
>> XFS: device supports only 4096 byte sectors (not 512)
> Did you expand an LV made of 512-sector physical devices by adding 4k-sec=
tor physical devices?

The three devices are ARECA 1880 card, but the last one was added later, =

and I never check for sector physical configuration on card configuration.
But yes, running fdisk, it seems that sda and sdb are 512, and sdc is =

4k... :(

> that's probably not something we anticipate or check for....
>
> What sector size(s) are the actual lowest level disks under all the lvm p=
ieces?

What command to run to get this info ?

r=E9mi


>
> -Eric
>
>> # xfs_check /dev/vg0/tomo-201111
>> ERROR: The filesystem has valuable metadata changes in a log which needs=
 to
>> be replayed.  Mount the filesystem to replay the log, and unmount it bef=
ore
>> re-running xfs_check.  If you are unable to mount the filesystem, then u=
se
>> the xfs_repair -L option to destroy the log and attempt a repair.
>> Note that destroying the log may cause corruption -- please attempt a mo=
unt
>> of the filesystem before doing this.
>>
>> # xfs_repair -L /dev/vg0/tomo-201111
>> xfs_repair: warning - cannot set blocksize 512 on block device /dev/vg0/=
tomo-201111: Argument invalide
>> Phase 1 - find and verify superblock...
>> superblock read failed, offset 1099511623680, size 2048, ag 1, rval -1
>>
>> fatal error -- Invalid argument
>>
>> Conf is as follow :
>>
>> LVM : 3pv - 1vg
>>
>> the lv containing the xfs system is on several extents :
>>
>>    tomo-201111 vg0  -wi-ao    1 linear  15,34t /dev/sda:5276160-9298322
>>    tomo-201111 vg0  -wi-ao    1 linear  18,66t /dev/sdb:0-4890732
>>    tomo-201111 vg0  -wi-ao    1 linear   8,81t /dev/sdb:6987885-9298322
>>    tomo-201111 vg0  -wi-ao    1 linear   1,19t /dev/sdc:2883584-3194585
>>
>> before growing fs, I lvextend the vg, and a new extents on /dev/sdc was =
used. I cant think it caused this issue... I saw there can be problem with =
underlying device (an ARECA 1880). With xfs_db, I found this strange :
>>   "logsectsize =3D 0"
>>
>> # xfs_db -c "sb 0" -c "p" /dev/vg0/tomo-201111
>> magicnum =3D 0x58465342
>> blocksize =3D 4096
>> dblocks =3D 10468982745
>> rblocks =3D 0
>> rextents =3D 0
>> uuid =3D 09793bea-952b-44fa-be71-02f59e69b41b
>> logstart =3D 1342177284
>> rootino =3D 128
>> rbmino =3D 129
>> rsumino =3D 130
>> rextsize =3D 1
>> agblocks =3D 268435455
>> agcount =3D 39
>> rbmblocks =3D 0
>> logblocks =3D 521728
>> versionnum =3D 0xb4b4
>> sectsize =3D 512
>> inodesize =3D 256
>> inopblock =3D 16
>> fname =3D "\000\000\000\000\000\000\000\000\000\000\000\000"
>> blocklog =3D 12
>> sectlog =3D 9
>> inodelog =3D 8
>> inopblog =3D 4
>> agblklog =3D 28
>> rextslog =3D 0
>> inprogress =3D 0
>> imax_pct =3D 5
>> icount =3D 6233280
>> ifree =3D 26
>> fdblocks =3D 1218766953
>> frextents =3D 0
>> uquotino =3D 0
>> gquotino =3D 0
>> qflags =3D 0
>> flags =3D 0
>> shared_vn =3D 0
>> inoalignmt =3D 2
>> unit =3D 0
>> width =3D 0
>> dirblklog =3D 0
>> logsectlog =3D 0
>> logsectsize =3D 0
>> logsunit =3D 1
>> features2 =3D 0xa
>> bad_features2 =3D 0xa
>>
>>
>> Any idea ?
>>
>> Cheers,
>> r=E9mi
>>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>


-- =

R=E9mi Cailletaud - IE CNRS
3SR - Laboratoire Sols, Solides, Structures - Risques
BP53, 38041 Grenoble CEDEX 0
FRANCE
remi.cailletaud@3sr-grenoble.fr
T=E9l: +33 (0)4 76 82 52 78
Fax: +33 (0)4 76 82 70 43



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
