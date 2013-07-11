Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 92FAB7F3F
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 19:55:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 17999AC002
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 17:54:58 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	OtVKfkq7yLFBIDJ9 for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 17:54:56 -0700 (PDT)
Date: Thu, 11 Jul 2013 10:54:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] large-fs: fix large_fs space detection
Message-ID: <20130711005454.GT3438@dastard>
References: <1373367918-7516-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373367918-7516-1-git-send-email-dmonakhov@openvz.org>
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

On Tue, Jul 09, 2013 at 03:05:15PM +0400, Dmitry Monakhov wrote:
> Currenly large_fs check compare $SCRATCH_DEV_EMPTY_SPACE and $fs_size
> which is not correct because total empty size required is $SCRATCH_DEV_EMPTY_SPACE + 50Gb
> This path fix space detection, so check becomes valid for all situations.

I'm not sure what problem you're fixing from this description?

It's takenme a few minutes to work out that:

"If SCRATCH_DEV_EMPTY_SPACE + 50GB is larger than the filesystem
size being tested, then the configuration being tested is invalid
and should fail. Currently we only check that
SCRATCH_DEV_EMPTY_SPACE is greater than the the filesystem size. Fix
it to check the combined empty space fits in the filesystem being
tested."

Otherwise the change looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
