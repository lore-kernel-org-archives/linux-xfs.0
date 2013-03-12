Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5B1587F5D
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 09:47:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 479C3304070
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 07:47:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Zslq8y2o6CN6oXEN for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 07:47:51 -0700 (PDT)
Message-ID: <513F4017.6050702@sandeen.net>
Date: Tue, 12 Mar 2013 09:47:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair segfaults
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
	<512FA67D.2090708@sandeen.net>
	<CANU9nTm3vR3Z5JwRwou4vnNejstAkAsnBb2ivwx-KhnHHbWpoQ@mail.gmail.com>
	<5130DB54.9030503@sandeen.net>
	<CANU9nTkekrw2mdptFdK2RVUFXD=evt0sTZhB9VL+PKY8DTj11A@mail.gmail.com>
	<5134BBA4.3060305@sandeen.net>
	<CANU9nTntXh5spRYc80OhsBqgLnZcJGA2qBeVVQaywthD1RMu4w@mail.gmail.com>
	<CANU9nTkG_XrNhDjGfRBofJkz=KryDmLGGJnYsBXyH5Ng=uiRWg@mail.gmail.com>
In-Reply-To: <CANU9nTkG_XrNhDjGfRBofJkz=KryDmLGGJnYsBXyH5Ng=uiRWg@mail.gmail.com>
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
To: Ole Tange <tange@binf.ku.dk>
Cc: xfs@oss.sgi.com

On 3/12/13 6:37 AM, Ole Tange wrote:

> $ ~/work/xfsprogs/repair/xfs_repair -L franklin.img
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
> ALERT: The filesystem has valuable metadata changes in a log which is being
> destroyed because the -L option was used.
>         - scan filesystem freespace and inode maps...
> xfs_repair: scan.c:1080: scan_freelist: Assertion `0' failed.
> Aborted (core dumped)

Oh, man.  I need to have my hacker card revoked.  Or maybe focus
on one filesystem at a time so I don't keep doing dumb things, like
adding an unconditional ASSERT in non-"-n"-mode.  Holy cow, I don't
know what's up with me lately.  :/

Anyway, just modify these 2 lines in repair/scan.c to remove the ASSERT
around line 1080.

I'll send a proper patch as well.



diff --git a/repair/scan.c b/repair/scan.c
index 6a62dff..76bb7f1 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1076,8 +1076,7 @@ scan_freelist(
 				  "freelist scan\n"), i);
 			return;
 		}
-	} else /* should have been fixed in verify_set_agf() */
-		ASSERT(0);
+	}
 
 	count = 0;
 	for (;;) {




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
