Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8NA12th120311 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 05:01:03 -0500
Received: from phd-imap.ethz.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A8DF112E68B2
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 03:14:30 -0700 (PDT)
Received: from phd-imap.ethz.ch (phd-imap.ethz.ch [129.132.80.51]) by
	cuda.sgi.com with ESMTP id HNnfJOWETolQyGjh for
	<xfs@oss.sgi.com>; Thu, 23 Sep 2010 03:14:30 -0700 (PDT)
Subject: Re: XFS errors on large Infiniband fileserver setup
MIME-Version: 1.0
Date: Thu, 23 Sep 2010 12:01:55 +0200
From: Christian Herzog <horeizo@phys.ethz.ch>
In-Reply-To: <29252416bd0d9dc973a909e411dbec6a@phys.ethz.ch>
References: <29252416bd0d9dc973a909e411dbec6a@phys.ethz.ch>
Message-ID: <eb1b2cfa58cddc44c92c3a87a0e0a6c4@phys.ethz.ch>
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


Dear list,

my colleague has been running tests without ISER all morning, and so
far we haven't encountered an error, even though we have copied > twice
as much data as for the other tests. Is it possible that a problem in
the transport layer remains undetected and only manifests itself in the
filesystem?

thanks again,
-Christian




> following modifications have been suggested and we're working on them
> right now:
> 
> - try w/o ISER (direct IB over TCP)
> - try an XFS filesystem < 2T
> - try RHEL or SLES (will take more time)
> 
> We already had to change the I/O scheduler from Deadline to CFQ in
> order to get it up and running at all and also tried to change the
> kernel from stock LTS to 2.6.34-020634-generic, but we still get the
> FS errors.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
