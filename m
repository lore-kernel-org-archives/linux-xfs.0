Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3EHOFA4008368 for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 12:24:15 -0500
Received: from mx.meyering.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id DADC81BDAD1C
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 10:27:34 -0700 (PDT)
Received: from mx.meyering.net (mx.meyering.net [82.230.74.64]) by
	cuda.sgi.com with SMTP id Z5eq7H1vXohrIfJz for
	<xfs@oss.sgi.com>; Thu, 14 Apr 2011 10:27:34 -0700 (PDT)
From: Jim Meyering <jim@meyering.net>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
In-Reply-To: <4DA7182B.8050409@draigBrady.com> (=?iso-8859-1?Q?=22P=E1drai?=
	=?iso-8859-1?Q?g?= Brady"'s message of
	"Thu, 14 Apr 2011 16:52:11 +0100")
References: <20110414102608.GA1678@x4.trippels.de>
	<20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net>
	<4DA7182B.8050409@draigBrady.com>
Date: Thu, 14 Apr 2011 19:27:31 +0200
Message-ID: <878vvcspz0.fsf@rho.meyering.net>
MIME-Version: 1.0
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
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, coreutils@gnu.org, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs-oss <xfs@oss.sgi.com>

P=E1draig Brady wrote:

> On 14/04/11 16:50, Eric Sandeen wrote:
>> On 4/14/11 9:59 AM, P=E1draig Brady wrote:
>>> On 14/04/11 15:02, Markus Trippelsdorf wrote:
>>>>>> Hi P=E1draig,
>>>>>>
>>>>>> here you go:
>>>>>> + filefrag -v unwritten.withdata
>>>>>> Filesystem type is: ef53
>>>>>> File size of unwritten.withdata is 5120 (2 blocks, blocksize 4096)
>>>>>>  ext logical physical expected length flags
>>>>>>    0       0   274432            2560 unwritten,eof
>>>>>> unwritten.withdata: 1 extent found
>>>>>>
>>>>>> Please notice that this also happens with ext4 on the same kernel.
>>>>>> Btrfs is fine.
>>>>>
>>>> `filefrag -vs` fixes the issue on both xfs and ext4.
>>>
>>> So in summary, currently on (2.6.39-rc3), the following
>>> will (usually?) report a single unwritten extent,
>>> on both ext4 and xfs
>>>
>>>   fallocate -l 10MiB -n k
>>>   dd count=3D10 if=3D/dev/urandom conv=3Dnotrunc iflag=3Dfullblock of=
=3Dk
>>>   filefrag -v k # grep for an extent without unwritten || fail
>>
>> right, that's what I see too in testing.
>>
>> But would the coreutils install have done a preallocation of the
>> destination file?
>>
>> Otherwise this looks like a different bug...
>>
>>> This particular issue has been discussed so far at:
>>> http://debbugs.gnu.org/cgi/bugreport.cgi?bug=3D8411
>>> Note there it was stated there that ext4 had this
>>> fixed as of 2.6.39-rc1, so maybe there is something lurking?
>>
>> ext4 got a fix, but not xfs, I guess.  My poor brain can't remember,
>> I think I started looking into it, but it's clearly still broken.
>>
>> Still, I don't know for sure what happened to Markus - did something
>> preallocate, in his case?
>
> Well that preallocate test is failing for him
> when the source file is either on ext4 or xfs.
> He noticed the issue initially on XFS when copying
> none preallocated files, so XFS probably just has
> the general issue of needing a sync before fiemap,
> where as EXT4 just has this preallocate one
> (though I've not seen it myself).

FYI, I see the same failure now using ext3 (and but not w/ext4)
with rawhide's 2.6.39-0.rc2.git0.0.fc16.x86_64:

  + df -t ext3 .
  + require_root_
  + uid_is_privileged_
  ++ id -u
  + my_uid=3D0
  + case $my_uid in
  + NON_ROOT_USERNAME=3Dnobody
  ++ id -g nobody
  + NON_ROOT_GROUP=3D99
  + cwd=3D/t/m/ext3/tmp/coreutils-8.11.1-5995ed-dirty/tests/gt-sparse-fiema=
p.Qhjo
  + skip=3D0
  + dd if=3D/dev/zero of=3Dblob bs=3D32k count=3D1000
  1000+0 records in
  1000+0 records out
  32768000 bytes (33 MB) copied, 1.02932 s, 31.8 MB/s
  + mkdir mnt
  + mkfs -t ext4 -F blob
  mke2fs 1.41.14 (22-Dec-2010)
  Filesystem label=3D
  OS type: Linux
  Block size=3D1024 (log=3D0)
  Fragment size=3D1024 (log=3D0)
  Stride=3D0 blocks, Stripe width=3D0 blocks
  8000 inodes, 32000 blocks
  1600 blocks (5.00%) reserved for the super user
  First data block=3D1
  Maximum filesystem blocks=3D32768000
  4 block groups
  8192 blocks per group, 8192 fragments per group
  2000 inodes per group
  Superblock backups stored on blocks:
          8193, 24577

  Writing inode tables: done
  Creating journal (1024 blocks): done
  Writing superblocks and filesystem accounting information: done

  This filesystem will be automatically checked every 21 mounts or
  180 days, whichever comes first.  Use tune2fs -c or -i to override.
  + mount -oloop blob mnt
  + cd mnt
  + echo test
  + test -s f
  + test 0 =3D 1
  ++ seq 1 2 21
  + for i in '$(seq 1 2 21)'
  + for j in 1 2 31 100
  + perl -e 'BEGIN { $n =3D 1 * 1024; *F =3D *STDOUT }' -e 'for (1..1) { sy=
sseek (*F, $n, 1)' -e '&& syswrite (*F, chr($_)x$n) or die "$!"}'
  + cp --sparse=3Dalways j1 j2
  + cmp j1 j2
  + filefrag -vs j1
  + grep -F extent
  + filefrag -v j1
  + filefrag -vs j2
  + f ff1
  + perl /t/m/ext3/tmp/coreutils-8.11.1-5995ed-dirty/tests/filefrag-extent-=
compare
  + sed 's/ [a-z,][a-z,]*$//' ff1
  + awk '/^ *[0-9]/ {printf "%d %d ", $2 ,NF < 5 ? $NF : $5 } END {print ""=
}'
  + f ff2
  + sed 's/ [a-z,][a-z,]*$//' ff2
  + awk '/^ *[0-9]/ {printf "%d %d ", $2 ,NF < 5 ? $NF : $5 } END {print ""=
}'
  + test 0 =3D 1
  + for j in 1 2 31 100
  + perl -e 'BEGIN { $n =3D 1 * 1024; *F =3D *STDOUT }' -e 'for (1..2) { sy=
sseek (*F, $n, 1)' -e '&& syswrite (*F, chr($_)x$n) or die "$!"}'
  + cp --sparse=3Dalways j1 j2
  + cmp j1 j2
  j1 j2 differ: char 1, line 1     <<<<=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
  + fail=3D1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
