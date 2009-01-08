Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n08JD8ic023944 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 13:13:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9AC4A17C012E
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 11:13:08 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AktEoXETD0XoLtHL for
	<xfs@oss.sgi.com>; Thu, 08 Jan 2009 11:13:08 -0800 (PST)
Date: Thu, 8 Jan 2009 14:12:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: add btrfs detection to libdisk
Message-ID: <20090108191237.GD10617@infradead.org>
References: <49664243.1090405@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49664243.1090405@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: "MASON, CHRISTOPHER" <CHRIS.MASON@oracle.com>, xfs mailing list <xfs@oss.sgi.com>

On Thu, Jan 08, 2009 at 12:13:23PM -0600, Eric Sandeen wrote:
> Now that the btrfs disk format has stabilized, libdisk can
> recognize it and mkfs.xfs will not overwrite it w/o "-f" :
> 
> # mkfs.btrfs -l 16384 -L mylabel -n 8192 -s 4096 /tmp/fsfile 
> fs created label mylabel on /tmp/fsfile
>         nodesize 8192 leafsize 16384 sectorsize 4096 size 1.28GB
> Btrfs v0.16-37-gb8271dc
> # mkfs.xfs /tmp/fsfile 
> mkfs.xfs: /tmp/fsfile appears to contain an existing filesystem (btrfs).
> mkfs.xfs: Use the -f option to force overwrite.

Looks good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
