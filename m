Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE7B1AA3C3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 22:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722377608; cv=none; b=khXB9h9qkW8K4gipPkZMY9JHe2o4QEZq83vM8m5S2DQ75kBo9HjQQL0lWe4oFWv3CcdphD2HnKuBTYAplocs7rDwQ8pOj76flFiKk0gXD1Sxlwcnbeg8vFhKpkBGw+s14rer/bVIdJU04ezpNbQpZgQc773L/JqUKHMR8EV5e1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722377608; c=relaxed/simple;
	bh=7TBPorIe5DHkvJ/fG5atb2R6H7lhmv40BGZn3SbJsuc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m5UqJEvWLBL9Xk+HUvVNtA/F61Lk6zVBjs+adeeU3dAw/703/sRDVnd9l62FQJV33G9g52/rzhoOLk2EN1OLmDTT88OecDzjer3M0ootNSzmkk53hFpwjj6fj8TEFtRs0K44/Lzpj214Bec1Uw6/0lBNy5mk6q8xtREnn14NpDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=gO4s969p; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="gO4s969p"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1fdd6d81812so41089555ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 15:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1722377605; x=1722982405; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FppkdFk6T8av3ftx+0musHHbp3bdT+sxnT7w7r3YykQ=;
        b=gO4s969p808gICCd0Sr2Uoqqu38ibxnDhOm+NlumK9aV1wteGGggX8PxxWbY3ZUjSA
         YIwIMIKUpcOH+qtcfUBdsVCnJBa3wzKXkBdNRcmFORzl9qvQAMCFV5SmeRtNbYNHqb40
         WdMETG/MLBHevUC2eU7M/znJhzpa+2r6Z6By40NCt/QIzcXqglYSeYN2rOaIm4a0TJnr
         i+nnY+A+07BjNPPH9SqAmvAuwMkSgrJCv7SvCPaOXlnkdsdlK41dpwlZttrVJTjBHzGT
         1hJVcAVpV+3FGQJMaYgipEOxUdUpbAMipzJFtaNn/fDGuBaOBFNMMchLTzIkJV35kJpM
         ef4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722377605; x=1722982405;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FppkdFk6T8av3ftx+0musHHbp3bdT+sxnT7w7r3YykQ=;
        b=QDbwgo5y1T7hjawG82O4nz8HuAFohjsNl4QJH1wFVIlnttnfmZwIkK+QFPXPLno+mW
         07e1+IfVbpK+K5pzd0zcSy7DCeXhnJd/xloe5PJzLZv9VmqTAspPwmLqH6eJgbvB9Psq
         Sh5u7a7mxda0S8uVMFYzlWBR0mUKqzF/1/b9XkN26zqxhQxr0y+hu5zRjsHlR/AdCWlk
         c24NjAEHwiP73svGhBLQq0UgCTnqGyBrX5H/1yz+jJlD6F7kd6qBjt3Yc0Smo0/bl4Q+
         S/DgD9rNiwx1kw7MLS/0FpotK7R9Xw/3X5mmE9mDnB15A3uRycnHGSO4d+eXVcINjKXL
         +sZA==
X-Gm-Message-State: AOJu0YzKqCV/Dd4mllEynWrf53fFW4uOxhESmihN1E2KsusPqClENJ+5
	OZobuSZZb9fK/xAHB0iz6hyVjFxCqx1poIyME2yzSXEtps1d65TFRNDAVsAQMmU=
X-Google-Smtp-Source: AGHT+IGlaujIwYPPFT6lJbRtQ5Reuy2cAiv2QTGLMWn1fTlNxWygXpEONGo4+fnCc971udmUp30RHw==
X-Received: by 2002:a17:902:6947:b0:1fd:876f:ed79 with SMTP id d9443c01a7336-1ff04942422mr115980145ad.65.1722377605619;
        Tue, 30 Jul 2024 15:13:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7ee4ce6sm107652045ad.157.2024.07.30.15.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jul 2024 15:13:25 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sYv5u-00HCZO-3B;
	Wed, 31 Jul 2024 08:13:23 +1000
Date: Wed, 31 Jul 2024 08:13:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/9] spaceman/defrag: pick up segments from target file
Message-ID: <ZqllgrMT8/p8mrtc@dread.disaster.area>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-3-wen.gang.wang@oracle.com>
 <ZpWzg9Jnko76tAx5@dread.disaster.area>
 <65CF7656-6B69-47A3-90E4-462E052D2543@oracle.com>
 <ZpdEZOWDbg5SKauo@dread.disaster.area>
 <E00E2394-D49E-47FF-B2F6-C094B0414C66@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E00E2394-D49E-47FF-B2F6-C094B0414C66@oracle.com>

On Wed, Jul 24, 2024 at 07:22:25PM +0000, Wengang Wang wrote:
> > On Jul 16, 2024, at 9:11 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>> Indeed, if you used FIEMAP, you can pass a minimum
> >>> segment length to filter out all the small extents. Iterating that
> >>> extent list means all the ranges you need to defrag are in the holes
> >>> of the returned mapping information. This would be much faster
> >>> than an entire linear mapping to find all the regions with small
> >>> extents that need defrag. The second step could then be doing a
> >>> fine grained mapping of each region that we now know either contains
> >>> fragmented data or holes....
> 
> 
> Where can we pass a minimum segment length to filter out things?
> I don’t see that in the fiemap structure:

Oh, sorry, too many similar APIs - it's FITRIM that has a minimum
length filter build into it. It's something we could add if we
really need it.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
