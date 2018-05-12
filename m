Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:37782 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750740AbeELCtZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 22:49:25 -0400
Date: Sat, 12 May 2018 04:49:20 +0200
From: Adam Borowski <kilobyte@angband.pl>
Subject: Re: [PATCH 1/2] vfs: allow dedupe of user owned read-only files
Message-ID: <20180512024920.i7duhoi3lnkha4yl@angband.pl>
References: <20180511192651.21324-1-mfasheh@suse.de>
 <20180511192651.21324-2-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180511192651.21324-2-mfasheh@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, May 11, 2018 at 12:26:50PM -0700, Mark Fasheh wrote:
> The permission check in vfs_dedupe_file_range() is too coarse - We
> only allow dedupe of the destination file if the user is root, or
> they have the file open for write.
> 
> This effectively limits a non-root user from deduping their own
> read-only files. As file data during a dedupe does not change,
> this is unexpected behavior and this has caused a number of issue
> reports. For an example, see:
> 
> https://github.com/markfasheh/duperemove/issues/129
> 
> So change the check so we allow dedupe on the target if:
> 
> - the root or admin is asking for it
> - the owner of the file is asking for the dedupe
> - the process has write access

I submitted a similar patch in May 2016, yet it has never been applied
despite multiple pings, with no NAK.  My version allowed dedupe if:
- the root or admin is asking for it
- the file has w permission (on the inode -- ie, could have been opened rw)

There was a request to include in xfstests a test case for the ETXTBSY race
this patch fixes, but there's no reasonable way to make such a test case:
the race condition is not a bug, it's write-xor-exec working as designed.

Another idea discussed was about possibly just allowing everyone who can
open the file to deduplicate it, as the file contents are not modified in
any way.  Zygo Blaxell expressed a concern that it could be used by an
unprivileged user who can trigger a crash to abuse writeout bugs.

I like this new version better than mine: "root or owner or w" is more
Unixy than "could have been opened w".

> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> ---
>  fs/read_write.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index c4eabbfc90df..77986a2e2a3b 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -2036,7 +2036,8 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
>  
>  		if (info->reserved) {
>  			info->status = -EINVAL;
> -		} else if (!(is_admin || (dst_file->f_mode & FMODE_WRITE))) {
> +		} else if (!(is_admin || (dst_file->f_mode & FMODE_WRITE) ||
> +			     uid_eq(current_fsuid(), dst->i_uid))) {
I had:
  +		} else if (!(is_admin || !inode_permission(dst, MAY_WRITE))) {
>  			info->status = -EINVAL;
>  		} else if (file->f_path.mnt != dst_file->f_path.mnt) {
>  			info->status = -EXDEV;
> -- 

Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢰⠒⠀⣿⡁ 
⢿⡄⠘⠷⠚⠋⠀ Certified airhead; got the CT scan to prove that!
⠈⠳⣄⠀⠀⠀⠀ 
