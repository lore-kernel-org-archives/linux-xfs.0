Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1C0237CA0
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 21:07:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 84D13AC003
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 19:07:30 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	mCEPyBHwKktH5yrd for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2016 19:07:28 -0700 (PDT)
Date: Mon, 22 Aug 2016 12:06:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/3] xfs_quota: additional changes to allow use on ext4
Message-ID: <20160822020650.GR19025@dastard>
References: <1471356998-2876-1-git-send-email-billodo@redhat.com>
	<1471356998-2876-4-git-send-email-billodo@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1471356998-2876-4-git-send-email-billodo@redhat.com>
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
To: Bill O'Donnell <billodo@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 16, 2016 at 09:16:38AM -0500, Bill O'Donnell wrote:
> Further changes to allow xfs_quota to be used on foreign filesystem(s)
> (e.g. ext4) for project quota testing in xfstests.
> 
> Add CMD_FLAG_GENERIC to enable generic xfs_quota commands (help and
> quit) when xfs_quota is run on foreign filesystems.
> 
> Use CMD_FLAG_FOREIGN_OK on commands suitable for foreign filesystems.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  include/command.h | 1 +
>  libxcmd/help.c    | 3 ++-
>  libxcmd/quit.c    | 3 ++-
>  quota/init.c      | 3 ++-
>  4 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/include/command.h b/include/command.h
> index 81d5a4d..1c2898a 100644
> --- a/include/command.h
> +++ b/include/command.h
> @@ -22,6 +22,7 @@
>  
>  #define CMD_FLAG_GLOBAL		(1<<31)	/* don't iterate "args" */
>  #define CMD_FLAG_FOREIGN_OK	(1<<30)	/* command not restricted to XFS */
> +#define CMD_FLAG_GENERIC	(1<<29) /* command is generic (help, quit) */

I don't think this belongs in include/command.h - it's an xfs_quota
specific behaviour so I'd put this in quota/init.h:

#define CMD_SKIP_CHECK	(1<<0)	/* command is always run */

> diff --git a/quota/init.c b/quota/init.c
> index d5d80c2..85931bf 100644
> --- a/quota/init.c
> +++ b/quota/init.c
> @@ -104,7 +104,8 @@ init_check_command(
>  	const cmdinfo_t	*ct)
>  {
>  	if (fs_path &&
> -	    !(ct->flags & CMD_FLAG_FOREIGN_OK) &&
> +	    !((ct->flags & CMD_FLAG_FOREIGN_OK) && foreign_allowed) &&
> +	    !(ct->flags & CMD_FLAG_GENERIC) &&
>  	     (fs_path->fs_flags & FS_FOREIGN)) {

This is now sufficiently confusing that it needs to be reworked to
make the logic clear and easily commented. i.e. something like this:

static int
init_check_command(
	const cmdinfo_t *ct)
{
	if (!fspath)
		return 1;

	/* Always run commands that we are told to skip here */
	if (ct->flags & CMD_SKIP_CHECK)
		return 1;

	/* if it's an XFS filesystem, always run the command */
	if (!(fs_path->fs_flags & FS_FOREIGN))
		return 1;

	/* If the user specified foreign filesysetms are ok, run it */
	if (foreign_allowed &&
	    (ct->flags & CMD_FLAG_FOREIGN_OK))
		return 1;

	/* foreign filesystem and it's no a valid command! */
	fprintf(stderr, _("%s command is for XFS filesystems only\n"),
			ct->name);
	return 0;
}

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
