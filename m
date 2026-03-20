Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25DF313E34
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 02:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773972432; cv=none; b=INUDaV1rTZIMGnvB9mZubU50SYimeB23MvWpqaGX1zy0j+76h3xaVNZBs4z8yv8BJZeswNyjTpbEuxiIo8O8aBfS63lkfIPOejN4nJCbg7l9sqhfG7v3RHw3mA/U1gKG65EmBv06fQ/KFfB+rXU7BWNhKpK0TcUeUytq90zOKq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773972432; c=relaxed/simple;
	bh=wHFWpC3vDQEqq65QHaqZVy1r6GFSfqd6Ji6JSSVsbEY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u0ifAoG+0VQnc8vb54n7/jdijr+/zRjNvfd5HDBsddbYH8WN8MvS4L35UpeTBbGKD2Cwhna3SJDKpxMO0XWq40JULNljWPnkVkYElF+k8t7fEVxtpS7dVB3zqRsF7WQdSf8SO9dvCoxsxr2U3pitrilHi4jv2L/OvziTIZ2Q5BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=P4tX24Qa; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="P4tX24Qa"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lTWC3ZUc1kuxpWxIZbM+h/Tgu72glHzlYXF2En43hsA=;
	b=P4tX24QaItzTSM3ZlnF9Zy3LugJPl4fqfICiX2L3UZ5NBvqSqUZ7leLAS3JVZpoeERFYjwYEf
	zPqNUE+XTQEbM2tCKHBano08AT31qlUW75IClTSxdHpm54NleD6V+QTOW6ubxFOHmxQFyGOM2YE
	b2pXv/QCmiziEh/v85zIBug=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4fcQlP4rDBz1K9WP;
	Fri, 20 Mar 2026 10:01:05 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id BB44E40562;
	Fri, 20 Mar 2026 10:07:05 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 20 Mar 2026 10:07:05 +0800
Received: from localhost (10.50.85.155) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 20 Mar
 2026 10:07:05 +0800
Date: Fri, 20 Mar 2026 10:02:45 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <cem@kernel.org>, <linux-xfs@vger.kernel.org>, <david@fromorbit.com>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: Re: [PATCH 2/2] xfs: don't irele after failing to iget in
 xfs_attri_recover_work
Message-ID: <abyqxTS51HFs2xjS@localhost.localdomain>
References: <20260319170938.GS1770774@frogsfrogsfrogs>
 <20260319171044.GT1770774@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260319171044.GT1770774@frogsfrogsfrogs>
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemn100013.china.huawei.com (7.202.194.116)

On Thu, Mar 19, 2026 at 10:10:44AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xlog_recovery_iget* never set @ip to a valid pointer if they return
> zero, so this irele will walk off a dangling pointer.  Fix that.
> 
> Cc: <stable@vger.kernel.org> # v6.10
> Fixes: ae673f534a3097 ("xfs: record inode generation in xattr update log intent items")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_attr_item.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 354472bf45f145..fe909bc44c3a79 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -653,7 +653,6 @@ xfs_attri_recover_work(
>  		break;
>  	}
>  	if (error) {
> -		xfs_irele(ip);
>  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, attrp,
>  				sizeof(*attrp));
>  		return ERR_PTR(-EFSCORRUPTED);
> 

Looks good
Reviewed-by: Long Li <leo.lilong@huawei.com>
