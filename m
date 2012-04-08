Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q38N2H8E219171 for <xfs@oss.sgi.com>; Sun, 8 Apr 2012 18:02:18 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	l7H9zkLDbdd6BX3E for <xfs@oss.sgi.com>;
	Sun, 08 Apr 2012 16:02:15 -0700 (PDT)
Date: Mon, 9 Apr 2012 09:02:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: detecting case-insensitivity
Message-ID: <20120408230208.GH18323@dastard>
References: <20120407140029.GA24090@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120407140029.GA24090@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: xfs@oss.sgi.com

On Sat, Apr 07, 2012 at 10:00:29AM -0400, J. Bruce Fields wrote:
> Is there a generic way to detect whether a given filesystem is
> case-insensitive?  If not, how should it be done?  (A bit in s_flags?)

I don't think there is a generic flag for it. We could trivially add
one, I think, as it is generally a fixed property for the entire
filesystem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
