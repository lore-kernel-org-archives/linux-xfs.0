Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q25LZKDd007995 for <xfs@oss.sgi.com>; Mon, 5 Mar 2012 15:35:20 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	mAjCz6oo1rpkLJPf for <xfs@oss.sgi.com>;
	Mon, 05 Mar 2012 13:35:18 -0800 (PST)
Date: Tue, 6 Mar 2012 08:35:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests: before test execution, print test number to
	syslog
Message-ID: <20120305213512.GC3592@dastard>
References: <1330968369-31779-1-git-send-email-sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1330968369-31779-1-git-send-email-sbehrens@giantdisaster.de>
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
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: xfs@oss.sgi.com

On Mon, Mar 05, 2012 at 06:26:09PM +0100, Stefan Behrens wrote:
> When the xfstests are executed in a batch (like "check 001-299")
> and produce syslog output, it is helpful to know which test was
> causing the output. Therefore each time a test is started, a
> syslog message is generated that contains the number of the
> xfstest.
> 
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>

Looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
