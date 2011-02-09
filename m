Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p196Qf0k195933 for <xfs@oss.sgi.com>; Wed, 9 Feb 2011 00:26:42 -0600
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96E21155AA79
	for <xfs@oss.sgi.com>; Tue,  8 Feb 2011 22:29:14 -0800 (PST)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	Rn7Pl1wxG1SM8CVC for <xfs@oss.sgi.com>;
	Tue, 08 Feb 2011 22:29:14 -0800 (PST)
Received: by iyj8 with SMTP id 8so4487542iyj.26
	for <xfs@oss.sgi.com>; Tue, 08 Feb 2011 22:29:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=sp8w3F=x7LteBMx6hzZY6+smQQsO=YQSA3KRd@mail.gmail.com>
References: <AANLkTi=sp8w3F=x7LteBMx6hzZY6+smQQsO=YQSA3KRd@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 9 Feb 2011 01:28:52 -0500
Message-ID: <AANLkTin-AT17vKtu9NqEhGHvRPsiwfeOBSB7g874-cmb@mail.gmail.com>
Subject: Re: xfssyncd keeps disks awake
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
To: xfs@oss.sgi.com

On Wed, Feb 9, 2011 at 12:49 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> I have an XFS filesystem on RAID5 (actually XFS on LVM on dm-crypt on
> RAID5, but I doubt that matters). =A0Every few seconds, xfssyncd writes
> something, so my disks never spin down. =A0As far as I can tell, there
> is nothing at all accessing that partition. =A0(I can even unmount it.)

I found the other thread [1] right after I sent this.  Sigh.

I'll email back if the patch doesn't fix it for me.

--Andy

[1] http://www.spinics.net/lists/xfs/msg02948.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
