Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C40977F93
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 08:27:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB4D98F8037
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 06:27:25 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	QkSlMB8dIGqMH0o2 for <xfs@oss.sgi.com>;
	Thu, 09 Apr 2015 06:27:23 -0700 (PDT)
Date: Thu, 9 Apr 2015 23:27:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Errors from basic open_by_handle operations
Message-ID: <20150409132720.GF13731@dastard>
References: <1504091316590.18609@sys953.ldn.framestore.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1504091316590.18609@sys953.ldn.framestore.com>
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
To: Mark Hills <mark.hills@framestore.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 09, 2015 at 01:53:31PM +0100, Mark Hills wrote:
> I am having troubles with elementary file handle functions in libhandle.
> 
> A basic open_by_handle is giving "Bad file descriptor".
> 
> But I am suspicious of a side effect; using path_to_fshandle earlier in 
> the program changes these errors to "Operation not permitted".

EPERM. Root permissions are required to convert file handles back to
file descriptors, as the handle could have been passed to anyone and
open_by_handle has no directory based access/permission checks to
determine if the user actually has permission to access the inode
behind the filehandle.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
