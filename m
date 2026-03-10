Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB662372B31
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 12:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773144145; cv=none; b=ZitpdMkYPH9FQv2h1DDoUwN5BvpaIJsiIhn/rbglXLnilsnhYWDxruxpZzNB4ysDn7HnKW1Uf0InpDZtsNZskX53rT2dFYmRWUsXYAhClM/zcZGEZsshoV+g/JslN+7QxzbzOAfIbhHTQ0ccFTB9NfXFEVdDo5E0fvtQNyPdNRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773144145; c=relaxed/simple;
	bh=at4BPLxLl5PeTiWnP69G7QF+T7bYNiMi3AVVn7YyvXk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AinBHFRS8GcKpLGHkRFzXp8HhCksmFeWSNp2/q3+fSChtoCOern7LcaM0kJftj/j2kNOWG4wWKvprVRS+FrDbk53/6ClWz4AWJTAyBIlL+iBPJmLTPeWcELlGgvE6jPG4BU3p7/Oo4RqHKSkNGvQH1y7+FP0Jf1TUE8A6BJ/DjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=qtGgLdnx; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="qtGgLdnx"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=c8euFrWljbzxJTf2Hi5PPrkksISqAB89fxwgIGE6pIc=;
	b=qtGgLdnxNR9hGpajct9iXPJ8xOSpYkjPN2EVM6UslTaX//H3Lr5nny23c8CViKmR4bClbFZMz
	worHgsY9XYzRktnu6yZgZnBdSfkN8geyH/dQe2bEwTaBt+bHeZsuk3NpQcOueGv6d9HkppdKRTy
	YBZ8LYeAfwdNUjUsKgWp6lc=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4fVXRM4HdZzcZy0;
	Tue, 10 Mar 2026 19:56:47 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 5093F40363;
	Tue, 10 Mar 2026 20:02:12 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Mar 2026 20:02:12 +0800
Received: from localhost (10.50.85.155) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 10 Mar
 2026 20:02:11 +0800
Date: Tue, 10 Mar 2026 19:58:23 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <cem@kernel.org>, <linux-xfs@vger.kernel.org>, <david@fromorbit.com>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: Re: [PATCH 2/4] xfs: factor out xfs_da3_node_entry_remove
Message-ID: <abAHX977xcOEaqRM@localhost.localdomain>
References: <20260309082752.2039861-1-leo.lilong@huawei.com>
 <20260309082752.2039861-3-leo.lilong@huawei.com>
 <20260309164229.GI6033@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260309164229.GI6033@frogsfrogsfrogs>
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemn100013.china.huawei.com (7.202.194.116)

On Mon, Mar 09, 2026 at 09:42:29AM -0700, Darrick J. Wong wrote:
> 
> > +	__xfs_da3_node_remove(state->args->trans, state->args->dp,
> > +			state->args->geo, drop_blk);
> > +}
> > +
> > +/*
> > + * Remove an entry from a node at the specified index, this is an exported
> > + * wrapper for removing entries from intermediate nodes.
> > + */
> > +void
> > +xfs_da3_node_entry_remove(
> 
> This only applies to attr(ibute) structures, as evidenced by m_attr_geo
> below.  I think this ought to be named xfs_attr3_node_entry_remove.
> 

Considering that xfs_da_btree.c implements functions related to xfs_da*, 
it might not be appropriate to place xfs_attr3_node_entry_remove here either.
I think we could add an additional `struct xfs_da_geometry *geo` parameter
to xfs_da3_node_entry_remove() and let it be specified externally, which
would increase the function's generality. What do you think?


Thanks,
Long Li
