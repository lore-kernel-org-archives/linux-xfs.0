Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5E50E7CA2
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 01:45:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C740FAC001
	for <xfs@oss.sgi.com>; Sun, 12 Jun 2016 23:45:49 -0700 (PDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id PBp2xejQRNbPtWNY
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 12 Jun 2016 23:45:47 -0700 (PDT)
Received: by mail-wm0-f51.google.com with SMTP id k204so64778790wmk.0
	for <xfs@oss.sgi.com>; Sun, 12 Jun 2016 23:45:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52b9dc9e-ae36-4f66-454a-b8f2d4b0c6d6@gmail.com>
References: <7494383b-a153-7a79-b872-42ac6506ac9e@gmail.com>
	<52b9dc9e-ae36-4f66-454a-b8f2d4b0c6d6@gmail.com>
From: Stefan Ring <stefanrin@gmail.com>
Date: Mon, 13 Jun 2016 08:45:45 +0200
Message-ID: <CAAxjCEwE5v_mL3ObWyx-i7GEtKovw-xab5JaGXSTuSMBvDcwmg@mail.gmail.com>
Subject: Re: Metadata corruption
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
To: Martin Aleksov <martin.aleksov@gmail.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On Mon, Jun 13, 2016 at 8:41 AM, Martin Aleksov
<martin.aleksov@gmail.com> wrote:
> Please note that after executing:
>
> [martin@marto ~]$ sudo xfs_db -c blockget -r /dev/sda2
>
>
> ERROR: The filesystem has valuable metadata changes in a log which needs to
> be replayed.  Mount the filesystem to replay the log, and unmount it before
> re-running xfs_db.  If you are unable to mount the filesystem, then use
> the xfs_repair -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a mount
> of the filesystem before doing this.
>
> and after that

> the error is gone.

After what?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
