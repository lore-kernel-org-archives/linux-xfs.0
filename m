Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5R492pZ030491 for <xfs@oss.sgi.com>; Sun, 26 Jun 2011 23:09:03 -0500
Received: from Ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0EA801670E72
	for <xfs@oss.sgi.com>; Sun, 26 Jun 2011 21:09:01 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id D4sHy7HCjtMXuWBC for
	<xfs@oss.sgi.com>; Sun, 26 Jun 2011 21:09:01 -0700 (PDT)
Message-ID: <4E080249.9060903@tlinx.org>
Date: Sun, 26 Jun 2011 21:08:41 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: question on new feature complexity/possibility/sensibility? (^
	Alternate)
References: <4E067D81.4070605@tlinx.org> <20110627003209.GD32466@dastard>
In-Reply-To: <20110627003209.GD32466@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>



Dave Chinner wrote:
> So use a filesystem that supports them natively ;)
---
	Got any in in mind that also support acls, extended attrs
and has the reliability and performance of xfs?  ;-)
> 
>> I.e. being able to hardlink files, but have an option to mark it as
>> copy on write -- allowing space to be save when copying directory trees,
>> but then dynamically making new copies when someone updates one of the
>> linked copies.
> 
> The problem is that a reflink sort of looks like a hard link, but in
> many cases behaves like a soft link (e.g. different owners,
> permissions, etc are possible) and hence - combined with the
> copy-on-write behaviour - they need to be treated more like a
> soft-link in terms of implementation.
----
	I can see this -- now this doesn't mean we are talking the same
type of reflink with the shared data above is it?  Cuz in this lower
case, I was talking about hmmm....interesting....

	I was thinking of just a copy-of-the whole file on write,
but that'd be a potential pain on some systems depending on the file
size....   

> Soft links have their own
> inode so can hold state separate to the inode they are pointing to,
> and for reflinked files it is simply not practical to retroactively
> modify the directory structure to point at a different inode when
> the first COW operation occurs.
----
	I see....   
> 
> Like I said, it can be done, but it's not a small project. If you
> want to sink a significant amount of development time to the
> project, we will help you in any way we can. However, I don't think
> anyone has the time to do something like this for you....
---
	If I had the time and mental resources...I'd love to.
But am a bit overwhelmed for time now, and even if I wasn't, I'd
not be anywhere near certain I'd be able to maintain continuous focus
for the length of time necessary to do that length of project....  
if you know what I mean...

	Maybe certain if it was something that I or others could break
down into useful 'subchunks' that could go in at separate times.  Nothing
useless by itself (if nothing less than specific 'upgrading' of 
data infrastructure (data fields on disk, routines to parse such...etc),
but the whole thing at once seems pretty large.

(I know...I'm being a wimp)...

to support such things in the future


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
