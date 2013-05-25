Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8AFD57F37
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 11:29:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 743608F8039
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 09:29:16 -0700 (PDT)
Received: from mail-qa0-f41.google.com (mail-qa0-f41.google.com
	[209.85.216.41]) by cuda.sgi.com with ESMTP id oFzFXjUKVn4Yro56
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 25 May 2013 09:29:12 -0700 (PDT)
Received: by mail-qa0-f41.google.com with SMTP id bn16so400779qab.7
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 09:29:12 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 26 May 2013 00:29:11 +0800
Message-ID: <CAEH94LjnVn-uD6cfwOcChC4wq1PppcD8BN30F93SD=YjdTbbuw@mail.gmail.com>
Subject: xfsprogs: is it one issue?
From: Zhi Yong Wu <zwu.kernel@gmail.com>
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
To: xfs@oss.sgi.com

HI,

Did anyone hit this issue?

[root@f15 xfsprogs]# make
Building include
Building libxfs
    [TEST]    CRC32
In file included from ../include/libxfs.h:584:0,
                 from crc32.c:36:
../include/xfs/xfs_ialloc.h:75:2: error: unknown type name =91umode_t=92
gmake[2]: *** [crc32selftest] Error 1
gmake[1]: *** [libxfs] Error 2
make: *** [default] Error 2


--
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
