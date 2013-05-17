Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EFB797F3F
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 16:44:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C6E9630406B
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 14:44:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 2AqNB0YxFKOSjLop for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 14:44:09 -0700 (PDT)
Message-ID: <5196A4A7.6010805@sandeen.net>
Date: Fri, 17 May 2013 16:44:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Crash recovery/zero-byte file question
References: <731755347.10846.1368808589019.JavaMail.root@coecis.cornell.edu>
In-Reply-To: <731755347.10846.1368808589019.JavaMail.root@coecis.cornell.edu>
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
To: Josh Endries <endries@cs.cornell.edu>
Cc: xfs@oss.sgi.com

On 5/17/13 11:36 AM, Josh Endries wrote:
> Hello,

Hi Josh -

> We have a RHEL 6.3 machine with a large XFS mount that suffered a
> power outage. 

For starters, have you engaged your RH support folks?

> When it came back up, it allegedly fixed itself, but
> now many files are zero bytes. I found a bug report/errata fix at RH
> that mentions something similar, which might be what we ran into.

Which one?  RH support can probably help you decide if that bug report
applies, and where/when it was fixed.

> We
> are running a kernel that should have the fix as far as I can tell,
> but we definitely have zero byte files that shouldn't be.

shouldn't be because they had all been properly synced to disk
before the power loss, or?  (just in general, files not fsynced
aren't guaranteed to be in any particular state if you lose power,
though of course there are certain expectations of timely flushing).

> My question is: is there a way to restore this or fix it before going
> to backups? Is it worth it to unmount and run xfs_check or similar?
> Unfortunately, since the system came up and appeared to be working,
> some users have been using that mount point.

If you have backups that's probably the best option.

-Eric

p.s. xfs_check is deprecated in favor of xfs_repair [-n]

> Thanks, Josh
> 
> _______________________________________________ xfs mailing list 
> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
