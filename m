Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0C5CE7F3F
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 09:04:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6F22CAC006
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 07:04:32 -0700 (PDT)
Received: from mail-yh0-f42.google.com (mail-yh0-f42.google.com
	[209.85.213.42]) by cuda.sgi.com with ESMTP id ejed2PouDsPe87Dy
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 Jun 2014 07:04:30 -0700 (PDT)
Received: by mail-yh0-f42.google.com with SMTP id i57so997776yha.1
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 07:04:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140611230706.GL9508@dastard>
References: <CA+Bg6wd9CFKdHaAM-XyJx3royVb2-QdKqhmaamA-KMQk1TdieQ@mail.gmail.com>
	<20140611230706.GL9508@dastard>
Date: Thu, 12 Jun 2014 10:04:29 -0400
Message-ID: <CA+Bg6wdvZTYufmfK-U_6zwjKVDPVuQP_-Jwsqnh=1ayyB_EmEA@mail.gmail.com>
Subject: Re: (Un)known issue with XFS group quotas on LVM?
From: John Desantis <desantis@mail.usf.edu>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave,

Thanks for your reply.  Let me address your questions and replies.

> That doesn't sound like a filesystem problem. Sounds more like the
> remote user/group configuration is getting squashed. Do the systems
> have the same user/group configurations, or are the clients sending
> group IDs the server doesn't recognise?

Stracing shows that the group and user ID's are not being squashed and
they are resolving each time to their respective UID/GID's.

> As it is, describing the problem in text doesn't tell me anything
> about the problem. You need to cut-n-paste the CLI and the output
> showing the incorrect behaviour so we can attempt to reproduce the
> same behaviour you are seeing.

Busted.  I figured before sending the usual gamut of console "action",
I'd "save" time by simply presenting the symptoms.

> I can't see how that is related to the filesystem - the filesystem
> will either account for group quota usage or it won't. It doesn't
> care what primary gid the process uses, it will simply account usage
> to that...

You're correct (but you already knew this!).  I can tell you that
running the quota report does show the group block count changing.

It looks like this "issue" is  my misunderstanding of how XFS is
checking the quota.  Perhaps you could shed some light?

When you're using active user and group quotas on the same file system
and the user quota is lower than the group quota, does XFS first check
against the user quota and then the group quota?  Is the order of
operations user, group, and then project or does it depend on the
mounting order of quotas?

In the case I presented yesterday, the user in question had a quota of
25 GB, but the group had an unlimited quota.  Each time that I used
sudo -u user -g group or logged into the user's account, the quota was
always exceeded.  Now that I have removed the user's quota, the group
quota is now being respected properly.

Again, thank you!

John DeSantis


2014-06-11 19:07 GMT-04:00 Dave Chinner <david@fromorbit.com>:
> On Wed, Jun 11, 2014 at 11:43:09AM -0400, John Desantis wrote:
>> Hello list!
>>
>> A big "thanks!" to all XFS developers for a great product.
>>
>> Now, to the point!
>>
>> We're using an XFS file system created on an LVM with a standard
>> kernel (2.6.32-431.3.1).
>
> RHEL kernel? If so, you probably want to report it to your support
> contact to see if it's a known issue with a fix/workaround.....
>
>> We're using quotas without an issue, with
>> the exception of the group quota.  It seems that group quotas are
>> ignored at times, at least from our configuration (we use remote user
>> and group look-ups and authentication).  I've only been able to get
>> root running sudo -g dd.. to create a group file which reflects
>> changes in the group quota limit.
>
> That doesn't sound like a filesystem problem. Sounds more like the
> remote user/group configuration is getting squashed. Do the systems
> have the same user/group configurations, or are the clients sending
> group IDs the server doesn't recognise?
>
> As it is, describing the problem in text doesn't tell me anything
> about the problem. You need to cut-n-paste the CLI and the output
> showing the incorrect behaviour so we can attempt to reproduce the
> same behaviour you are seeing.
>
>> We've mounted the file system in question with both user and group
>> quotas enabled;  I didn't see anywhere in the man page that said this
>> isn't possible, although I did see where group and project quotas
>> cannot be used simultaneously on the same file system.
>>
>> Has anyone experienced this behavior before?  I feel that I did some
>> pretty good searching in the archives, Google, and the BugZilla page,
>> but there were no "real" results which seemed to describe the same
>> issue we're facing.  Strace didn't provide any clues either.  I don't
>> think it's a sync issue because I've allowed a few days to pass in
>> between "test" runs.
>>
>> I've tested the quota by:
>>
>> 1.)  Using sudo -u user -g group dd.... on both the exported file
>> system and its mount path on the server itself.
>> 2.)  Using sudo -u user -g group dd.. on the client and the file
>> system's mount path.
>> 3.)  Using sudo -g group dd... on both the exported file system and
>> its mount path on the server itself;  this method produces expected
>> results.
>> 4.)  Using sudo -g group dd.. on the client and the file system's
>> mount path;  this method also produces expected results.
>>
>> Items #1 and #2 produce the error.
>
> I can't see how that is related to the filesystem - the filesystem
> will either account for group quota usage or it won't. It doesn't
> care what primary gid the process uses, it will simply account usage
> to that...
>
>> I just wanted to ping the list before creating a local testing group
>> to see if it's an issue with remote group look-ups.
>
> Quite possibly that's a problem when generating quota reports, but
> again that's a userspace problem, not a filesystem quota accounting
> issue...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
