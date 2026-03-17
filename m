Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68D7346E66
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 02:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773715063; cv=none; b=vARSjLUA7YyccRgOz2K5DddXOvXZi6460k5Pv7HIh8NiUQyEKnzzOC770N0zwmAAAWBeULl/Pp2BKMM97lsn76tlmXn4DsI3RbHPbvfMKGTg7K6YPZ6nJvTtwEVWbXvMw6T68hsOEi7or92ox/sQzEHurM77k658VrBmfyMmAV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773715063; c=relaxed/simple;
	bh=ijCCkd1g8KtlX5FeXh3bqwjdNFB1Ee2ugVa4zUX9d7U=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZlJoaniJZJHbJ76rC9d9Rhqngf2I81v7/9TFiulb76y4UJF/tfKbPUIOwvvu/MICSNzO8rdLbzpbqeCLY/k06jGK5E9l4VT9LfZPu8LkKUIRhP9dthF2XjsxflkaLUJsyuW1Mq3Lh0hAXGccUnbw4xa8b8pg+n1Vl4YOY43S9Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=Z2FU606R; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="Z2FU606R"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=WL8xayYGV+2T2j7/lUxCUrow3+9LV5VcBQh25IRBhBI=;
	b=Z2FU606RFdotic3oqOKdAXiJhVx9lAEYgq91tvZWEDbxg1yCghFQgOyHX+xEAnA67HHxV9plO
	6SSkG2GC5nP1cgsIl5aYB2OyCaaRGwpglUUitU2bUkTgNx6zhYG8NIAt3HQ7Ea/hN7LCkbswNK4
	WzxDfGSEli4aPI0h3v0XNX8=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fZbZQ04tLznTWg;
	Tue, 17 Mar 2026 10:31:58 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 763B04055B;
	Tue, 17 Mar 2026 10:37:30 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 17 Mar 2026 10:37:30 +0800
Received: from localhost (10.50.85.155) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 17 Mar
 2026 10:37:29 +0800
Date: Tue, 17 Mar 2026 10:33:20 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <cem@kernel.org>, <linux-xfs@vger.kernel.org>, <david@fromorbit.com>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: Re: [PATCH 3/3] xfs: simplify iovec validation in
 xlog_recover_attri_commit_pass2
Message-ID: <abi9cPp1pfsVhsAD@localhost.localdomain>
References: <20260316012416.2413909-1-leo.lilong@huawei.com>
 <20260316012416.2413909-4-leo.lilong@huawei.com>
 <20260316224632.GE1770774@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260316224632.GE1770774@frogsfrogsfrogs>
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemn100013.china.huawei.com (7.202.194.116)

On Mon, Mar 16, 2026 at 03:46:32PM -0700, Darrick J. Wong wrote:
> On Mon, Mar 16, 2026 at 09:24:16AM +0800, Long Li wrote:
> > Consolidate the per-case ri_total checks into a single comparison by
> > assigning the expected iovec count to a local variable inside each
> > switch arm, removing four nearly identical error blocks.
> > 
> > Remove the redundant post-parse validation switch. By the time that
> > block is reached, xfs_attri_validate() has already guaranteed all name
> > lengths are non-zero via xfs_attri_validate_namelen(), and
> > xfs_attri_validate_name_iovec() has already returned -EFSCORRUPTED for
> > NULL names. For the REMOVE case, attr_value and value_len are
> > structurally guaranteed to be NULL/zero because the parsing loop only
> > populates them when value_len != 0. All checks in that switch are
> > therefore dead code.
> > 
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/xfs_attr_item.c | 79 +++++++-----------------------------------
> >  1 file changed, 12 insertions(+), 67 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> > index 21da995ba4e7..32236f5008ec 100644
> > --- a/fs/xfs/xfs_attr_item.c
> > +++ b/fs/xfs/xfs_attr_item.c
> > @@ -1016,12 +1016,13 @@ xlog_recover_attri_commit_pass2(
> >  	unsigned int			new_name_len = 0;
> >  	unsigned int			new_value_len = 0;
> >  	unsigned int			op, i = 0;
> > +	unsigned int			expected = 0;
> >  
> >  	/* Validate xfs_attri_log_format before the large memory allocation */
> >  	len = sizeof(struct xfs_attri_log_format);
> >  	if (item->ri_buf[i].iov_len != len) {
> >  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> > -				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
> > +				item->ri_buf[i].iov_base, item->ri_buf[i].iov_len);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > @@ -1038,32 +1039,20 @@ xlog_recover_attri_commit_pass2(
> >  	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
> >  	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
> >  		/* Log item, attr name, attr value */
> > -		if (item->ri_total != 3) {
> > -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> > -					     attri_formatp, len);
> > -			return -EFSCORRUPTED;
> > -		}
> > +		expected = 3;
> >  		name_len = attri_formatp->alfi_name_len;
> >  		value_len = attri_formatp->alfi_value_len;
> >  		break;
> >  	case XFS_ATTRI_OP_FLAGS_SET:
> >  	case XFS_ATTRI_OP_FLAGS_REPLACE:
> >  		/* Log item, attr name, attr value */
> > -		if (item->ri_total != 2 + !!attri_formatp->alfi_value_len) {
> > -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> > -					     attri_formatp, len);
> > -			return -EFSCORRUPTED;
> > -		}
> > +		expected = 2 + !!attri_formatp->alfi_value_len;
> >  		name_len = attri_formatp->alfi_name_len;
> >  		value_len = attri_formatp->alfi_value_len;
> >  		break;
> >  	case XFS_ATTRI_OP_FLAGS_REMOVE:
> >  		/* Log item, attr name */
> > -		if (item->ri_total != 2) {
> > -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> > -					     attri_formatp, len);
> > -			return -EFSCORRUPTED;
> > -		}
> > +		expected = 2;
> >  		name_len = attri_formatp->alfi_name_len;
> >  		break;
> >  	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
> > @@ -1071,11 +1060,7 @@ xlog_recover_attri_commit_pass2(
> >  		 * Log item, attr name, new attr name, attr value, new attr
> >  		 * value
> >  		 */
> > -		if (item->ri_total != 5) {
> > -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> > -					     attri_formatp, len);
> > -			return -EFSCORRUPTED;
> > -		}
> > +		expected = 5;
> >  		name_len = attri_formatp->alfi_old_name_len;
> >  		new_name_len = attri_formatp->alfi_new_name_len;
> >  		new_value_len = value_len = attri_formatp->alfi_value_len;
> > @@ -1085,6 +1070,12 @@ xlog_recover_attri_commit_pass2(
> >  				     attri_formatp, len);
> >  		return -EFSCORRUPTED;
> >  	}
> > +
> > +	if (item->ri_total != expected) {
> > +		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> 
> The downside to this change is that XFS_CORRUPTION_ERROR prints the
> source file and line number, so now anyone looking through the logs
> cannot identify a specific line number.  However...
> 

The corrupted information will output the entire `xfs_attri_log_format`,
from which the operation type can also be inferred. However, the original
code outputs more intuitive information, and thus it might be fine to leave
it unchanged.

Thanks,
Long Li

