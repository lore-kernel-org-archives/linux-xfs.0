Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p61AkVCj061259 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 05:46:31 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53E821D7ED74
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 03:46:28 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	PUEutiEjENmDRqpo for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 03:46:28 -0700 (PDT)
Date: Fri, 1 Jul 2011 20:46:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_growfs doesn't resize
Message-ID: <20110701104624.GS561@dastard>
References: <55283.1309476620@sonic.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55283.1309476620@sonic.net>
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
To: kkeller@sonic.net
Cc: xfs@oss.sgi.com

On Thu, Jun 30, 2011 at 04:30:20PM -0700, kkeller@sonic.net wrote:
> Hello again all,
> 
> I apologize for following up my own post, but I found some new information.
> 
> On Thu 30/06/11  2:42 PM , kkeller@sonic.net wrote:
> 
> > http://oss.sgi.com/archives/xfs/2008-01/msg00085.html
> 
> I found a newer thread in the archives which might be more relevant to my issue:
> 
> http://oss.sgi.com/archives/xfs/2009-09/msg00206.html
> 
> But I haven't yet done a umount, and don't really wish to.  So, my followup questions are:
> 
> ==Is there a simple way to figure out what xfs_growfs did, and whether it caused any problems?

Apart from looking at what is on disk with xfs_db in the manner that
is done in the first thread you quoted, no.


> ==Will I be able to fix these problems, if any, without needing a umount?

If you need to modify anything with xfs_db, then you have to unmount
the filesystem first.  And realistically, you need to unmount the
filesystem to make sure what xfs-db is reporting is not being
modified by the active filesystem.

So either way, you will have to unmount the filesystem.

> ==Assuming my filesystem is healthy, will a simple kernel update
> (and reboot of course!) allow me to resize the filesystem in one
> step, instead of 2TB increments?

I'd upgrade both kernel and userspace.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
