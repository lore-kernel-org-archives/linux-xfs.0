Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 53B2C7CCA
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 07:44:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 04FBA304039
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 05:44:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gK5jSL4gNT43OLGq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 26 Aug 2016 05:44:20 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 29FA1332F74
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 12:44:20 +0000 (UTC)
Subject: Re: [PATCH] xfs_db: new -FF option help to continue the command
	without verify
References: <1472209496-2401-1-git-send-email-zlang@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <ddece9fc-ca2a-4ec3-de28-73067a1700fb@redhat.com>
Date: Fri, 26 Aug 2016 07:44:18 -0500
MIME-Version: 1.0
In-Reply-To: <1472209496-2401-1-git-send-email-zlang@redhat.com>
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
To: Zorro Lang <zlang@redhat.com>, xfs@oss.sgi.com

On 8/26/16 6:04 AM, Zorro Lang wrote:
> When I try to do below steps(a V5 xfs on $fsile):
> 
>   # xfs_db -x -c "sb 0" -c "write features_ro_compat 4096" $fsfile
>   # xfs_db -x -c "sb 0" -c "write features_ro_compat 0" $fsfile
>   # xfs_db -c "sb 0" -c p $fsfile
> 
> The step#2 and #3 all failed, as:
> 
>   Superblock has unknown read-only compatible features (0x1000) enable
> 
> When the "sb" command try to verify the superblock, it find a bad
> features_ro_compat number then end the xfs_db process.
> 
> Even"-F" option can't help more. So we need a "super force" mode
> which can ignore all "verify" failures, continue the command running.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Hi Zorro - I think this isn't quite the right approach.  I can see the
advantage of allowing xfs_db to operate on filesystems with unknown
features, in case those "features" are the result of corruption, and
we'd like to analyze it and/or fix it.  Or, for testing, as motivated
you here.

So allowing xfs_db to skip superblock feature checks makes some sense
to me.

However, as I read the patch, it is completely overriding every verifier
for every type of metadata; in addition to skipping every read verification,
it also unhooks the write verifiers, so now crcs aren't updated:

# db/xfs_db -x -FF -c "sb 0" -c "write fname \"test\"" fsfile
fname = "test\000\000\000\000\000\000\000\000"
# db/xfs_db -x -c "sb 0" -c "p crc" fsfile
Metadata CRC error detected at xfs_sb block 0x0/0x200
crc = 0x7e27467b (bad)

So I think that if the goal is to be able to dangerously operate on
filesystems with unknown features, this needs to be more targeted to
allow only that, and not completely unhook all verifiers.

Thanks,
-Eric

> ---
> 
> Hi,
> 
> I don't know if my patch is good or not, but I think the "--forceforce"
> option is needed for xfs_db. As above example:
> 
>   # xfs_db -x -c "sb 0" -c "write features_ro_compat 4096" $fsfile
>   # xfs_db -x -c "sb 0" -c "write features_ro_compat 0" $fsfile
>   # xfs_db -c "sb 0" -c p $fsfile
> 
> If we break the superblock, at least xfs_db should help to print the
> superblock info. And as a xfs debugger, xfs_db should can ignore
> unexpected errors to continue the "expert" command which an expert
> want to do.
> 
> That's my personal opinion, so if I'm wrong, feel free to correct me:)
> 
> Thanks,
> Zorro
> 
>  db/init.c         |  6 +++++-
>  db/io.c           | 21 ++++++++++++++++++++-
>  db/io.h           |  2 ++
>  man/man8/xfs_db.8 |  4 ++++
>  4 files changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/db/init.c b/db/init.c
> index c0472c8..690e6ea 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -29,6 +29,7 @@
>  #include "malloc.h"
>  #include "type.h"
>  
> +int			xfs_skip_verify = 0;
>  static char		**cmdline;
>  static int		ncmdline;
>  char			*fsdevice;
> @@ -75,7 +76,7 @@ init(
>  			x.disfile = 1;
>  			break;
>  		case 'F':
> -			force = 1;
> +			force++;
>  			break;
>  		case 'i':
>  			x.isreadonly = (LIBXFS_ISREADONLY|LIBXFS_ISINACTIVE);
> @@ -105,6 +106,9 @@ init(
>  		/*NOTREACHED*/
>  	}
>  
> +	if (force > 1)
> +		xfs_skip_verify = 1;
> +
>  	fsdevice = argv[optind];
>  	if (!x.disfile)
>  		x.volname = fsdevice;
> diff --git a/db/io.c b/db/io.c
> index 91cab12..897388d 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -41,6 +41,16 @@ static void     back_help(void);
>  static int      ring_f(int argc, char **argv);
>  static void     ring_help(void);
>  
> +/*
> + * If xfs_skip_verify is true, use this dummy xfs_buf_ops structure
> + * to instead of the real xfs_buf_ops in set_cur()
> + */
> +static const struct xfs_buf_ops xfs_dummy_buf_ops = {
> +        .name = "dummy",
> +        .verify_read = xfs_dummy_verify,
> +        .verify_write = xfs_dummy_verify,
> +};
> +
>  static const cmdinfo_t	pop_cmd =
>  	{ "pop", NULL, pop_f, 0, 0, 0, NULL,
>  	  N_("pop location from the stack"), pop_help };
> @@ -503,7 +513,16 @@ set_cur(
>  	xfs_ino_t	dirino;
>  	xfs_ino_t	ino;
>  	__uint16_t	mode;
> -	const struct xfs_buf_ops *ops = t ? t->bops : NULL;
> +	const struct xfs_buf_ops *ops = NULL;
> +
> +	if (t) {
> +		if (xfs_skip_verify) {
> +			ops = &xfs_dummy_buf_ops;
> +		} else {
> +			ops = t->bops;
> +		}
> +	} else
> +		ops = NULL;
>  
>  	if (iocur_sp < 0) {
>  		dbprintf(_("set_cur no stack element to set\n"));
> diff --git a/db/io.h b/db/io.h
> index c69e9ce..eb64638 100644
> --- a/db/io.h
> +++ b/db/io.h
> @@ -16,6 +16,8 @@
>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  
> +extern int xfs_skip_verify;
> +
>  struct typ;
>  
>  #define	BBMAP_SIZE		(XFS_MAX_BLOCKSIZE / BBSIZE)
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index ff8f862..c52a5bf 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -57,6 +57,10 @@ Specifies that we want to continue even if the superblock magic is not
>  correct.  For use in
>  .BR xfs_metadump .
>  .TP
> +.B \-FF
> +The "force force" mode. Skip all read/write verify to continue the command,
> +even if it'll cause something be broken.
> +.TP
>  .B \-i
>  Allows execution on a mounted filesystem, provided it is mounted read-only.
>  Useful for shell scripts
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
