Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p43KNms2028128 for <xfs@oss.sgi.com>; Tue, 3 May 2011 15:23:49 -0500
Received: from mail.perches.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 493B31E1AF31
	for <xfs@oss.sgi.com>; Tue,  3 May 2011 13:27:25 -0700 (PDT)
Received: from mail.perches.com (mail.perches.com [173.55.12.10]) by
	cuda.sgi.com with ESMTP id g6RdT78rctw8uwhS for
	<xfs@oss.sgi.com>; Tue, 03 May 2011 13:27:25 -0700 (PDT)
Subject: Re: [PATCH] xfs: kill off xfs_printk()
From: Joe Perches <joe@perches.com>
In-Reply-To: <a7077b2b2f6f46ac48d03cff4ccede2feba18f07.1304453673.git.aelder@sgi.com>
References: <a7077b2b2f6f46ac48d03cff4ccede2feba18f07.1304453673.git.aelder@sgi.com>
Date: Tue, 03 May 2011 13:27:24 -0700
Message-ID: <1304454444.1788.34.camel@Joe-Laptop>
Mime-Version: 1.0
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
Cc: xfs@oss.sgi.com

On Tue, 2011-05-03 at 15:14 -0500, Alex Elder wrote:
> From: Joe Perches <joe@perches.com>
> 
> xfs_alert_tag() can be defined using xfs_alert(), and thereby avoid
> using xfs_printk() altogether.  This is the only remaining use of
> xfs_printk(), so changing it this way means xfs_printk() can simply
> be eliminated.can simply be eliminated.can simply be eliminated.can
> simply be eliminated.can simply be eliminated.can simply be
> eliminated.can simply be eliminated.can simply be eliminated.can
> simply be eliminated.

Recursion overflow?


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
