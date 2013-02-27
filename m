Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6428D7F37
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 11:00:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5292E304064
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 09:00:36 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id rXs85SUPoUHgMWix for <xfs@oss.sgi.com>;
	Wed, 27 Feb 2013 09:00:35 -0800 (PST)
Message-ID: <512E3BB2.6060407@sandeen.net>
Date: Wed, 27 Feb 2013 11:00:34 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Read corruption on ARM
References: <CA+AKrqBQ=VG0oVsai+agywDKRgO9cG9AvT6mCTSZxKO3Si5Aiw@mail.gmail.com>
	<512D3856.5050305@sandeen.net>
	<CA+AKrqC+6nXuCxdY08MBLsjv1fOPJ6=1ruTHsfGqxosQmCi_jQ@mail.gmail.com>
	<512D49E2.40003@sandeen.net>
	<CA+AKrqCrphO-eKy0n=70O9hmB3mXttOsKmTdfRnPxgJM3_PAkQ@mail.gmail.com>
In-Reply-To: <CA+AKrqCrphO-eKy0n=70O9hmB3mXttOsKmTdfRnPxgJM3_PAkQ@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jason Detring <detringj@gmail.com>
Cc: xfs@oss.sgi.com

On 2/27/13 10:28 AM, Jason Detring wrote:
>             find-502   [000]   207.983594: xfs_da_btree_corrupt: dev 7:0 bno 0x5a4f8 nblks 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES caller xfs_dir2_leaf_readbuf

Was this on the same image as you sent earlier?

Ok, so this tells us that it was trying to read sector nr. 0x5a4f8 (369912), or fsblock 46239

What's really on disk there?

$ xfs_db problemimage.xfs
xfs_db> blockget -n
xfs_db> daddr 369912
xfs_db> blockuse
block 49152 (3/0) type sb
xfs_db> type text
xfs_db> p
000:  58 46 53 42 00 00 10 00 00 00 00 00 00 00 f0 d3  XFSB............
...

So it really did have a superblock location that it was reading
at that point - the backup SB in the 3rd allocation group, to be exact.
But it shouldn't have been trying to read a superblock at this point
in the code...

Hm, maybe I should have had you enable all xfs tracepoints to get
more info about where we thought we were on disk when we were doing this.
If you used trace-cmd you can do "trace-cmd record -e xfs*" IIRC.
You can do similar echo 1 > /<blah>/xfs*/enable I think for the sysfs route.

Can you identify which directory it was that tripped the above error?

(I still think it sounds like a miscompile, but trying to get more clues)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
