Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F80C3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 07:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4408420828
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 07:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbfH0HZV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 03:25:21 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33856 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbfH0HZV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 03:25:21 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1090B43D736;
        Tue, 27 Aug 2019 17:25:18 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2Vqu-0003o7-Jq; Tue, 27 Aug 2019 17:25:16 +1000
Date:   Tue, 27 Aug 2019 17:25:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] libfrog: refactor open-coded bulkstat calls
Message-ID: <20190827072516.GE1119@dread.disaster.area>
References: <156633303230.1215733.4447734852671168748.stgit@magnolia>
 <156633306332.1215733.6520962409761161178.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156633306332.1215733.6520962409761161178.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=0kQ5DtjWnjYdIAaqtz4A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 01:31:03PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the BULKSTAT_SINGLE and BULKSTAT ioctl callsites into helper
> functions.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
.....
> ---
> @@ -617,25 +592,27 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
>  		return -1;
>  	}
>  
> -	if ((fsfd = open(mntdir, O_RDONLY)) < 0) {
> +	if ((fsxfd.fd = open(mntdir, O_RDONLY)) < 0) {
>  		fsrprintf(_("unable to open: %s: %s\n"),
>  		          mntdir, strerror( errno ));
>  		free(fshandlep);
>  		return -1;
>  	}
>  
> -	if (xfrog_geometry(fsfd, &fsgeom) < 0 ) {
> +	ret = xfrog_prepare_geometry(&fsxfd);
> +	if (ret) {
>  		fsrprintf(_("Skipping %s: could not get XFS geometry\n"),
>  			  mntdir);
> -		close(fsfd);
> +		xfrog_close(&fsxfd);
>  		free(fshandlep);
>  		return -1;
>  	}

/me wonders if this would be better wrapped as xfd_open(&xfd, path, flags,
mode) ?

> @@ -684,16 +661,16 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
>  		}
>  		if (endtime && endtime < time(NULL)) {
>  			tmp_close(mntdir);
> -			close(fsfd);
> +			xfrog_close(&fsxfd);
>  			fsrall_cleanup(1);
>  			exit(1);
>  		}
>  	}
>  	if (ret < 0)
> -		fsrprintf(_("%s: xfs_bulkstat: %s\n"), progname, strerror(errno));
> +		fsrprintf(_("%s: xfrog_bulkstat: %s\n"), progname, strerror(errno));

It'd change this to just "bulkstat" - it's a user facing error, and
they aren't going to know what "xfrog" means...

> @@ -745,14 +725,21 @@ fsrfile(char *fname, xfs_ino_t ino)
>  	 * Need to open something on the same filesystem as the
>  	 * file.  Open the parent.
>  	 */
> -	fsfd = open(getparent(fname), O_RDONLY);
> -	if (fsfd < 0) {
> +	fsxfd.fd = open(getparent(fname), O_RDONLY);
> +	if (fsxfd.fd < 0) {
>  		fsrprintf(_("unable to open sys handle for %s: %s\n"),
>  			fname, strerror(errno));
>  		goto out;
>  	}
>  
> -	if ((xfs_bulkstat_single(fsfd, &ino, &statbuf)) < 0) {
> +	error = xfrog_prepare_geometry(&fsxfd);
> +	if (error) {
> +		fsrprintf(_("Unable to get geom on fs for: %s\n"), fname);
> +		goto out;
> +	}
> +

same xfd_open() code here.

> diff --git a/io/open.c b/io/open.c
> index e70c8cb0..67976f7f 100644
> --- a/io/open.c
> +++ b/io/open.c
....
> @@ -767,35 +766,36 @@ inode_f(
>  			exitcode = 1;
>  			return 0;
>  		}
> +	} else if (ret_next) {
> +		struct xfs_fd	xfd = XFS_FD_INIT(file->fd);
> +
> +		/* get next inode */
> +		ret = xfrog_bulkstat(&xfd, &userino, 1, &bstat, &count);
> +		if (ret) {
> +			perror("xfsctl");

perror("bulkstat");

....

Otherwise looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
