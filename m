Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n53Jha2d191938 for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 14:43:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D93B102FCC8
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2009 12:50:28 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 0e0sn110Oli3wE86 for
	<xfs@oss.sgi.com>; Wed, 03 Jun 2009 12:50:28 -0700 (PDT)
Date: Wed, 3 Jun 2009 15:43:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: Check for xlog_assign_lsn in xfs headers
Message-ID: <20090603194350.GA5313@infradead.org>
References: <4A26C53F.5080105@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A26C53F.5080105@redhat.com>
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
Cc: xfs mailing list <xfs@oss.sgi.com>

On Wed, Jun 03, 2009 at 01:47:27PM -0500, Eric Sandeen wrote:
> Check for xlog_assign_lsn in xfs headers
> 
> Checking for libxfs.h isn't enough; some debian installs
> have libxfs.h but no xlog_assign_lsn, and the loggen build still
> fails.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

I don't actually have a box with an old enough libxfs.h, but the
test looks sane to me.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
