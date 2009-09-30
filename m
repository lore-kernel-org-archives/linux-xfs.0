Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8UCgZjM019828 for <xfs@oss.sgi.com>; Wed, 30 Sep 2009 07:42:36 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 296691D73E96
	for <xfs@oss.sgi.com>; Wed, 30 Sep 2009 05:43:56 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Xykg52OPq3PRx8sc for
	<xfs@oss.sgi.com>; Wed, 30 Sep 2009 05:43:56 -0700 (PDT)
Date: Wed, 30 Sep 2009 08:43:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: enable generic filesystems on some ENOSPC tests
Message-ID: <20090930124355.GB7463@infradead.org>
References: <4AC1114C.2070802@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AC1114C.2070802@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

The change to 204 and the infrastructure seems fine for me, but I don't
really like how the other use an explicit agcount (which at least for
109 was very intentional) for xfs and just defaults for others.  At
least 109 should be duplicated into a generic one run everywhere and
an xfs-specific with the agcount.  Need to look a bit more at the
history of 083 to max a decision for that one.  And some less cryptic
variable names in the new code would also be nice.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
