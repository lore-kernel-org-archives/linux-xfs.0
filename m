Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p440fVTn042976 for <xfs@oss.sgi.com>; Tue, 3 May 2011 19:41:32 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 534141E1B038
	for <xfs@oss.sgi.com>; Tue,  3 May 2011 17:45:07 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	UP0UmsMiQHJ677Wg for <xfs@oss.sgi.com>;
	Tue, 03 May 2011 17:45:07 -0700 (PDT)
Date: Wed, 4 May 2011 10:44:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: kill off xfs_printk()
Message-ID: <20110504004453.GC9114@dastard>
References: <a7077b2b2f6f46ac48d03cff4ccede2feba18f07.1304453673.git.aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a7077b2b2f6f46ac48d03cff4ccede2feba18f07.1304453673.git.aelder@sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: Joe Perches <joe@perches.com>, xfs@oss.sgi.com

On Tue, May 03, 2011 at 03:14:44PM -0500, Alex Elder wrote:
> From: Joe Perches <joe@perches.com>
> 
> xfs_alert_tag() can be defined using xfs_alert(), and thereby avoid
> using xfs_printk() altogether.  This is the only remaining use of
> xfs_printk(), so changing it this way means xfs_printk() can simply
> be eliminated.can simply be eliminated.can simply be eliminated.can
> simply be eliminated.can simply be eliminated.can simply be
> eliminated.can simply be eliminated.can simply be eliminated.can
> simply be eliminated.
> 
> Also add format checking to the non-debug inline function xfs_debug.
> Miscellaneous function prototype argument alignment.
> 
> (Updated to delete the definition of xfs_printk(), which is
> no longer used or needed.)
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

If you are going to credit Joe as the original source of the patch
in the commit (i.e. via the "From:" tag), you probably should copy
in his original Signed-off-by tag as well....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
