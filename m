Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n082JMQ1025525 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 20:19:22 -0600
Message-ID: <4965629C.2000703@sgi.com>
Date: Thu, 08 Jan 2009 13:19:08 +1100
From: Mark Goodwin <markgw@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump support for 64K page size
References: <4964C5EF.3060308@sgi.com>
In-Reply-To: <4964C5EF.3060308@sgi.com>
Reply-To: markgw@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs@oss.sgi.com



Bill Kendall wrote:
> Various fixes to allow xfsdump/xfsrestore to work with 64K
> page size. This is essentially Chinner's patch from a while
> back.
>
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

Lachlan reviewed and ack'd this on an internal list and I've committed
it (on Bill's behalf) as follows :

git://oss.sgi.com/xfs/cmds/xfsdump.git
	commit 9502587dbbfdd465958889a568dc2842f10b1ff9
	Author: Mark Goodwin <markgw@sgi.com>
	Date:   Thu Jan 8 12:37:53 2009 +1100

	    Various fixes to allow xfsdump/xfsrestore to work with 64K
	    page size. This is essentially Chinner's patch from a while
	    back.
	
	    Signed-off-by: Bill Kendall <wkendall@sgi.com>
	    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
	    Signed-off-by: Mark Goodwin <markgw@sgi.com>

and for the libhandle changes :

git://oss.sgi.com/xfs/cmds/xfsprogs.git
	commit aa23a327ad7bb659f94c492119c928038d13b069
	Author: Mark Goodwin <markgw@sgi.com>
	Date:   Thu Jan 8 12:37:11 2009 +1100

	    Various fixes to allow xfsdump/xfsrestore to work with 64K
	    page size. This is essentially Chinner's patch from a while
	    back.
	
	    Signed-off-by: Bill Kendall <wkendall@sgi.com>
	    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
	    Signed-off-by: Mark Goodwin <markgw@sgi.com>

This introduces a dependency between xfsdump and libhandle (in xfsprogs),
which may or may not be an issue now that the cmds are in split trees.
I guess maybe xfsdump/restore should rightfully be part of xfsprogs?

In any case, Christoph, please pull these commits into your kernel.org 
-dev trees.

Thanks
-- Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
