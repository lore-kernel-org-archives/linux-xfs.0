Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBL4aBw3214907 for <xfs@oss.sgi.com>; Tue, 20 Dec 2011 22:36:11 -0600
Date: Tue, 20 Dec 2011 22:36:38 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/2] xfs: fix endian conversion issue in discard code
Message-ID: <20111221043638.GR29840@sgi.com>
References: <1324426062-21505-1-git-send-email-david@fromorbit.com>
	<1324426062-21505-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1324426062-21505-3-git-send-email-david@fromorbit.com>
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

On Wed, Dec 21, 2011 at 11:07:42AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When finding the longest extent in an AG, we read the value directly
> out of the AGF buffer without endian conversion. This will give an
> incorrect length, resulting in FITRIM operations potentially not
> trimming everything that it should.

Looks good to me.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
