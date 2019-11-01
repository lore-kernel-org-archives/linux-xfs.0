Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86CC3CA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 20:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43EA82086D
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 20:18:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QHjSDgZ1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfKAUSG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 16:18:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42044 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfKAUSG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 16:18:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1KE63f026124;
        Fri, 1 Nov 2019 20:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=TV9/aWIqD91jZkBEAkjC/TY0gQ2whm5RbcVYy2eR9X8=;
 b=QHjSDgZ1pyhDTVBbvIYWgXltVPI/YylwpVLBqwUS1oVFqnJvC2Qu30jQii2rlO6eJ1WJ
 C1k7fP3d1+MzvumURvyemIvn8sSsA8jWdmJ5mj3LAlKZdRN0vSZnDALYKfRx0wZMzYHI
 RH08Or8sI96Zur+uevI35YvZVXJE/5iStdW1o2+1aV5ZQr2NWEAHrAOQGITxmWf1bOci
 OWvUP73p7eNEavnXTBDScSgcPEoXfqT7weumYsddhjoadBz0lGRHz7bagSxeQG8tkiIp
 9C8RP+lT7ZoM+KoUZm2+rXiImG9V9WewNb2ZyPCmgIlNZDSct6szHkYf/3rL4EJO2XvW Fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vxwhg3w5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 20:17:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1KDxsE185182;
        Fri, 1 Nov 2019 20:17:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w0qcrnupk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 20:17:43 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA1KHghj030940;
        Fri, 1 Nov 2019 20:17:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Nov 2019 13:17:42 -0700
Date:   Fri, 1 Nov 2019 13:17:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v8 16/16] xfs: move xfs_fc_parse_param() above
 xfs_fc_get_tree()
Message-ID: <20191101201741.GJ15222@magnolia>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
 <157259468795.28278.16467063707250965967.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157259468795.28278.16467063707250965967.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911010186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911010186
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:51:27PM +0800, Ian Kent wrote:
> Grouping the options parsing and mount handling functions above the
> struct fs_context_operations but below the struct super_operations
> should improve (some) the grouping of the super operations while also
> improving the grouping of the options parsing and mount handling code.
> 
> Lastly move xfs_fc_parse_param() and related functions down to above
> xfs_fc_get_tree() and it's related functions.
> 
> But leave the options enum, struct fs_parameter_spec and the struct
> fs_parameter_description declarations at the top since that's the
> logical place for them.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c |  507 ++++++++++++++++++++++++++--------------------------
>  1 file changed, 254 insertions(+), 253 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 7ff35ee0dc8f..9e587a294656 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -111,259 +111,6 @@ static const struct fs_parameter_description xfs_fs_parameters = {
>  	.specs		= xfs_param_specs,
>  };
>  
> -static int
> -suffix_kstrtoint(
> -	const char	*s,
> -	unsigned int	base,
> -	int		*res)
> -{
> -	int		last, shift_left_factor = 0, _res;
> -	char		*value;
> -	int		ret = 0;
> -
> -	value = kstrdup(s, GFP_KERNEL);
> -	if (!value)
> -		return -ENOMEM;
> -
> -	last = strlen(value) - 1;
> -	if (value[last] == 'K' || value[last] == 'k') {
> -		shift_left_factor = 10;
> -		value[last] = '\0';
> -	}
> -	if (value[last] == 'M' || value[last] == 'm') {
> -		shift_left_factor = 20;
> -		value[last] = '\0';
> -	}
> -	if (value[last] == 'G' || value[last] == 'g') {
> -		shift_left_factor = 30;
> -		value[last] = '\0';
> -	}
> -
> -	if (kstrtoint(value, base, &_res))
> -		ret = -EINVAL;
> -	kfree(value);
> -	*res = _res << shift_left_factor;
> -	return ret;
> -}
> -
> -static int
> -xfs_fc_parse_param(
> -	struct fs_context	*fc,
> -	struct fs_parameter	*param)
> -{
> -	struct xfs_mount	*mp = fc->s_fs_info;
> -	struct fs_parse_result	result;
> -	int			size = 0;
> -	int			opt;
> -
> -	opt = fs_parse(fc, &xfs_fs_parameters, param, &result);
> -	if (opt < 0)
> -		return opt;
> -
> -	switch (opt) {
> -	case Opt_logbufs:
> -		mp->m_logbufs = result.uint_32;
> -		return 0;
> -	case Opt_logbsize:
> -		if (suffix_kstrtoint(param->string, 10, &mp->m_logbsize))
> -			return -EINVAL;
> -		return 0;
> -	case Opt_logdev:
> -		kfree(mp->m_logname);
> -		mp->m_logname = kstrdup(param->string, GFP_KERNEL);
> -		if (!mp->m_logname)
> -			return -ENOMEM;
> -		return 0;
> -	case Opt_rtdev:
> -		kfree(mp->m_rtname);
> -		mp->m_rtname = kstrdup(param->string, GFP_KERNEL);
> -		if (!mp->m_rtname)
> -			return -ENOMEM;
> -		return 0;
> -	case Opt_allocsize:
> -		if (suffix_kstrtoint(param->string, 10, &size))
> -			return -EINVAL;
> -		mp->m_allocsize_log = ffs(size) - 1;
> -		mp->m_flags |= XFS_MOUNT_ALLOCSIZE;
> -		return 0;
> -	case Opt_grpid:
> -	case Opt_bsdgroups:
> -		mp->m_flags |= XFS_MOUNT_GRPID;
> -		return 0;
> -	case Opt_nogrpid:
> -	case Opt_sysvgroups:
> -		mp->m_flags &= ~XFS_MOUNT_GRPID;
> -		return 0;
> -	case Opt_wsync:
> -		mp->m_flags |= XFS_MOUNT_WSYNC;
> -		return 0;
> -	case Opt_norecovery:
> -		mp->m_flags |= XFS_MOUNT_NORECOVERY;
> -		return 0;
> -	case Opt_noalign:
> -		mp->m_flags |= XFS_MOUNT_NOALIGN;
> -		return 0;
> -	case Opt_swalloc:
> -		mp->m_flags |= XFS_MOUNT_SWALLOC;
> -		return 0;
> -	case Opt_sunit:
> -		mp->m_dalign = result.uint_32;
> -		return 0;
> -	case Opt_swidth:
> -		mp->m_swidth = result.uint_32;
> -		return 0;
> -	case Opt_inode32:
> -		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> -		return 0;
> -	case Opt_inode64:
> -		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> -		return 0;
> -	case Opt_nouuid:
> -		mp->m_flags |= XFS_MOUNT_NOUUID;
> -		return 0;
> -	case Opt_ikeep:
> -		mp->m_flags |= XFS_MOUNT_IKEEP;
> -		return 0;
> -	case Opt_noikeep:
> -		mp->m_flags &= ~XFS_MOUNT_IKEEP;
> -		return 0;
> -	case Opt_largeio:
> -		mp->m_flags |= XFS_MOUNT_LARGEIO;
> -		return 0;
> -	case Opt_nolargeio:
> -		mp->m_flags &= ~XFS_MOUNT_LARGEIO;
> -		return 0;
> -	case Opt_attr2:
> -		mp->m_flags |= XFS_MOUNT_ATTR2;
> -		return 0;
> -	case Opt_noattr2:
> -		mp->m_flags &= ~XFS_MOUNT_ATTR2;
> -		mp->m_flags |= XFS_MOUNT_NOATTR2;
> -		return 0;
> -	case Opt_filestreams:
> -		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
> -		return 0;
> -	case Opt_noquota:
> -		mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
> -		mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
> -		mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
> -		return 0;
> -	case Opt_quota:
> -	case Opt_uquota:
> -	case Opt_usrquota:
> -		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
> -				 XFS_UQUOTA_ENFD);
> -		return 0;
> -	case Opt_qnoenforce:
> -	case Opt_uqnoenforce:
> -		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
> -		mp->m_qflags &= ~XFS_UQUOTA_ENFD;
> -		return 0;
> -	case Opt_pquota:
> -	case Opt_prjquota:
> -		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
> -				 XFS_PQUOTA_ENFD);
> -		return 0;
> -	case Opt_pqnoenforce:
> -		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
> -		mp->m_qflags &= ~XFS_PQUOTA_ENFD;
> -		return 0;
> -	case Opt_gquota:
> -	case Opt_grpquota:
> -		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
> -				 XFS_GQUOTA_ENFD);
> -		return 0;
> -	case Opt_gqnoenforce:
> -		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
> -		mp->m_qflags &= ~XFS_GQUOTA_ENFD;
> -		return 0;
> -	case Opt_discard:
> -		mp->m_flags |= XFS_MOUNT_DISCARD;
> -		return 0;
> -	case Opt_nodiscard:
> -		mp->m_flags &= ~XFS_MOUNT_DISCARD;
> -		return 0;
> -#ifdef CONFIG_FS_DAX
> -	case Opt_dax:
> -		mp->m_flags |= XFS_MOUNT_DAX;
> -		return 0;
> -#endif
> -	default:
> -		xfs_warn(mp, "unknown mount option [%s].", param->key);
> -		return -EINVAL;
> -	}
> -
> -	return 0;
> -}
> -
> -static int
> -xfs_fc_validate_params(
> -	struct xfs_mount	*mp)
> -{
> -	/*
> -	 * no recovery flag requires a read-only mount
> -	 */
> -	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
> -	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
> -		xfs_warn(mp, "no-recovery mounts must be read-only.");
> -		return -EINVAL;
> -	}
> -
> -	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
> -	    (mp->m_dalign || mp->m_swidth)) {
> -		xfs_warn(mp,
> -	"sunit and swidth options incompatible with the noalign option");
> -		return -EINVAL;
> -	}
> -
> -	if (!IS_ENABLED(CONFIG_XFS_QUOTA) && mp->m_qflags != 0) {
> -		xfs_warn(mp, "quota support not available in this kernel.");
> -		return -EINVAL;
> -	}
> -
> -	if ((mp->m_dalign && !mp->m_swidth) ||
> -	    (!mp->m_dalign && mp->m_swidth)) {
> -		xfs_warn(mp, "sunit and swidth must be specified together");
> -		return -EINVAL;
> -	}
> -
> -	if (mp->m_dalign && (mp->m_swidth % mp->m_dalign != 0)) {
> -		xfs_warn(mp,
> -	"stripe width (%d) must be a multiple of the stripe unit (%d)",
> -			mp->m_swidth, mp->m_dalign);
> -		return -EINVAL;
> -	}
> -
> -	if (mp->m_logbufs != -1 &&
> -	    mp->m_logbufs != 0 &&
> -	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
> -	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
> -		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
> -			mp->m_logbufs, XLOG_MIN_ICLOGS, XLOG_MAX_ICLOGS);
> -		return -EINVAL;
> -	}
> -	if (mp->m_logbsize != -1 &&
> -	    mp->m_logbsize !=  0 &&
> -	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
> -	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
> -	     !is_power_of_2(mp->m_logbsize))) {
> -		xfs_warn(mp,
> -			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
> -			mp->m_logbsize);
> -		return -EINVAL;
> -	}
> -
> -	if ((mp->m_flags & XFS_MOUNT_ALLOCSIZE) &&
> -	    (mp->m_allocsize_log > XFS_MAX_IO_LOG ||
> -	     mp->m_allocsize_log < XFS_MIN_IO_LOG)) {
> -		xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
> -			mp->m_allocsize_log, XFS_MIN_IO_LOG, XFS_MAX_IO_LOG);
> -		return -EINVAL;
> -	}
> -
> -	return 0;
> -}
> -
>  struct proc_xfs_info {
>  	uint64_t	flag;
>  	char		*str;
> @@ -1378,6 +1125,260 @@ xfs_mount_alloc(void)
>  	return mp;
>  }
>  
> +static int
> +suffix_kstrtoint(
> +	const char	*s,
> +	unsigned int	base,
> +	int		*res)
> +{
> +	int		last, shift_left_factor = 0, _res;
> +	char		*value;
> +	int		ret = 0;
> +
> +	value = kstrdup(s, GFP_KERNEL);
> +	if (!value)
> +		return -ENOMEM;
> +
> +	last = strlen(value) - 1;
> +	if (value[last] == 'K' || value[last] == 'k') {
> +		shift_left_factor = 10;
> +		value[last] = '\0';
> +	}
> +	if (value[last] == 'M' || value[last] == 'm') {
> +		shift_left_factor = 20;
> +		value[last] = '\0';
> +	}
> +	if (value[last] == 'G' || value[last] == 'g') {
> +		shift_left_factor = 30;
> +		value[last] = '\0';
> +	}
> +
> +	if (kstrtoint(value, base, &_res))
> +		ret = -EINVAL;
> +	kfree(value);
> +	*res = _res << shift_left_factor;
> +	return ret;
> +}
> +
> +static int
> +xfs_fc_parse_param(
> +	struct fs_context	*fc,
> +	struct fs_parameter	*param)
> +{
> +	struct xfs_mount	*mp = fc->s_fs_info;
> +	struct fs_parse_result	result;
> +	int			size = 0;
> +	int			opt;
> +
> +	opt = fs_parse(fc, &xfs_fs_parameters, param, &result);
> +	if (opt < 0)
> +		return opt;
> +
> +	switch (opt) {
> +	case Opt_logbufs:
> +		mp->m_logbufs = result.uint_32;
> +		return 0;
> +	case Opt_logbsize:
> +		if (suffix_kstrtoint(param->string, 10, &mp->m_logbsize))
> +			return -EINVAL;
> +		return 0;
> +	case Opt_logdev:
> +		kfree(mp->m_logname);
> +		mp->m_logname = kstrdup(param->string, GFP_KERNEL);
> +		if (!mp->m_logname)
> +			return -ENOMEM;
> +		return 0;
> +	case Opt_rtdev:
> +		kfree(mp->m_rtname);
> +		mp->m_rtname = kstrdup(param->string, GFP_KERNEL);
> +		if (!mp->m_rtname)
> +			return -ENOMEM;
> +		return 0;
> +	case Opt_allocsize:
> +		if (suffix_kstrtoint(param->string, 10, &size))
> +			return -EINVAL;
> +		mp->m_allocsize_log = ffs(size) - 1;
> +		mp->m_flags |= XFS_MOUNT_ALLOCSIZE;
> +		return 0;
> +	case Opt_grpid:
> +	case Opt_bsdgroups:
> +		mp->m_flags |= XFS_MOUNT_GRPID;
> +		return 0;
> +	case Opt_nogrpid:
> +	case Opt_sysvgroups:
> +		mp->m_flags &= ~XFS_MOUNT_GRPID;
> +		return 0;
> +	case Opt_wsync:
> +		mp->m_flags |= XFS_MOUNT_WSYNC;
> +		return 0;
> +	case Opt_norecovery:
> +		mp->m_flags |= XFS_MOUNT_NORECOVERY;
> +		return 0;
> +	case Opt_noalign:
> +		mp->m_flags |= XFS_MOUNT_NOALIGN;
> +		return 0;
> +	case Opt_swalloc:
> +		mp->m_flags |= XFS_MOUNT_SWALLOC;
> +		return 0;
> +	case Opt_sunit:
> +		mp->m_dalign = result.uint_32;
> +		return 0;
> +	case Opt_swidth:
> +		mp->m_swidth = result.uint_32;
> +		return 0;
> +	case Opt_inode32:
> +		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> +		return 0;
> +	case Opt_inode64:
> +		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> +		return 0;
> +	case Opt_nouuid:
> +		mp->m_flags |= XFS_MOUNT_NOUUID;
> +		return 0;
> +	case Opt_ikeep:
> +		mp->m_flags |= XFS_MOUNT_IKEEP;
> +		return 0;
> +	case Opt_noikeep:
> +		mp->m_flags &= ~XFS_MOUNT_IKEEP;
> +		return 0;
> +	case Opt_largeio:
> +		mp->m_flags |= XFS_MOUNT_LARGEIO;
> +		return 0;
> +	case Opt_nolargeio:
> +		mp->m_flags &= ~XFS_MOUNT_LARGEIO;
> +		return 0;
> +	case Opt_attr2:
> +		mp->m_flags |= XFS_MOUNT_ATTR2;
> +		return 0;
> +	case Opt_noattr2:
> +		mp->m_flags &= ~XFS_MOUNT_ATTR2;
> +		mp->m_flags |= XFS_MOUNT_NOATTR2;
> +		return 0;
> +	case Opt_filestreams:
> +		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
> +		return 0;
> +	case Opt_noquota:
> +		mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
> +		mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
> +		mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
> +		return 0;
> +	case Opt_quota:
> +	case Opt_uquota:
> +	case Opt_usrquota:
> +		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
> +				 XFS_UQUOTA_ENFD);
> +		return 0;
> +	case Opt_qnoenforce:
> +	case Opt_uqnoenforce:
> +		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
> +		mp->m_qflags &= ~XFS_UQUOTA_ENFD;
> +		return 0;
> +	case Opt_pquota:
> +	case Opt_prjquota:
> +		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
> +				 XFS_PQUOTA_ENFD);
> +		return 0;
> +	case Opt_pqnoenforce:
> +		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
> +		mp->m_qflags &= ~XFS_PQUOTA_ENFD;
> +		return 0;
> +	case Opt_gquota:
> +	case Opt_grpquota:
> +		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
> +				 XFS_GQUOTA_ENFD);
> +		return 0;
> +	case Opt_gqnoenforce:
> +		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
> +		mp->m_qflags &= ~XFS_GQUOTA_ENFD;
> +		return 0;
> +	case Opt_discard:
> +		mp->m_flags |= XFS_MOUNT_DISCARD;
> +		return 0;
> +	case Opt_nodiscard:
> +		mp->m_flags &= ~XFS_MOUNT_DISCARD;
> +		return 0;
> +#ifdef CONFIG_FS_DAX
> +	case Opt_dax:
> +		mp->m_flags |= XFS_MOUNT_DAX;
> +		return 0;
> +#endif
> +	default:
> +		xfs_warn(mp, "unknown mount option [%s].", param->key);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +xfs_fc_validate_params(
> +	struct xfs_mount	*mp)
> +{
> +	/*
> +	 * no recovery flag requires a read-only mount
> +	 */
> +	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
> +	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
> +		xfs_warn(mp, "no-recovery mounts must be read-only.");
> +		return -EINVAL;
> +	}
> +
> +	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
> +	    (mp->m_dalign || mp->m_swidth)) {
> +		xfs_warn(mp,
> +	"sunit and swidth options incompatible with the noalign option");
> +		return -EINVAL;
> +	}
> +
> +	if (!IS_ENABLED(CONFIG_XFS_QUOTA) && mp->m_qflags != 0) {
> +		xfs_warn(mp, "quota support not available in this kernel.");
> +		return -EINVAL;
> +	}
> +
> +	if ((mp->m_dalign && !mp->m_swidth) ||
> +	    (!mp->m_dalign && mp->m_swidth)) {
> +		xfs_warn(mp, "sunit and swidth must be specified together");
> +		return -EINVAL;
> +	}
> +
> +	if (mp->m_dalign && (mp->m_swidth % mp->m_dalign != 0)) {
> +		xfs_warn(mp,
> +	"stripe width (%d) must be a multiple of the stripe unit (%d)",
> +			mp->m_swidth, mp->m_dalign);
> +		return -EINVAL;
> +	}
> +
> +	if (mp->m_logbufs != -1 &&
> +	    mp->m_logbufs != 0 &&
> +	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
> +	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
> +		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
> +			mp->m_logbufs, XLOG_MIN_ICLOGS, XLOG_MAX_ICLOGS);
> +		return -EINVAL;
> +	}
> +
> +	if (mp->m_logbsize != -1 &&
> +	    mp->m_logbsize !=  0 &&
> +	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
> +	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
> +	     !is_power_of_2(mp->m_logbsize))) {
> +		xfs_warn(mp,
> +			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
> +			mp->m_logbsize);
> +		return -EINVAL;
> +	}
> +
> +	if ((mp->m_flags & XFS_MOUNT_ALLOCSIZE) &&
> +	    (mp->m_allocsize_log > XFS_MAX_IO_LOG ||
> +	     mp->m_allocsize_log < XFS_MIN_IO_LOG)) {
> +		xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
> +			mp->m_allocsize_log, XFS_MIN_IO_LOG, XFS_MAX_IO_LOG);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static int
>  xfs_fc_fill_super(
>  	struct super_block	*sb,
> 
