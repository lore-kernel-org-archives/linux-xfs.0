Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8D5DF7CBF
	for <linux-xfs@oss.sgi.com>; Fri,  7 Jun 2013 17:40:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 648F4304066
	for <linux-xfs@oss.sgi.com>; Fri,  7 Jun 2013 15:40:10 -0700 (PDT)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id Cq9rzAM3Nbj9wuFg (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Fri, 07 Jun 2013 15:40:08 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1Ul5KF-0005Oj-WA
	for linux-xfs@oss.sgi.com; Sat, 08 Jun 2013 00:40:04 +0200
Received: from 89-69-21-174.dynamic.chello.pl ([89.69.21.174])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sat, 08 Jun 2013 00:40:03 +0200
Received: from arekm by 89-69-21-174.dynamic.chello.pl with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sat, 08 Jun 2013 00:40:03 +0200
From: Arkadiusz =?ISO-8859-2?Q?Mi=B6kiewicz?= <arekm@maven.pl>
Subject: Re: xfsprogs: is it one issue?
Date: Sat, 08 Jun 2013 00:31:55 +0200
Message-ID: <kotn0m$fmo$1@ger.gmane.org>
References: <CAEH94LjnVn-uD6cfwOcChC4wq1PppcD8BN30F93SD=YjdTbbuw@mail.gmail.com>
	<20130526224449.GM24543@dastard> <20130526224805.GN24543@dastard>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Dave Chinner wrote:

> On Mon, May 27, 2013 at 08:44:49AM +1000, Dave Chinner wrote:
>> On Sun, May 26, 2013 at 12:29:11AM +0800, Zhi Yong Wu wrote:
>> > HI,
>> > =

>> > Did anyone hit this issue?
>> > =

>> > [root@f15 xfsprogs]# make
>> > Building include
>> > Building libxfs
>> >     [TEST]    CRC32
>> > In file included from ../include/libxfs.h:584:0,
>> >                  from crc32.c:36:
>> > ../include/xfs/xfs_ialloc.h:75:2: error: unknown type name ?umode_t?
>> > gmake[2]: *** [crc32selftest] Error 1
>> > gmake[1]: *** [libxfs] Error 2
>> > make: *** [default] Error 2
>> =

>> Install the latest kernel headers package for your distro.
> =

> Actually, on debian it's part of a libc-dev package:
> =

> $ grep -r umode /usr/include |head -1
> /usr/include/asm-generic/types.h:typedef unsigned short umode_t
> $ apt-file search /usr/include/asm-generic/types.h
> linux-libc-dev: /usr/include/asm-generic/types.h
> $

This won't work on recent kernels. Recent kernels export sanitized headers =
- it's called UAPI .

>From irc conversation:

00:07 < arekm> anyway current kernels export uapi headers (aka user space a=
pi headers,
https://lwn.net/Articles/507794/) and these don't export things like umode_=
t -
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/includ=
e/uapi/asm-generic/types.h =

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/includ=
e/uapi/asm-generic/int-ll64.h
00:10 < bpm> arekm, linux/types.h has it on 3.10
00:10 < arekm> bpm: yes but this is not userspace installed header. it's ke=
rnel only
00:11 < arekm> bpm: linux-*/include/uapi/asm-generic/types.h is the one bei=
ng installed for userspace



-- =

Arkadiusz Mi=B6kiewicz, arekm / maven.pl

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
