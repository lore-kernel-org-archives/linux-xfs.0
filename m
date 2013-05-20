Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4F1887CBF
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 21:22:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1A6108F8033
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 19:22:57 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id pzcCut8V8pUfjKKq for <xfs@oss.sgi.com>;
	Sun, 19 May 2013 19:22:56 -0700 (PDT)
Message-ID: <519988FF.3010702@sandeen.net>
Date: Sun, 19 May 2013 21:22:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Crash recovery/zero-byte file question
References: <731755347.10846.1368808589019.JavaMail.root@coecis.cornell.edu>
	<5196A4A7.6010805@sandeen.net>
	<76015885.11204.1369015296087.JavaMail.root@coecis.cornell.edu>
In-Reply-To: <76015885.11204.1369015296087.JavaMail.root@coecis.cornell.edu>
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

On 5/19/13 9:01 PM, Josh Endries wrote:
> Hello,
> 
> Thanks for the reply!
> 
>>> We have a RHEL 6.3 machine with a large XFS mount that suffered a
>>> power outage.
>>
>> For starters, have you engaged your RH support folks?
> 
> Unfortunately we don't have support for these machines. We have tons of RH machines and licenses, but only a few with paid support. Generally the (grant-funded) research machines don't include RH support. (And generally we don't run into problems like this. :))

ok

>>> When it came back up, it allegedly fixed itself, but
>>> now many files are zero bytes. I found a bug report/errata fix at RH
>>> that mentions something similar, which might be what we ran into.
>>
>> Which one?  RH support can probably help you decide if that bug report
>> applies, and where/when it was fixed.
> 
> This one: https://access.redhat.com/site/solutions/272673

well, that's a "solution" ;)

> You need a login to view that, though... I think this is the same one, which I just found today:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=845233
> 
> That URL is currently broken for me, so here is a cache of it:
> 
> http://webcache.googleusercontent.com/search?q=cache:3OjuPDd8A1AJ:https://bugzilla.redhat.com/show_bug.cgi%3Fid%3D845233+&cd=2&hl=en&ct=clnk&gl=us&client=firefox-a
> 
> Reading this, I'm no longer sure we have a kernel with the fix. That machine is running:
> 
> 2.6.32-279.el6.x86_64

Right, and:  "Fixed In Version: 	kernel-2.6.32-328.el6"

So this is a known bug and fixed, but you're not running the fix it seems.

> I'm not really sure when the files were created or how long it was
> idle before the crash... I wonder if ctime/mtime would be reliable
> for the files. I also don't know how to reproduce the situation in
> order to test if it's fixed in a later kernel. I can pull the power
> out to test if I knew how to modify files ahead of time such that
> they would zero themselves out.

I think you can be fairly certain that it's resolved in the above
kernel.

>>> We
>>> are running a kernel that should have the fix as far as I can tell,
>>> but we definitely have zero byte files that shouldn't be.
>>
>> shouldn't be because they had all been properly synced to disk
>> before the power loss, or?  (just in general, files not fsynced
>> aren't guaranteed to be in any particular state if you lose power,
>> though of course there are certain expectations of timely flushing).
> 
> No, I mean they shouldn't be zero normally. They weren't zero a week
> ago. In other words, the files definitely changed unexpectedly, I'm
> assuming due to the power outage. The files had not been touched in
> at least a few days before the crash, according to the researcher
> working on those files. If I read the report correctly, though, that
> might not matter much.

ok

>>> My question is: is there a way to restore this or fix it before going
>>> to backups? Is it worth it to unmount and run xfs_check or similar?
>>> Unfortunately, since the system came up and appeared to be working,
>>> some users have been using that mount point.
>>
>> If you have backups that's probably the best option.
> 
> There aren't any backups of these files. The researchers should be
> able to recreate them (I hope so); the data sets come from various
> places. It's a lot of data, so I was hoping I could recover something
> to lessen the downtime. They opted not to back up that directory
> because it's just too many TBs for normal backups.
> 
> I'm not really expecting to be able to restore everything, I just
> want to put some effort in to getting back what I can before telling
> them they need to start over...

Dave is more familiar with that bug than I am, but short of some serious
forensics & luck, I don't think you'll be able to get things back.

I'd update to the kernel mentioned above soon, though, and sorry
about the hassle.  :(

-Eric

> Thanks,
> Josh
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
