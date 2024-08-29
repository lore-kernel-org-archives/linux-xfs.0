Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266AE195FF1
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 12:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724935328; cv=none; b=hGo2B9WruQwdBK2d5DgI9PTVHKWwsED4+JAsi2YoSlK6u8Uf5qNojfDLR7JQSuiBvZixrV7/wmi05J+lrleWkydRx+0j66Ey+uo5RS5sYPqnNMuOe/dSy6p1H4z9mtEEhGQQ27BEjdGNhdZdUy6QWaILrlKuKH1oCEbyAn9+W3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724935328; c=relaxed/simple;
	bh=rPTzSrrL44gBi+TXZ2hY1ABQe2FEI7q+NKSsoU3u77o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GoWvt08N9L5/vdygmQ5ry/bRHtlgRgzJDsHrRq4JAhzCJ5OwHhXjSSbx+LvMOpdAAUFWNdCwJMqWNsTkqfpQ/gRm1fiN6iEnpAZsgoZVHCyJrjCVsFLBsq9c9cFUDo2Kq93U9xfTNXSZAbsr6OkTa/JNNxGskDLLW0t8j1skQcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=Rg2iW+We; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="Rg2iW+We"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-70943713472so285510a34.2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 05:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1724935324; x=1725540124; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FVPDR0EpectGlXjsBS1JG87x2k26ixV87HJkZnRLrOE=;
        b=Rg2iW+WeOk3dyEMoUEBAZrlngLG6MQB7ShlrwSyWUlDCi+yE8JTaGrS1s1ViY6CMmz
         mkzi5f6vnfm+BoOMV22cSwoeY+89/9YmfzaeK9WMmtK4dwlXn5Qi1hmGKRC+LprrWAM0
         KQNqjwPH8q5vFDyTG75AIwCi3UQRvxN0TR3V8ic7Oq333HmInhrWCz0dmFGjukOEq+8O
         SO6h+C7KSNNRJv3Fv+wwv8RD+MWibpksu0GtS6v/f07k7mHO4HBG+JgzeMTJLdKS8oDC
         Lkac+eRF/uVx3hv7AoyfQCV1vZY2PbfVG4XLILri6uCJFKOm6t8TqswwHc5jFbXyfhCN
         1/0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724935324; x=1725540124;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FVPDR0EpectGlXjsBS1JG87x2k26ixV87HJkZnRLrOE=;
        b=jQlLqykReHNVoeoqDqlqBzNM3/Kh2NzpSAjLXF3uqHSamIYk3Iv8A5Zi8NKoPU4o9S
         kxWTVIfFgyYubiLwQQt88U+GM2aC+kNQ413DssTJDVM6XB+IZWyNy9T2EpdaeAVqL6uX
         6lhAk4LiPyqC7vgPyORqf77ftErlUjizU4vc+bL4wlhmMjQlFHZDzunKNOwk5FQbw+eW
         l+ENOazVSAFMTtQ74iZIRzLweWMjzYUitxTrYny2QnUwyiNn2WRE9H45wkWTSZHAIYhL
         kD8e8+5kEboHdXJuEtUwytiPJgiKZNSv8mwe+1YCi8FGR8trO0H6Q4YZq3mgKOFPySd2
         TYpA==
X-Forwarded-Encrypted: i=1; AJvYcCVd8Q7lgCnz4/n+ZlRNMLTdU4a/Sq6EMsZ1eefz/wmkDb2jUDAnpsWyFbablehKxzB1RAcOEMRJmxo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxxXzqtQQxPKveaPUhaspgvPeyFKNzFwcfRsZYy/3BqITiSxY4
	bL0xnIx3KnD/QeNVHhtOu5eaI6rnChoDf+hBOlma3bU6hQsLMQW0r+H88uJiXp0=
X-Google-Smtp-Source: AGHT+IERjQ2135hGQyZwiYosgx5A9+JFDCAJw4M5MqUbqQEwCfNN1chSfcV3K03nBIADv4Tc9PUPIw==
X-Received: by 2002:a05:6830:4985:b0:703:7a17:f24a with SMTP id 46e09a7af769-70f5c21d1c5mr3939782a34.0.1724935324156;
        Thu, 29 Aug 2024 05:42:04 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a806d3a047sm47621985a.98.2024.08.29.05.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 05:42:03 -0700 (PDT)
Date: Thu, 29 Aug 2024 08:42:02 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Jan Kara <jack@suse.cz>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, amir73il@gmail.com,
	brauner@kernel.org, linux-xfs@vger.kernel.org, gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v4 15/16] gfs2: add pre-content fsnotify hook to fault
Message-ID: <20240829124202.GA2995802@perftesting>
References: <cover.1723670362.git.josef@toxicpanda.com>
 <2bd333be8352f31163eac7528fdcb8b47a1f97b4.1723670362.git.josef@toxicpanda.com>
 <20240829111510.dfyqczbyzefqzdtx@quack3>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829111510.dfyqczbyzefqzdtx@quack3>

On Thu, Aug 29, 2024 at 01:15:10PM +0200, Jan Kara wrote:
> On Wed 14-08-24 17:25:33, Josef Bacik wrote:
> > gfs2 takes the glock before calling into filemap fault, so add the
> > fsnotify hook for ->fault before we take the glock in order to avoid any
> > possible deadlock with the HSM.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> The idea of interactions between GFS2 cluster locking and HSM gives me
> creeps. But yes, this patch looks good to me. Would be nice to get ack from
> GFS2 guys. Andreas?

I did a lot of gfs2 work originally so I'm familiar with how it works, otherwise
I definitely would have just left it off.

That being said I'd also be fine with just gating it at an FS level.  Thanks,

Josef
