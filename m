Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAM0mSwA161589 for <xfs@oss.sgi.com>; Sun, 21 Nov 2010 18:48:29 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 57FA013DDD92
	for <xfs@oss.sgi.com>; Sun, 21 Nov 2010 16:50:04 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	UqfYlzRAM1JPU7ry for <xfs@oss.sgi.com>;
	Sun, 21 Nov 2010 16:50:04 -0800 (PST)
Date: Mon, 22 Nov 2010 11:49:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: clarifications on inode64 mount option
Message-ID: <20101122004957.GF13830@dastard>
References: <C90EF576.118F%ivan.novick@emc.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <C90EF576.118F%ivan.novick@emc.com>
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
To: Ivan.Novick@emc.com
Cc: Timothy.Heath@emc.com, xfs@oss.sgi.com

On Sun, Nov 21, 2010 at 07:12:38PM -0500, Ivan.Novick@emc.com wrote:
> Hi all,
> 
> My understanding from the documentation is that inode64 allows
> inode numbers to be 64 bits in size rather than the default of
> 32.
> 
> Is this correct? 

Yes.

> Will the option work fine on 32 bit X86 builds?

Yes, with a few caveats - all userspace applications, libraries, etc
need to use stat64() rather than stat() so that 64 bit inode numbers
can be correctly exported to userspace.

> The documentation also says:
> "This is provided for backwards compatibility, but causes problems
> for backup applications that cannot handle large inode numbers."
> Is this a current issue?  Any examples of backup applications that
> have trouble reading a file system that uses this option?

See this discussion:

http://oss.sgi.com/archives/xfs/2010-04/msg00111.html

EMC Networker is one of the backup programs that has historically
not supported 64 bit inodes. Whether that is still true or not,
maybe you can find out for us. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
