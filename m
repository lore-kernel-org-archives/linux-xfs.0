Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793631308;
	b=eN2mkqFQ9Vp31IwiiWMwmgBc64SlB4llZOsoM43luWNBFHuTwrJ0/Mzd47HBYejJjKgu
	 lz/SB96/YXfKCGVd7mGePCEiCK9vGHHHv0jyZQnLy1fPynoB5B91y7dYZF2HT64tuKnaG
	 KDL1kvLRPxx6R/Zn9ScYgjto4U9BTFIdDsWtR9bLO7sWqoj4mKlZK2Fsw8EEyd5/VbMQJ
	 tXCa6CCItH4IhXyqL4fPm+GwmhaWlBuuqW5vqd/JDxNQc/gHDhzdk4txlRoupS8HrlBtN
	 0v7AAYGuKav63TJqEsnzyTTus/YDH6D1/Ur/sLN0G08UZ18SjhPKhTkD3n9UN75Lj9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793631308;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=JgVRWDDgxfnt1UNm4iJSAE8im0t1NobTbuAeI75ZQrM=;
	b=JuQyz5czZ3tXnrMN7Rah2dY3lKiR4soiAzrYBJ4T2U8b1ZYLlxoW7AY3XWT113GHzwH4
	 1EJXSlnQ5tuyDvBDRBppW5m6GHS3W2xo+cvNl3RSXS857MOP4u+hPrTTy9WSL9cm0Ffer
	 Z8WdCly/bsEEBqNgNmy0LOxp88qQXCftmmGtGYD5ifWgygmC0TTRmUuZXfCqxu6x+9KfZ
	 7Qawq5PUBHDKKAneBVkGeXYmWZ/N/N0eri3U/yJ6HA1DBAW4fdMxyfKUDbA2KoKvweUf0
	 hp1+HrlPcDC6KcQDGaqjO1zcNMfyfmViS6ZesrJKUBXNBYMBP4l2WVfCiNEWOPtM1yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kpf+c897;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14326606A596;
	Mon,  2 Nov 2026 14:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kpf+c897
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC7C1F00A17;
	Mon,  2 Nov 2026 14:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631307;
	bh=JgVRWDDgxfnt1UNm4iJSAE8im0t1NobTbuAeI75ZQrM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kpf+c897g1wkGVh2koigX2VvT9hw81kGK1I50cMJ9/x1lgmqFNArFxRX7iwwfspet
	 ABJsMkVdfKPy3T9AzijVMT7rZLzI6tarNCrMJSWGWLkgo2W34+ukNW/sSbp9tWvAfS
	 MdgpCOz9GtDSySBZlCigMidyvVgb8YZgmSkzoDTBlfmQZ+UHQQ0Os/C2X9CheQ3S5h
	 4pIN6QRG1onM5U5vlHSQkkRKqDkT7GCvDpqhohs6EZFFthgRbVW9a/rfsg1Ah6wRMM
	 CMEYW+gdgYx346sLa69ZyeypEiYOi44FHmFXTOWm37WTbJXPA0flmbgsJ6GIc/uhJT
	 hUBhi58yOofNw==
Date: Mon, 2 Nov 2026 22:55:00 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Anand Suveer Jain <asj@kernel.org>, Chao Yu <chao@kernel.org>
Subject: Re: [PATCH v2 2/6] fstests: consolidate _require_fs_sysfs and
 _require_fs_sysfs_dev_attr
Message-ID: <auij080MipLBdTfy@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>, 
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Anand Suveer Jain <asj@kernel.org>, Chao Yu <chao@kernel.org>
References: <20261023203114.1655019-1-zlang@kernel.org>
 <20261023203114.1655019-3-zlang@kernel.org>
 <auIbZuqnQBrNdqDF@infradead.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auIbZuqnQBrNdqDF@infradead.org>

On Wed, Oct 28, 2026 at 08:57:26AM -0700, Christoph Hellwig wrote:
> On Sat, Oct 24, 2026 at 04:31:10AM +0800, Zorro Lang wrote:
> > There is heavy overlap between _require_fs_sysfs and
> > _require_fs_sysfs_dev_attr, and their ambiguous names make it
> > difficult to tell them apart.
> > 
> > Teach _require_fs_sysfs_dev_attr to default to $TEST_DEV when only
> > an attribute is given, remove _has_fs_sysfs and _require_fs_sysfs,
> > and update their callers.
> 
> I find the optional device argument a bit confusing.  What speaks against
> making it mandatory and having _require_{test,scratch}_sysfs_dev_attr
> wrappers?

Thanks for reviewing! Sure, that makes more sense.

> 
> > +	_has_fs_sysfs_dev_attr $dev "$ctlfile" && _set_fs_sysfs_dev_attr $dev "$ctlfile" 1
> 
> Please turn this into an if to make it more readable and avoid the
> long line.

Sure, I'll send v3 with this patch updated.

Thanks,
Zorro

> 
> >  
> >  	# Disable retry of metadata writes that fail with EIO
> >  	for ctl in max_retries retry_timeout_seconds; do
> >  		ctlfile="error/metadata/EIO/$ctl"
> >  
> > -		_has_fs_sysfs "$ctlfile" && _set_fs_sysfs_dev_attr $dev "$ctlfile" 0
> > +		_has_fs_sysfs_dev_attr $dev "$ctlfile" && _set_fs_sysfs_dev_attr $dev "$ctlfile" 0
> 
> Same.
> 
