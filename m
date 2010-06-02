Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o52Np09Y120277 for <xfs@oss.sgi.com>; Wed, 2 Jun 2010 18:51:00 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D97301B1941C
	for <xfs@oss.sgi.com>; Wed,  2 Jun 2010 16:53:27 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	mmUavHm7Tsi2B2K1 for <xfs@oss.sgi.com>;
	Wed, 02 Jun 2010 16:53:27 -0700 (PDT)
Date: Thu, 3 Jun 2010 09:53:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_quota timer
Message-ID: <20100602235325.GB8287@dastard>
References: <4C064FC6.5050401@sussex.ac.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C064FC6.5050401@sussex.ac.uk>
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
To: Albert Asawaroengchai <a.asawaroengchai@sussex.ac.uk>
Cc: xfs@oss.sgi.com

On Wed, Jun 02, 2010 at 01:34:14PM +0100, Albert Asawaroengchai wrote:
> Hi,
> 
> I'm trying to set the timer for a filesystem, but I don't understand how
> to use the syntax.
> 
> xfs_quota -x -c 'timer 1w user' /target/filesystem
> 
> The above doesn't seem to work, can anyone give advice or point me in
> the right direction?

$ man xfs_quota
.....
	timer [ -gpu ] [ -bir ] value

Grace timers are global in XFS, not per-user or per-group.

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
