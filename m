Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C9C037F37
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 14:51:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A74FF304039
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 12:50:59 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	leOcmmuZOo7iX6au for <xfs@oss.sgi.com>;
	Thu, 21 Mar 2013 12:50:57 -0700 (PDT)
Date: Fri, 22 Mar 2013 06:50:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: add execution of a custom command to fsstress
	(-x and -X options)
Message-ID: <20130321195054.GO17758@dastard>
References: <1363863585-25598-1-git-send-email-list.xfs@jan-o-sch.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363863585-25598-1-git-send-email-list.xfs@jan-o-sch.net>
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
To: Jan Schmidt <list.xfs@jan-o-sch.net>
Cc: xfs@oss.sgi.com

On Thu, Mar 21, 2013 at 11:59:45AM +0100, Jan Schmidt wrote:
> From: Jan Schmidt <list.btrfs@jan-o-sch.net>
> 
> This patch adds execution of a custom command in the middle of all fsstress
> operations. Its intended use is the creation of snapshots in the middle of a
> test run.

Why do you need fsstress to do this? Why can't you just run fsstress
in the background and run a loop creating periodic snapshots in the
control script?

Also, did you intend that every process creates a snapshot? i.e. it
looks lik eif you run a 1000 processes, they'll all run a snapshot
operation at X operations? i.e. this will generate nproc * X
snapshots in a single run. This doesn't seem very wise to me....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
