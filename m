Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q184Ehfd033358 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 22:14:43 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	aomz3q4xxt1gJTDT for <xfs@oss.sgi.com>;
	Tue, 07 Feb 2012 20:14:41 -0800 (PST)
Date: Wed, 8 Feb 2012 15:14:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: 068: run fsstress in read/write mode
Message-ID: <20120208041440.GD20305@dastard>
References: <4F315F88.3020200@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F315F88.3020200@redhat.com>
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
Cc: Jan Kara <jack@suse.cz>, xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 07, 2012 at 11:29:44AM -0600, Eric Sandeen wrote:
> Jan Kara was testing filesystem freeze, and was consistently locking
> up, although my tests of 068 were passing.  He pointed out that
> he was running in read/write mode, and it was atime updates causing
> the trouble.  Sure enough, dropping "-w" from fsstress locked me up
> too.  Change this so we get better (and more realistic) coverage.

Good idea.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
