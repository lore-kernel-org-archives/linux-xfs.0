Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4927E7CA0
	for <xfs@oss.sgi.com>; Sun,  3 Jul 2016 07:34:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C8F97AC001
	for <xfs@oss.sgi.com>; Sun,  3 Jul 2016 05:34:14 -0700 (PDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com
	[74.125.82.41]) by cuda.sgi.com with ESMTP id IDBMy2jO6vl4VZnQ
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 03 Jul 2016 05:34:09 -0700 (PDT)
Received: by mail-wm0-f41.google.com with SMTP id a66so83228326wme.0
	for <xfs@oss.sgi.com>; Sun, 03 Jul 2016 05:34:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC5UwBi8Skjx90_XC5Z5B8P+CadawBZ3iUabKtm-2ZvrkgocZQ@mail.gmail.com>
References: <CAC5UwBi8Skjx90_XC5Z5B8P+CadawBZ3iUabKtm-2ZvrkgocZQ@mail.gmail.com>
From: Stefan Ring <stefanrin@gmail.com>
Date: Sun, 3 Jul 2016 14:34:07 +0200
Message-ID: <CAAxjCEx4sHH+Eo=HnEXR7+EXwV9unHOg53stRkAn9UecHyQpcg@mail.gmail.com>
Subject: Re: High Fragmentation with XFS and NFS Sync
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
To: Nick Fisk <friskyfisk10@googlemail.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On Sat, Jul 2, 2016 at 10:52 AM, Nick Fisk <friskyfisk10@googlemail.com> wrote:
> Hi, hope someone can help me here.
>
> I'm exporting some XFS fs's to ESX via NFS with the sync option enabled. I'm
> seeing really heavy fragmentation when multiple VM's are copied onto the
> share at the same time. I'm also seeing kmem_alloc failures, which is
> probably the biggest problem as this effectively takes everything down.
>

The same thing happens with MySQL's InnoDB files if O_DIRECT is in use.

The kmem_alloc failure taking everything down is most likely a result
of you calling xfs_bmap on these files and does not happen during
normal use. I've had the same experience some time ago.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
