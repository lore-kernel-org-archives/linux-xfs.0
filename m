Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oANElxph222749 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 08:47:59 -0600
Received: from ssec.wisc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 00427152557E
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 06:49:36 -0800 (PST)
Received: from ssec.wisc.edu (mahogany.ssec.wisc.edu [128.104.110.2]) by
	cuda.sgi.com with ESMTP id DaDLKa5bt8hd0QyQ for
	<xfs@oss.sgi.com>; Tue, 23 Nov 2010 06:49:36 -0800 (PST)
Message-ID: <4CEBD47F.1040004@ssec.wisc.edu>
Date: Tue, 23 Nov 2010 08:49:35 -0600
From: Jesse Stroik <jstroik@ssec.wisc.edu>
MIME-Version: 1.0
Subject: Re: Improving XFS file system inode performance
References: <4CEAE7D7.6050401@ssec.wisc.edu>
	<20101122232528.21b78a9e@galadriel.home>
	<4CEAEF66.7030708@ssec.wisc.edu> <20101122234419.GK13830@dastard>
In-Reply-To: <20101122234419.GK13830@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Linux XFS <xfs@oss.sgi.com>

Dave,

Thanks.  This is precisely what I was looking for.  I'll let you know 
how it turns out.

As this file system is likely to continue to increase in number of files 
at a fairly rapid rate, we're going to need a long term strategy.  I 
suspect it may be necessary in the near future to double or quadruple 
the memory to 32GB or 64GB, but the uncertainty in the formula makes me 
nervous.

For a situation like this, it would be ideal if we could specify an 
inode cache size.

Thanks,
Jesse

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
