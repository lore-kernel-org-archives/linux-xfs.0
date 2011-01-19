Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0JBag5n208749 for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 05:36:42 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 90B5B19E8545
	for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 03:39:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Dk5wRyOiiELMlnxb for
	<xfs@oss.sgi.com>; Wed, 19 Jan 2011 03:39:01 -0800 (PST)
Date: Wed, 19 Jan 2011 06:39:01 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/12] xfs: kill xfs_fs_mount_cmn_err() macro
Message-ID: <20110119113900.GB12941@infradead.org>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
	<1294792553-8378-8-git-send-email-david@fromorbit.com>
	<20110118130023.GA23988@infradead.org>
	<20110118214610.GW28803@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110118214610.GW28803@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jan 19, 2011 at 08:46:10AM +1100, Dave Chinner wrote:
> > I would be nice to just move the quite flag into the normal mount flags
> > and have a xfs_mount_warn that checks it based off the mp.
> 
> Given it is a flag that is only relevant for the mount context, is
> there really any need to use a flag that persists for the entire
> life of the filesystem for it? I don't think the code is that hard
> to follow right now. ;)

We can clear the flag after the mount.  But in the end it's probably
not worth bothering, so feel free to leave it as-is.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
