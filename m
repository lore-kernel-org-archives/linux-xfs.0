Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EA018FC89
	for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 18:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731696168; cv=none; b=PHumZFy2kgW7CcbdAfghpOcvulMYaGsHJICyTCHchkWICrL2N2GKrb93HNbfvAiAQkSdhTu/B7edfDC6MmHnxBsCHj9cGCaU8ipMm5Z2kOhsSyy6TN6Zof1V1KRH0qHtWsCBwV8s2Hi+7MD6xL+uBeoWMWoBdCyxMzueLK15JQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731696168; c=relaxed/simple;
	bh=gE/s65Hr13ndnPOhFkNM7JGRBr1W7MGPdAOIjQMbMqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nQs11YNfMrrMT4ZqjiuxTB4ZN/MAa7B0E1n9wKTP6FTMuo8rPuS6SZk2YGR0zy0Zz2nrHm40Zv6Hrk2zOSpyEfbJzdm97WqS7PQZZpeAwJgeWj4ULwjUGO0zDOzs1qDsCuLBAuh1+f27dhJJJTZedUEv0kQO1UBYH4KJM5uGfug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NoVXBFFP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NoVXBFFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61E8C4CECF;
	Fri, 15 Nov 2024 18:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731696167;
	bh=gE/s65Hr13ndnPOhFkNM7JGRBr1W7MGPdAOIjQMbMqg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NoVXBFFPpig0W2Xe3OwpiEEbafwVfbc2w0Kz0XyQmzmARLib73wb/OVjpgeFpp9vV
	 n50EIfpdv7FdRPkrfgJtsdwxczoto+0gjNolSm5a7St7vEoCRGif72jZlL6bUz5ukq
	 jHPxtpyyq4ua/bpPLbmez412VmTjgqCc1+cPNq04oi1rf75xY8odcKSSCjdRfMpvI5
	 YfgasEoMZyGfHx/v1yZ89mibTTzs5W8v5H9aTM4mdsZ7pGWsxin7yIxw2reWRoDb3T
	 a/AbUjlkIGSH2ms1T0DsH1y7ZD9Tmjuru+jmfaTHgs0ZuuTV3h1vDqoS0/K83MtcHJ
	 gw2O0BF/YYpTA==
Date: Fri, 15 Nov 2024 10:42:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [bug report] xfs: support creating per-RTG files in growfs
Message-ID: <20241115184247.GQ9438@frogsfrogsfrogs>
References: <9c8c3f8e-80c0-4d78-8cc8-1e4d055452ab@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c8c3f8e-80c0-4d78-8cc8-1e4d055452ab@stanley.mountain>

On Fri, Nov 15, 2024 at 12:10:04PM +0300, Dan Carpenter wrote:
> Hello Christoph Hellwig,
> 
> Commit ae897e0bed0f ("xfs: support creating per-RTG files in growfs")
> from Nov 3, 2024 (linux-next), leads to the following Smatch static
> checker warning:
> 
> fs/xfs/libxfs/xfs_rtgroup.c:499 xfs_rtginode_create() warn: missing unwind goto?
> 
> fs/xfs/libxfs/xfs_rtgroup.c
>     467 int
>     468 xfs_rtginode_create(
>     469         struct xfs_rtgroup                *rtg,
>     470         enum xfs_rtg_inodes                type,
>     471         bool                                init)
>     472 {
>     473         const struct xfs_rtginode_ops        *ops = &xfs_rtginode_ops[type];
>     474         struct xfs_mount                *mp = rtg_mount(rtg);
>     475         struct xfs_metadir_update        upd = {
>     476                 .dp                        = mp->m_rtdirip,
>     477                 .metafile_type                = ops->metafile_type,
>     478         };
>     479         int                                error;
>     480 
>     481         if (!xfs_rtginode_enabled(rtg, type))
>     482                 return 0;
>     483 
>     484         if (!mp->m_rtdirip) {
>     485                 xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
>     486                 return -EFSCORRUPTED;
>     487         }
>     488 
>     489         upd.path = xfs_rtginode_path(rtg_rgno(rtg), type);
>     490         if (!upd.path)
>     491                 return -ENOMEM;
>     492 
>     493         error = xfs_metadir_start_create(&upd);
>     494         if (error)
>     495                 goto out_path;
>     496 
>     497         error = xfs_metadir_create(&upd, S_IFREG);
>     498         if (error)
> --> 499                 return error;
> 
> I think this should go to out_cancel?  I'm not totally sure.

Yeah, looks like a bug to me.  Thanks for the report, I'll send it out
with a largeish pile of bugfixes next week.

--D

> 
>     500 
>     501         xfs_rtginode_lockdep_setup(upd.ip, rtg_rgno(rtg), type);
>     502 
>     503         upd.ip->i_projid = rtg_rgno(rtg);
>     504         error = ops->create(rtg, upd.ip, upd.tp, init);
>     505         if (error)
>     506                 goto out_cancel;
>     507 
>     508         error = xfs_metadir_commit(&upd);
>     509         if (error)
>     510                 goto out_path;
>     511 
>     512         kfree(upd.path);
>     513         xfs_finish_inode_setup(upd.ip);
>     514         rtg->rtg_inodes[type] = upd.ip;
>     515         return 0;
>     516 
>     517 out_cancel:
>     518         xfs_metadir_cancel(&upd, error);
>     519         /* Have to finish setting up the inode to ensure it's deleted. */
>     520         if (upd.ip) {
>     521                 xfs_finish_inode_setup(upd.ip);
>     522                 xfs_irele(upd.ip);
>     523         }
>     524 out_path:
>     525         kfree(upd.path);
>     526         return error;
>     527 }
> 
> regards,
> dan carpenter
> 
