Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1CLu9fX087363 for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 15:56:09 -0600
Received: from web30205.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id EFB2A18EBC63
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 13:55:33 -0800 (PST)
Received: from web30205.mail.mud.yahoo.com (web30205.mail.mud.yahoo.com
	[209.191.69.52]) by cuda.sgi.com with SMTP id tsBr2VWcH06fSsR9
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 13:55:33 -0800 (PST)
Message-ID: <159640.7088.qm@web30205.mail.mud.yahoo.com>
Date: Thu, 12 Feb 2009 13:55:33 -0800 (PST)
From: <raksac@yahoo.com>
Subject: Re: BUG: soft lockup detected on CPU#1!
In-Reply-To: <20090212214916.GS8830@disturbed>
MIME-Version: 1.0
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
Cc: xfs@oss.sgi.com


Hi Dave,

No it does not. Just sits there any access to mount
point (ll) also blocks forever.

I must point out that I brought the changes from
2.6.28.4 xfs into my private space and that seems to
show improvement on test 008 however now test 011 dies
with kernel oops.

Please see my reply posts.

Thanks,
Rakesh
--- Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Feb 10, 2009 at 11:16:25PM -0800,
> raksac@yahoo.com wrote:
> > 
> > Hello,
> > 
> > I am running the 2.6.28 based xfs kernel driver on
> a
> > custom kernel with following kernel config
> enabled.
> > 
> > CONFIG_PREEMPT
> > CONFIG_DETECT_SOFTLOCKUP
> > 
> > Running the following xfsqa causes a soft lockup.
> The
> > configuration is a x86 with Hyperthreading, 4GB
> RAM
> > and a AHCI connected JBOD. Its 100% reproducible.
> 
> Is the system making progress, or has it hung? i.e.
> does the test
> complete?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 



      

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
