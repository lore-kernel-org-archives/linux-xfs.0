Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALFM1iJ006175
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 09:22:02 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F13AD1629C08
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 07:21:58 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id Xf0vzg3nSoOVFoUE for
	<linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 07:21:58 -0800 (PST)
Date: Mon, 21 Nov 2011 16:21:55 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: stale NFS file handle problem on XFS inode64
Message-ID: <20111121162155.0bfa0342@harpe.intellique.com>
In-Reply-To: <CAJNJY8SoNvqQB0WNJq5SVUhkLSJROoMkVEkOHrESVR0iMB4JDA@mail.gmail.com>
References: <CAJNJY8Q--O2Z3K6KFxVKOivwaABk+oRtC1y0eQ0nS1WdPNMwsQ@mail.gmail.com>
	<20111121150158.5f8b2512@harpe.intellique.com>
	<CAJNJY8SoNvqQB0WNJq5SVUhkLSJROoMkVEkOHrESVR0iMB4JDA@mail.gmail.com>
Mime-Version: 1.0
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
To: hank peng <pengxihan@gmail.com>
Cc: linux-xfs@oss.sgi.com

Le Mon, 21 Nov 2011 23:02:32 +0800
hank peng <pengxihan@gmail.com> =E9crivait:

> no, client and server are both 32 bits kernel.
> =


I'm afraid the 32 bits nfs client can't manage 64 bits inodes at all.
Maybe with a much more recent kernel, something like 2.6.29 or better? =


See for instance
http://oss.sgi.com/archives/xfs/2009-11/msg00174.html

Your best choice is to revert to not using the "inode64" option.
Unfortunately the easiest way is to backup and restore the whole
filesystem.

Alternatively, switch to samba...

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
