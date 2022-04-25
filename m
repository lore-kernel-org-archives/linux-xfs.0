Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F72C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Apr 2022 16:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbiDYQgk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 12:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232384AbiDYQgj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 12:36:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781E4DEBAC
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 09:33:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B243B818F8
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 16:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E028FC385A7;
        Mon, 25 Apr 2022 16:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650904412;
        bh=/+UynYLskulQHg3hyJWKUH78O7LhnefIAlxlmlIYS+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f55N4djZAEZsxCqEdXM1IvAy+v0T+RrmDi7/hJYIw/CO54m68Ns7nejG/8t596jx2
         Im7K5sGp2AqVaxg1NskthaKDlM7KzVRDaGNgW3LQj9D2gAAsCl1w/cPDuQNySy0sW4
         FISBb8ZylrJlB8MRY8rWqzta9teCYAN2nG9UkPrLPOU8fBCHBOJAAZnqAdJTIMnRsY
         eoGlelJ5odR8yRlgIJms1etes5Qa8QIzRnF6QX3r3FLGxiAvCgBTwvpZgUpoW8XdQQ
         mXs2ztiD4TA45iPwpFGYwosmYM/N14mIb25AIX7BgVOUoMSPSnZFJddis6xRU/xd8N
         wQpkSge28BJyA==
Date:   Mon, 25 Apr 2022 09:33:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 5/5] xfs_quota: apply -L/-U range limits in
 uid/gid/pid loops
Message-ID: <20220425163332.GK17025@magnolia>
References: <20220420144507.269754-1-aalbersh@redhat.com>
 <20220420144507.269754-6-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420144507.269754-6-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 20, 2022 at 04:45:08PM +0200, Andrey Albershteyn wrote:
> In case kernel doesn't support XFS_GETNEXTQUOTA the report/dump
> command will fallback to iterating over all known uid/gid/pid.
> However, currently it won't take -L/-U range limits into account
> (all entities with non-zero qoutas will be outputted). This applies
> those limits for fallback case.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  quota/report.c | 40 +++++++++++++++++++++++++++-------------
>  1 file changed, 27 insertions(+), 13 deletions(-)
> 
> diff --git a/quota/report.c b/quota/report.c
> index 65d931f3..8af763e4 100644
> --- a/quota/report.c
> +++ b/quota/report.c
> @@ -161,9 +161,11 @@ dump_limits_any_type(
>  			struct group *g;
>  			setgrent();
>  			while ((g = getgrent()) != NULL) {
> -				get_dquot(&d, g->gr_gid, NULL, type,
> -						mount->fs_name, 0);
> -				dump_file(fp, &d, mount->fs_name);
> +				if (get_dquot(&d, g->gr_gid, NULL, type,
> +							mount->fs_name, 0) &&
> +						!(lower && (d.d_id < lower)) &&
> +						!(upper && (d.d_id > upper)))
> +					dump_file(fp, &d, mount->fs_name);
>  			}
>  			endgrent();
>  			break;
> @@ -172,9 +174,11 @@ dump_limits_any_type(
>  			struct fs_project *p;
>  			setprent();
>  			while ((p = getprent()) != NULL) {
> -				get_dquot(&d, p->pr_prid, NULL, type,
> -						mount->fs_name, 0);
> -				dump_file(fp, &d, mount->fs_name);
> +				if (get_dquot(&d, p->pr_prid, NULL, type,
> +							mount->fs_name, 0) &&
> +						!(lower && (d.d_id < lower)) &&
> +						!(upper && (d.d_id > upper)))
> +					dump_file(fp, &d, mount->fs_name);
>  			}
>  			endprent();
>  			break;
> @@ -183,9 +187,11 @@ dump_limits_any_type(
>  			struct passwd *u;
>  			setpwent();
>  			while ((u = getpwent()) != NULL) {
> -				get_dquot(&d, u->pw_uid, NULL, type,
> -						mount->fs_name, 0);
> -				dump_file(fp, &d, mount->fs_name);
> +				if (get_dquot(&d, u->pw_uid, NULL, type,
> +							mount->fs_name, 0) &&
> +						!(lower && (d.d_id < lower)) &&
> +						!(upper && (d.d_id > upper)))
> +					dump_file(fp, &d, mount->fs_name);
>  			}
>  			endpwent();
>  			break;
> @@ -478,7 +484,9 @@ report_user_mount(
>  		setpwent();
>  		while ((u = getpwent()) != NULL) {
>  			if (get_dquot(&d, u->pw_uid, NULL, XFS_USER_QUOTA,
> -						mount->fs_name, flags)) {
> +						mount->fs_name, flags) &&
> +					!(lower && (d.d_id < lower)) &&
> +					!(upper && (d.d_id > upper))) {
>  				report_mount(fp, &d, u->pw_name, form,
>  						XFS_USER_QUOTA, mount, flags);
>  				flags |= NO_HEADER_FLAG;
> @@ -518,7 +526,9 @@ report_group_mount(
>  		setgrent();
>  		while ((g = getgrent()) != NULL) {
>  			if (get_dquot(&d, g->gr_gid, NULL, XFS_GROUP_QUOTA,
> -						mount->fs_name, flags)) {
> +						mount->fs_name, flags) &&
> +					!(lower && (d.d_id < lower)) &&
> +					!(upper && (d.d_id > upper))) {
>  				report_mount(fp, &d, g->gr_name, form,
>  						XFS_GROUP_QUOTA, mount, flags);
>  				flags |= NO_HEADER_FLAG;
> @@ -560,7 +570,9 @@ report_project_mount(
>  			 * isn't defined
>  			 */
>  			if (get_dquot(&d, 0, NULL, XFS_PROJ_QUOTA,
> -						mount->fs_name, flags)) {
> +						mount->fs_name, flags) &&
> +					!(lower && (d.d_id < lower)) &&
> +					!(upper && (d.d_id > upper))) {
>  				report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA,
>  						mount, flags);
>  				flags |= NO_HEADER_FLAG;
> @@ -570,7 +582,9 @@ report_project_mount(
>  		setprent();
>  		while ((p = getprent()) != NULL) {
>  			if (get_dquot(&d, p->pr_prid, NULL, XFS_PROJ_QUOTA,
> -						mount->fs_name, flags)) {
> +						mount->fs_name, flags) &&
> +					!(lower && (d.d_id < lower)) &&
> +					!(upper && (d.d_id > upper))) {
>  				report_mount(fp, &d, p->pr_name, form,
>  						XFS_PROJ_QUOTA, mount, flags);
>  				flags |= NO_HEADER_FLAG;
> -- 
> 2.27.0
> 
