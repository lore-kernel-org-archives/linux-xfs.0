Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 913E029DF8
	for <xfs@oss.sgi.com>; Sat, 27 Apr 2013 15:44:15 -0500 (CDT)
Date: Sat, 27 Apr 2013 15:44:15 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 24/22] xfs: Teach dquot recovery about CONFIG_XFS_QUOTA
Message-ID: <20130427204415.GJ29359@sgi.com>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
	<20130409073322.GJ17758@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130409073322.GJ17758@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hey,

On Tue, Apr 09, 2013 at 05:33:22PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Fix a build error when CONFIG_XFS_QUOTA=n:
> 
> fs/built-in.o: In function `xlog_recovery_validate_buf_type':
> /home/dave/src/build/x86-64/xfsdev/fs/xfs/xfs_log_recover.c:1948: undefined
> reference to `xfs_dquot_buf_ops'
> 
> Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This one didn't want to apply cleanly for some reason.  Will give it a closer
look in coming days.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
