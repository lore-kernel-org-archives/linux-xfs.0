Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4FE6D7F6C
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 22:22:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B5AA3AC001
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 20:22:47 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	cSIQ58ZATMFhE6We for <xfs@oss.sgi.com>;
	Wed, 12 Mar 2014 20:22:45 -0700 (PDT)
Date: Thu, 13 Mar 2014 14:22:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/8] Add tests for zero range into xfstests
Message-ID: <20140313032242.GD4263@dastard>
References: <1394034699-21187-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1394034699-21187-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Wed, Mar 05, 2014 at 04:51:31PM +0100, Lukas Czerner wrote:
> Hi,
> 
> this patch set adds two new test for zero range into xfstests - generic/008
> and ext4/001. It also adds zero range support for fsstress and fsx.

Lukas, I don't see a generic test equivalent of ext4/001 in this
series? Can you please write one so that we have the same coverage
on all other supported filesystems?  The rest of the patch series is
fine, but I'd really like you to finish the job off properly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
