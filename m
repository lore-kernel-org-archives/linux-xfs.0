Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p43KHmCX027982 for <xfs@oss.sgi.com>; Tue, 3 May 2011 15:17:48 -0500
Subject: Re: [PATCH] xfs: kill off xfs_printk()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <a7077b2b2f6f46ac48d03cff4ccede2feba18f07.1304453673.git.aelder@sgi.com>
References: <a7077b2b2f6f46ac48d03cff4ccede2feba18f07.1304453673.git.aelder@sgi.com>
Date: Tue, 3 May 2011 15:21:22 -0500
Message-ID: <1304454082.2853.46.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: Joe Perches <joe@perches.com>

On Tue, 2011-05-03 at 15:14 -0500, Alex Elder wrote:
...
> xfs_alert_tag() can be defined using xfs_alert(), and thereby avoid
> using xfs_printk() altogether.  This is the only remaining use of
> xfs_printk(), so changing it this way means xfs_printk() can simply
> be eliminated.can simply be eliminated.can simply be eliminated.can
> simply be eliminated.can simply be eliminated.can simply be
> eliminated.can simply be eliminated.can simply be eliminated.can
> simply be eliminated.

. . .


In case it wasn't clear from my text, xfs_printk() can
simply be eliminated.

(I don't know how all those duplicates got in there.)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
