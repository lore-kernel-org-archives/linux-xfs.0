Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F8E18BC1C
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838002; cv=none; b=bZwvKxdQcTOhjceRGggTH/Yi6Nn+RQKTSpLW/3qzt09zU/U49NOAivsomimy6GQ3WgobonG3nhdW741yuApIxjjeIANIH1RI607ThSh/Nxf8bt/05vN04flG9NNCoWbljSwE+NuBTq5RRmmN66tmurKtYMZMsUkyXe6e1nDuy/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838002; c=relaxed/simple;
	bh=JyLpIJJkAzoTE06gLFtBwyYhOFiv3P+cxN+AuVb4eqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GnmwB+S2iEqCWKSQPsh3c2gFNWniV+tlir32ZuemoDgRSzor4OU93TH55r3VAfMRDwJydoUN12RbWs7r5I8skGE2dEKQh4WjRrhnu5ZUFClmXvUaspfo7/4WpmEU1XJD3rHjETFNsaFRuKyrGOVHOkQ4KHqFubsZUeRuHwIkNsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=TMr9nsYQ; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="TMr9nsYQ"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7cd8803fe0aso1156575a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2024 23:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729838000; x=1730442800; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFB+rLaaecQbzOySfht9RM55bOTfCIht0qGVitxQ4fk=;
        b=TMr9nsYQZxNxJ6Nxd7FfWuBEfMnwZLnBY8aFGcQ+go0EUjQDTFHhOOmYbYlzI7vqGc
         ybZj3B2yVk/VcDQO/UKYGFxDUSZwL8T8IcfIHFih1HUzeVJmuBXFzpjkPbqNfOeb5Uz1
         P0Yx5tNE+q+E/wOcXNCQ7fmBgTHKijHxSQ6bZ2mn+M4AHipSopsFDoh42w6qsoKB9jnk
         oR3mrEoI23DJpty3RqaMP81l0Mr6nAF+1M1nwmWKY7fcwrJk5o768gcr0VXLJBn8HXza
         WzoJR60v+Tkbe3dNTbD5nb1+WisRSpB8fK/jXL2R8uWQsxN5o4ZI4qWncFFLZ3hQ1KId
         MfzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729838000; x=1730442800;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZFB+rLaaecQbzOySfht9RM55bOTfCIht0qGVitxQ4fk=;
        b=dar/ZTiMuVqbCt2oQrX28UbS8KnCkvtOmHlQzZbnwZ/uorw9OgYKmPX9pRkth5cBlP
         WO68pXg6LFhpTAIactSIg4as4sxGcFzjTK4TF9S7SyMJOR7RHNdf6PPzGhjDkYlaZONY
         t+F13JRGG97pd2jn7c46/kUUKySIbNObGti0iLss/1LeC3qHM2D4L3QRDCxBr3wZVPfi
         Rq6Pf4VXVvBnF7Sh6UllZnPJohfKeju3kLLz7k/c3wpuNBCnp8gKBHlcQYa4xK7O3oeM
         4i5wB9kqysXuLcZIMiGhxb/DcsoktbsCoAFLQjCes73NC89o6WwS9bySqlQe5XkKM67W
         eWYA==
X-Gm-Message-State: AOJu0Yx5hGGNzgKN4vMz9eW/Qnuv0ooUvlsnCNgNFm/fqxpYsPwYCtIQ
	8dKbr8vAvvNvBpymTSPCBWN0oPaU35/NpsLdTYgMgbrldB6qPjeBi7Jv9Pz5UEg=
X-Google-Smtp-Source: AGHT+IHwCwIC6V9g3XCymBrIyESpVPBZHg+zF5zECbGY19VN5CH1DB25ARUJLM/Xh/pBuEG/w1PDAg==
X-Received: by 2002:a05:6a21:6b0c:b0:1d9:78c:dcf2 with SMTP id adf61e73a8af0-1d978bd32cdmr11767826637.43.1729837999718;
        Thu, 24 Oct 2024 23:33:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72057950068sm417362b3a.89.2024.10.24.23.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 23:33:19 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t4Dsq-005TPx-2L;
	Fri, 25 Oct 2024 17:33:16 +1100
Date: Fri, 25 Oct 2024 17:33:16 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: sb_spino_align is not verified
Message-ID: <Zxs7rLd951k9EzdA@dread.disaster.area>
References: <20241024025142.4082218-1-david@fromorbit.com>
 <20241024025142.4082218-4-david@fromorbit.com>
 <20241024165544.GI21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024165544.GI21853@frogsfrogsfrogs>

On Thu, Oct 24, 2024 at 09:55:44AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 24, 2024 at 01:51:05PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > It's just read in from the superblock and used without doing any
> > validity checks at all on the value.
> > 
> > Fixes: fb4f2b4e5a82 ("xfs: add sparse inode chunk alignment superblock field")
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Cc: <stable@vger.kernel.org> # v4.2

Yeah. And probably what ever fix we decide on, too.

> Oof yeah that's quite a gap!

*nod*

What surprises me is that syzbot hasn't found this - it's exactly
the sort of thing that randomised structure fuzzing is supposed to
find..... 

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
