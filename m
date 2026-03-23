Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E2B33C53F
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 07:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774251496; cv=none; b=WihbVjcA9j5D+s7nQEhRQlD9LixqsRHnOZgGjHq3WdIu86+LBjxl4kEr60JqpVq58wErTzMWGSbCRM2xutzR4dOqYUnMXkId+XlHbjMOt1DC4UJrhj64n3MQfXYbd8f6AOVGqJsAVPRhYl1tcbdYzOschgUvJxp0SVXM0GXYL6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774251496; c=relaxed/simple;
	bh=W8zk4L8XulFSN42zEB2JwOJUyYb0R04I1cEQViXzRJo=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZNNhn1xAhs18VSz+CadgICQ2XRyWP+DyLVUPYJ7QAQXsMwXuUMEIfN0ItaplTh//YOMGGfuXP0sFUKXUsRg85UFQptQJ1M/Ua+BwOx4cDBhzy1ipJRgaV4ZO4bdoeGkHkiR8CK/ASulwaH+iEQJ9XxFRtfvkEoQLGRR6AQroZhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=Mb/La/j3; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="Mb/La/j3"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Vdmhnl+GuPSSDnJOAdLMwXcxfnW2GGDGl9PmEtX0ccg=;
	b=Mb/La/j3AS+m2zJSh7ZKvHpw+eyQE20Ng8zHq1ZIxcyrhBhjbbuw44kWx5nGpwD4EU4DbgW2r
	SAQMkeD429c0CIrGQ3ulLGjA+zqxyJdTQPpcLuUEp+tzt+oObusqTpcK/clwSXQL/ACsKImaYTP
	Fa8H1KHXkLx3h+7vqqgYCAM=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4ffPyD5s7SzcZyP;
	Mon, 23 Mar 2026 15:32:20 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id DB3BE404AD;
	Mon, 23 Mar 2026 15:38:08 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 23 Mar 2026 15:38:08 +0800
Received: from localhost (10.50.85.155) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 23 Mar
 2026 15:38:08 +0800
Date: Mon, 23 Mar 2026 15:33:38 +0800
From: Long Li <leo.lilong@huawei.com>
To: Christoph Hellwig <hch@infradead.org>
CC: <djwong@kernel.org>, <cem@kernel.org>, <linux-xfs@vger.kernel.org>,
	<david@fromorbit.com>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<yangerkun@huawei.com>, <lonuxli.64@gmail.com>
Subject: Re: [PATCH v3 1/2] xfs: fix ri_total validation in
 xlog_recover_attri_commit_pass2
Message-ID: <acDs0lV_O3tkKpKc@localhost.localdomain>
References: <20260320021130.2936657-1-leo.lilong@huawei.com>
 <20260320021130.2936657-2-leo.lilong@huawei.com>
 <acDaZj40D3-j2Y50@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <acDaZj40D3-j2Y50@infradead.org>
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemn100013.china.huawei.com (7.202.194.116)

On Sun, Mar 22, 2026 at 11:15:02PM -0700, Christoph Hellwig wrote:
> On Fri, Mar 20, 2026 at 10:11:29AM +0800, Long Li wrote:
> > This problem may cause log recovery failures. The following script can be
> > used to reproduce the problem:
> 
> Can you add this to xfstests, please?

Okay.

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> 

Thanks for your review.

Long Li
