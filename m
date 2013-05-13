Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE1647F37
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 19:13:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A6946304039
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 17:13:26 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	jk5mUaqZktDgo1aT for <xfs@oss.sgi.com>;
	Sun, 12 May 2013 17:13:25 -0700 (PDT)
Date: Mon, 13 May 2013 10:13:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfstests 200: remove words from output
Message-ID: <20130513001323.GH32675@dastard>
References: <1368349273-23968-1-git-send-email-tracek@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1368349273-23968-1-git-send-email-tracek@redhat.com>
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
To: Tomas Racek <tracek@redhat.com>
Cc: lczerner@redhat.com, xfs@oss.sgi.com

On Sun, May 12, 2013 at 11:01:12AM +0200, Tomas Racek wrote:
> Remove phrase "block device" from 200.out since mount warning message
> does not use it.

Yes it does:

$ sudo blockdev --setro /dev/vdb
$ sudo mount /dev/vdb /mnt/scratch
mount: block device /dev/vdb is write-protected, mounting read-only
mount: cannot mount block device /dev/vdb read-only

So this change will break a currently working test....

Have you just upgraded to a new core-utils installation? Your next
patch about apostrophes indicates that you probably have. If the
mount error output has changed as a result of the upgrade, you need
to add a filter so that both old and new versions emit the same
golden output....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
