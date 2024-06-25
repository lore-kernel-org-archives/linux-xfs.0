Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A362E16DEB8
	for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2024 13:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719323943; cv=none; b=lwMl8GSCUSZOsycdYJJdEmnMj9gCfbsZqmZ3F7bMssvOyt4UY/klyP/MMr+56TSNUo6N/9yyoK+lVniuL13xwQ+WjJKDr30LqWeclr18uSwq8U2tULTTE2kZUACZIb/56MHfnKLk+/nz2x6nv2iDCHrHGjOfozXFph8sFIKAlIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719323943; c=relaxed/simple;
	bh=Ub8lGMTV/5+jycOvPUfmD9QGMF72G9xiQIUZFWScg5g=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gGaPWad42+XSksLjWP2Ln4TGTuPVg4KVKyN3oGe7L+N5kxb/v0zucqAEQCtIvDvhICeMmpZwkiJaRgHf3zNsOnNmoEo84y0MDb9C0jclsp7ANBBcjfrisYVpQdDP2HSlJr66Ikn8lzI+QmDgG/HClObHWFLFkm3gJ6CCNjjn8lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4W7mXw50DdzxTb2;
	Tue, 25 Jun 2024 21:54:40 +0800 (CST)
Received: from kwepemi500009.china.huawei.com (unknown [7.221.188.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 86EBA18006C;
	Tue, 25 Jun 2024 21:58:59 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 25 Jun
 2024 21:58:58 +0800
Date: Tue, 25 Jun 2024 22:10:26 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <chandanbabu@kernel.org>, <linux-xfs@vger.kernel.org>,
	<david@fromorbit.com>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<yangerkun@huawei.com>
Subject: Re: [PATCH] xfs: eliminate lockdep false positives in
 xfs_attr_shortform_list
Message-ID: <20240625141026.GA986685@ceph-admin>
References: <20240622082631.2661148-1-leo.lilong@huawei.com>
 <20240624160342.GP3058325@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20240624160342.GP3058325@frogsfrogsfrogs>
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500009.china.huawei.com (7.221.188.199)

On Mon, Jun 24, 2024 at 09:03:42AM -0700, Darrick J. Wong wrote:
> On Sat, Jun 22, 2024 at 04:26:31PM +0800, Long Li wrote:
> > xfs_attr_shortform_list() only called from a non-transactional context, it
> > hold ilock before alloc memory and maybe trapped in memory reclaim. Since
> > commit 204fae32d5f7("xfs: clean up remaining GFP_NOFS users") removed
> > GFP_NOFS flag, lockdep warning will be report as [1]. Eliminate lockdep
> > false positives by use __GFP_NOLOCKDEP to alloc memory
> > in xfs_attr_shortform_list().
> > 
> > [1] https://lore.kernel.org/linux-xfs/000000000000e33add0616358204@google.com/
> > Reported-by: syzbot+4248e91deb3db78358a2@syzkaller.appspotmail.com
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/xfs_attr_list.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> > index 5c947e5ce8b8..8cd6088e6190 100644
> > --- a/fs/xfs/xfs_attr_list.c
> > +++ b/fs/xfs/xfs_attr_list.c
> > @@ -114,7 +114,8 @@ xfs_attr_shortform_list(
> >  	 * It didn't all fit, so we have to sort everything on hashval.
> >  	 */
> >  	sbsize = sf->count * sizeof(*sbuf);
> > -	sbp = sbuf = kmalloc(sbsize, GFP_KERNEL | __GFP_NOFAIL);
> > +	sbp = sbuf = kmalloc(sbsize,
> > +			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
> 
> Why wouldn't we memalloc_nofs_save any time we take an ILOCK when we're
> not in transaction context?  Surely you'd want to NOFS /any/ allocation
> when the ILOCK is held, right?
> 
> --D
> 
> 

I believe using memalloc_nofs_save could solve the problem, sometimes it may be 
more effective than using the __GFP_NOLOCKDEP flag. However, looking at similar
functions, for example xfs_btree_alloc_cursor, it uses __GFP_NOLOCKDEP to prevent
ABBA deadlock false positive warnings.

xfs_attr_list_ilocked
  xfs_iread_extents
    xfs_bmbt_init_cursor
      xfs_btree_alloc_cursor
        kmem_cache_zalloc(cache, GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL)

After thinking a little more, I found out that just using __GFP_NOLOCKDEP may
not be enough, AA deadlock false positive warnings [1] still exist in the
mainline kernel if my understanding is correct.

[1] https://lore.kernel.org/linux-xfs/20240622094411.GA830005@ceph-admin/T/#m6f7ab8438bf82f0dc44c6d42d183ae08c07dcd5f

thanks,
Long Li
