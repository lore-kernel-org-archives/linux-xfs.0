Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EE0195
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 22:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733954972; cv=none; b=i2pDmwbg+3aRUCX1uEJy54K3PNkytnYvCUoGz91dTA5kg66+hR8Wp23vMUCJsvYMW7WfZF2C1wwyjNZ9SH4zUjAz6ndDR0Z/FWTsG2sWyXhM5HlcJ/fsPzIo8V53L6ELN9UZrKwu+bmlj35fmZM9B0RgjCGS0dDlma/UtIkqeFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733954972; c=relaxed/simple;
	bh=LQRaYay111gKdZ9KVTGbRXF9I92kSJDFz80nWLPaj1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RW/1UnG1uOSq3XsfbbZqWSPGwhB3c9cX5Jm0IcalLdLrCZZQS2ZS1EVepbS101uA12XG0jIndI5JHgdZrJPc72WvpY2EFxex3rbIt6azgs3Ge0lsLmJBYZ7T+ekqlkTzzt5HiN2ZH/iDE0GAW2wyML8gmHhc3056alF0ltCz8Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eHSgCPnY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eHSgCPnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DCDC4CED2;
	Wed, 11 Dec 2024 22:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733954971;
	bh=LQRaYay111gKdZ9KVTGbRXF9I92kSJDFz80nWLPaj1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eHSgCPnYUAOkxT+6vxA4Qbq64P5jgh32hl60jYolO4lMXXNQ7o9sLR+n3TP5la2pd
	 Y2MfTO65viKRYCHWxUrErd2anyqo5hQb5adhahNbYgp1ZCjrwGEhL96VuUS0kbGefO
	 INEMwIMHjy4npvtb/78ZZ/f53va+xHgpJoNTnhlMrKTPjt1scw9ps5MPjcbNFasILs
	 YECbBuYewjkJTj9lOIg4lFEjSVZbmq21xzm3Gv/XyhJeAsdArVhdMba2OsWDWDDDBh
	 PDdUaIQoOKcwrS1MUp6hji1pLDYYh1Ry1JvNAKymGMXmXj6KB9JimCwSRlRlIBU5MB
	 T6IyUy7DgiGKQ==
Date: Wed, 11 Dec 2024 14:09:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/50] xfs_mdrestore: restore rt group superblocks to
 realtime device
Message-ID: <20241211220930.GX6678@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752495.126362.8968721228760590908.stgit@frogsfrogsfrogs>
 <Z1fXPAHmSToru25O@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1fXPAHmSToru25O@infradead.org>

On Mon, Dec 09, 2024 at 09:53:00PM -0800, Christoph Hellwig wrote:
> > +++ b/mdrestore/xfs_mdrestore.c
> > @@ -19,8 +19,9 @@ struct mdrestore_ops {
> >  	void (*read_header)(union mdrestore_headers *header, FILE *md_fp);
> >  	void (*show_info)(union mdrestore_headers *header, const char *md_file);
> >  	void (*restore)(union mdrestore_headers *header, FILE *md_fp,
> > -			int ddev_fd, bool is_data_target_file, int logdev_fd,
> > -			bool is_log_target_file);
> > +			int ddev_fd, bool is_data_target_file,
> > +			int logdev_fd, bool is_log_target_file,
> > +			int rtdev_fd, bool is_rt_target_file);
> 
> This almost feels like adding a little struct nicely clean up the
> interface here:
> 
> struct mdrestore_dev {
> 	int fd;
> 	bool is_file;
> }
> 
> 
>  	void (*restore)(union mdrestore_headers *header, FILE *md_fp,
> 			struct mdrestore_dev *ddev,
> 			struct mdrestore_dev *logdev,
> 			struct mdrestore_dev *rtdev);
> 
> and also be useful for at least verify_device_size.

Yeah, that callsite only gets uglier with this patch.  I'll add a prep
patch to refactor the fd/is_file parameters into mdrestore_dev.

--D
