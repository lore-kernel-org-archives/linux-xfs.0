Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DBFE17F61
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 10:58:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 55ED6AC003
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 08:58:46 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id RaMAjNA2prdZIBoo for <xfs@oss.sgi.com>;
	Thu, 11 Jun 2015 08:58:43 -0700 (PDT)
Message-ID: <5579B034.4070503@sandeen.net>
Date: Thu, 11 Jun 2015 10:58:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: PROBLEM: XFS on ARM corruption 'Structure needs cleaning'
References: <5579296A.8010208@skylable.com>	<20150611151620.GB59168@bfoster.bfoster>	<5579A904.3020204@skylable.com>
	<5579AE85.5080203@sandeen.net>
In-Reply-To: <5579AE85.5080203@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?windows-1252?Q?T=F6r=F6k_Edwin?= <edwin@skylable.com>, Brian Foster <bfoster@redhat.com>
Cc: Christopher Squires <christopher.squires@hgst.com>, Wayne Burri <wayne.burri@hgst.com>, Luca Gibelli <luca@skylable.com>, xfs@oss.sgi.com

On 6/11/15 10:51 AM, Eric Sandeen wrote:
> On 6/11/15 10:28 AM, T=F6r=F6k Edwin wrote:
>> On 06/11/2015 06:16 PM, Brian Foster wrote:
>>> On Thu, Jun 11, 2015 at 09:23:38AM +0300, T=F6r=F6k Edwin wrote:
>>>> [1.] XFS on ARM corruption 'Structure needs cleaning'
>>>> [2.] Full description of the problem/report:
>>>>
>>>> I have been running XFS sucessfully on x86-64 for years, however I'm h=
aving trouble running it on ARM.
>>>>
>>>> Running the testcase below [7.] reliably reproduces the filesystem cor=
ruption starting from a freshly
>>>> created XFS filesystem: running ls after 'sxadm node --new --batch /ex=
port/dfs/a/b' shows a 'Structure needs cleaning' error,
>>>> and dmesg shows a corruption error [6.].
>>>> xfs_repair 3.1.9 is not able to repair the corruption: after mounting =
the repair filesystem
>>>> I still get the 'Structure needs cleaning' error.
>>>>
>>>> Note: using /export/dfs/a/b is important for reproducing the problem: =
if I only use one level of directories in /export/dfs then the problem
>>>> doesn't reproduce. Also if I use a tuned version of sxadm that creates=
 fewer database files then the problem doesn't reproduce either.
>>>>
>>>> [3.] Keywords: filesystems, XFS corruption, ARM
>>>> [4.] Kernel information
>>>> [4.1.] Kernel version (from /proc/version):
>>>> Linux hornet34 3.14.3-00088-g7651c68 #24 Thu Apr 9 16:13:46 MDT 2015 a=
rmv7l GNU/Linux
>>>>
>>> ...
>>>> [5.] Most recent kernel version which did not have the bug: Unknown, f=
irst kernel I try on ARM
>>>>
>>>> [6.] dmesg stacktrace
>>>>
>>>> [4627578.440000] XFS (sda4): Mounting Filesystem
>>>> [4627578.510000] XFS (sda4): Ending clean mount
>>>> [4627621.470000] dd6ee000: 58 46 53 42 00 00 10 00 00 00 00 00 37 40 2=
1 00  XFSB........7@!.
>>>> [4627621.480000] dd6ee010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00  ................
>>>> [4627621.490000] dd6ee020: 5b 08 7f 79 0e 3a 46 3d 9b ea 26 ad 9d 62 1=
7 8d  [..y.:F=3D..&..b..
>>>> [4627621.490000] dd6ee030: 00 00 00 00 20 00 00 04 00 00 00 00 00 00 0=
0 80  .... ...........
>>>
>>> Just a data point... the magic number here looks like a superblock magic
>>> (XFSB) rather than one of the directory magic numbers. I'm wondering if
>>> a buffer disk address has gone bad somehow or another.
>>>
>>> Does this happen to be a large block device? I don't see any partition
>>> or xfs_info data below. If so, it would be interesting to see if this
>>> reproduces on a smaller device. It does appear that the large block
>>> device option is enabled in the kernel config above, however, so maybe
>>> that's unrelated.
>>
>> This is mkfs.xfs /dev/sda4:
>> meta-data=3D/dev/sda4              isize=3D256    agcount=3D4, agsize=3D=
231737408 blks
>>          =3D                       sectsz=3D512   attr=3D2, projid32bit=
=3D0
>> data     =3D                       bsize=3D4096   blocks=3D926949632, im=
axpct=3D5
>>          =3D                       sunit=3D0      swidth=3D0 blks
>> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
>> log      =3Dinternal log           bsize=3D4096   blocks=3D452612, versi=
on=3D2
>>          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-c=
ount=3D1
>> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
>>
>> But it also reproduces with this small loopback file:
>> meta-data=3D/tmp/xfs.test          isize=3D256    agcount=3D2, agsize=3D=
5120 blks
>>          =3D                       sectsz=3D512   attr=3D2, projid32bit=
=3D0
>> data     =3D                       bsize=3D4096   blocks=3D10240, imaxpc=
t=3D25
>>          =3D                       sunit=3D0      swidth=3D0 blks
>> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
>> log      =3Dinternal log           bsize=3D4096   blocks=3D1200, version=
=3D2
>>          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-c=
ount=3D1
>> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
> =

> ok so not a block number overflow issue, thanks.
> =

>> You can have a look at xfs.test here: http://vol-public.s3.indian.skylab=
le.com:8008/armel/testcase/xfs.test.gz
>>
>> If I loopback mount that on an x86-64 box it doesn't show the corruption=
 message though ...
> =

> FWIW, this is the 2nd report we've had of something similar, both on Armv=
7, both ok on x86_64.
> =

> I'll take a look at your xfs.test; that's presumably copied after it repo=
rted the error, and you unmounted it before uploading, correct?  And it was=
 mkfs'd on armv7, never mounted or manipulated in any way on x86_64?

Oh, and what were the kernel messages when you produced the corruption with=
 xfs.txt?

thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
