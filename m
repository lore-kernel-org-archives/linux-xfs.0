Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15ECAC3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 07:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E27B7206BA
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 07:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfH0HvH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 03:51:07 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:40192 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbfH0HvH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 03:51:07 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7DC2743DAD3;
        Tue, 27 Aug 2019 17:51:03 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2WFp-0003tc-UY; Tue, 27 Aug 2019 17:51:01 +1000
Date:   Tue, 27 Aug 2019 17:51:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_spaceman: embed struct xfs_fd in struct fileio
Message-ID: <20190827075101.GG1119@dread.disaster.area>
References: <156685442011.2839773.2684103942714886186.stgit@magnolia>
 <156685443883.2839773.16670488313525688465.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156685443883.2839773.16670488313525688465.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=HONnocmIuUyGkf_3ne8A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 02:20:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Replace the open-coded fd and geometry fields of struct fileio with a
> single xfs_fd, which will enable us to use it natively throughout
> xfs_spaceman in upcoming patches.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  spaceman/file.c     |   27 +++++++++++++--------------
>  spaceman/freesp.c   |   30 +++++++++++++++++-------------
>  spaceman/info.c     |   18 ++----------------
>  spaceman/init.c     |   11 +++++++----
>  spaceman/prealloc.c |   15 ++++++++-------
>  spaceman/space.h    |    9 +++++----
>  spaceman/trim.c     |   40 +++++++++++++++++++++-------------------
>  7 files changed, 73 insertions(+), 77 deletions(-)
> 
> 
> diff --git a/spaceman/file.c b/spaceman/file.c
> index 5665da7d..9d550274 100644
> --- a/spaceman/file.c
> +++ b/spaceman/file.c
> @@ -45,26 +45,27 @@ print_f(
>  int
>  openfile(
>  	char		*path,
> -	struct xfs_fsop_geom *geom,
> +	struct xfs_fd	*xfd,
>  	struct fs_path	*fs_path)
>  {
>  	struct fs_path	*fsp;
> -	int		fd;
> +	int		ret;
>  
> -	fd = open(path, 0);
> -	if (fd < 0) {
> +	xfd->fd = open(path, 0);
> +	if (xfd->fd < 0) {
>  		perror(path);
>  		return -1;
>  	}
>  
> -	if (xfrog_geometry(fd, geom) < 0) {
> +	ret = xfrog_prepare_geometry(xfd);
> +	if (ret < 0) {
>  		if (errno == ENOTTY)
>  			fprintf(stderr,
>  _("%s: Not on a mounted XFS filesystem.\n"),
>  					path);
>  		else
>  			perror("XFS_IOC_FSGEOMETRY");
> -		close(fd);
> +		xfrog_close(xfd);
>  		return -1;
>  	}

There's that xfd_open() pattern again :P

> --- a/spaceman/init.c
> +++ b/spaceman/init.c
> @@ -5,6 +5,7 @@
>   */
>  
>  #include "libxfs.h"
> +#include "xfrog.h"
>  #include "command.h"
>  #include "input.h"
>  #include "init.h"
> @@ -60,7 +61,7 @@ init(
>  	char		**argv)
>  {
>  	int		c;
> -	struct xfs_fsop_geom geometry = { 0 };
> +	struct xfs_fd	xfd = XFS_FD_INIT(-1);

XFS_FD_INIT_EMPTY()

Otherwise looks good.

-- 
Dave Chinner
david@fromorbit.com
