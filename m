Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46218 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751472AbdJ0RDl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Oct 2017 13:03:41 -0400
Date: Fri, 27 Oct 2017 19:03:39 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [RFC] xfs_repair: clear file / directory attribute on symlinks
Message-ID: <20171027170339.GA22894@wotan.suse.de>
References: <20171026225053.10263-1-mcgrof@kernel.org>
 <b52bcf80-6848-c3f3-c8bc-68e69054267c@sandeen.net>
 <20171027001118.GF5483@magnolia>
 <20171027002812.GV17331@wotan.suse.de>
 <7281013b-835e-031c-6ed0-dd0c220b271c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7281013b-835e-031c-6ed0-dd0c220b271c@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, Laurent Bonnaud <Laurent.Bonnaud@inpg.fr>, Tso Ted <tytso@mit.edu>, Flex Liu <fliu@suse.com>, Jake Norris <jake.norris@suse.com>, Jan Kara <jack@suse.cz>

On Fri, Oct 27, 2017 at 09:18:07AM +0300, Nikolay Borisov wrote:
> 
> 
> On 27.10.2017 03:28, Luis R. Rodriguez wrote:
> > On Thu, Oct 26, 2017 at 05:11:18PM -0700, Darrick J. Wong wrote:
> >> On Thu, Oct 26, 2017 at 06:48:53PM -0500, Eric Sandeen wrote:
> >>>> 	b) xfsctl()
> >>
> >> Requires an open file descriptor, path argument not used.  Returns EBADF if
> >> you opened a symlink with O_PATH|O_NOFOLLOW, which AFAIK is the only way to
> >> do that.
> > 
> > Hrm, were you suggesting you didn't think its possible to use xfsctl to
> > set some attributes? Because I was able to:
> > 
> > #include <xfs/xfs.h>
> > #include <stdlib.h>
> > #include <string.h>
> > #include <sys/stat.h>
> > #include <fcntl.h>
> > 
> > char *prog;
> > 
> > static void usage(void)
> > {
> > 		printf("Usage: %s [set|get] <file>\n", prog);
> > 		exit(1);
> > }
> > 
> > int main(int argc, char *argv[])
> > {
> > 	int ret = 0;
> > 	struct stat sb;
> > 	char *cmd_str, *file;
> > 	int cmd = 0;
> > 	int open_flags = 0;
> > 	int fd;
> > 	struct fsxattr fsx;
> > 
> > 	prog = argv[0];
> > 
> > 	if (argc != 3)
> > 		usage();
> > 
> > 	memset(&fsx, 0, sizeof(fsx));
> > 
> > 	/* First run is get to get old values */
> > 	cmd = FS_IOC_FSGETXATTR;
> > 
> > 	if ((strncmp("get", argv[1], 3) == 0))
> > 		open_flags = O_RDONLY;
> > 	else if (strncmp("set", argv[1], 3) == 0) {
> > 		cmd = FS_IOC_FSGETXATTR;
> > 		open_flags = O_RDWR | O_APPEND;
> > 	}
> > 

Remove the following chunk:

> > 	if (!open_flags)
> > 		usage();

Instead add an:

	else
		usage();

Given O_RDONLY is 0.

> > 
> > 	cmd_str = argv[1];
> > 
> > 	ret = stat(argv[2], &sb);
> > 	if (ret) {
> > 		printf("File may not be present or readable\n");
> > 		usage();
> > 	}

As per testing stat() won't work on a dangling sylink.

> > 
> > 	file = argv[2];
> > 
> > 	fd = open(file, open_flags);
> > 	if (!fd) {
> > 		printf("Could not open file for operation: %s\n", cmd_str);
> > 		usage();
> > 	}

This open() will though.

> > 	ret = xfsctl(file, fd, cmd, &fsx);
> > 	if (ret < 0) {
> > 		printf("Could not issue xfsctl GET flags\n");
> > 		exit(1);
> > 	}

And this xfsctl() won't work either.

> > 	if (strncmp("get", argv[1], 3) == 0)
> > 		goto out;
> > 
> > 	/* Now do the setting */
> > 	cmd = FS_IOC_FSSETXATTR;
> > 	fsx.fsx_xflags |= XFS_XFLAG_APPEND;
> > 
> > 	ret = xfsctl(file, fd, cmd, &fsx);
> > 	if (ret < 0) {
> > 		printf("Could not issue xfsctl SET flags\n");
> > 		exit(1);
> > 	}
> > 
> > out:
> > 	printf("fsxattr.xflags = 0x%x\n", fsx.fsx_xflags);
> > 
> > 	return 0;
> > }
> 
> 
> I think this program is not really working on the symlink but rather on
> the file it points to.

I've confirmed this, thanks! Not only does xfsctl() fail on a symlink alone,
but also stat(). I'll run some more test but indeed it does not see we currently
allow symlinks alone to get user attributes. This however is important
information for the commit log so will add it.

> If you have a dangling symlin then the open() call would just return ENOENT.

Actually open() seems to work just fine on a dangling symlink as per my tests.

> On the other hand, if the file exists when you open the symlink you will have
> actually opened the file it points to, not the symlink itself. And this
> behavior is actually controlled by the vfs traversal code. in path_lookupat:
> 
>         while (!(err = link_path_walk(s, nd))
> 
>                 && ((err = lookup_last(nd)) > 0)) {
> 
>                 s = trailing_symlink(nd);
>                 if (IS_ERR(s)) {
> 
>                         err = PTR_ERR(s);
> 
>                         break;
> 
>                 }
> 
>         }
> 
> In order to be able to set ioctl-xattr (as per Darick's convetion :D)
> you need to get a reference to a struct file with it's f_op set to
> xfs_file_operations, since that's where the unlocked_ioctl handler is.
> And for symlink that's forbidden by the vfs traversal code.

Unless someone slipped magic mushrooms on my coffee today open() seems to work.
I'll unravel this a bit and add the explanation to why this is not possible on
the next patch iteration.

  Luis
