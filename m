Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BC9DF7F3F
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 20:18:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9CFD78F8033
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 18:18:37 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ZP5Z83kBB7aZWJAM for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 18:18:28 -0700 (PDT)
Date: Thu, 11 Jul 2013 11:17:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] large-fs: fix ext4 defragmentation tests
Message-ID: <20130711011741.GW3438@dastard>
References: <1373367918-7516-1-git-send-email-dmonakhov@openvz.org>
	<1373367918-7516-4-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373367918-7516-4-git-send-email-dmonakhov@openvz.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, dchinner@redhat.com, xfs@oss.sgi.com

On Tue, Jul 09, 2013 at 03:05:18PM +0400, Dmitry Monakhov wrote:
> Initially work space size calculation was based on size of blkdev which
> obviously wrong for large-fs case. This patch calculate work space based
> on `df` cmd.

when have a "_used" command in common/rc for getting the used space
on a device (i.e. _used $SCRATCH_DEV). This loocks like a case for a
"_free" equivalent....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
