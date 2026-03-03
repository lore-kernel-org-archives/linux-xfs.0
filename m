Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EC63EBF01
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772553399; cv=none; b=aHMRgO7OJzVeI1u7gUvgcb9MVk4ot/EgWVkzeWFJ98nLjw46+fL+A7SSHn1zYjs9laSDe1lmGygmK19QCzB+NPgV6BNqzpvErsVSUpZgWXn98btWfz4dFXDf/oL/HsKfOa4nF94/+7M4u++79LoSzKlrBqQxCQHnkfyYY8KZfWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772553399; c=relaxed/simple;
	bh=knFGaCsR/znX3pyzOhmcMTLi1J+J5GBO7VWDGxu+MJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=htyoc4zJttiuTek+eyXhCDrOkWpNNRgGIrEzsvPf1lAes9OW7vRbAcV+NKV6TfpRa7PfjlwijCLW7UeAUYRWvc6B8iYiVtCC+k+cHFpulVjyovQ8XwfXIp2ILfSrhFKIifjhN7lZshLtir641OL+dOoo9siQ9GfvbdHJIsR8cNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4aLeynv6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4aLeynv6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=T6cVs6ucsyvf5Ws2d0HBsOAAGNR3cCDSkLM+2qXdsXI=; b=4aLeynv63FXEm5qn3cwLXB0Fbd
	Mp2sofOXF8yxt5A7h80ZTpnHhSIzyFNzzd94MgM5phvzif1K5j9gVah6TBp0uNaS/xDGowgr3A2Qg
	mvGR98eLMQSrCRdlByMWwaR3X4Nqj0aoebu3Lj1pxPXCMWIz6xwGSN5pU3qHm0ScF3Auw79JoJmEm
	7ACmrClH/z/EwdRg+0kcqOmezxfxgtlORV5z6VvI3nLSGSWqiPQlFmnb1IRX/cJ5ti/AtIVsv+zow
	tt+5FJAOxnSHCoZA78/cnaXhkvOS41KpiAoPt8FAygx9NyqZj2M0S9jyKQSgcA0cImCZzq0os39h1
	FcOJ5YEg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxS6t-0000000FUSz-3yHp;
	Tue, 03 Mar 2026 15:56:35 +0000
Date: Tue, 3 Mar 2026 07:56:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/26] xfs_io: add listmount command
Message-ID: <aacEs2wlToV8vwu1@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783693.482027.14656443953017714472.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783693.482027.14656443953017714472.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 02, 2026 at 04:39:33PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a command to list all mounts, now that we use this in
> xfs_healer_start.

> +/* copied from linux/mount.h in linux 6.18 */
> +struct statmount_fixed {

Shouldn't this use the kernel uapi header and/or a copy of it?

And be split out of the .c file into a separate header for maintainance
and eventually nuking once the kernel requirement becomes new enough?

> +static int
> +listmount(
> +	const struct mnt_id_req	*req,
> +	uint64_t		*mnt_ids,
> +	size_t			nr_mnt_ids)
> +{
> +	return syscall(SYS_listmount, req, mnt_ids, nr_mnt_ids, 0);
> +}

Same comment as for the other listmount instance here.

> +
> +static int
> +statmount(
> +	const struct mnt_id_req	*req,
> +	struct statmount_fixed	*smbuf,
> +	size_t			smbuf_size)
> +{
> +	return syscall(SYS_statmount, req, smbuf, smbuf_size, 0);
> +}

and similar here.

