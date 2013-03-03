Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9EEF0800E
	for <xfs@oss.sgi.com>; Sat,  2 Mar 2013 19:19:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1C9FBAC002
	for <xfs@oss.sgi.com>; Sat,  2 Mar 2013 17:19:21 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	BW1cVdufErDe9IX7 for <xfs@oss.sgi.com>;
	Sat, 02 Mar 2013 17:19:20 -0800 (PST)
Date: Sun, 3 Mar 2013 12:19:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Do not check ocfs2
Message-ID: <20130303011917.GI23616@dastard>
References: <1362269150-21478-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1362269150-21478-1-git-send-email-richard@nod.at>
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
To: Richard Weinberger <richard@nod.at>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Sun, Mar 03, 2013 at 01:05:50AM +0100, Richard Weinberger wrote:
> We cannot run fsck.ocfs2 because the file system
> is most likely mounted on another node.

This patch means that ocfs2 filesystems are *never* checked for
consistency, even when you are testing them with exclusive local
access. That defeats a primary function of xfstests - ensuring that
the tests run do no corrupt the filesystem.

Besides, why would you be running xfstests on a filesystem that is
mounted on multiple nodes? Yes, ocfs2 is a cluster filesystem, but
xfstests is designed to test local filesystem behaviour and is
completely cluster naive. Hence having multiple nodes mount the
filesystem that is being tested by xfstests does not serve any
purpose at all. Further, turning off consistency checking for those
that are running ocfs2 testing on single nodes means that testing is
now mostly wasted as the majority of problems that can occur are no
longer detectable....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
