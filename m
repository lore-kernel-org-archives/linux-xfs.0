Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E206C7F3F
	for <xfs@oss.sgi.com>; Fri,  5 Sep 2014 06:19:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CF409304070
	for <xfs@oss.sgi.com>; Fri,  5 Sep 2014 04:19:40 -0700 (PDT)
Received: from mail-qg0-f42.google.com (mail-qg0-f42.google.com
	[209.85.192.42]) by cuda.sgi.com with ESMTP id HQ45p3JsZoJxDKjt
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 05 Sep 2014 04:19:36 -0700 (PDT)
Received: by mail-qg0-f42.google.com with SMTP id q107so2274894qgd.15
	for <xfs@oss.sgi.com>; Fri, 05 Sep 2014 04:19:35 -0700 (PDT)
In-Reply-To: <20140905110211.GA3208@laptop.bfoster>
References: <1409848708-42666-1-git-send-email-bfoster@redhat.com>
	<20140905004501.GU20518@dastard> <54090C33.2060102@sandeen.net>
	<20140905012404.GV20518@dastard>
	<20140905110211.GA3208@laptop.bfoster>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsrestore: use utimensat() to provide atime/mtime
	with	ns resolution
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Fri, 05 Sep 2014 07:19:29 -0400
Message-ID: <21bfe93e-aadc-47d9-a49d-ec5207a72d99@email.android.com>
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
To: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com



On September 5, 2014 7:02:12 AM EDT, Brian Foster <bfoster@redhat.com> wrote:
>On Fri, Sep 05, 2014 at 11:24:04AM +1000, Dave Chinner wrote:
>> On Thu, Sep 04, 2014 at 08:04:51PM -0500, Eric Sandeen wrote:
>> > On 9/4/14, 7:45 PM, Dave Chinner wrote:
>> > >On Thu, Sep 04, 2014 at 12:38:28PM -0400, Brian Foster wrote:
>> > >>xfsdump encodes and stores the full atime and mtime for each file
>with
>> > >>nanosecond resolution. xfsrestore uses utime() to set the times
>of each
>> > >>file that is restored. The latter supports resolution of 1
>second, thus
>> > >>sub-second timestamp data is lost on restore.
>> > >
>> > >That doesn't seem like a big deal. What sort of problems does this
>> > >actually cause?
>> > >
>> > >FYI, many linux filesystems only have second resolution timestamps
>> > >and hence applications can't rely on sub-second timestamp
>resolution
>> > >to actually mean anything useful....
>> > 
>> > But why not restore the same resolution as is actually stored in
>the dump?
>> > Throwing it away seems odd, and restoring it looks easy enough.
>> 
>> Comes from a time when we couldn't restore what was in the dump. :/
>> 
>> > In any case, there was a user who noticed & complained.  Seems like
>a
>> > very reasonable thing to fix, to me.
>> 
>> Sure, but we don't make changes with the justification "just
>> because". xfsrestore has had this behaviour since dump/restore was
>> first introduced, so first we need to understand what the actual
>> problem is. Was the user complaining because they noticed they were
>> "different" in passing, or was it noticed because the difference is
>> the root cause of some other problem?
>> 
>
>No problems that I'm aware of. As Eric mentioned, it was noticed during
>an evaluation of possible data transfer mechanisms for a glusterfs
>setup. The user had to evaluate whether it would lead to any issues (a
>geo-replication tracking thing I suspect) for a customer, but I hadn't
>heard anything that suggested it was. The utime() call appears to be
>obsolete as well, for whatever that's worth.
>
>Brian

During forensic exams, detailed examination of timestamps can be useful.  For instance I saw a report recently that timestamps with only milliseconds precision (xxx.yyy00000) are an indication that malware has overridden the timestamp.  

It seems that the Windows api in particular has a time set mechanism that supports millisecond precision only.  Thus xfs backing a samba share would I assume share that same forensic detail.

The average breach is not detected until months after the initial penetration, so a xfsrestore between the activity of interest and the time of the investigation is very much a possibility.

I don't know if you care about that use case.

Greg
-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
