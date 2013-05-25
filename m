Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C2C727F37
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 16:07:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9CFCF8F8033
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 14:07:28 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id jsHHRqixGHn23ub6 for <xfs@oss.sgi.com>;
	Sat, 25 May 2013 14:07:27 -0700 (PDT)
Message-ID: <51A1280D.701@sandeen.net>
Date: Sat, 25 May 2013 16:07:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs: is it one issue?
References: <CAEH94LjnVn-uD6cfwOcChC4wq1PppcD8BN30F93SD=YjdTbbuw@mail.gmail.com>
In-Reply-To: <CAEH94LjnVn-uD6cfwOcChC4wq1PppcD8BN30F93SD=YjdTbbuw@mail.gmail.com>
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
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: xfs@oss.sgi.com

On 5/25/13 11:29 AM, Zhi Yong Wu wrote:
> HI,
> =

> Did anyone hit this issue?
> =

> [root@f15 xfsprogs]# make
> Building include
> Building libxfs
>     [TEST]    CRC32
> In file included from ../include/libxfs.h:584:0,
>                  from crc32.c:36:
> ../include/xfs/xfs_ialloc.h:75:2: error: unknown type name =91umode_t=92
> gmake[2]: *** [crc32selftest] Error 1
> gmake[1]: *** [libxfs] Error 2
> make: *** [default] Error 2

For starters, which version of xfsprogs?  And what version of kernel header=
s?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
