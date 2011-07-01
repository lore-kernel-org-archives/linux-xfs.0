Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p61Gik6u081287 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 11:44:46 -0500
Received: from a.mail.sonic.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70EC81675FC5
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 09:44:41 -0700 (PDT)
Received: from a.mail.sonic.net (a.mail.sonic.net [64.142.16.245]) by
	cuda.sgi.com with ESMTP id paKyhxtQSaRO6Zy0 for
	<xfs@oss.sgi.com>; Fri, 01 Jul 2011 09:44:41 -0700 (PDT)
Received: from webmail.sonic.net (b.webmail.sonic.net [69.12.208.80])
	by a.mail.sonic.net (8.13.8.Beta0-Sonic/8.13.7) with ESMTP id
	p61GifeR000730 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 09:44:41 -0700
MIME-Version: 1.0
Message-ID: <51043.1309538681@sonic.net>
Date: Fri, 01 Jul 2011 09:44:41 -0700
Subject: Re: xfs_growfs doesn't resize
From: kkeller@sonic.net
Reply-To: kkeller@sonic.net
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

Thanks for the response, Dave!  I have some additional questions inline.


On Fri 01/07/11  3:46 AM , Dave Chinner <david@fromorbit.com> wrote:

> So either way, you will have to unmount the filesystem.

Yikes!  I am guessing that may put the filesystem at risk of not being able to re-mount without xfs_db commands, as happened to the other posters I cited.  If I want to minimize the amount of downtime if umounting does cause the fs not to be mountable, is there a way for me to look at the xfs_db output after I umount, and calculate any new parameters myself?  Or is that considered generally unwise, and xfs_db needs an expert to look at the output?  I want to minimize downtime, but I also want to minimize the risk of data loss, so I wouldn't want to derive my own xfs_db commands unless it was very safe.  (Even with backups available, it's more work to switch over or restore if I do lose the filesystem; we're a small group so we don't have an automatic failover server.)

Are there any other docs concerning using xfs_db?  I saw a post from last year that said that there weren't, but I'm wondering if that's changed since then.  There is of course the man page, but that doesn't describe how to interpret what's going on from its output (or what the correct steps to take are if there's a problem).

> > ==Assuming my filesystem is healthy, will a simple kernel update
> > (and reboot of course!) allow me to resize the filesystem in one
> > step, instead of 2TB increments?
> 
> I'd upgrade both kernel and userspace.

Would you recommend upgrading userspace from source?  CentOS 5 still calls the version available (from their centosplus repo) 2.9.4, but I haven't investigated what sort of patches they may have applied.


--keith


-- 
kkeller@sonic.net


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
