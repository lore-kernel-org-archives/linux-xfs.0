Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBA11aJB032491 for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 19:01:36 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay1.corp.sgi.com (Postfix) with SMTP id CBE6D8F808E
	for <xfs@oss.sgi.com>; Tue,  9 Dec 2008 17:01:31 -0800 (PST)
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com
	[134.14.55.58]) by larry.melbourne.sgi.com
	(950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id MAA23417 for
	<xfs@oss.sgi.com>; Wed, 10 Dec 2008 12:01:29 +1100
Date: Wed, 10 Dec 2008 12:05:28 +1100
Subject: Re: xfsprogs 2.10.2 source tarball released
From: "Barry Naujok" <bnaujok@sgi.com>
MIME-Version: 1.0
References: <op.ultkdxb03jf8g2@pc-bnaujok.melbourne.sgi.com>
Message-ID: <op.ulw9beyj3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.ultkdxb03jf8g2@pc-bnaujok.melbourne.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, 08 Dec 2008 12:14:11 +1100, Barry Naujok <bnaujok@sgi.com> wrote:

> ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs_2.10.2-1.tar.gz
>
> This version contains important bug fixes to xfsprogs 2.10.1:
>
> xfsprogs-2.10.2 (8 December 2008)
> 	- Fix an mkfs.xfs regression where -i maxpct option was ignored.
> 	- Fix mkfs.xfs -d agcount and su/sw options when used together.
> 	- Fix a regression where repaired inodes in xfs_repair were not
> 	  written to disk.
> 	- Allow 64K block size support in xfs_repair.
> 	- Fix up unaligned accesses in 64 bit platforms in xfs_repair.

I released the wrong tarball - it can't create RPMs and has other
unrelated build code.

The tarball has been updated with the correct build infrastructure
(mainly for RPM users).

Barry.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
