Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E874A7641E
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 09:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724751117; cv=none; b=P/nhpz+rUpg6ffwqWDWAhJZ3UEUVP4dQMVjiQ3cgTpIvXPNoCk29Ct5LR7C2YxAId+GpTdYaaYo0Guyi6KjILCnqNDpLyk3tlkGx3fWb75fmzyqxZHFNRfy+oMjZFS5shNC25FegEte3gbACwQGAv9wx4eu9szuyXBDh9AUHY0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724751117; c=relaxed/simple;
	bh=tP5uaOEehWiYlIA4tIM15cYK4IorF/gDS0GsQTYDsDA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jsesvdFxE//vnelkIPLL2XnmERrSYj0QSc5ET7nlcx3k8NFpzLklfyy0ClfthpKrsQo/TuyxBig55UBqhxMlwOl0s6tWWaFpmnMs4vhnEo6eQGVKgu2S4vFgIz+W4wzPcfRmKwilKPISBUfSWEm//vsGLgQ++Wiyd42VRR0UEmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WtMd26h2sz20mrM;
	Tue, 27 Aug 2024 17:27:02 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 2529C140136;
	Tue, 27 Aug 2024 17:31:51 +0800 (CST)
Received: from localhost (10.175.127.227) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 27 Aug
 2024 17:31:50 +0800
Date: Tue, 27 Aug 2024 17:41:49 +0800
From: Long Li <leo.lilong@huawei.com>
To: Christoph Hellwig <hch@infradead.org>
CC: <djwong@kernel.org>, <chandanbabu@kernel.org>,
	<linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <yangerkun@huawei.com>
Subject: Re: [PATCH 3/5] xfs: add XFS_ITEM_UNSAFE for log item push return
 result
Message-ID: <20240827094149.GB2719005@ceph-admin>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
 <20240823110439.1585041-4-leo.lilong@huawei.com>
 <ZslU0yvCX9pbJq8C@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZslU0yvCX9pbJq8C@infradead.org>
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Fri, Aug 23, 2024 at 08:34:43PM -0700, Christoph Hellwig wrote:
> On Fri, Aug 23, 2024 at 07:04:37PM +0800, Long Li wrote:
> > After pushing log items, the log item may have been freed, making it
> > unsafe to access in tracepoints. This commit introduces XFS_ITEM_UNSAFE
> > to indicate when an item might be freed during the item push operation.
> 
> So instead of this magic unsafe operation I think declaring a rule that
> the lip must never be accessed after the return is the much saner
> choice.
> 
> We'll then need to figure out how we can still keep useful tracing
> without accessing the lip.  The only information the trace points need
> from the lip itself are the type, flags, and lsn and those seem small
> enough to save on the stack before calling into ->iop_push.
> 
> 

Hi Christoph,

Thank you for pointing out the issues with the current approach. Establishing
a rule to not access 'lip' after the item has been pushed would indeed make
the logic clearer.

However, saving the log item information that needs to be traced on the stack
also looks unappealing:

	1. We would need to add new log item trace code, instead of using the
	generic DEFINE_LOG_ITEM_EVENT macro definition. This increases code
	redundancy.

	2. We would need to use CONFIG_TRACEPOINTS to manage whether we need
	to save type, flags, lsn, and other information on the stack.

	3. If we need to extend tracing to other fields of the log item in
	the future, we would need to add new variables.

If we save log item on the stack before each push, I think it would affect
performance, although this impact would be minimal. I wonder what other 
people's opinions are?

Thanks,
Long Li
