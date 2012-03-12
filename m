Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2CMBSws152358 for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 17:11:29 -0500
Received: from mail-yx0-f181.google.com (mail-yx0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	Y23JjJY96EwZdaVb (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 Mar 2012 15:11:26 -0700 (PDT)
Received: by yenq2 with SMTP id q2so4237800yen.26
	for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 15:11:25 -0700 (PDT)
Received: by yhjj72 with SMTP id j72so4218590yhj.26
	for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 15:11:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F5D6690.3010006@hardwarefreak.com>
References: <CAEm1Pvny7Q2rrsCLURvo5kQM3vt+yMg17WxoSYGKVWm7Lgp8MA@mail.gmail.com>
	<4F5ADFCB.9010602@sandeen.net>
	<CAEm1PvmTCaw_eSNPPvQLvwu5X7ywseOBbALxMkSLnOT9iQd6fQ@mail.gmail.com>
	<4F5D6690.3010006@hardwarefreak.com>
Date: Mon, 12 Mar 2012 15:11:25 -0700
Message-ID: <CAEm1PvmfrNAYiDKbsmx-0vaqMX_0h6WKEnDAWUKF7h9g1CQP0g@mail.gmail.com>
Subject: Re: 1B files, slow file creation, only AG0 used
From: Michael Spiegle <mike@nauticaltech.com>
Reply-To: mike@nauticaltech.com
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
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

On Sun, Mar 11, 2012 at 7:59 PM, Stan Hoeppner <stan@hardwarefreak.com> wro=
te:
>
> When using the inode32 allocator and having 64k dirs, and seeing no
> files in AGs other than AG0, might this tend to suggest that these are
> zero length files or similar, being stored entirely within the directory
> inodes, thus occupying no extents in other AGs? =A0Would this tend to
> explain why 'everything' is in AG0?
>

If any of our files are 0-bytes, then that would probably be an error.
 Our files are anywhere from 1K-50KB.  There could be files outside of
that range, but they're at the edges of the bell curve.

>
> If my guess about these files is correct, mounting with inode64 and
> writing additional files should create new directory inodes in other
> AGs, but you still won't see file extents in those other AGs, just as
> you don't in the first AG.
>
> Are you using this XFS filesystem as a poor man's database or something
> similar? =A0This would tend to explain a billion files, with no extents,
> wholly stored in directory inodes, only in AG0, while using the inode32
> allocator.
>
> --
> Stan

I mentioned it in another reply, but we just found out that the AG
information appeared to be cached.  We had to unmount/remount the
filesystem in order to get updated counts.  We do see other AGs being
used when mounting with inode64.

No, we have a database for the database stuff =3D)  These are legitimate
pieces of content that we're storing for our users (many many billions
of files).  We were using EXT3, but recently moved to XFS.  It's nice
to not be constrained by statically-allocated inodes!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
