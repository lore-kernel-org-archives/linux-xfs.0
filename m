Return-Path: <SRS0=mWNF=DI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A11F6C4727C
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 15:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66C342145D
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 15:19:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CKduhSWO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732594AbgJAPTv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Oct 2020 11:19:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57084 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732516AbgJAPTv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Oct 2020 11:19:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091FJFZs003850;
        Thu, 1 Oct 2020 15:19:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=V3stt+5hWSPJTXJCW2e+IgCRoVBlF+NaLe6enzriDc8=;
 b=CKduhSWOP5iONb1FwAGHySZmoG8oaDb5dNRqTD85M8A4S9bisbqiCB/K7IvwysQVMd0p
 Rqe10u9BrS6lymmmSyqwyQl8CGNAoxGw9cH3CD4eWnvOsoq/45aV14fDkgl5+9g8tQRy
 Q8V7TzrXaqOE1AMfcPVg5b3YkTgSsnn0XmNLau7+cQ2L/OxvSpoqgwChQx7R4Wg06hyI
 CNbP8XxokCmFz3dRwx69L11NnitmX/bSwlKn7rrkjd0GKQuvc7aV07Uec0VFvFkevG+U
 8VmXZ42co35L6YqeGlVRbsiMVb2hnliKtRS8l9KYySCja79XYQvSomyyE3TgheuTfT/b EQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33sx9nekba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 01 Oct 2020 15:19:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091FF9mG072728;
        Thu, 1 Oct 2020 15:19:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33uv2h2psc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Oct 2020 15:19:45 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 091FJiXp012217;
        Thu, 1 Oct 2020 15:19:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Oct 2020 08:19:43 -0700
Date:   Thu, 1 Oct 2020 08:19:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfsprogs: ignore autofs mount table entries
Message-ID: <20201001151942.GP49547@magnolia>
References: <160151439137.66595.8436234885474855194.stgit@mickey.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160151439137.66595.8436234885474855194.stgit@mickey.themaw.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1011
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010132
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 01, 2020 at 09:06:31AM +0800, Ian Kent wrote:
> Some of the xfsprogs utilities read the mount table via. getmntent(3).
> 
> The mount table may contain (almost always these days since /etc/mtab is
> symlinked to /proc/self/mounts) autofs mount entries. During processing
> of the mount table entries statfs(2) can be called on mount point paths
> which will trigger an automount if those entries are direct or offset
> autofs mount triggers (indirect autofs mounts aren't affected).
> 
> This can be a problem when there are a lot of autofs direct or offset
> mounts because real mounts will be triggered when statfs(2) is called.
> This can be particularly bad if the triggered mounts are NFS mounts and
> the server is unavailable leading to lengthy boot times or worse.
> 
> Simply ignoring autofs mount entries during getmentent(3) traversals
> avoids the statfs() call that triggers these mounts. If there are
> automounted mounts (real mounts) at the time of reading the mount table
> these will still be seen in the list so they will be included if that
> actually matters to the reader.
> 
> Recent glibc getmntent(3) can ignore autofs mounts but that requires the
> autofs user to configure autofs to use the "ignore" pseudo mount option
> for autofs mounts. But this isn't yet the autofs default (to prevent
> unexpected side effects) so that can't be used.
> 
> The autofs direct and offset automount triggers are pseudo file system
> mounts and are more or less useless in terms on file system information
> so excluding them doesn't sacrifice useful file system information
> either.
> 
> Consequently excluding autofs mounts shouldn't have any adverse side
> effects.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fsr/xfs_fsr.c   |    3 +++
>  libfrog/linux.c |    2 ++
>  libfrog/paths.c |    2 ++
>  3 files changed, 7 insertions(+)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 77a10a1d..466ad9e4 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -323,6 +323,9 @@ initallfs(char *mtab)
>  	while ((mnt = platform_mntent_next(&cursor)) != NULL) {
>  		int rw = 0;
>  
> +		if (!strcmp(mnt->mnt_type, "autofs"))
> +			continue;

Hmm...  the libfrog changes look decent, but it strikes me as a little
odd that we don't just make platform_mntent_next filter that out?

(Or I guess refactor fsr to use the fs table...)

OTOH "Not _another_ herring^Wrefactor!"

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +
>  		if (strcmp(mnt->mnt_type, MNTTYPE_XFS ) != 0 ||
>  		    stat(mnt->mnt_fsname, &sb) == -1 ||
>  		    !S_ISBLK(sb.st_mode))
> diff --git a/libfrog/linux.c b/libfrog/linux.c
> index 40a839d1..a45d99ab 100644
> --- a/libfrog/linux.c
> +++ b/libfrog/linux.c
> @@ -73,6 +73,8 @@ platform_check_mount(char *name, char *block, struct stat *s, int flags)
>  	 * servers.  So first, a simple check: does the "dev" start with "/" ?
>  	 */
>  	while ((mnt = getmntent(f)) != NULL) {
> +		if (!strcmp(mnt->mnt_type, "autofs"))
> +			continue;
>  		if (mnt->mnt_fsname[0] != '/')
>  			continue;
>  		if (stat(mnt->mnt_dir, &mst) < 0)
> diff --git a/libfrog/paths.c b/libfrog/paths.c
> index 32737223..d6793764 100644
> --- a/libfrog/paths.c
> +++ b/libfrog/paths.c
> @@ -389,6 +389,8 @@ fs_table_initialise_mounts(
>  			return errno;
>  
>  	while ((mnt = getmntent(mtp)) != NULL) {
> +		if (!strcmp(mnt->mnt_type, "autofs"))
> +			^continue;
>  		if (!realpath(mnt->mnt_dir, rmnt_dir))
>  			continue;
>  		if (!realpath(mnt->mnt_fsname, rmnt_fsname))
> 
> 
