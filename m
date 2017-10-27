Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43813 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750828AbdJ0GSM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Oct 2017 02:18:12 -0400
Subject: Re: [RFC] xfs_repair: clear file / directory attribute on symlinks
References: <20171026225053.10263-1-mcgrof@kernel.org>
 <b52bcf80-6848-c3f3-c8bc-68e69054267c@sandeen.net>
 <20171027001118.GF5483@magnolia> <20171027002812.GV17331@wotan.suse.de>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <7281013b-835e-031c-6ed0-dd0c220b271c@suse.com>
Date: Fri, 27 Oct 2017 09:18:07 +0300
MIME-Version: 1.0
In-Reply-To: <20171027002812.GV17331@wotan.suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, Laurent Bonnaud <Laurent.Bonnaud@inpg.fr>, Tso Ted <tytso@mit.edu>, Flex Liu <fliu@suse.com>, Jake Norris <jake.norris@suse.com>, Jan Kara <jack@suse.cz>



On 27.10.2017 03:28, Luis R. Rodriguez wrote:
> On Thu, Oct 26, 2017 at 05:11:18PM -0700, Darrick J. Wong wrote:
>> On Thu, Oct 26, 2017 at 06:48:53PM -0500, Eric Sandeen wrote:
>>>> 	b) xfsctl()
>>
>> Requires an open file descriptor, path argument not used.  Returns EBADF if
>> you opened a symlink with O_PATH|O_NOFOLLOW, which AFAIK is the only way to
>> do that.
> 
> Hrm, were you suggesting you didn't think its possible to use xfsctl to
> set some attributes? Because I was able to:
> 
> #include <xfs/xfs.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> 
> char *prog;
> 
> static void usage(void)
> {
> 		printf("Usage: %s [set|get] <file>\n", prog);
> 		exit(1);
> }
> 
> int main(int argc, char *argv[])
> {
> 	int ret = 0;
> 	struct stat sb;
> 	char *cmd_str, *file;
> 	int cmd = 0;
> 	int open_flags = 0;
> 	int fd;
> 	struct fsxattr fsx;
> 
> 	prog = argv[0];
> 
> 	if (argc != 3)
> 		usage();
> 
> 	memset(&fsx, 0, sizeof(fsx));
> 
> 	/* First run is get to get old values */
> 	cmd = FS_IOC_FSGETXATTR;
> 
> 	if ((strncmp("get", argv[1], 3) == 0))
> 		open_flags = O_RDONLY;
> 	else if (strncmp("set", argv[1], 3) == 0) {
> 		cmd = FS_IOC_FSGETXATTR;
> 		open_flags = O_RDWR | O_APPEND;
> 	}
> 
> 	if (!open_flags)
> 		usage();
> 
> 	cmd_str = argv[1];
> 
> 	ret = stat(argv[2], &sb);
> 	if (ret) {
> 		printf("File may not be present or readable\n");
> 		usage();
> 	}
> 
> 	file = argv[2];
> 
> 	fd = open(file, open_flags);
> 	if (!fd) {
> 		printf("Could not open file for operation: %s\n", cmd_str);
> 		usage();
> 	}
> 
> 	ret = xfsctl(file, fd, cmd, &fsx);
> 	if (ret < 0) {
> 		printf("Could not issue xfsctl GET flags\n");
> 		exit(1);
> 	}
> 
> 	if (strncmp("get", argv[1], 3) == 0)
> 		goto out;
> 
> 	/* Now do the setting */
> 	cmd = FS_IOC_FSSETXATTR;
> 	fsx.fsx_xflags |= XFS_XFLAG_APPEND;
> 
> 	ret = xfsctl(file, fd, cmd, &fsx);
> 	if (ret < 0) {
> 		printf("Could not issue xfsctl SET flags\n");
> 		exit(1);
> 	}
> 
> out:
> 	printf("fsxattr.xflags = 0x%x\n", fsx.fsx_xflags);
> 
> 	return 0;
> }


I think this program is not really working on the symlink but rather on
the file it points to. If you have a dangling symlin then the open()
call would just return ENOENT. On the other hand, if the file exists
when you open the symlink you will have actually opened the file it
points to, no the symlink itself. And this behavior is actually
controlled by the vfs traversal code. in path_lookupat:

        while (!(err = link_path_walk(s, nd))

                && ((err = lookup_last(nd)) > 0)) {

                s = trailing_symlink(nd);
                if (IS_ERR(s)) {

                        err = PTR_ERR(s);

                        break;

                }

        }

In order to be able to set ioctl-xattr (as per Darick's convetion :D)
you need to get a reference to a struct file with it's f_op set to
xfs_file_operations, since that's where the unlocked_ioctl handler is.
And for symlink that's forbidden by the vfs traversal code.

> 
> However, its unclear if we intentionally supported this.
> 
>>>> 	c) xfs_db [1] [2] - only when umounted
>>
>> Fuzzing and corruption aren't all that dissimilar. :)
> 
> Agreed.
> 
>>>> POSIX doesn't seem to actually have a position on this.
>>>>
>>>> These are not extended attributes, however xattr(7) does have
>>>> a little nugget worth considering regarding this, and for which
>>>> it was decided to at least not support extended attributes on
>>>> symlinks or special files:
>>>>
>>>> 	The file permissions of symbolic links are not used in
>>>>         access checks. These differences would allow users to consume
>>>> 	filesystem resources in a way not controllable by disk quotas
>>>> 	for group or world writable special files and directories.
>>>>
>>>> 	For this reason, extended user attributes are allowed only for
>>>> 	regular files and directories.
>>
>> Yet lsetxattr() sets extended attributes on a symlink, right?
> 
> True...
> 
>>> Hm, that seems like a different issue/rationale, no?
>>>
>>>> For these reasons, and since corruption is the only current valid
>>>> case where these seem to have popped up -- apply the same logic on
>>>> XFS, otherwise we'd be going against the e2fsprogs chattr convention
>>>> set since August 2002, and which folks likely are used to.
>>>>
>>>> This fixes filesystems which have these attributes set where clearly
>>>> they were set by corruption.
>>>
>>> OK but hang on, I think a core question is:
>>>
>>> Does the kernel allow us to set attributes on symlinks?
>>
>> I don't think it should, I can't figure out how userspace would set them
>> in the first place, 
> 
> It seems we currently allow for it though :(
> 
> Perhaps another consideration to take, but I didn't test, should attributes set
> with SETFLAGS be preserved across filesystems? If so this may be an issue.
> 
>> but repair (and now scrub) don't actually check those flags.
> 
> Right, given we seem to be rather loose on SETFLAGS, its unclear
> really what is the right thing to do should be.
> 
>>>> diff --git a/repair/dinode.c b/repair/dinode.c
>>>> index 15ba8cc22b39..03e93a6e17c0 100644
>>>> --- a/repair/dinode.c
>>>> +++ b/repair/dinode.c
>>>> @@ -2482,6 +2482,41 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>>>>  						FS_XFLAG_EXTSIZE);
>>>>  			}
>>>>  		}
>>>> +		if (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_PREALLOC |
>>>> +			     XFS_DIFLAG_IMMUTABLE | XFS_DIFLAG_APPEND |
>>>> +			     XFS_DIFLAG_SYNC | XFS_DIFLAG_NOATIME |
>>>> +			     XFS_DIFLAG_NODUMP | XFS_DIFLAG_RTINHERIT |
>>>> +			     XFS_DIFLAG_PROJINHERIT | XFS_DIFLAG_NOSYMLINKS |
>>>> +			     XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT |
>>>> +			     XFS_DIFLAG_NODEFRAG | XFS_DIFLAG_FILESTREAM |
>>>> +			     XFS_DIFLAG2_DAX | XFS_DIFLAG2_COWEXTSIZE)) {
>>
>> Do not mix DIFLAG and DIFLAG2.
>>
>> Also probably easier on the eyes if you don't write this huge OR list
>> twice.
> 
> Great, I thought it wasn't done before due to some reason, but that
> is indeed the approach I prefer.
> 
>   Luis
> 
