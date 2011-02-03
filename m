Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p131GIOt088771 for <xfs@oss.sgi.com>; Wed, 2 Feb 2011 19:16:19 -0600
Received: from straum.hexapodia.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81DDD1279C29
	for <xfs@oss.sgi.com>; Wed,  2 Feb 2011 17:18:46 -0800 (PST)
Received: from straum.hexapodia.org (straum.hexapodia.org [207.7.131.186]) by
	cuda.sgi.com with ESMTP id vQ35KiyLxVDWDDJt for
	<xfs@oss.sgi.com>; Wed, 02 Feb 2011 17:18:46 -0800 (PST)
Date: Wed, 2 Feb 2011 17:18:45 -0800
From: Andy Isaacson <adi@hexapodia.org>
Subject: Re: XFS stat/statvfs problems with 2.6.38-rc2-00175-g6fb1b30
Message-ID: <20110203011845.GL11874@hexapodia.org>
References: <20110202023644.GA25214@hexapodia.org>
	<20110202221858.GS11040@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110202221858.GS11040@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Feb 03, 2011 at 09:18:58AM +1100, Dave Chinner wrote:
> On Tue, Feb 01, 2011 at 06:36:44PM -0800, Andy Isaacson wrote:
> > Since updating past 2.6.37, I'm seeing du(1) sometimes report files
> > taking up 8GB even though ls(1) reports the correct size (hundreds of
> 
> It'll be the excessive specualtive preallocation bug introduced in
> .38-rc1  which is fixed in .38-rc3.

Indeed, I've been running 2.6.38-rc3-00019-gafe8a88 for 18 hours now
with the same load and not seen any issues.

Thanks,
-andy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
