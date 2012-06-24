Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5O2KXAv172792 for <xfs@oss.sgi.com>; Sat, 23 Jun 2012 21:20:34 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 8Av9uFn9JSIaRVY0 for <xfs@oss.sgi.com>;
	Sat, 23 Jun 2012 19:20:32 -0700 (PDT)
Message-ID: <4FE67970.2030008@sandeen.net>
Date: Sat, 23 Jun 2012 21:20:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mkfs.xfs states log stripe unit is too large
References: <D3F781FA-CEB0-4896-9441-772A9E533354@2012.bluespice.org>
	<20120623234445.GZ19223@dastard>
In-Reply-To: <20120623234445.GZ19223@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: =?ISO-8859-1?Q?Ingo_J=FCrgensmann?= <ij@2012.bluespice.org>, xfs@oss.sgi.com

On 6/23/12 6:44 PM, Dave Chinner wrote:
> On Sat, Jun 23, 2012 at 02:50:49PM +0200, Ingo J=FCrgensmann wrote:
>> muaddib:~# cat /proc/mdstat =

>> Personalities : [raid1] [raid6] [raid5] [raid4] =

>> md7 : active raid5 sdf4[3] sdd4[1] sde4[0]
>>       7811261440 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3]=
 [UUU]
> .....
> =

>> The RAID devices /dev/md0 to /dev/md4 are on my old 3x 1 TB
>> Seagate disks. Anyway, to finally come to the problem, when I try
>> to create a filesystem on the new RAID5 I get the following:  =

>>
>> muaddib:~# mkfs.xfs /dev/lv/usr
>> log stripe unit (524288 bytes) is too large (maximum is 256KiB)
>> log stripe unit adjusted to 32KiB

...

> =

>> So, the question is: =

>> - is this a bug somewhere in XFS, LVM or Linux's software RAID
>> implementation?
> =

> Not a bug at all.

Dave, I'd suggest that we should remove the warning though, if XFS picks
the wrong defaults and then overrides itself.

Rule of Silence: When a program has nothing surprising to say, it should sa=
y nothing.

;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
