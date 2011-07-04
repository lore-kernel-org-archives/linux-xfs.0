Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p644YtvM106558 for <xfs@oss.sgi.com>; Sun, 3 Jul 2011 23:34:55 -0500
Received: from b.mail.sonic.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13405524070
	for <xfs@oss.sgi.com>; Sun,  3 Jul 2011 21:34:54 -0700 (PDT)
Received: from b.mail.sonic.net (b.mail.sonic.net [64.142.19.5]) by
	cuda.sgi.com with ESMTP id OZZQ4DUV2x6KFxd3 for
	<xfs@oss.sgi.com>; Sun, 03 Jul 2011 21:34:54 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <44866.1309754093@sonic.net>
Date: Sun, 03 Jul 2011 21:34:53 -0700
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com



On Sun 03/07/11  3:14 PM , Eric Sandeen <sandeen@sandeen.net> wrote:

[some rearranging]

> You're welcome but here's the obligatory plug in return - running RHEL5
> proper would have gotten you up to date, fully supported xfs, and you
> wouldn't have run into this mess. Just sayin' ... ;)

Yep, that's definitely a lesson learned.  Though I don't think I can blame CentOS either--from what I can tell the bug has been available from yum for some time now.  So it's pretty much entirely my own fault.  :(

I also am sorry for not preserving threading--for some reason, the SGI mailserver rejected mail from my normal host (which is odd, as it's not in any blacklists I know of), so I am using an unfamiliar mail client.

> You probably hit this bug:
> http://oss.sgi.com/archives/xfs/2007-01/msg00053.html [1]
> 
> See also:
> http://oss.sgi.com/archives/xfs/2009-07/msg00087.html [2]
> 
> I can't remember how much damage the original bug did ...

If any?  I'm a bit amazed that, if there was damage, that the filesystem is still usable.  Perhaps if I were to fill it it would show signs of inconsistency?  Or remounting would read the now-incorrect values from the superblock 0?

> is it still mounted I guess?

Yes, it's still mounted, and as far as I can tell perfectly fine.  But I won't really know till I can throw xfs_repair -n and/or xfs_db and/or remount it; I'm choosing to get as much data off as I can before I try these things, just in case.

How safe is running xfs_db with -r on my mounted filesystem?  I understand that results might not be consistent, but on the off chance that they are I am hoping that it might be at least a little helpful.

I was re-reading some of the threads I posted in my original messages, in particular these posts:

http://oss.sgi.com/archives/xfs/2009-09/msg00210.html
http://oss.sgi.com/archives/xfs/2009-09/msg00211.html

If I am reading those, plus the xfs_db man page, correctly, it seems like what Russell suggested was to look at superblock 1 (or some other one?) and use those values to correct superblock 0.  At what points (if any) are the other superblocks updated?  I was testing on another machine, on a filesystem that I had successfully grown using xfs_growfs, and of the two values Russell suggested the OP to change, dblocks is different between sb 0 and sb 1, but agcount is not.  Could that just be that I did not grow the filesystem too much, so that agcount didn't need to change?  That seems a bit counterintuitive, but (as should be obvious) I don't know XFS all that well.  I am hoping to know because, in re-reading those messages, I got a better idea of what those particular xfs_db commands do, so that if I did run into problems remounting, I might be able to determine the appropriate new values myself and reduce my downtime.  But I want to understand more what I'm doing before I try!
  that!

--keith

-- 
kkeller@sonic.net

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
