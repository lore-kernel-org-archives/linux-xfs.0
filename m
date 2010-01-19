Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0JNaPiF225284 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 17:36:26 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E1998176C29
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 15:37:25 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id 9ytNw8XY6k2AwCDi for
	<xfs@oss.sgi.com>; Tue, 19 Jan 2010 15:37:25 -0800 (PST)
Message-ID: <4B564235.60403@sandeen.net>
Date: Tue, 19 Jan 2010 17:37:25 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: Convert all tests to use /bin/bash
References: <1263891633-30868-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1263891633-30868-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> While most tests use /bin/sh, they are dependent on /bin/sh being a
> bash shell.  Convert all the tests to execute via /bin/bash as it is
> much, much simpler than trying to debug and remove all the bashisms
> throughout the test code.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>

well, spoke a little too soon.

OK as far as it goes, but not quite far enough :)

the "new" file still contains sh and I guess it could be used
as a template so maybe fix that up.

and do you care about things like:

        | tee -a $here/$seq.full | sh


in 001?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
