Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5ODI4kt023033 for <xfs@oss.sgi.com>; Sun, 24 Jun 2012 08:18:05 -0500
Received: from vserv.windfluechter.net (vserv.windfluechter.net
	[178.63.83.104]) by cuda.sgi.com with ESMTP id qXHNEi0JT33FbMqO
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 24 Jun 2012 06:18:02 -0700 (PDT)
Subject: Re: mkfs.xfs states log stripe unit is too large
Mime-Version: 1.0 (Apple Message framework v1084)
From: =?iso-8859-1?Q?Ingo_J=FCrgensmann?= <ij@2012.bluespice.org>
In-Reply-To: <4FE710B7.5010704@hardwarefreak.com>
Date: Sun, 24 Jun 2012 15:17:59 +0200
Message-Id: <4954261F-D4FB-4589-BE18-2BFCEC05E9B4@2012.bluespice.org>
References: <D3F781FA-CEB0-4896-9441-772A9E533354@2012.bluespice.org>
	<20120623234445.GZ19223@dastard> <4FE67970.2030008@sandeen.net>
	<4FE710B7.5010704@hardwarefreak.com>
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
To: xfs@oss.sgi.com
Cc: stan@hardwarefreak.com

Am 24.06.2012 um 15:05 schrieb Stan Hoeppner:

> On 6/23/2012 9:20 PM, Eric Sandeen wrote:
>> On 6/23/12 6:44 PM, Dave Chinner wrote:
>>> On Sat, Jun 23, 2012 at 02:50:49PM +0200, Ingo J=FCrgensmann wrote:
>>>> muaddib:~# cat /proc/mdstat =

>>>> Personalities : [raid1] [raid6] [raid5] [raid4] =

>>>> md7 : active raid5 sdf4[3] sdd4[1] sde4[0]
>>>>      7811261440 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3=
] [UUU]
>                                               ^^^^^^^^^^
> =

> The the log stripe unit mismatch error is a direct result of Ingo
> manually choosing a rather large chunk size for his two stripe spindle
> md array, yielding a 1MB stripe, and using an internal log with it.
> Maybe there is a good reason for this, but I'm going to challenge it.

Correction: I did not manually choose that chunk size, but it was automatic=
ally chosen by mdadm when creating the RAID5. =


> The default md chunk size IIRC is 64KB, 8x smaller than Ingo's chunk.

64k is the default for creating RAIDs with 0.90 format superblock. My RAID5=
 has a 1.2 format superblock. =


> Does backup PC perform better writing 2048 sectors per stripe write,
> 1024 per spindle, with two spindles, than 256 sectors per stripe write,
> 128 per spindle, using two spindles?

Don't know how BackupPC actually writes the data, but it does make extensiv=
e use of hardlinks to save some diskspace. Some sort of deduplicating, if y=
ou like to say it that way. =


>> Rule of Silence: When a program has nothing surprising to say, it should=
 say nothing.
> I think this goes to the heart of the matter.  Ingo chose an arbitrarily
> large chunk size apparently without understanding the ramifications.

That's wrong! I've just worked with the defaults.  =


-- =

Ciao...            //      Fon: 0381-2744150
      Ingo       \X/       http://blog.windfluechter.net


gpg pubkey:  http://www.juergensmann.de/ij_public_key.asc

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
