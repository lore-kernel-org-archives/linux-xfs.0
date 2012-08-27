Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7R6te2q009322 for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 01:55:40 -0500
Received: from mail.vlasiu.net (mail.vlasiu.net [91.223.50.125]) by
	cuda.sgi.com with ESMTP id AYF6EotS4cRByYNC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Aug 2012 23:56:26 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.vlasiu.net (Postfix) with ESMTP id A30297E07F
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 09:56:24 +0300 (EEST)
Received: from mail.vlasiu.net ([127.0.0.1])
	by localhost (mail.vlasiu.net [127.0.0.1]) (amavisd-new, port 10026)
	with LMTP id 3hlMv8EnFW7z for <xfs@oss.sgi.com>;
	Mon, 27 Aug 2012 09:56:21 +0300 (EEST)
Received: from localhost (localhost [127.0.0.1])
	by mail.vlasiu.net (Postfix) with ESMTP id 6D8157E07F
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 09:56:21 +0300 (EEST)
Date: Mon, 27 Aug 2012 09:56:17 +0300 (EEST)
From: Gabriel VLASIU <gabriel@vlasiu.net>
Subject: Re: umount doesn't seem to really unmount
In-Reply-To: <CAAxjCExx8LB3PyMUR8T215hMYps17D+Lvg4C0aOwLwD=d-NOMQ@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1208270952390.8166@mail.vlasiu.net>
References: <CAAxjCEwdYbcDoUvcAV1n8281HCCvrCvReaG2oM5+h+WV5yDZvA@mail.gmail.com>
	<1104CDC2-47D2-40CF-8294-A17E33125D54@sandeen.net>
	<CAAxjCExx8LB3PyMUR8T215hMYps17D+Lvg4C0aOwLwD=d-NOMQ@mail.gmail.com>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Mon, 27 Aug 2012, Stefan Ring wrote:

> Regardless of the barriers, it doesn't explain this:
> 
> $ sudo mount -o barrier=1,inode64 /dev/mapper/vg_xfs2-lvxfs1 /xfs1
> $ sudo umount /xfs1
> $ sudo xfs_logprint /dev/mapper/vg_xfs2-lvxfs1
> xfs_logprint:
> xfs_logprint: /dev/mapper/vg_xfs2-lvxfs1 contains a mounted and
> writable filesystem
>     data device: 0xfd01
>     log device: 0xfd01 daddr: 83882016 length: 81912
Same here. Plain sata hdd. 3.5.2 (Fedora 17).

# mount | grep /saves
/dev/sdb1 on /saves type xfs (rw,seclabel,nosuid,nodev,noexec,relatime,attr2,noquota)
# umount /saves
# xfs_repair /dev/sdb1
xfs_repair: /dev/sdb1 contains a mounted filesystem

fatal error -- couldn't initialize XFS library

> As crazy as that sounds, I've just found out what triggers the
> situation. The weird behavior only manifests itself after this:
> 
> $ sudo service mysqld start
Does not work for me. It must be something else.


Sincerely,
Gabriel

- --

// Gabriel VLASIU
//
// OpenGPG-KeyID      : 44952F15
// OpenGPG-Fingerprint: 4AC5 7C26 2FE9 02DA 4906  24B2 D32B 7ED7 4495 2F15
// OpenGPG-URL        : http://www.vlasiu.net/public.key


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQOxoRAAoJENMrftdElS8VlCYQAKiLaCp0KDsnkzr0nHGIBrbU
Xza/Ph2yIPw3BAZtXCPYGxH5gn7vemCnwZUhz+Oia9V9XFnlEjALvzdA1zhhdiYO
SRQi9n0qcuVLwuF/Mtp8w6B2K8S7DATeDmVBR3HGKb2SgvnOeJD3FaJYIPp98FKF
Kg9KhEmvOVyyXG7btCwqj0w7Uk5TxlPbAq+RVDjSeQLyo879fyQbdEmT6+jFk73Z
4afK0LhiOlzMGUGoU1Wr/hY16JIIeY2RIyoW6aS4QJQJMdLq8oiH3wgi+v+4lpJB
d1EOfKsqibK8+iqMiOkUP18VhK6xTP9nGthIB3wtmNyF/8StOc071GluJHOE2I7y
klxO807oj6pnKcYZrH/xxFEwf2iABJd6faFuu1pUtBr+ExlEQiJ2B5fGxWPFIysv
17/NtM/jNyNzhHQjImeYJvM0f2C0kXqhHsZ6U33Qk58OIjV8AEXVKHAPYMy5CXn2
GKD4catqrTsklzNW3Mi34cSXeMPFd7KqsuXQ3u6tekmal3TK01TMZJfdMlZ6IJqA
i+fUGk7iBfgamcwbn1wdy+odz5ZukvzkcEGlQZ9BGdSIcNz0p9/Tbk9hc5jCcfPw
gBwWSzTUFMdvPO9ccVE9hVs2285sL+p81ojk1wos71SPK3cfJmAQz715808zRlt1
VgQV6MwXCmZQlF/9Y2C0
=oamX
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
