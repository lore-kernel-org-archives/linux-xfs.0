Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DA0C47F52
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 13:31:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B7280304066
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:31:08 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	CArm54I2us7tS8yP for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 11:31:07 -0800 (PST)
Date: Wed, 26 Feb 2014 06:31:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] util-linux/fallocate: introduce an option -c to support
	FALLOC_FL_COLLAPSE_RANGE
Message-ID: <20140225193101.GW13647@dastard>
References: <alpine.LFD.2.00.1402181001530.2216@localhost.localdomain>
	<1393355305-12009-1-git-send-email-dongsu.park@profitbricks.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393355305-12009-1-git-send-email-dongsu.park@profitbricks.com>
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
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org

On Tue, Feb 25, 2014 at 08:08:25PM +0100, Dongsu Park wrote:
> Introduce a new option -c (or --collapse-range) to support a new flag
> FALLOC_FL_COLLAPSE_RANGE for fallocate(2). It will nullify a particular
> range [offset, offset+len] by shifting extents beyond the range to the
> beginning of the hole.
> 
> To test that, it's necessary to apply kernel patches in the patchset
> "fs: Introduce new flag (FALLOC_FL_COLLAPSE_RANGE) for fallocate" [1],
> as well as "[PATCH v6] ext4: Add support FALLOC_FL_COLLAPSE_RANGE for
> fallocate". [2]
> 
> As discussed in the thread "[PATCH RESEND 3/10] ext4: Add support
> FALLOC_FL_COLLAPSE_RANGE for fallocate", [3] this patch to util-linux
> will be useful for testing collapse-range inside xfstests.

FYI, we've already got support in xfs_io for collapse-range tests
inside xfstests.

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsprogs.git;a=commit;h=ca692f162d36c871c9c1b6169136b2c70503f2d8

There are already several tests that use it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
