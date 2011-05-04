Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p44EQNR0079352 for <xfs@oss.sgi.com>; Wed, 4 May 2011 09:26:23 -0500
Subject: Re: [PATCH] xfs: kill off xfs_printk()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110504004453.GC9114@dastard>
References: <a7077b2b2f6f46ac48d03cff4ccede2feba18f07.1304453673.git.aelder@sgi.com>
	<20110504004453.GC9114@dastard>
Date: Wed, 4 May 2011 09:29:58 -0500
Message-ID: <1304519398.2841.12.camel@doink>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Joe Perches <joe@perches.com>, xfs@oss.sgi.com

On Wed, 2011-05-04 at 10:44 +1000, Dave Chinner wrote:
> On Tue, May 03, 2011 at 03:14:44PM -0500, Alex Elder wrote:
> > From: Joe Perches <joe@perches.com>
> > 
> > xfs_alert_tag() can be defined using xfs_alert(), and thereby avoid
> > using xfs_printk() altogether.  This is the only remaining use of
> > xfs_printk(), so changing it this way means xfs_printk() can simply
> > be eliminated.can simply be eliminated.can simply be eliminated.can
> > simply be eliminated.can simply be eliminated.can simply be
> > eliminated.can simply be eliminated.can simply be eliminated.can
> > simply be eliminated.
> > 
> > Also add format checking to the non-debug inline function xfs_debug.
> > Miscellaneous function prototype argument alignment.
> > 
> > (Updated to delete the definition of xfs_printk(), which is
> > no longer used or needed.)
> > 
> > Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> If you are going to credit Joe as the original source of the patch
> in the commit (i.e. via the "From:" tag), you probably should copy
> in his original Signed-off-by tag as well....

Honestly I wasn't sure about that.  Since I changed it I
kind of hoped he'd acknowledge or sign off on it.  I guess
I'm still learning about the conventions for signing off
on things.  I want to give all credit properly, I just
don't always know the Right Way to do so.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
