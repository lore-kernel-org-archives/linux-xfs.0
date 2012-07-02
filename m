Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q623iiab155387 for <xfs@oss.sgi.com>; Sun, 1 Jul 2012 22:44:45 -0500
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id kfrHbb6hMOAr1whJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 01 Jul 2012 20:44:43 -0700 (PDT)
Message-ID: <4FF11925.10301@tlinx.org>
Date: Sun, 01 Jul 2012 20:44:37 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: Strange case of deleting lots of files and "df" not recognizing
	it....(unless I umount/mount) the disk...
References: <4FE7FDF4.6080506@tlinx.org> <20120626023302.GD19223@dastard>
	<20120626093323.3cb0cc18@galadriel.home>
	<20120702033014.GP19223@dastard>
In-Reply-To: <20120702033014.GP19223@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Well, in my case, may be a while, it is usually every few months when I
clear out about 30% of a large (~11T) volume on my backup disk...

It only grows slowly as I make backups on it...then I delete maybe ...
60-100 files worth of backups (xfsdumps)....but for me dropping
the cache did work so it may not be the same problem.



Dave Chinner wrote:
> On Tue, Jun 26, 2012 at 09:33:23AM +0200, Emmanuel Florac wrote:
>> Le Tue, 26 Jun 2012 12:33:02 +1000 vous =E9criviez:
>>
>>> As ben said, the last reference has to go away before the space is
>>> freed. lsof is your friend.
>> I just had the same problem recently, but lsof reported zero open files
>> on the volume. umount/mount worked though, I didn't thought the cache
>> trick would be enough.
> =

> I think that we need a reproducable test case for this issue before
> we'll be able to make any progress on it, then....
> =

> Cheers,
> =

> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
