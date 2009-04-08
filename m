Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n384AeRn059783 for <xfs@oss.sgi.com>; Tue, 7 Apr 2009 23:10:50 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E14B614024B4
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2009 21:11:49 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id 82FdMytUfx5QSJf0 for
	<xfs@oss.sgi.com>; Tue, 07 Apr 2009 21:11:49 -0700 (PDT)
Date: Wed, 8 Apr 2009 14:10:14 +1000 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <430737146.3196421239163814099.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <20090408115648.efaee933.thomas@nchc.org.tw>
Subject: Re: Build xfs 3.0 deb problem
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
To: Thomas Tsai <thomas@nchc.org.tw>
Cc: xfs@oss.sgi.com


----- "Thomas Tsai" <thomas@nchc.org.tw> wrote:

> tkx for reply soon.
> 
> My package name is partclone(partclone.org), like partimage, but I

Sounds like xfs_copy(8)?

> used libxfs to check bitmap/super block and backup xfs partition. It's
> GPL licensed.
> 
> We need GPL tool to backup XFS partition. The partimage can do that
> but get some problems(not based on the xfs library).
> The xfs library you maintained well, and it's why I use xfslibs-dev's
> liarbry to write backup tool, "partclone.xfs" .

Can this use xfs_copy directly?

> so..., may I use xfslibs-dev to build partclone?
> or stop it and remove?

Its historically proved disasterous having ondisk filesystem knowledge
in tools (e.g. grub) ... and restricts what filesystem developers can
do in terms of extending their ondisk formats, somewhat.  It'd be alot
better if you could use a tool shipped by the XFS folk rather than one
you write yourself (libxfs is a very error prone interface modelled on
kernel code, it wasn't designed as a general purpose API).

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
