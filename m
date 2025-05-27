Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEC31862
	for <linux-xfs@vger.kernel.org>; Tue, 27 May 2025 23:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748389926; cv=none; b=F+a1c5IKCjWoXynIfr9y9b682qnyWTGsc2I/7RRhM2tN3Uf94JsWOgtTB/xtvHOETEohgyRrM342bT8k+pxzuE0U51ulA2atk++spDx9CZz8jnnFh+sHITmkiFP11Hg5hJ5Yi8ByOAnk9qBBuxPGzpb558FPDNDfekWp0k6vDA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748389926; c=relaxed/simple;
	bh=4OXAg37CYDGTuf5cCjUJMd7uGdLLhj11Zq6JGYOYBVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D0bJsUGZqvByQWM894y55WyX/ZzZINmw/Nsol3efewvuV70osv3AYlTGl+lTNF64oHcV0t5HFB7Nmw8O24bB4CAgbBzEm2mxMhv+N0BavIu4E0GkRu+TE/UWd3r2SaO6Jo1Q77vLrAoiOoDthOdLKauEp08A4rOs7rf0xl96xeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=wIGQMCt9; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="wIGQMCt9"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-742c5eb7d1cso4312779b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 May 2025 16:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1748389924; x=1748994724; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bmfh5PXzStZotlCYpKANwA843qFjQL6xga7R2lCb0vE=;
        b=wIGQMCt91F7Hg+2yTjD2hhJ/56Kfg4KHF2LHyxm8Ws9vZN/VEZb8sRxOQZdlgyfv94
         zEM10HnjiHs2CH0RP/GpCje4oMJ4OoHL8iJhnKF4xahEtzcxDPJ6m2iNGPpjuVNsuLaz
         dWB/i/owWBU+8WOrtDL8HXfyPPqXBtZ+Xl4YWI7LaWElWEGaqJc9gLc6ZEaZNlmELClG
         RhWnDlOLjEXQWzRbcOub7iUeBp5vEHT6mXpiyk8KwPlAa9kc6psBbn+nTCsNtLFTWFKL
         vvZBluAjvo4X+QNshY7XbbZzL8szcPSSbE0FdX9Wedo7NKrOHquiba0wynw5GjzxyUet
         ggHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748389924; x=1748994724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bmfh5PXzStZotlCYpKANwA843qFjQL6xga7R2lCb0vE=;
        b=aBbqOZgCaWy2X6Fr1aRV+9HHipdOAFMYIn1lZRulo3V3EzKwdfPxnaFy7fLSA8EFwG
         EH89Q/rQN+45PaYpFLJecHtZ4MMcS8GzIv+XGnJ6vich5+OfiFtoHzw9Snp/leKiMxi4
         JgxSyYV6x6+YwHbwE46+CiJmzuEWO6ceZxG95xaM9iIxUmT85GiyX5vgFBq3TMCo8Ezf
         DG05jPTJVd5FrKPksXWp8usHNLoo29t+viMwsGm+msbaD9mu3J9ONk1s0CPncgw3ejYJ
         l5mg5BcImDqKmOiVtRjW6ePjpx8LHlgqsBs83UzYkkT/JHl804hEmDAaCNvoOI57oKnz
         fH+A==
X-Forwarded-Encrypted: i=1; AJvYcCXr24yRlvM+KU59UV1o+10qpdEFyEwTLLBZzee+yLhKDGYaKflNy80aqw5imYkQFzsNT0LyW4FYi/k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7u1OmaaajXylVFYm+Jn17OeVAnK+uPH63EtzX/c1/ApRY3W07
	c83gmXeaxeMCc2S6MyvAmprA9fPkWZq3mW/SwWWyFWAzECVP++sm5IZeuUbATE88YrA=
X-Gm-Gg: ASbGncufsI4evDBBw2553AUB6Pl5PsAKBNaiyI9tT3Yixhci+X7XcP6C9WmU6QOq5NY
	PTalW0q0jIbUmpEK/FsQEV9bQlwE5fAWxfXdjhK2Ix0PbqpHSyYUFTuDMprTTu11mV//W5p7N+e
	ztgd+pBrkGwoO+t4mPd+H2hFI8MuGZIW/cXrc7RJEMRMEtOaJ/Zp1dU3qiCfMY9X/GIVMNEcUMj
	V9JZgHNkz+ss+cich8jl/IgzOATXz9A29VVwue0HDPO7Gd82SkK4QegopzssnjY7l31BVbsPvQI
	RpyVdwxZiZKOPgaRZz8FK5iCKMpDMeK4xIpjIsCpR/E2DABOs09PWVy2oi9zqqqRUO1SSve+sTE
	dEw9oZ+789tzc/8Tc/rOt13mI7sI=
X-Google-Smtp-Source: AGHT+IGjVyDrg3w6oPAW9PAypx8bpLsNzCm/OTJwY6v6hJyuA03GGUwylGYveFQDmPSqx/NJbXVihA==
X-Received: by 2002:a05:6a00:1482:b0:740:67aa:94ab with SMTP id d2e1a72fcca58-745fdaf1dadmr21994737b3a.0.1748389923796;
        Tue, 27 May 2025 16:52:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-746d5c642f7sm45212b3a.3.2025.05.27.16.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 May 2025 16:52:03 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uK45Q-00000008zYO-2o3v;
	Wed, 28 May 2025 09:52:00 +1000
Date: Wed, 28 May 2025 09:52:00 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] iomap: don't lose folio dropbehind state for
 overwrites
Message-ID: <aDZQIETrdC_4fKGU@dread.disaster.area>
References: <5153f6e8-274d-4546-bf55-30a5018e0d03@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5153f6e8-274d-4546-bf55-30a5018e0d03@kernel.dk>

On Tue, May 27, 2025 at 05:01:31PM -0600, Jens Axboe wrote:
> DONTCACHE I/O must have the completion punted to a workqueue, just like
> what is done for unwritten extents, as the completion needs task context
> to perform the invalidation of the folio(s). However, if writeback is
> started off filemap_fdatawrite_range() off generic_sync() and it's an
> overwrite, then the DONTCACHE marking gets lost as iomap_add_to_ioend()
> don't look at the folio being added and no further state is passed down
> to help it know that this is a dropbehind/DONTCACHE write.
> 
> Check if the folio being added is marked as dropbehind, and set
> IOMAP_IOEND_DONTCACHE if that is the case. Then XFS can factor this into
> the decision making of completion context in xfs_submit_ioend().
> Additionally include this ioend flag in the NOMERGE flags, to avoid
> mixing it with unrelated IO.
> 
> Since this is the 3rd flag that will cause XFS to punt the completion to
> a workqueue, add a helper so that each one of them can get appropriately
> commented.
> 
> This fixes extra page cache being instantiated when the write performed
> is an overwrite, rather than newly instantiated blocks.
> 
> Fixes: b2cd5ae693a3 ("iomap: make buffered writes work with RWF_DONTCACHE")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
