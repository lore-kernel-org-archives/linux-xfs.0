Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 May 2007 23:10:39 -0700 (PDT)
Received: from mail.ggsys.net (mail.ggsys.net [69.26.161.131])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4P6AYWt001120
	for <xfs@oss.sgi.com>; Thu, 24 May 2007 23:10:36 -0700
Subject: Re: raid5: I lost a XFS file system due to a minor IDE cable
	problem
From: Alberto Alonso <alberto@ggsys.net>
In-Reply-To: <20070525045500.GF86004887@sgi.com>
References: <200705241318.30711.dap@mail.index.hu>
	 <Pine.LNX.4.64.0705240720040.16751@p34.internal.lan>
	 <20070525000547.GH85884050@sgi.com>
	 <1180056948.6183.10.camel@daptopfc.localdomain>
	 <20070525045500.GF86004887@sgi.com>
Content-Type: text/plain
Date: Fri, 25 May 2007 00:43:51 -0500
Message-Id: <1180071831.21028.125.camel@w100>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Pallai Roland <dap@mail.index.hu>, Linux-Raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com


> >  The difference between ext3 and XFS is that ext3 will remount to
> > read-only on the first write error but the XFS won't, XFS only fails
> > only the current operation, IMHO. The method of ext3 isn't perfect, but
> > in practice, it's working well.
> 
> XFS will shutdown the filesystem if metadata corruption will occur
> due to a failed write. We don't immediately fail the filesystem on
> data write errors because on large systems you can get *transient*
> I/O errors (e.g. FC path failover) and so retrying failed data
> writes is useful for preventing unnecessary shutdowns of the
> filesystem.
> 
> Different design criteria, different solutions...

I think his point was that going into a read only mode causes a
less catastrophic situation (ie. a web server can still serve
pages). I think that is a valid point, rather than shutting down
the file system completely, an automatic switch to where the least
disruption of service can occur is always desired.

Maybe the automatic failure mode could be something that is 
configurable via the mount options.

I personally have found the XFS file system to be great for
my needs (except issues with NFS interaction, where the bug report
never got answered), but that doesn't mean it can not be improved.

Just my 2 cents,

Alberto

> Cheers,
> 
> Dave.
-- 
Alberto Alonso                        Global Gate Systems LLC.
(512) 351-7233                        http://www.ggsys.net
Hardware, consulting, sysadmin, monitoring and remote backups
