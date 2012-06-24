Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5OD617o021161 for <xfs@oss.sgi.com>; Sun, 24 Jun 2012 08:06:01 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id EQL9O5YIoahYOFo8
	for <xfs@oss.sgi.com>; Sun, 24 Jun 2012 06:06:00 -0700 (PDT)
Message-ID: <4FE710B7.5010704@hardwarefreak.com>
Date: Sun, 24 Jun 2012 08:05:59 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: mkfs.xfs states log stripe unit is too large
References: <D3F781FA-CEB0-4896-9441-772A9E533354@2012.bluespice.org>
	<20120623234445.GZ19223@dastard> <4FE67970.2030008@sandeen.net>
In-Reply-To: <4FE67970.2030008@sandeen.net>
Reply-To: stan@hardwarefreak.com
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: =?ISO-8859-1?Q?Ingo_J=FCrgensma?=@oss.sgi.com, =?ISO-8859-1?Q?nn?= <ij@2012.bluespice.org>, xfs@oss.sgi.com

On 6/23/2012 9:20 PM, Eric Sandeen wrote:
> On 6/23/12 6:44 PM, Dave Chinner wrote:
>> On Sat, Jun 23, 2012 at 02:50:49PM +0200, Ingo J=FCrgensmann wrote:
>>> muaddib:~# cat /proc/mdstat =

>>> Personalities : [raid1] [raid6] [raid5] [raid4] =

>>> md7 : active raid5 sdf4[3] sdd4[1] sde4[0]
>>>       7811261440 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3=
] [UUU]
                                               ^^^^^^^^^^

The the log stripe unit mismatch error is a direct result of Ingo
manually choosing a rather large chunk size for his two stripe spindle
md array, yielding a 1MB stripe, and using an internal log with it.
Maybe there is a good reason for this, but I'm going to challenge it.

The default md chunk size IIRC is 64KB, 8x smaller than Ingo's chunk.
With the default it would require 16 stripe spindles to reach a 1MB
stripe.  Ingo has TWO stripe spindles.

In the default case with a 1MB stripe and 16 spindles, each aligned
aggregated stripe write out will be 256 XFS blocks, or 16 blocks to each
spindle, 128 sectors (512 byte).  In Ingo's case, it will be 128 XFS
blocks, 1024 sectors.

Does backup PC perform better writing 2048 sectors per stripe write,
1024 per spindle, with two spindles, than 256 sectors per stripe write,
128 per spindle, using two spindles?

>> .....
>>
>>> The RAID devices /dev/md0 to /dev/md4 are on my old 3x 1 TB
>>> Seagate disks. Anyway, to finally come to the problem, when I try
>>> to create a filesystem on the new RAID5 I get the following:  =

>>>
>>> muaddib:~# mkfs.xfs /dev/lv/usr
>>> log stripe unit (524288 bytes) is too large (maximum is 256KiB)
>>> log stripe unit adjusted to 32KiB
> =

> ...
> =

>>
>>> So, the question is: =

>>> - is this a bug somewhere in XFS, LVM or Linux's software RAID
>>> implementation?
>>
>> Not a bug at all.
> =

> Dave, I'd suggest that we should remove the warning though, if XFS picks
> the wrong defaults and then overrides itself.
> =

> Rule of Silence: When a program has nothing surprising to say, it should =
say nothing.

I think this goes to the heart of the matter.  Ingo chose an arbitrarily
large chunk size apparently without understanding the ramifications.
mkfs.xfs was written to read md parameters I believe with the assumption
the parameters were md defaults.  It obviously wasn't written to
gracefully deal with a manually configured arbitrarily large md chunks size.

Maybe a better solution than silence here would be education.  Flag the
mismatch as we do now, and provide a URL to a new FAQ entry that
explains why this occurs, and possible solutions to the problem, the
first recommendation being to choose a sane chunk size.

Question:  does this occur with hardware RAID when entering all the same
parameters manually on the command line?  Or is this error limited to
the md interrogation path?

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
