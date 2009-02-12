Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1CM8wlS088132 for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 16:08:58 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DDC821925B4A
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 14:08:21 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	QXWZB9qfyiMKvsIZ for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2009 14:08:21 -0800 (PST)
Date: Fri, 13 Feb 2009 09:08:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs preallocation timeout
Message-ID: <20090212220803.GU8830@disturbed>
References: <200902111522.11987@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200902111522.11987@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Wed, Feb 11, 2009 at 03:22:11PM +0100, Michael Monnerie wrote:
> Does /proc/sys/vm/dirty_expire_centisecs influence the maximum time XFS 
> takes before the "in-memory but not on disk" preallocation actually 
> starts writing to disk?

Yes.

BTW, you are referring to "delayed allocation", not
"pre-allocation". Pre-allocation is the act of immediately
allocating space on disk without writing data; delayed allocation is
avoiding allocation until the data is to be written to disk...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
