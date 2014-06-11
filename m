Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D13407F3F
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 18:07:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7C12CAC006
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 16:07:13 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HjnXTbC9klu2lUZh for <xfs@oss.sgi.com>;
	Wed, 11 Jun 2014 16:07:10 -0700 (PDT)
Date: Thu, 12 Jun 2014 09:07:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: (Un)known issue with XFS group quotas on LVM?
Message-ID: <20140611230706.GL9508@dastard>
References: <CA+Bg6wd9CFKdHaAM-XyJx3royVb2-QdKqhmaamA-KMQk1TdieQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+Bg6wd9CFKdHaAM-XyJx3royVb2-QdKqhmaamA-KMQk1TdieQ@mail.gmail.com>
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
To: John Desantis <desantis@mail.usf.edu>
Cc: xfs@oss.sgi.com

On Wed, Jun 11, 2014 at 11:43:09AM -0400, John Desantis wrote:
> Hello list!
> 
> A big "thanks!" to all XFS developers for a great product.
> 
> Now, to the point!
> 
> We're using an XFS file system created on an LVM with a standard
> kernel (2.6.32-431.3.1). 

RHEL kernel? If so, you probably want to report it to your support
contact to see if it's a known issue with a fix/workaround.....

> We're using quotas without an issue, with
> the exception of the group quota.  It seems that group quotas are
> ignored at times, at least from our configuration (we use remote user
> and group look-ups and authentication).  I've only been able to get
> root running sudo -g dd.. to create a group file which reflects
> changes in the group quota limit.

That doesn't sound like a filesystem problem. Sounds more like the
remote user/group configuration is getting squashed. Do the systems
have the same user/group configurations, or are the clients sending
group IDs the server doesn't recognise?

As it is, describing the problem in text doesn't tell me anything
about the problem. You need to cut-n-paste the CLI and the output
showing the incorrect behaviour so we can attempt to reproduce the
same behaviour you are seeing.

> We've mounted the file system in question with both user and group
> quotas enabled;  I didn't see anywhere in the man page that said this
> isn't possible, although I did see where group and project quotas
> cannot be used simultaneously on the same file system.
> 
> Has anyone experienced this behavior before?  I feel that I did some
> pretty good searching in the archives, Google, and the BugZilla page,
> but there were no "real" results which seemed to describe the same
> issue we're facing.  Strace didn't provide any clues either.  I don't
> think it's a sync issue because I've allowed a few days to pass in
> between "test" runs.
> 
> I've tested the quota by:
> 
> 1.)  Using sudo -u user -g group dd.... on both the exported file
> system and its mount path on the server itself.
> 2.)  Using sudo -u user -g group dd.. on the client and the file
> system's mount path.
> 3.)  Using sudo -g group dd... on both the exported file system and
> its mount path on the server itself;  this method produces expected
> results.
> 4.)  Using sudo -g group dd.. on the client and the file system's
> mount path;  this method also produces expected results.
> 
> Items #1 and #2 produce the error.

I can't see how that is related to the filesystem - the filesystem
will either account for group quota usage or it won't. It doesn't
care what primary gid the process uses, it will simply account usage
to that...

> I just wanted to ping the list before creating a local testing group
> to see if it's an issue with remote group look-ups.

Quite possibly that's a problem when generating quota reports, but
again that's a userspace problem, not a filesystem quota accounting
issue...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
