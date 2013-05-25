Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0484E7F3F
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 14:43:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E50808F8037
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 12:43:09 -0700 (PDT)
Received: from mail-gh0-f179.google.com (mail-gh0-f179.google.com
	[209.85.160.179]) by cuda.sgi.com with ESMTP id
	bPu1CxrsUW4KNjlL (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 25 May 2013 12:43:09 -0700 (PDT)
Received: by mail-gh0-f179.google.com with SMTP id f16so1709490ghb.10
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 12:43:08 -0700 (PDT)
Message-ID: <51A1144A.4020600@gmail.com>
Date: Sat, 25 May 2013 15:43:06 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
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
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: xfs@oss.sgi.com

On 05/25/2013 12:29 PM, Zhi Yong Wu wrote:
> HI,
>
> Did anyone hit this issue?
>
> [root@f15 xfsprogs]# make
> Building include
> Building libxfs
>      [TEST]    CRC32
> In file included from ../include/libxfs.h:584:0,
>                   from crc32.c:36:
> ../include/xfs/xfs_ialloc.h:75:2: error: unknown type name =91umode_t=92
> gmake[2]: *** [crc32selftest] Error 1
> gmake[1]: *** [libxfs] Error 2
> make: *** [default] Error 2
>
>
> --
> Regards,
>
> Zhi Yong Wu

Yes.  I've been getting around it by inserting the following in one of =

the two files above, perhaps in xfs_ialloc.h...

typedef unsigned short umode_t;

It's something in the private kernel headers that doesn't get exported =

to the public headers by `make headers_install` from the kernel =

build...at least not for the 3.9 kernel series and later, maybe 3.8 as =

well.  However, I've been told that umode_t is in the Debian 2.6 kernel =

headers.  The main questions here are 1) when did umode_t go away? and =

2) what is the proper solution?  I use slackware-current, which is =

unaltered in many places where other distros would add extra tweaks, so =

it may not be a good reference distribution in this case.

If you mention your distribution and have an idea of which kernel =

version made the headers in /usr/include/linux, it might help the pros =

here come up with a solutio...or at least tell the people in charge of =

the public headers that they might export umode_t.

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
