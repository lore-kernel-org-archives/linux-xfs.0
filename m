Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o44AFRHQ219603 for <xfs@oss.sgi.com>; Tue, 4 May 2010 05:15:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9C9930B8E7
	for <xfs@oss.sgi.com>; Tue,  4 May 2010 03:17:36 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id MG0keEm8Q6WlKNdF for
	<xfs@oss.sgi.com>; Tue, 04 May 2010 03:17:36 -0700 (PDT)
Date: Tue, 4 May 2010 06:17:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT] Delayed Logging V3
Message-ID: <20100504101733.GA18229@infradead.org>
References: <20100504015042.GA8120@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100504015042.GA8120@dastard>
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
Cc: xfs@oss.sgi.com

On Tue, May 04, 2010 at 11:50:42AM +1000, Dave Chinner wrote:
> The new cleanups added in this version mean it touche?? more files
> that the previous versions, but overall it should still be simpler
> to review because I've collapsed many of the intermediate patches
> into one "Introduce delayed logging core code" commit.

Thanks.  Btw, a little procedural comment - you include the V2 markers
and changelogs in the commit message.  Normal procedure is to have
them below the -- or what it is marker with the diffstat so that they
only get picked up in the mail and not the final commits, and no V2 in
the subject line at all.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
