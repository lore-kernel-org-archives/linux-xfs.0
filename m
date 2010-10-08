Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o98Mp756068078 for <xfs@oss.sgi.com>; Fri, 8 Oct 2010 17:51:07 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34909D5768
	for <xfs@oss.sgi.com>; Fri,  8 Oct 2010 15:51:49 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	T5jA2OU0NE1F3QE3 for <xfs@oss.sgi.com>;
	Fri, 08 Oct 2010 15:51:49 -0700 (PDT)
Date: Sat, 9 Oct 2010 09:51:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ENOSPC at 90% with plenty of inodes
Message-ID: <20101008225146.GJ4681@dastard>
References: <AANLkTinwnOm0V=9WwbXiUGFnyjCwT3GUHo0hiQahQNUV@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTinwnOm0V=9WwbXiUGFnyjCwT3GUHo0hiQahQNUV@mail.gmail.com>
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
To: James Braid <jamesb@loreland.org>
Cc: xfs@oss.sgi.com

On Fri, Oct 08, 2010 at 06:17:52PM +0100, James Braid wrote:
> Hi,
> 
> On a fairly busy mail server hosting about 1000 cyrus mailboxes (each
> message is stored as a separate file), we are observing ENOSPC errors
> from the cyrus pop/imap daemons when attempting to create (tiny)
> files. e.g.
> 
> Oct  8 12:18:49 xxx cyrus/pop3[14119]: IOERROR: creating
> /user/imap/proc/14119: No space left on device
> Oct  8 12:18:49 xxx cyrus/lmtpunix[14361]: IOERROR: creating quota
> file /user/imap/quota/m/user.xx.NEW: No space left on device
> Oct  8 12:18:49 xxx cyrus/imap[12804]: IOERROR: creating quota file
> /user/imap/quota/d/user.xxx.NEW: No space left on device
> 
> The filesystem appears to have plenty of space available:
> 
> # df -i /user
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> /dev/sdb1            102294688 10201313 92093375   10% /user
> # df /user
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sdb1            213014148 190023408  22990740  90% /user
> 
> Any ideas for how can we go about debugging where ENOSPC is coming
> from? Unfortunately it's running a vintage 2.6.24 kernel (Ubuntu 8.04)
> - we're trying to get it upgraded to 10.04 (2.6.32)

Sounds like fragmented free space. What is the output of:

# xfs_db -r -c "freesp -s" <device>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
