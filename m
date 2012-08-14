Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7ELe9Zk011771 for <xfs@oss.sgi.com>; Tue, 14 Aug 2012 16:40:09 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	g09DmXxQ3DrpDzD5 for <xfs@oss.sgi.com>;
	Tue, 14 Aug 2012 14:40:08 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1T1OqM-0006yT-ST
	for xfs@oss.sgi.com; Wed, 15 Aug 2012 07:40:06 +1000
Date: Wed, 15 Aug 2012 07:40:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/10] xfstests: rework large filesystem testing
Message-ID: <20120814214006.GP2877@dastard>
References: <1343291989-14987-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1343291989-14987-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

ping?

On Thu, Jul 26, 2012 at 06:39:39PM +1000, Dave Chinner wrote:
> This is a resend of a series that has been sitting inmy local
> workarea for months. It reworks the large filesystem testing
> infrastructure for XFS to allow it to use xfs_repair by switching
> the filesystem filling to using preallocation rather than xfs_db
> hacks.
> 
> It also introduces support for ext4 testing, also via preallocation
> to fill the filesystem. btrfs isn't yet supported because I haven't
> worked out how to reliably get the size of the filesystem and
> calculate how much space is actually available in it.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 
> -- 
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is
> believed to be clean.
> 
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
