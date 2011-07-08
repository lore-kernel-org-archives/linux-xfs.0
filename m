Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p684mSRc213656 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 23:48:28 -0500
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E049E8E1E7
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 21:48:26 -0700 (PDT)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	HD8GgznFtGZU9Di5 for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 21:48:26 -0700 (PDT)
Received: by iyf40 with SMTP id 40so1541173iyf.26
	for <xfs@oss.sgi.com>; Thu, 07 Jul 2011 21:48:26 -0700 (PDT)
Message-ID: <4E168C16.6000408@uvic.ca>
Date: Thu, 07 Jul 2011 21:48:22 -0700
From: Paul Nienaber <phox@uvic.ca>
MIME-Version: 1.0
Subject: Re: xfs_quota: bug: traverses bind mountpoints
References: <4E161B1D.90301@uvic.ca> <20110708032351.GF1026@dastard>
In-Reply-To: <20110708032351.GF1026@dastard>
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
Cc: xfs@oss.sgi.com

I would definitely agree that this is perhaps perhaps quite nonsensical 
in the case of user/group quotas.  However, a project quota is 
conceptually a quota for "files in a directory and its subdirectories on 
a particular filesystem", and I would argue that, regardless of 
bindmounts, / is never a subdirectory of /foo, and this is where I think 
the change in behaviour should be.  There's also the somewhat-grey area 
of how 'project -C' should behave, and I suppose the simplest and most 
sensible answer there is "however 'project -s' and 'project -c' behave", 
as that's both at least somewhat sensible and the least likely to 
confuse people.  I'd be happy to go digging at find at some point soon.

cheers
~Paul

On 11-07-07 8:23 PM, Dave Chinner wrote:
> On Thu, Jul 07, 2011 at 01:46:21PM -0700, Paul Nienaber wrote:
>> So, much like coreutils' du (which also shouldn't), xfs_quota
>> traverses bind mountpoints both when doing 'project -s' and 'project
>> -C', and probably also 'project -c' although I haven't tested it.
>> Testcase and output follows.
> How is a userspace traversal supposed to detect the fact it crosses
> a bind mount when it enters a directory?  If you bind a directory
> from the same filesystem, stat(2) on the file returns -identical-
> information regardless of whether you are inside or outside the bind
> mount. So the normal mechanisms (e.g. st_dev changes) for detecting
> such a mount point traversal simply don't work.
>
> So the first question is whether we should be trying to detect bind
> mounts within the same filesystem and handling them for project
> quotas? I don't know the answer to that.
>
> Indeed:
>
> $ find .
> .
> ./projects
> ./projects/foo
> ./projects/foo/chroot
> find: File system loop detected; `./projects/foo/chroot/scratch' is
> part of the same file system loop as `.'.
> ./projects/bar
> ./projects/bar/foo
> ./baz
>
> find has some way of detecting such cases, but it doesn't do it via
> any special syscalls, nor does the newfstatat(AT_SYMLINK_NOFOLLOW)
> call it does return an error. And it does it regardless of whether
> the -xdev option is specified or not. So it must have some form of
> internal logic for detecting such loopy filesystem constructs.
>
> However, operations such as "chmod -R" do *not* detect this
> situation:
>
> $ sudo chown -R -v dave:dave *
> ownership of `baz' retained as dave:dave
> changed ownership of `projects/foo/chroot/scratch/projects/foo/chroot/scratch' to dave:dave
> changed ownership of `projects/foo/chroot/scratch/projects/foo/chroot' to dave:dave
> changed ownership of `projects/foo/chroot/scratch/projects/foo' to dave:dave
> changed ownership of `projects/foo/chroot/scratch/projects/bar/foo' to dave:dave
> changed ownership of `projects/foo/chroot/scratch/projects/bar' to dave:dave
> changed ownership of `projects/foo/chroot/scratch/projects' to dave:dave
> ownership of `projects/foo/chroot/scratch/baz' retained as dave:dave
> changed ownership of `projects/foo/chroot/scratch' to dave:dave
> changed ownership of `projects/foo/chroot' to dave:dave
> changed ownership of `projects/foo' to dave:dave
> ownership of `projects/bar/foo' retained as dave:dave
> ownership of `projects/bar' retained as dave:dave
> changed ownership of `projects' to dave:dave
>
> It's totally unclear what the behaviour of xfs_quota should be,
> because operations that change user and group quotas are completely
> ignorant of bind mounts.
>
> So if we decide bind mounts are important to detect, the second
> question is how do we detect bind mount point traversals in a
> reliable manner that doesn't involve adding significant overhead to
> the directory traversal code?  I don't know the answer to that,
> either, and if you care about this enough I guess you'll go and look
> up what find does and tell us about it ;)
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
