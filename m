Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4A14A7F53
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 11:44:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B2965AC008
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 09:44:29 -0800 (PST)
Received: from srvmail.3sr-grenoble.fr (3sr-srvmail.ampere.inpg.fr
	[147.171.64.82]) by cuda.sgi.com with ESMTP id nTbjHhPoxg3AcjoS
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 09:44:28 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by srvmail.3sr-grenoble.fr (Postfix) with SMTP id B823B28A0A9
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 18:44:27 +0100 (CET)
Message-ID: <511BD0FB.2070401@3sr-grenoble.fr>
Date: Wed, 13 Feb 2013 18:44:27 +0100
From: =?ISO-8859-1?Q?R=E9mi_Cailletaud?= <remi.cailletaud@3sr-grenoble.fr>
MIME-Version: 1.0
Subject: Re: problem after growing
References: <511BC78B.6070205@3sr-grenoble.fr> <511BCB41.4060804@sandeen.net>
	<511BCD11.20907@3sr-grenoble.fr> <511BCFB6.8000309@sandeen.net>
In-Reply-To: <511BCFB6.8000309@sandeen.net>
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
Cc: xfs-oss <xfs@oss.sgi.com>

Le 13/02/2013 18:39, Eric Sandeen a =E9crit :
> On 2/13/13 11:27 AM, R=E9mi Cailletaud wrote:
>> Le 13/02/2013 18:20, Eric Sandeen a =E9crit :
>>> On 2/13/13 11:04 AM, R=E9mi Cailletaud wrote:
>>>> Hi,
>>>>
>>>> I face a strange and scary issue. I just grow a xfs filesystem (44To),=
 and no way to mount it anymore :
>>>> XFS: device supports only 4096 byte sectors (not 512)
>>> Did you expand an LV made of 512-sector physical devices by adding 4k-s=
ector physical devices?
>> The three devices are ARECA 1880 card, but the last one was added later,=
 and I never check for sector physical configuration on card configuration.
>> But yes, running fdisk, it seems that sda and sdb are 512, and sdc is 4k=
... :(
>>
>>> that's probably not something we anticipate or check for....
>>>
>>> What sector size(s) are the actual lowest level disks under all the lvm=
 pieces?
> (re-cc'ing xfs list)
>
>> What command to run to get this info ?
> IIRC,
>
> # blockdev --getpbsz --getss  /dev/sda
>
> to print the physical&  logical sector size
>
> You can also look at i.e.:
> /sys/block/sda/queue/hw_sector_size
> /sys/block/sda/queue/physical_block_size
> /sys/block/sda/queue/logical_block_size
ouch... nice guess :
#  blockdev --getpbsz --getss  /dev/sda
512
512
#  blockdev --getpbsz --getss  /dev/sdb
512
512
#  blockdev --getpbsz --getss  /dev/sdc
4096
4096


> I wonder what the recovery steps would be here.  I wouldn't do anything y=
et; I wish you hadn't already cleared the log, but oh well.

I tried a xfs_repair -L (as mentionned by xfs_check), but it early =

failed as show on my first post...
> So you grew it, that all worked ok, you were able to copy new data into t=
he new space, you unmounted it, but now it won't mount, correct?
I never was able to copy data to new space. I had an input/output error =

just after growing.
may pmove-ing extents on 4k device on a 512k device be a solution ?

r=E9mi

> -Eric
>
>
>
>> r=E9mi
>>
>>
>>> -Eric
>>>
>>>> # xfs_check /dev/vg0/tomo-201111
>>>> ERROR: The filesystem has valuable metadata changes in a log which nee=
ds to
>>>> be replayed.  Mount the filesystem to replay the log, and unmount it b=
efore
>>>> re-running xfs_check.  If you are unable to mount the filesystem, then=
 use
>>>> the xfs_repair -L option to destroy the log and attempt a repair.
>>>> Note that destroying the log may cause corruption -- please attempt a =
mount
>>>> of the filesystem before doing this.
>>>>
>>>> # xfs_repair -L /dev/vg0/tomo-201111
>>>> xfs_repair: warning - cannot set blocksize 512 on block device /dev/vg=
0/tomo-201111: Argument invalide
>>>> Phase 1 - find and verify superblock...
>>>> superblock read failed, offset 1099511623680, size 2048, ag 1, rval -1
>>>>
>>>> fatal error -- Invalid argument
>>>>
>>>> Conf is as follow :
>>>>
>>>> LVM : 3pv - 1vg
>>>>
>>>> the lv containing the xfs system is on several extents :
>>>>
>>>>     tomo-201111 vg0  -wi-ao    1 linear  15,34t /dev/sda:5276160-92983=
22
>>>>     tomo-201111 vg0  -wi-ao    1 linear  18,66t /dev/sdb:0-4890732
>>>>     tomo-201111 vg0  -wi-ao    1 linear   8,81t /dev/sdb:6987885-92983=
22
>>>>     tomo-201111 vg0  -wi-ao    1 linear   1,19t /dev/sdc:2883584-31945=
85
>>>>
>>>> before growing fs, I lvextend the vg, and a new extents on /dev/sdc wa=
s used. I cant think it caused this issue... I saw there can be problem wit=
h underlying device (an ARECA 1880). With xfs_db, I found this strange :
>>>>    "logsectsize =3D 0"
>>>>
>>>> # xfs_db -c "sb 0" -c "p" /dev/vg0/tomo-201111
>>>> magicnum =3D 0x58465342
>>>> blocksize =3D 4096
>>>> dblocks =3D 10468982745
>>>> rblocks =3D 0
>>>> rextents =3D 0
>>>> uuid =3D 09793bea-952b-44fa-be71-02f59e69b41b
>>>> logstart =3D 1342177284
>>>> rootino =3D 128
>>>> rbmino =3D 129
>>>> rsumino =3D 130
>>>> rextsize =3D 1
>>>> agblocks =3D 268435455
>>>> agcount =3D 39
>>>> rbmblocks =3D 0
>>>> logblocks =3D 521728
>>>> versionnum =3D 0xb4b4
>>>> sectsize =3D 512
>>>> inodesize =3D 256
>>>> inopblock =3D 16
>>>> fname =3D "\000\000\000\000\000\000\000\000\000\000\000\000"
>>>> blocklog =3D 12
>>>> sectlog =3D 9
>>>> inodelog =3D 8
>>>> inopblog =3D 4
>>>> agblklog =3D 28
>>>> rextslog =3D 0
>>>> inprogress =3D 0
>>>> imax_pct =3D 5
>>>> icount =3D 6233280
>>>> ifree =3D 26
>>>> fdblocks =3D 1218766953
>>>> frextents =3D 0
>>>> uquotino =3D 0
>>>> gquotino =3D 0
>>>> qflags =3D 0
>>>> flags =3D 0
>>>> shared_vn =3D 0
>>>> inoalignmt =3D 2
>>>> unit =3D 0
>>>> width =3D 0
>>>> dirblklog =3D 0
>>>> logsectlog =3D 0
>>>> logsectsize =3D 0
>>>> logsunit =3D 1
>>>> features2 =3D 0xa
>>>> bad_features2 =3D 0xa
>>>>
>>>>
>>>> Any idea ?
>>>>
>>>> Cheers,
>>>> r=E9mi
>>>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>
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
