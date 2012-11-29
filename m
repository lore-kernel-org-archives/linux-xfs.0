Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qATLKKCQ084655 for <xfs@oss.sgi.com>; Thu, 29 Nov 2012 15:20:20 -0600
Date: Thu, 29 Nov 2012 15:22:34 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/4] xfs: patch queue for 3.8
Message-ID: <20121129212234.GJ27055@sgi.com>
References: <1354068063-1692-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1354068063-1692-1-git-send-email-david@fromorbit.com>
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

On Wed, Nov 28, 2012 at 01:00:59PM +1100, Dave Chinner wrote:
> More bug fixes for 3.8. This series contains:
> 
> - the DIO transaction deadlock patch (unmodified),
> - addressed Christoph's zero-range review points and fixes the
>   ASSERT in the sub-block zeroing case. (updated)
> - a dquot locking issue that has been causing me random hangs in
>   xfstests 232 for months (new)
> - fixes for the log CRC sparse endian warnings. (new)

committed 1-3.  We'll see what Christoph says about #4.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
