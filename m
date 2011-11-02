Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA2Jtbjh196956 for <xfs@oss.sgi.com>; Wed, 2 Nov 2011 14:55:37 -0500
Date: Wed, 2 Nov 2011 15:55:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] xfstests: add fiemap operation to fsstress
Message-ID: <20111102195534.GB22500@infradead.org>
References: <1319849297-3506-1-git-send-email-dmonakhov@openvz.org>
	<1319849297-3506-7-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1319849297-3506-7-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@lst.de, aelder@sgi.com

On Sat, Oct 29, 2011 at 04:48:15AM +0400, Dmitry Monakhov wrote:
> Related bug: http://patchwork.ozlabs.org/patch/118863
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

This causes a very weird XFS failure in test 117 for me.  While it
obviously is an xfs bug that you uncovered (good!) I'm a bit worried
about simply enabling operations in existing tests.

Alex, Eric, Dave - should we add new tests with the new operations
Dmitry added, or is adding new ops to the existing tests fine?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
