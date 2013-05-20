Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EF0227CBF
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 21:01:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 89CC0AC001
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 19:01:39 -0700 (PDT)
Received: from limestone5.mail.cornell.edu (limestone5.mail.cornell.edu
	[128.253.83.165]) by cuda.sgi.com with ESMTP id
	ca2lwfvh63CUjdI3 for <xfs@oss.sgi.com>;
	Sun, 19 May 2013 19:01:38 -0700 (PDT)
Date: Sun, 19 May 2013 22:01:36 -0400 (EDT)
From: Josh Endries <endries@cs.cornell.edu>
Message-ID: <76015885.11204.1369015296087.JavaMail.root@coecis.cornell.edu>
In-Reply-To: <5196A4A7.6010805@sandeen.net>
References: <731755347.10846.1368808589019.JavaMail.root@coecis.cornell.edu>
	<5196A4A7.6010805@sandeen.net>
Subject: Re: Crash recovery/zero-byte file question
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Hello,

Thanks for the reply!

> > We have a RHEL 6.3 machine with a large XFS mount that suffered a
> > power outage.
> 
> For starters, have you engaged your RH support folks?

Unfortunately we don't have support for these machines. We have tons of RH machines and licenses, but only a few with paid support. Generally the (grant-funded) research machines don't include RH support. (And generally we don't run into problems like this. :))

> > When it came back up, it allegedly fixed itself, but
> > now many files are zero bytes. I found a bug report/errata fix at RH
> > that mentions something similar, which might be what we ran into.
> 
> Which one?  RH support can probably help you decide if that bug report
> applies, and where/when it was fixed.

This one: https://access.redhat.com/site/solutions/272673

You need a login to view that, though... I think this is the same one, which I just found today:

https://bugzilla.redhat.com/show_bug.cgi?id=845233

That URL is currently broken for me, so here is a cache of it:

http://webcache.googleusercontent.com/search?q=cache:3OjuPDd8A1AJ:https://bugzilla.redhat.com/show_bug.cgi%3Fid%3D845233+&cd=2&hl=en&ct=clnk&gl=us&client=firefox-a

Reading this, I'm no longer sure we have a kernel with the fix. That machine is running:

2.6.32-279.el6.x86_64

I'm not really sure when the files were created or how long it was idle before the crash... I wonder if ctime/mtime would be reliable for the files. I also don't know how to reproduce the situation in order to test if it's fixed in a later kernel. I can pull the power out to test if I knew how to modify files ahead of time such that they would zero themselves out.

> > We
> > are running a kernel that should have the fix as far as I can tell,
> > but we definitely have zero byte files that shouldn't be.
> 
> shouldn't be because they had all been properly synced to disk
> before the power loss, or?  (just in general, files not fsynced
> aren't guaranteed to be in any particular state if you lose power,
> though of course there are certain expectations of timely flushing).

No, I mean they shouldn't be zero normally. They weren't zero a week ago. In other words, the files definitely changed unexpectedly, I'm assuming due to the power outage. The files had not been touched in at least a few days before the crash, according to the researcher working on those files. If I read the report correctly, though, that might not matter much.

> > My question is: is there a way to restore this or fix it before going
> > to backups? Is it worth it to unmount and run xfs_check or similar?
> > Unfortunately, since the system came up and appeared to be working,
> > some users have been using that mount point.
> 
> If you have backups that's probably the best option.

There aren't any backups of these files. The researchers should be able to recreate them (I hope so); the data sets come from various places. It's a lot of data, so I was hoping I could recover something to lessen the downtime. They opted not to back up that directory because it's just too many TBs for normal backups.

I'm not really expecting to be able to restore everything, I just want to put some effort in to getting back what I can before telling them they need to start over...

Thanks,
Josh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
