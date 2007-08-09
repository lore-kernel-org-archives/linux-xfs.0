Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Aug 2007 17:14:31 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l790ENbm003032
	for <xfs@oss.sgi.com>; Wed, 8 Aug 2007 17:14:27 -0700
Message-ID: <38891.192.168.3.1.1186618480.squirrel@mail.aconex.com>
In-Reply-To: <20070808231310.GS12413810@sgi.com>
References: <20070808231310.GS12413810@sgi.com>
Date: Thu, 9 Aug 2007 10:14:40 +1000 (EST)
Subject: Re: [PATCH 4 of 4] Per Allocation Group inode radix trees
From: nscott@aconex.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

> ...
> operations by keeping structures and operations within AGs. This
> removes the need for the ihashsize mount parameter altogether
> as the inode caches should never need size hints anymore.
>...
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2007-08-01 15:43:30.383433897
> +1000
> +++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2007-08-01 15:43:34.150945479 +1000
> ...
> -#define MNTOPT_IHASHSIZE    "ihashsize"    /* size of inode hash table */

You probably want to keep this string & parsing for awhile (forever?), but
move it to the end of the list with the other deprecated options - just so
as to not fail mounts on kernel upgrades... and surprise/annoy sysadmins
the world over.

cheers.

--
Nathan
