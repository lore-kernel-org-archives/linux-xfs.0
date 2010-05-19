Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JILKiZ146609 for <xfs@oss.sgi.com>; Wed, 19 May 2010 13:21:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D9B65156DD13
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 11:24:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id h13cbQkXA4Js9fCn for
	<xfs@oss.sgi.com>; Wed, 19 May 2010 11:24:47 -0700 (PDT)
Date: Wed, 19 May 2010 14:23:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: noatime,nodiratime?
Message-ID: <20100519182336.GA6264@infradead.org>
References: <4BF3F212.5030600@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BF3F212.5030600@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Wed, May 19, 2010 at 09:13:38AM -0500, Stan Hoeppner wrote:
> Need a little education here.  I have a general understanding of what the
> inode access timestamps "are" but I have no idea what, if any, applications
> make use of these access times.  I see posts all over Google land saying to
> use "noatime,nodiratime,logbufs=8" for XFS mount options to increase
> performance.

Which doesn't make much sense.  First 8 log buffers has been the default
for XFS for a long time.  Second nodiratime has always been useless as
it is a strict subset of of noatime.  Now noatime isn't the default yet,
but instead relatime is, which still updates the atime in memory, but
only writes it back when the inode has other changes, or on umount.
It should give you equivalent performance to noatime, but better
functionality.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
