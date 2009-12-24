Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBO0mo40020261 for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 18:48:50 -0600
Received: from QMTA07.emeryville.ca.mail.comcast.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B8B21249B4
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 16:49:33 -0800 (PST)
Received: from QMTA07.emeryville.ca.mail.comcast.net
	(qmta07.emeryville.ca.mail.comcast.net [76.96.30.64]) by
	cuda.sgi.com with ESMTP id zRxzlr0nTdNd7bfJ for
	<xfs@oss.sgi.com>; Wed, 23 Dec 2009 16:49:33 -0800 (PST)
Message-ID: <4B32BABC.7020908@byu.net>
Date: Wed, 23 Dec 2009 17:50:04 -0700
From: Eric Blake <ebb9@byu.net>
MIME-Version: 1.0
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net>
	<87aaxclr4q.fsf@devron.myhome.or.jp>	<4B2F7421.10005@byu.net>
	<4B2F7A95.3010708@byu.net>	<87hbrkjrk8.fsf@devron.myhome.or.jp>
	<4B304D04.6040501@byu.net>	<87d427jscr.fsf@devron.myhome.or.jp>
	<4B3097C4.3060803@wanadoo.fr>	<874onjjnln.fsf@devron.myhome.or.jp>
	<4B30B67A.7080703@wanadoo.fr>	<87ljgvi1an.fsf@devron.myhome.or.jp>
	<4B30F0C9.2020702@wanadoo.fr>
	<87my1aevro.fsf@devron.myhome.or.jp> <4B3212ED.4090208@byu.net>
	<4B32B303.6070807@gmail.com>
In-Reply-To: <4B32B303.6070807@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: ctrn3e8 <ctrn3e8@gmail.com>
Cc: =?ISO-8859-1?Q?Jean-Pie?=@oss.sgi.com, Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net, bug-coreutils <bug-coreutils@gnu.org>, =?ISO-8859-1?Q?rre_Andr=E9?= <jean-pierre.andre@wanadoo.fr>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

According to ctrn3e8 on 12/23/2009 5:17 PM:
> The strace has the following function call  (and it may be because I am
> looking at the trace rather than the actual source):

> utimensat(0, NULL, {UTIME_OMIT, UTIME_NOW}, 0) = 0

> The two don't seem to match.  Is this just because of the way the trace is printed?

Yes.  When the tv_nsec field is UTIME_OMIT or UTIME_NOW, the tv_sec field
is irrelevant.  Therefore, to save on space, strace omits the tv_sec field
in its output.  But rest assured that the kernel has read access to all
four 32-bit words located at the timespec pointer passed in the syscall.

> No mention of ntfs-3g support for nanosecond time stamping.

Read the rest of the thread on lkml - that is a known issue, which will
probably not be solved any sooner than January (all the patches this week
only dealt with mishandling of UTIME_OMIT).

- --
Don't work too hard, make some time for fun as well!

Eric Blake             ebb9@byu.net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Cygwin)
Comment: Public key at home.comcast.net/~ericblake/eblake.gpg
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksyurwACgkQ84KuGfSFAYDJ2gCgv9YMVwl7HL//ThRvQKJH5hSR
S/EAn0WzRr7FrFbkDHUtEfRdtXDdkqxT
=YpCl
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
