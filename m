Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:36501 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752067AbcLOV24 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 16:28:56 -0500
Received: by mail-pg0-f51.google.com with SMTP id f188so23860720pgc.3
        for <linux-xfs@vger.kernel.org>; Thu, 15 Dec 2016 13:28:56 -0800 (PST)
Date: Thu, 15 Dec 2016 13:20:37 -0800
From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] xfs_io: implement 'set_encpolicy' and 'get_encpolicy'
 commands
Message-ID: <20161215212037.GA103871@google.com>
References: <1480371512-12493-1-git-send-email-ebiggers@google.com>
 <c6553dba-e7da-0692-cc2e-a1a59aaa8bf8@sandeen.net>
 <9445b3d2-d0d9-dec2-1c92-3e4e103a711e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9445b3d2-d0d9-dec2-1c92-3e4e103a711e@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Richard Weinberger <richard@nod.at>, David Gstir <david@sigma-star.at>, Michael Halcrow <mhalcrow@google.com>

On Thu, Dec 15, 2016 at 01:40:12PM -0600, Eric Sandeen wrote:
> On 12/14/16 10:19 PM, Eric Sandeen wrote:
> >> +
> >> +static int
> >> +get_encpolicy_f(int argc, char **argv)
> >> +{
> >> +	struct fscrypt_policy policy;
> >> +
> >> +	if (ioctl(file->fd, FS_IOC_GET_ENCRYPTION_POLICY, &policy) < 0) {
> >> +		fprintf(stderr, "%s: failed to get encryption policy: %s\n",
> >> +			file->name, strerror(errno));
> >> +		return 1;
> > Ok, I need to go look at dave's other patch series to give you guidance
> > on what to return here, or anything else under the foo_f() functions.
> > 
> > see [PATCH 0/6] xfs_io: fix up command iteration - I need to see how dave
> > wants that all to work now.  Prior to that, anyway, most commands returned
> > 0 even on an error, and possibly set exitcode = 1, but I have to see what
> > that patchset does.
> 
> Ok, having looked at dave's patchset, it doesn't really change this yet.
> 
> Today, almost every command returns 0 regardless of failure, but sets
> exitcode=1 if a failure occurred.  This lets command processing continue,
> but results in an ultimate non-zero exit from the utility.
> 
> For argument parsing, failures should almost certainly return 0;
> even command_usage() does this.
> 
> For functional failures, see i.e. allocsp_f:
> 
>         if (xfsctl(file->name, file->fd, XFS_IOC_ALLOCSP64, &segment) < 0) {
>                 perror("XFS_IOC_ALLOCSP64");
>                 return 0;
>         }
> 
> (though that didn't set exitcode...)
> 
> This all needs cleanup across xfs_io, but I think these new functions will
> be outliers for now if you are returning 1 in many locations under your
> new foo_f functions.  Unless you want commandline processing to stop,
> and for interactive shell to quit, you probably want to switch to returning
> 0 even on errors, (usually after printing a message.)
> 
> At some point we should probably clean this up, and possibly make it
> continue for interactive shell, but stop for commandline operation,
> or something along those lines.  But that's for another day ...
> 

Okay, I guess I'll make them always return 0, and additionally set exitcode=1 if
the actual ioctl failed.  I'll send v2 of the patch to address this and your
other comments.

I'm not an expert in xfs_io or xfsprogs, but the way I would have expected it to
work is that commands would return a nonzero value if they fail, and then the
higher level logic would use that value to decide whether to continue on and
what to use as the overall exit status --- probably continue by default, then
exit with failure status overall if any one command failed.

Thanks,

Eric
