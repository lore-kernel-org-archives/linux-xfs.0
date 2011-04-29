Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3T0T19E030022 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 19:29:01 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 360DE41EF32
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 17:32:34 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	s5xOWs0hjmO9PpkG for <xfs@oss.sgi.com>;
	Thu, 28 Apr 2011 17:32:34 -0700 (PDT)
Date: Fri, 29 Apr 2011 10:32:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: convert External Log to Internal Log
Message-ID: <20110429003231.GS12436@dastard>
References: <4DB9FC37.8080904@slac.stanford.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DB9FC37.8080904@slac.stanford.edu>
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
To: Ling Ho <ling@slac.stanford.edu>
Cc: xfs@oss.sgi.com

On Thu, Apr 28, 2011 at 04:45:59PM -0700, Ling Ho wrote:
> Is there any way to convert from external log to internal log on RHEL 5.6?

Try dump-mkfs-restore - there's no simple way of converting an
existing filesystem.  At least, not without highly dangerous offline
manual xfs_db surgery that could corrupt the fs....

> I tried running xfs_growfs -i but it complains saying
> 
> xfs_growfs: failed to access external log for /dev/sdc
> 
> and the man page says -i is not implemented. I am using xfsprogs
> version 3.1.5.

Yup, not implemented and as such not supported.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
