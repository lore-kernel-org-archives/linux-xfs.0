Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBNCqtka235001 for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 06:52:55 -0600
Received: from QMTA07.emeryville.ca.mail.comcast.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3194C1C102B7
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 04:53:37 -0800 (PST)
Received: from QMTA07.emeryville.ca.mail.comcast.net
	(qmta07.emeryville.ca.mail.comcast.net [76.96.30.64]) by
	cuda.sgi.com with ESMTP id 9h3svQBuIRCbXO67 for
	<xfs@oss.sgi.com>; Wed, 23 Dec 2009 04:53:37 -0800 (PST)
Message-ID: <4B3212ED.4090208@byu.net>
Date: Wed, 23 Dec 2009 05:54:05 -0700
From: Eric Blake <ebb9@byu.net>
MIME-Version: 1.0
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net>
	<87aaxclr4q.fsf@devron.myhome.or.jp>	<4B2F7421.10005@byu.net>
	<4B2F7A95.3010708@byu.net>	<87hbrkjrk8.fsf@devron.myhome.or.jp>
	<4B304D04.6040501@byu.net>	<87d427jscr.fsf@devron.myhome.or.jp>
	<4B3097C4.3060803@wanadoo.fr>	<874onjjnln.fsf@devron.myhome.or.jp>
	<4B30B67A.7080703@wanadoo.fr>	<87ljgvi1an.fsf@devron.myhome.or.jp>
	<4B30F0C9.2020702@wanadoo.fr> <87my1aevro.fsf@devron.myhome.or.jp>
In-Reply-To: <87my1aevro.fsf@devron.myhome.or.jp>
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
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net, bug-coreutils <bug-coreutils@gnu.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, ctrn3e8 <ctrn3e8@gmail.com>, =?ISO-8859-1?Q?Jean-Pierre_Andr=E9?= <jean-pierre.andre@wanadoo.fr>, Christoph Hellwig <hch@lst.de>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

According to OGAWA Hirofumi on 12/22/2009 10:58 AM:
>> I suggest I port Miklos patch to fuse-lite soon,
>> and delay the low-level case (and microsecond
>> precision) until January. Does that suit your needs ?
> 
> Thanks. Sounds good. I'm not using ntfs-3g actually, I just bridged the
> bug report on lkml to others. Eric?

I'm also bridging the report from a coreutils user (now cc'd).  Since I
also don't use ntfs-3g, I'm hoping that ctrn3e8 will be able to help test
whether the latest patch to ntfs-3g makes a difference in properly setting
times.  To me, delaying precision while fixing UTIME_OMIT semantics is a
reasonable approach.

By the way, is there any reliable way, other than uname() and checking for
a minimum kernel version, to tell if all file systems will properly
support UTIME_OMIT?  For coreutils 8.3, we will be inserting a workaround
where instead of using UTIME_OMIT, we call fstatat() in advance of
utimensat() and pass the original timestamp down.  But it would be nice to
avoid the penalty of the extra stat if there were a reliable way to ensure
that, regardless of file system, the use of UTIME_OMIT will be honored.
After all, coreutils wants touch(1) to work regardless of how old the
user's kernel and file system drivers are.

- --
Don't work too hard, make some time for fun as well!

Eric Blake             ebb9@byu.net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Cygwin)
Comment: Public key at home.comcast.net/~ericblake/eblake.gpg
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksyEu0ACgkQ84KuGfSFAYCrzACgirIjqmS7vFOBcI8xau6jHEa0
4L0AnAjJkje+tSMF/FZkTbkohg/fhQ+i
=ngx0
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
