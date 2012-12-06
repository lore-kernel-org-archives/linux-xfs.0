Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB6KXdVB151954 for <xfs@oss.sgi.com>; Thu, 6 Dec 2012 14:33:40 -0600
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id faNvlZEKwUFYiSg0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Dec 2012 12:36:04 -0800 (PST)
Subject: Bug#694624: freezes under lying (root) - patch
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.694624.B694624.135482594610164@bugs.debian.org>
Date: Thu, 6 Dec 2012 14:22:57 -0600
From: Ben Myers <bpm@sgi.com>
Message-ID: <20121206202257.GR27055@sgi.com>
References: <50C0258F.6070409@talbragar.com.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50C0258F.6070409@talbragar.com.au>
Reply-To: Ben Myers <bpm@sgi.com>, 694624@bugs.debian.org
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Pat Emblen <talcom@talbragar.com.au>, 694624@bugs.debian.org

Hey Pat,

On Thu, Dec 06, 2012 at 03:56:47PM +1100, Pat Emblen wrote:
> A patch for the man page is (hopefully) attached.

Thanks for the patch!

> I'll warn you that
> this is the first time I've edited a man page or generated a patch,
> so it could be wrong / incomplete.

Ok, I'll go easy on you then.  ;) 

There are some guidelines for submitting patches in the kernel sources
under Documentation/SubmittingPatches.  Please give that a quick read:
I think it will help you.  (read: it will help us get your patch in
faster)

> Having said that I still personally consider a 'safety catch' on the
> root filesystem would be a good idea.

I tend to agree.  It really sucks that someone had to drive out to the
site to get things working again.  Not a great situation.

> Description: Updates to the man page to more accurately describe the
>  behaviour of the program.
> Forwarded: not-needed
> Bug-Debian: http://bugs.debian.org/694624
> Author: Patrick Emblen <support@talbragar.com.au>
> --- a/man/man8/xfs_freeze.8
> +++ b/man/man8/xfs_freeze.8
> @@ -1,16 +1,17 @@
>  .TH xfs_freeze 8
>  .SH NAME
> -xfs_freeze \- suspend access to an XFS filesystem
> +xfs_freeze \- suspend access to a freezable filesystem
>  .SH SYNOPSIS
>  .B xfs_freeze \-f
>  |
>  .B \-u
> -.I mount-point
> -.fi
> -.SH DESCRIPTION
> -.B xfs_freeze
> -suspends and resumes access to an XFS filesystem (see
> -.BR xfs (5)).
> +.I path.fi
> +.SH DESCRIPTION.B xfs_freezesuspends and resumes access to compatible filesystems.
		  ^^ Do you need a newline there?

		     xfs_freeze suspends
> +The command was originaly specific to the XFS filesystem (see
> +.BR xfs (5))but since Linux kernel version 2.6.29, the interface which
		^^^^^^^ This displays without spaces between.  e.g butsinceLinuxKernelVersion2.

> +XFS uses to freeze and unfreeze has been elevated to the VFS, so that
> +this tool can now be used on many other Linux filesystems.
> +The root filesystem is not treated in any special way and may also be frozen.

I think this history lesson was more appropriate in the notes section of the manpage.

>  .PP
>  .B xfs_freeze
>  halts new access to the filesystem and creates a stable image on disk.
> @@ -19,15 +20,14 @@
>  that support the creation of snapshots.
>  .PP
>  The
> -.I mount-point
> -argument is the pathname of the directory where the filesystem
> -is mounted.
> -The filesystem must be mounted to be frozen (see
> -.BR mount (8)).
> +.I path
> +argument is the path to any directory within the mounted filesystem up to and including
> +the
> +.I mount-point.

Not sure you need 'up to and including the mount-point'?

>  .PP
>  The
>  .B \-f
> -flag requests the specified XFS filesystem to be
> +flag requests the specified filesystem to be

Ok.

>  frozen from new modifications.
>  When this is selected, all ongoing transactions in the filesystem
>  are allowed to complete, new write system calls are halted, other
> @@ -55,16 +55,23 @@
>  must be supplied to
>  .BR xfs_freeze .
>  .SH NOTES
> -A copy of a frozen XFS filesystem will usually have the same universally
> +.BR xfs_freeze
> +treats the root filesystem the same as any other filesystem.

> +Take great care to verify that the path you specify contains the filesystem
> +you intend to freeze and is not for example, an empty mount-point.

I think this is all you need, just make it bold?

> +If you inadvertently freeze the root filesystem you should immediately
> +unfreeze it with the
> +.B \-u
> +option.  If you attempt any action that tries to write to the frozen filesystem
> +your shell can be blocked waiting for the write and in most cases you will
> +not be able to open another shell to run the unfreeze command.
> +.PP
> +A copy of a frozen filesystem will usually have the same universally 

That's pretty wordy... do we really need all that?

>  unique identifier (UUID) as the original, and thus may be prevented from
>  being mounted.
> -The XFS
> +For XFS filesystems, the
>  .B nouuid
>  mount option can be used to circumvent this issue.
> -.PP
> -In Linux kernel version 2.6.29, the interface which XFS uses to freeze
> -and unfreeze was elevated to the VFS, so that this tool can now be
> -used on many other Linux filesystems.
>  .SH SEE ALSO
>  .BR xfs (5),
>  .BR lvm (8),

Could you clean those up and repost?  If not we'll figure something out
eventually.  ;)

Thanks again,
       Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
