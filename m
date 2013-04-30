Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 446AD29DFA
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 01:19:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E06DDAC001
	for <xfs@oss.sgi.com>; Mon, 29 Apr 2013 23:19:02 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Co3AxQSgu6I5JcO2 for <xfs@oss.sgi.com>;
	Mon, 29 Apr 2013 23:19:00 -0700 (PDT)
Date: Tue, 30 Apr 2013 16:18:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 24/22] xfs: Teach dquot recovery about CONFIG_XFS_QUOTA
Message-ID: <20130430061856.GE23072@dastard>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
	<20130409073322.GJ17758@dastard> <20130427204415.GJ29359@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130427204415.GJ29359@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Sat, Apr 27, 2013 at 03:44:15PM -0500, Ben Myers wrote:
> Hey,
> 
> On Tue, Apr 09, 2013 at 05:33:22PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Fix a build error when CONFIG_XFS_QUOTA=n:
> > 
> > fs/built-in.o: In function `xlog_recovery_validate_buf_type':
> > /home/dave/src/build/x86-64/xfsdev/fs/xfs/xfs_log_recover.c:1948: undefined
> > reference to `xfs_dquot_buf_ops'
> > 
> > Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> This one didn't want to apply cleanly for some reason.  Will give it a closer
> look in coming days.

Strange, my local copy applied cleanly to the updated tree. I'll
repost it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
