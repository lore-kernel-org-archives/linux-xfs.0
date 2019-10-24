Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E263DCA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 15:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A619021655
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 15:52:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LgLlvUHv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407481AbfJXPwV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 11:52:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47532 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733169AbfJXPwV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 11:52:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9OFog0l077787;
        Thu, 24 Oct 2019 15:52:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=5V/f7jfrIo34BWgYKcQ/wMVh0HnQmL6lJbGEdjB0m6k=;
 b=LgLlvUHvbgZDNkgISOXhXcX0g+6nHpPbQo3F352IvgfhYpfRj0umgWBq40MEapoBFeO+
 LZCQ3FUn3sFYREBS27WAdRz09rSlDCiCkFUoJhxJQZwaolrRw8KrOwkxRQ1iEN5QXeTm
 ShIJTUnjHsyiX+wXQcFSt8nuaE6NPRe2RNmJEDN31bKpHCM5TFHiuKkRB1Z5AFUOAp2t
 x5H2eEleU7onByOHlXqgcCJv6LlFrexLUag49RAsLtkUjxxGNRCNSjcfMMBjUsiR+fSt
 M5NtTOSBoOjAiPwOqhArpNCbq4vNp7Y9eKg+PRZ+iid20XO6XOS4UhL/rrYMsixKQHuh XQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vqswtvpmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 15:52:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9OFoRve147861;
        Thu, 24 Oct 2019 15:52:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vtjkjyuxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 15:52:00 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9OFpwJZ029853;
        Thu, 24 Oct 2019 15:51:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 08:51:58 -0700
Date:   Thu, 24 Oct 2019 08:51:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v7 14/17] xfs: move xfs_parseargs() validation to a helper
Message-ID: <20191024155156.GX913374@magnolia>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
 <157190350890.27074.6204984936498640245.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157190350890.27074.6204984936498640245.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910240147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910240147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 03:51:48PM +0800, Ian Kent wrote:
> Move the validation code of xfs_parseargs() into a helper for later
> use within the mount context methods.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c |  128 ++++++++++++++++++++++++++++------------------------
>  1 file changed, 69 insertions(+), 59 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index de0ab79536b3..b3c27a0781ed 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -314,68 +314,13 @@ xfs_fc_parse_param(
>  	return 0;
>  }
>  
> -/*
> - * This function fills in xfs_mount_t fields based on mount args.
> - * Note: the superblock has _not_ yet been read in.
> - *
> - * Note that this function leaks the various device name allocations on
> - * failure.  The caller takes care of them.
> - *
> - * *sb is const because this is also used to test options on the remount
> - * path, and we don't want this to have any side effects at remount time.
> - * Today this function does not change *sb, but just to future-proof...
> - */
>  static int
> -xfs_parseargs(
> +xfs_fc_validate_params(
>  	struct xfs_mount	*mp,
> -	char			*options)
> +	int			dsunit,
> +	int			dswidth,
> +	uint8_t			iosizelog)
>  {
> -	const struct super_block *sb = mp->m_super;
> -	char			*p;
> -	substring_t		args[MAX_OPT_ARGS];
> -	int			dsunit = 0;
> -	int			dswidth = 0;
> -	uint8_t			iosizelog = 0;
> -
> -	/*
> -	 * Copy binary VFS mount flags we are interested in.
> -	 */
> -	if (sb_rdonly(sb))
> -		mp->m_flags |= XFS_MOUNT_RDONLY;
> -	if (sb->s_flags & SB_DIRSYNC)
> -		mp->m_flags |= XFS_MOUNT_DIRSYNC;
> -	if (sb->s_flags & SB_SYNCHRONOUS)
> -		mp->m_flags |= XFS_MOUNT_WSYNC;
> -
> -	/*
> -	 * Set some default flags that could be cleared by the mount option
> -	 * parsing.
> -	 */
> -	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> -
> -	/*
> -	 * These can be overridden by the mount option parsing.
> -	 */
> -	mp->m_logbufs = -1;
> -	mp->m_logbsize = -1;
> -
> -	if (!options)
> -		return 0;
> -
> -	while ((p = strsep(&options, ",")) != NULL) {
> -		int		token;
> -		int		ret;
> -
> -		if (!*p)
> -			continue;
> -
> -		token = match_token(p, tokens, args);
> -		ret = xfs_fc_parse_param(token, p, args, mp, &dsunit, &dswidth,
> -					 &iosizelog);
> -		if (ret)
> -			return ret;
> -	}
> -
>  	/*
>  	 * no recovery flag requires a read-only mount
>  	 */
> @@ -600,6 +545,71 @@ xfs_remount_ro(
>  	return 0;
>  }
>  
> +/*
> + * This function fills in xfs_mount_t fields based on mount args.
> + * Note: the superblock has _not_ yet been read in.
> + *
> + * Note that this function leaks the various device name allocations on
> + * failure.  The caller takes care of them.
> + *
> + * *sb is const because this is also used to test options on the remount
> + * path, and we don't want this to have any side effects at remount time.
> + * Today this function does not change *sb, but just to future-proof...
> + */
> +static int
> +xfs_parseargs(
> +	struct xfs_mount	*mp,
> +	char			*options)
> +{
> +	const struct super_block *sb = mp->m_super;
> +	char			*p;
> +	substring_t		args[MAX_OPT_ARGS];
> +	int			dsunit = 0;
> +	int			dswidth = 0;
> +	uint8_t			iosizelog = 0;
> +
> +	/*
> +	 * Copy binary VFS mount flags we are interested in.
> +	 */
> +	if (sb_rdonly(sb))
> +		mp->m_flags |= XFS_MOUNT_RDONLY;
> +	if (sb->s_flags & SB_DIRSYNC)
> +		mp->m_flags |= XFS_MOUNT_DIRSYNC;
> +	if (sb->s_flags & SB_SYNCHRONOUS)
> +		mp->m_flags |= XFS_MOUNT_WSYNC;
> +
> +	/*
> +	 * Set some default flags that could be cleared by the mount option
> +	 * parsing.
> +	 */
> +	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> +
> +	/*
> +	 * These can be overridden by the mount option parsing.
> +	 */
> +	mp->m_logbufs = -1;
> +	mp->m_logbsize = -1;
> +
> +	if (!options)
> +		return 0;
> +
> +	while ((p = strsep(&options, ",")) != NULL) {
> +		int		token;
> +		int		ret;
> +
> +		if (!*p)
> +			continue;
> +
> +		token = match_token(p, tokens, args);
> +		ret = xfs_fc_parse_param(token, p, args, mp, &dsunit, &dswidth,
> +					 &iosizelog);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return xfs_fc_validate_params(mp, dsunit, dswidth, iosizelog);
> +}
> +
>  struct proc_xfs_info {
>  	uint64_t	flag;
>  	char		*str;
> 
