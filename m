Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1TK0bWs042689 for <xfs@oss.sgi.com>; Wed, 29 Feb 2012 14:00:37 -0600
Date: Wed, 29 Feb 2012 14:00:42 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 3/8] quota: make Q_XQUOTASYNC a noop
Message-ID: <20120229200042.GL7762@sgi.com>
References: <20120220022815.018921977@bombadil.infradead.org>
	<20120220022903.853258996@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120220022903.853258996@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Feb 19, 2012 at 09:28:18PM -0500, Christoph Hellwig wrote:
> Now that XFS takes quota reservations into account there is no need to flush
> anything before reporting quotas - in addition to beeing fully transactional
> all quota information is also 100% coherent with the rest of the filesystem
> now.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.  IIRC there were also some userspace bits related to this
awhile ago.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
