Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CBE47DF8D
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 17:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772559124; cv=none; b=HowOo1lUnSiyWGzMElYaAVH45ebhidoVV10DAZ4XbDKL++FKRl7FGqfjSSFXpaeoBy+SYFFeNaBKvAuJPzE2KyAYZkIpBLeiIES2DDNBHD9T1uV+OBGbBMCaWbxkGzfDunp2HZNVs9tNGgBnm1o4RgQR9g2XuLE0MouqO5mGFYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772559124; c=relaxed/simple;
	bh=hgC/pircXvxkbCW+tErRIsCla87uK2UB/ubiyOvu+qk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WFnuFaW6xGRPZKm9ztURI9rmhCszHL9WOlFoaw02TxJOc1+TdiYKlrf4oN76FnwHf2z5BPuzGeYcIN9XYbGzXO6H4B2HjplRnxk/K0/dlWFU4UaOdi0qf8U2SO4YkGc3hfkXFRPxlW67QRyCfoDOLzOd12yZZD/AXbjPT8knAcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qfAjjkyJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qfAjjkyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9F6C116C6;
	Tue,  3 Mar 2026 17:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772559123;
	bh=hgC/pircXvxkbCW+tErRIsCla87uK2UB/ubiyOvu+qk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qfAjjkyJqLQXOXP+uDRuuSf0hN4mvUpPsRBt8Ao8iZRdezrctR6KSRTInyY1XSxNd
	 oxUD0/PqFJ7IGtV3uMmMewatT9k1l8i2ELsIqHlFvZEENF6+Y/OnDj2hgYrH7z6qXP
	 ZKZuK9BMxNnlDV5qcOXVGkiUDlrw2OgiITeTIwiouqf75psnJdmSvCCEYRxdIBK+na
	 V9WRhtVd/oEWxPD1IZogFSIjxLNB+SCrkrxxZloCCUFhww9Mh3spr4g/yGMx02Twpf
	 6MYgXaFy4xsNDuWh1tUQsVgsnbe2ciXS3OBHFi5861SD+00svHoJMuB5TgKWjXgL61
	 YrG6D8omdfwtA==
Date: Tue, 3 Mar 2026 09:32:03 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/26] mkfs: enable online repair if all backrefs are
 enabled
Message-ID: <20260303173203.GS57948@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783730.482027.15356275256378511742.stgit@frogsfrogsfrogs>
 <aacFDgyTFG8OhJOM@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aacFDgyTFG8OhJOM@infradead.org>

On Tue, Mar 03, 2026 at 07:58:06AM -0800, Christoph Hellwig wrote:
> On Mon, Mar 02, 2026 at 04:40:05PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If all backreferences are enabled in the filesystem, then enable online
> > repair by default if the user didn't supply any other autofsck setting.
> > Users might as well get full self-repair capability if they're paying
> > for the extra metadata.
> 
> Does this cause scrub to run by default or just healer on demand?
> People might not be happy about the former.

Ultimately it's up to the distro to decide if (a) they turn on the
kernel support and (b) enable the systemd services by default.  Setting
the fsproperty just means that you'll get different levels of
online repair functionality if the user/sysadmin/crond actually invoke
the services.

(That said, I was wondering if it was time to get rid of all the Kconfig
options...)

--D
