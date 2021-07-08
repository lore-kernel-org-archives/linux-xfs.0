Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E660C07E96
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jul 2021 20:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2F4D616EA
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jul 2021 20:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhGHVBb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jul 2021 17:01:31 -0400
Received: from sandeen.net ([63.231.237.45]:41260 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230442AbhGHVBb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Jul 2021 17:01:31 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 14DE8550;
        Thu,  8 Jul 2021 15:58:03 -0500 (CDT)
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <162528110197.38907.6647015481710886949.stgit@locust>
 <162528110744.38907.9770913472348824425.stgit@locust>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/1] xfs_io: allow callers to dump fs stats individually
Message-ID: <b85719a6-ffd0-dfcd-431d-12cf4987bcf7@sandeen.net>
Date:   Thu, 8 Jul 2021 15:58:47 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <162528110744.38907.9770913472348824425.stgit@locust>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/2/21 9:58 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Enable callers to decide if they want to see statfs, fscounts, or
> geometry information (or any combination) from the xfs_io statfs
> command.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  io/stat.c         |  149 +++++++++++++++++++++++++++++++++++++++--------------
>  man/man8/xfs_io.8 |   17 ++++++
>  2 files changed, 127 insertions(+), 39 deletions(-)
> 
> 
> diff --git a/io/stat.c b/io/stat.c
> index 49c4c27c..1993247c 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -171,6 +171,26 @@ stat_f(
>  	return 0;
>  }
>  
> +static void
> +statfs_help(void)
> +{
> +        printf(_(
> +"\n"
> +" Display file system status.\n"
> +"\n"
> +" Options:\n"
> +" -a -- Print statfs, geometry, and fs summary count data.\n"
> +" -c -- Print fs summary count data.\n"
> +" -g -- Print fs geometry data.\n"
> +" -s -- Print statfs data.\n"
> +"\n"));
> +}
> +
> +#define REPORT_STATFS		(1 << 0)
> +#define REPORT_GEOMETRY		(1 << 1)
> +#define REPORT_FSCOUNTS		(1 << 2)
> +#define REPORT_DEFAULT		(1 << 31)
> +
>  static int
>  statfs_f(
>  	int			argc,
> @@ -179,55 +199,102 @@ statfs_f(
>  	struct xfs_fsop_counts	fscounts;
>  	struct xfs_fsop_geom	fsgeo;
>  	struct statfs		st;
> +	unsigned int		flags = REPORT_DEFAULT;

Nitpicking this only because the patch will need to be resent anyway ;)
Why not just "flags = 0" and "if !flags flags = ALL|THREE|FLAGS;" ?

(OTOH I don't really care, just wasn't sure about the need for it)

> +	int			c;
>  	int			ret;
>  
> +	while ((c = getopt(argc, argv, "acgs")) != EOF) {
> +		switch (c) {
> +		case 'a':
> +			flags = REPORT_STATFS | REPORT_GEOMETRY |
> +				REPORT_FSCOUNTS;
> +			break;
> +		case 'c':
> +			flags &= ~REPORT_DEFAULT;
> +			flags |= REPORT_FSCOUNTS;
> +			break;
> +		case 'g':
> +			flags &= ~REPORT_GEOMETRY;
> +			flags |= REPORT_FSCOUNTS;

this looks ... wrong. ITYM:

+		case 'g':
+			flags &= ~REPORT_DEFAULT;
+			flags |= REPORT_GEOMETRY;

?

> +			break;
> +		case 's':
> +			flags &= ~REPORT_STATFS;
> +			flags |= REPORT_FSCOUNTS;

similar here

> +			break;
> +		default:
> +			exitcode = 1;
> +			return command_usage(&statfs_cmd);
> +		}
> +	}
> +
> +	if (flags & REPORT_DEFAULT)
> +		flags = REPORT_STATFS | REPORT_GEOMETRY | REPORT_FSCOUNTS;
> +
>  	printf(_("fd.path = \"%s\"\n"), file->name);
> -	if (platform_fstatfs(file->fd, &st) < 0) {
> -		perror("fstatfs");
> -		exitcode = 1;
> -	} else {
> -		printf(_("statfs.f_bsize = %lld\n"), (long long) st.f_bsize);
> -		printf(_("statfs.f_blocks = %lld\n"), (long long) st.f_blocks);
> -		printf(_("statfs.f_bavail = %lld\n"), (long long) st.f_bavail);
> -		printf(_("statfs.f_files = %lld\n"), (long long) st.f_files);
> -		printf(_("statfs.f_ffree = %lld\n"), (long long) st.f_ffree);
> +	if (flags & REPORT_STATFS) {
> +		ret = platform_fstatfs(file->fd, &st);
> +		if (ret < 0) {
> +			perror("fstatfs");
> +			exitcode = 1;
> +		} else {
> +			printf(_("statfs.f_bsize = %lld\n"),
> +					(long long) st.f_bsize);
> +			printf(_("statfs.f_blocks = %lld\n"),
> +					(long long) st.f_blocks);
> +			printf(_("statfs.f_bavail = %lld\n"),
> +					(long long) st.f_bavail);
> +			printf(_("statfs.f_files = %lld\n"),
> +					(long long) st.f_files);
> +			printf(_("statfs.f_ffree = %lld\n"),
> +					(long long) st.f_ffree);
>  #ifdef HAVE_STATFS_FLAGS
> -		printf(_("statfs.f_flags = 0x%llx\n"), (long long) st.f_flags);
> +			printf(_("statfs.f_flags = 0x%llx\n"),
> +					(long long) st.f_flags);
>  #endif
> +		}
>  	}
> +
>  	if (file->flags & IO_FOREIGN)
>  		return 0;
> -	ret = -xfrog_geometry(file->fd, &fsgeo);
> -	if (ret) {
> -		xfrog_perror(ret, "XFS_IOC_FSGEOMETRY");
> -		exitcode = 1;
> -	} else {
> -		printf(_("geom.bsize = %u\n"), fsgeo.blocksize);
> -		printf(_("geom.agcount = %u\n"), fsgeo.agcount);
> -		printf(_("geom.agblocks = %u\n"), fsgeo.agblocks);
> -		printf(_("geom.datablocks = %llu\n"),
> -			(unsigned long long) fsgeo.datablocks);
> -		printf(_("geom.rtblocks = %llu\n"),
> -			(unsigned long long) fsgeo.rtblocks);
> -		printf(_("geom.rtextents = %llu\n"),
> -			(unsigned long long) fsgeo.rtextents);
> -		printf(_("geom.rtextsize = %u\n"), fsgeo.rtextsize);
> -		printf(_("geom.sunit = %u\n"), fsgeo.sunit);
> -		printf(_("geom.swidth = %u\n"), fsgeo.swidth);
> +
> +	if (flags & REPORT_GEOMETRY) {
> +		ret = -xfrog_geometry(file->fd, &fsgeo);
> +		if (ret) {
> +			xfrog_perror(ret, "XFS_IOC_FSGEOMETRY");
> +			exitcode = 1;
> +		} else {
> +			printf(_("geom.bsize = %u\n"), fsgeo.blocksize);
> +			printf(_("geom.agcount = %u\n"), fsgeo.agcount);
> +			printf(_("geom.agblocks = %u\n"), fsgeo.agblocks);
> +			printf(_("geom.datablocks = %llu\n"),
> +				(unsigned long long) fsgeo.datablocks);
> +			printf(_("geom.rtblocks = %llu\n"),
> +				(unsigned long long) fsgeo.rtblocks);
> +			printf(_("geom.rtextents = %llu\n"),
> +				(unsigned long long) fsgeo.rtextents);
> +			printf(_("geom.rtextsize = %u\n"), fsgeo.rtextsize);
> +			printf(_("geom.sunit = %u\n"), fsgeo.sunit);
> +			printf(_("geom.swidth = %u\n"), fsgeo.swidth);
> +		}
>  	}
> -	if ((xfsctl(file->name, file->fd, XFS_IOC_FSCOUNTS, &fscounts)) < 0) {
> -		perror("XFS_IOC_FSCOUNTS");
> -		exitcode = 1;
> -	} else {
> -		printf(_("counts.freedata = %llu\n"),
> -			(unsigned long long) fscounts.freedata);
> -		printf(_("counts.freertx = %llu\n"),
> -			(unsigned long long) fscounts.freertx);
> -		printf(_("counts.freeino = %llu\n"),
> -			(unsigned long long) fscounts.freeino);
> -		printf(_("counts.allocino = %llu\n"),
> -			(unsigned long long) fscounts.allocino);
> +
> +	if (flags & REPORT_FSCOUNTS) {
> +		ret = ioctl(file->fd, XFS_IOC_FSCOUNTS, &fscounts);
> +		if (ret < 0) {
> +			perror("XFS_IOC_FSCOUNTS");
> +			exitcode = 1;
> +		} else {
> +			printf(_("counts.freedata = %llu\n"),
> +				(unsigned long long) fscounts.freedata);
> +			printf(_("counts.freertx = %llu\n"),
> +				(unsigned long long) fscounts.freertx);
> +			printf(_("counts.freeino = %llu\n"),
> +				(unsigned long long) fscounts.freeino);
> +			printf(_("counts.allocino = %llu\n"),
> +				(unsigned long long) fscounts.allocino);
> +		}
>  	}
> +
>  	return 0;
>  }
>  
> @@ -407,9 +474,13 @@ stat_init(void)
>  
>  	statfs_cmd.name = "statfs";
>  	statfs_cmd.cfunc = statfs_f;
> +	statfs_cmd.argmin = 0;
> +	statfs_cmd.argmax = -1;

Eh, I guess you can do "stats -a -a -a -c -c -c -s -a -a -c -c -c -g -g -g ...." and it works fine, so sure, "-1" ;)

> +	statfs_cmd.args = _("[-a] [-c] [-g] [-s]");
>  	statfs_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
>  	statfs_cmd.oneline =
>  		_("statistics on the filesystem of the currently open file");
> +	statfs_cmd.help = statfs_help;
>  
>  	add_command(&stat_cmd);
>  	add_command(&statx_cmd);
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 1103dc42..32bdd866 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8

Probably want to turn this into:

statfs [-a] [-c] [-g] [-s]
	<description, probably updated to add XFS_IOC_FSCOUNTS to the list of $STUFF>

> @@ -1240,6 +1240,23 @@ Selected statistics from
>  .BR statfs (2)
>  and the XFS_IOC_FSGEOMETRY
>  system call on the filesystem where the current file resides.
> +.RS 1.0i
> +.PD 0
> +.TP
> +.BI \-a
> +Display statfs, geometry, and fs summary counter data.

Perhaps note that this is the default if no options are specified?

> +.TP
> +.BI \-c
> +Display fs summary counter data.
> +.TP
> +.BI \-g
> +Display geometry data.
> +.TP
> +.BI \-s
> +Display statfs data.
> +.TP
> +.RE
> +.PD
>  .TP
>  .BI "inode  [ [ -n ] " number " ] [ -v ]"
>  The inode command queries physical information about an inode. With
> 
