Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 41A457F4E
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2015 12:02:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 300C930404E
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2015 10:02:14 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id sGVXxEZ9STv8kUJf for <xfs@oss.sgi.com>;
	Thu, 17 Sep 2015 10:02:12 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 7D85E63BECC9
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2015 12:02:12 -0500 (CDT)
Subject: Re: [RFC PATCH] xfs_io: Implement inodes64 command
References: <1442499846-10470-1-git-send-email-cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55FAF212.2010308@sandeen.net>
Date: Thu, 17 Sep 2015 12:02:10 -0500
MIME-Version: 1.0
In-Reply-To: <1442499846-10470-1-git-send-email-cmaiolino@redhat.com>
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
To: xfs@oss.sgi.com

(oops, resending to list not just Carlos)

On 9/17/15 9:24 AM, Carlos Maiolino wrote:
> This command aims to implement an easy way to check a filesystem for the
> existence of 64bit inodes.
>
> Based on XFS_IOC_FSINUMBERS, and starting with a lastip = 0xffffffff
> instead of 0.
>
> For now, it just returns a string saying there is or there is no 64bit inodes
> in the filesystem, but, I was wondering if it might not be better to just return
> 0 or 1, so it can be used inside scripts to check for that. Or maybe an argument
> to chose between an integer output or a string verbose output.
>
> Also, I was wondering if might be useful to, besides return the existence of
> 64bit inodes, also inform if there is any 64bit inodes allocated in the groups
> or not. Although, this will need the tool to walk through all the inode groups
> checking for allocated inodes or not, instead of just stop at the first 64bit
> inode found.

I'm not sure what you mean here - list the groups which contain them?
Any group above the one where the first 64 bit inode is found will also
have 64-bit inodes, (unless they have no inodes at all) - so I don't see
the value, but maybe I'm missing something.

> Also, I'm still not sure if 'inodes64' is a good name for the command, I was
> also thinking about something like 'chk64inos' but 'inodes64' was the best and
> easy to be remembered I could find.

Eh, seems reasonable to me.  Not super, but I can't think of anything much
better. 

> Comments are appreciated 

Below...

> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  io/open.c | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
>
> diff --git a/io/open.c b/io/open.c
> index ac5a5e0..3a98fdf 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -44,6 +44,7 @@ static cmdinfo_t statfs_cmd;
>  static cmdinfo_t chproj_cmd;
>  static cmdinfo_t lsproj_cmd;
>  static cmdinfo_t extsize_cmd;
> +static cmdinfo_t inodes64_cmd;
>  static prid_t prid;
>  static long extsize;
>  
> @@ -750,6 +751,37 @@ statfs_f(
>  	return 0;
>  }
>  
> +static int
> +inodes64_f(
> +	  int			argc,
> +	  char			**argv)
> +{
> +	int			i;
> +	__s32			count;
> +	__u64			last = 0xffffffff;

might be good to use XFS_MAXINUMBER_32 here

> +	xfs_inogrp_t		igroup[64];

why 64?  wouldn't one suffice?

> +	xfs_fsop_bulkreq_t	bulkreq;
> +
> +	/* Setup bulkreq structure */
> +	bulkreq.lastip = &last;
> +	bulkreq.icount = 64;
> +	bulkreq.ubuffer = &igroup;
> +	bulkreq.ocount = &count;
> +
> +	while (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS, &bulkreq) == 0) {
> +		if (count > 0) {
> +			printf("Filesystem does have 64bit inodes\n");
> +			return 0;
> +		} else {
> +			printf("Filesystem does not have 64bit inodes\n");
> +			return 0;
> +		}
> +	}

I'm also not sure what the "while" is for, here.

If you start at XFS_MAXINUMBER_32, won't a single call either
give you count = 1 or count = 0?

> +	perror("xfsctl(XFS_IOC_FSINUMBERS)");
> +	exitcode = 1;
> +	return 0;
> +}
> +
>  void
>  open_init(void)
>  {
> @@ -815,6 +847,12 @@ open_init(void)
>  		_("get/set preferred extent size (in bytes) for the open file");
>  	extsize_cmd.help = extsize_help;
>  
> +	inodes64_cmd.name = "inodes64";
> +	inodes64_cmd.cfunc = inodes64_f;
> +	inodes64_cmd.flags = CMD_NOMAP_OK;
> +	inodes64_cmd.oneline =
> +		_("Checks if filesyste contais 64bit inodes");

"if filesystem contains"

> +
>  	add_command(&open_cmd);
>  	add_command(&stat_cmd);
>  	add_command(&close_cmd);
> @@ -822,4 +860,5 @@ open_init(void)
>  	add_command(&chproj_cmd);
>  	add_command(&lsproj_cmd);
>  	add_command(&extsize_cmd);
> +	add_command(&inodes64_cmd);
>  }

needs xfs_io manpage updates too, and possibly an xfstest test case?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
