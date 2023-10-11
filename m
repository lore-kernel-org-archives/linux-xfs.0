Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A170CDB47E
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 21:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbjJKVpj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 17:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbjJKVpi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 17:45:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BACA9E
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 14:45:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29E7C433C8;
        Wed, 11 Oct 2023 21:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697060736;
        bh=2UKYjeSJgKNiyJSFHO8ciVdhVUdBe80yYC2WlOJNXvk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e42rcLtv5v8s9v+1LiAIAE635VGwAk4Oh3hj8Col34q8q21y4MoL9G3W512xZu2bn
         MlKO+pBSNTiuDBtUOxwhlM2entEe98wcUbMzMSfSp7+b4ZIBW9sVQWDedkgZdHrzrU
         uqFvQLKHnNFtLUu+uwnOhSrJZ15Nd1PCdS9huX69MziUdH7/8Z7WSkUkrHj8HYNYck
         /39Dh1Go2Fh82hsmsXbFHygWYhVuf1HpqUHETNUNRlVtqFFu/VNSjirmi4y3WgHcIk
         k5K8pRLSZv1ZOEk4XmBYLfdXOufJtEqbfgUYVsztcXWDU65rVhoyJJ1pjpYD02HYJq
         1MuI/Z8WxgDmQ==
Date:   Wed, 11 Oct 2023 14:45:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_quota: fix missing mount point warning
Message-ID: <20231011214535.GB21298@frogsfrogsfrogs>
References: <20231011205054.115937-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011205054.115937-1-preichl@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 10:50:54PM +0200, Pavel Reichl wrote:
> When user have mounted an XFS volume, and defined project in
> /etc/projects file that points to a directory on a different volume,
> then:
> 	`xfs_quota -xc "report -a" $path_to_mounted_volume'
> 
> complains with:
> 	"xfs_quota: cannot find mount point for path \
> `directory_from_projects': Invalid argument"
> 
> unlike `xfs_quota -xc "report -a"' which works as expected and no
> warning is printed.
> 
> This is happening because in the 1st call we pass to xfs_quota command
> the $path_to_mounted_volume argument which says to xfs_quota not to
> look for all mounted volumes on the system, but use only those passed
> to the command and ignore all others (This behavior is intended as an
> optimization for systems with huge number of mounted volumes). After
> that, while projects are initialized, the project's directories on
> other volumes are obviously not in searched subset of volumes and
> warning is printed.
> 
> I propose to fix this behavior by conditioning the printing of warning
> only if all mounted volumes are searched.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  libfrog/paths.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/libfrog/paths.c b/libfrog/paths.c
> index abb29a237..d8c42163a 100644
> --- a/libfrog/paths.c
> +++ b/libfrog/paths.c
> @@ -457,7 +457,8 @@ fs_table_insert_mount(
>  
>  static int
>  fs_table_initialise_projects(
> -	char		*project)
> +	char		*project,
> +	bool		all_mps_initialised)

I might've called all of these @warn_notfound, but that's my nitpicky
preference. :)

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  {
>  	fs_project_path_t *path;
>  	fs_path_t	*fs;
> @@ -473,8 +474,10 @@ fs_table_initialise_projects(
>  			continue;
>  		fs = fs_mount_point_from_path(path->pp_pathname);
>  		if (!fs) {
> -			fprintf(stderr, _("%s: cannot find mount point for path `%s': %s\n"),
> -					progname, path->pp_pathname, strerror(errno));
> +			if (all_mps_initialised)
> +				fprintf(stderr,
> +	_("%s: cannot find mount point for path `%s': %s\n"), progname,
> +					path->pp_pathname, strerror(errno));
>  			continue;
>  		}
>  		(void) fs_table_insert(path->pp_pathname, path->pp_prid,
> @@ -495,11 +498,12 @@ fs_table_initialise_projects(
>  
>  static void
>  fs_table_insert_project(
> -	char		*project)
> +	char		*project,
> +	bool		all_mps_initialised)
>  {
>  	int		error;
>  
> -	error = fs_table_initialise_projects(project);
> +	error = fs_table_initialise_projects(project, all_mps_initialised);
>  	if (error)
>  		fprintf(stderr, _("%s: cannot setup path for project %s: %s\n"),
>  			progname, project, strerror(error));
> @@ -532,9 +536,9 @@ fs_table_initialise(
>  	}
>  	if (project_count) {
>  		for (i = 0; i < project_count; i++)
> -			fs_table_insert_project(projects[i]);
> +			fs_table_insert_project(projects[i], mount_count == 0);
>  	} else {
> -		error = fs_table_initialise_projects(NULL);
> +		error = fs_table_initialise_projects(NULL, mount_count == 0);
>  		if (error)
>  			goto out_error;
>  	}
> -- 
> 2.41.0
> 
