Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA4F14006
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 06:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712126501; cv=none; b=T4d9mQbtNvTSOoCwsbrpdlJytLuyAq/jvsMLUhz27R1qW9LLfjz4x5DhLKDvq5dgJgwC3PDWzYuL3Ep4Hn2rhfjrV05A6JzfjtTjFWHIDe6bOMv9T/F1CNqEMZADPacraj5Fdg04vsU6/j5SHOSjViKCgF3vQORaV2HVW1zWsmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712126501; c=relaxed/simple;
	bh=N9TUrZCYYb5UGgU07R4+oLfM8IVhUWRKWCbxGTcjd2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lkgy5fRY3ZVmVq1QpjvISmjzuC9ssFi+6jyOrG6+v0GbdDJcenQDsjfkugsYUhhQdQFsYYlHQlRbVkIrNHVsoyIGj3ju5CsmwlpYcxfcm6gIzTBujIt3pDeilEIf0x4OxIyMmEdVfMLDJm798We608G1WZaaSRY/KIaA6XoW0uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=A8aRKsfF; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="A8aRKsfF"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5a7c3dd2556so1328454eaf.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 23:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712126499; x=1712731299; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tftzlaXG5dwNiW7S4aLgiIuJMsH/QPDweoTJWwIOznE=;
        b=A8aRKsfFezYWstk5DQf3nheZTIMbHDkYIGyc7r5opWZLjZ2yB3p89tRV/RMvIw/keQ
         faT5xz5AidWvpRQyoEssEsMU9fNoEu7J4jAJF0U49SomjCKaH4+Kw7PZDa7LlxA8T8Al
         Vb/cLzsWaqfhdLmRgKGZEcGAYy66aBIngf+1KcmuTSrFog1HrPDDS13jss/BufBmQh+t
         bP2XJI7sYyUN5Wt48+HJuSVRMxDanJ1wKzHw2LBDlo04LI+8QUkfTEbsqhEK/ITXCrK3
         4fLyOzCoSBvcDVph8tLhCZ/cnptfT4dIye9bM4GtA2QYUHf40kojcWCTY8k2zmRnS1YW
         rkrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712126499; x=1712731299;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tftzlaXG5dwNiW7S4aLgiIuJMsH/QPDweoTJWwIOznE=;
        b=DFK0WxzVCdc3swuHoNlYcyJugi1MnddWUMh20fWj9dlhivUixuUt0m2+Q95ZbvNyeh
         IScHuQuNuXM/ZzTtInBnmn8xaCjiedRxi8fN6sz6mKqto5EnFLRt6xUfgxgix1a+pxou
         zPAaAqEc8xPN+q2sjHbU4PYDoZcKSJJRiBILi63tGRu1gMd2Ke1ev5trlnE1atATLZNr
         TiV8JuNB4le1cl7WPzo4fCb1QgAUjA8Hqr5l+ONei9SuTIbXDJiUel6kvCfOgzkNi56I
         EF8mwzc2Vgwbb1TiUpG+mzvnqcwYt+LHr8dv94ATpN3VepN9hh9OBNZ4gb8EEjQ1q5zP
         JHoA==
X-Forwarded-Encrypted: i=1; AJvYcCWPibxmZNuwVWjfxjCsoj1dq2lXUfc6I0W0loWhNDsEzOnKXc1cPhWvWarwnaz+BMra1J1vKoEd5dZbpNZGcgMOBR13RPsyQzfS
X-Gm-Message-State: AOJu0Ywmsp+7WWrj9RDfjbvC84etm8wzwtqB8Oz7zL0FFn/P34hRfOm9
	DuFOINuU+N9sMZiMCuXtcvXerusGuL6+sPBDt7dSIn8UHjXwv2V4q9GUjI/elQZBvUHx15lieTG
	4
X-Google-Smtp-Source: AGHT+IHCofYGQtEU4+AO49cy/RNPy+R8nWMItJFK1tIeBQVhFFQht15TSqTDyJKQ9zKb5q0CfwODXQ==
X-Received: by 2002:a05:6870:910d:b0:229:ce58:477a with SMTP id o13-20020a056870910d00b00229ce58477amr2221681oae.19.1712126498872;
        Tue, 02 Apr 2024 23:41:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id p19-20020aa78613000000b006e6c10fc87fsm10978609pfn.46.2024.04.02.23.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 23:41:38 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rruJT-002Eex-32;
	Wed, 03 Apr 2024 17:41:35 +1100
Date: Wed, 3 Apr 2024 17:41:35 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	chandanbabu@kernel.org
Subject: Re: [PATCH 3/4] xfs: handle allocation failure in
 xfs_dquot_disk_alloc()
Message-ID: <Zgz6H7tXehgxOfYC@dread.disaster.area>
References: <20240402221127.1200501-1-david@fromorbit.com>
 <20240402221127.1200501-4-david@fromorbit.com>
 <ZgzeFIJhkWp40-t7@infradead.org>
 <20240403045456.GR6390@frogsfrogsfrogs>
 <ZgzheEqxrVBg3dbs@infradead.org>
 <20240403050430.GT6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240403050430.GT6390@frogsfrogsfrogs>

On Tue, Apr 02, 2024 at 10:04:30PM -0700, Darrick J. Wong wrote:
> On Tue, Apr 02, 2024 at 09:56:24PM -0700, Christoph Hellwig wrote:
> > On Tue, Apr 02, 2024 at 09:54:56PM -0700, Darrick J. Wong wrote:
> > > Usually this will result in the file write erroring out, right?
> > 
> > quota file allocations usually come originally from a file write or
> > inode creation.  But I'm not entirely sure if that was the question..
> 
> Heh, and the question was based on a misreading of your comment. 8-)
> 
> AFAICT this can result in dqattach erroring out, which seems mostly
> benign.

Right - this propagates the ENOSPC error back to the caller without
a shutdown being required. If we get a corruption detected, then
the allocation will return an error, not nmaps == 0. That error will
cause a corruption. But an unexpected allocation failure right at
ENOSPC can occur without there being corruption because of, say, one
of the many, many near ENOSPC accounting bugs we've had to fix
over the past 20 years, and if the allocation fails we should just
clean up and return -ENOSPC without shutting down the filesystem.
We're right at ENOSPC, so there's every chance that the next
operation after the dquot was attached would fail with ENOSPC
anyway....

So, yeah, I don't see any reason to shut the filesytsem down because
we ended up with a transient ENOSPC error or an off-by one in the
free space accounting somewhere...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
