Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1F55A803C
	for <xfs@oss.sgi.com>; Sat, 16 Feb 2013 00:51:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A91BAAC002
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 22:51:16 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZfMzcPtACAQq4Fk6 for <xfs@oss.sgi.com>;
	Fri, 15 Feb 2013 22:51:15 -0800 (PST)
Date: Sat, 16 Feb 2013 17:51:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsdump segfault
Message-ID: <20130216065111.GV26694@dastard>
References: <201302152220.46756.db@kavod.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201302152220.46756.db@kavod.com>
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
To: Daniel Browning <db@kavod.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 15, 2013 at 10:20:46PM -0800, Daniel Browning wrote:
> Hello folks, 
> 
> I ran into a segfault while running xfsdump, what should I do
> to find the cause?

xfsrestore segfaulted, not xfsdump.  Can you run xfsdump to dump to
a file, then xfsrestore to restore from the file, rather than piping
one into the other? That way we can determine what went wrong first.
i.e dump failing and restore segfaulting when the pipe was broken,
or restore segfaulting and dump stopping because the pipe was
broken....

Once you've worked out which failed, adding "-v verbose" or "-v
debug" flags to the the command line might give us more indication
of what went wrong.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
