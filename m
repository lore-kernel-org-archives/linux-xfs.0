Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n97KDPRS207644 for <xfs@oss.sgi.com>; Wed, 7 Oct 2009 15:13:26 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C445B4ACA63
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2009 13:14:52 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ErihCHAgDmnlSMvQ for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2009 13:14:52 -0700 (PDT)
Date: Wed, 7 Oct 2009 16:14:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: allow using libblkid instead of libdisk
Message-ID: <20091007201451.GA30192@infradead.org>
References: <20091006185252.GA10250@infradead.org>
	<4ACCE37F.4070006@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ACCE37F.4070006@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, util-linux-ng@vger.kernel.org, xfs@oss.sgi.com

On Wed, Oct 07, 2009 at 01:52:47PM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
>> Add a new --enable-blkid switch to use libblkid from util-linux to detect
>> the device geometry and check for existing partitions or filesystem on a
>> device.  Note that this requires the latest blkid from util-linux-ng git
>> for the topology calls, odler ones won't work.  If I had a little more
>> autoconf fu we might be able to detect a too early one, but right now it
>> just fails if it's too old and --enable-blkid is specified.
>
> Here's some autoconf fu to check for blkid topo support; this changes it to
> default to using blkid, optionally disable-able, and disables it automatically
> if the topo stuff isn't found (I think ;)

Thanks, I've folded it into my patch.

Btw, something I forgot to ask with the original patch:  Does anyone
have a use for the fstype binary that doesn't actually get installed?
It would be a lot cleaner to just nuke it instead of building it
conditionally.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
