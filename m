Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA9C3209
	for <linux-xfs@vger.kernel.org>; Thu,  4 Sep 2025 03:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756956309; cv=none; b=jh2SWAC/EOmO+6GwyxkfB6WgMHRZ9UQ2t2sYm46Mmzk4+c6v9cD1JBc9pOHftXW2caWAcqbrs6fAfhhOXaYtPs1lMEdqPweqZQIZSlQmVidYf4QoYLRsiM/1OqaCGs3O3FbjD3mOgeGLEzUh1WFPEp5VJScTZoWai1ztnPtXAWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756956309; c=relaxed/simple;
	bh=4+l3LKM7D0YA3xgn9aaPGi+GLQe3jV6o3ZK1Per/1Fk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kCYkW9BfauCUFhaAnbBkMd/cvnXHco/UxrYBsszsHnj71/svWICDjujCHMfV1xvYZ8TFUjIHKHbT469dy+T2vTdZfJH1kpD7Xu3y2VJdc9KUtUmjjKoF/tJcyyqIKCUHXEszNyMtG2LP6i+nWLMX/xvo2E7/0oK0lQIsw2fu8lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=U23029Zd; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="U23029Zd"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-32b5d3e1762so423754a91.3
        for <linux-xfs@vger.kernel.org>; Wed, 03 Sep 2025 20:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1756956308; x=1757561108; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g8IVXDPfVfTQfSyD2JC6av+KC9LMTLlhdSCNpR9/ISQ=;
        b=U23029Zd1um4GtNrykTy8cO8aUNMuzW42ymN30svy2yU09NHZTUacyCKZ7MZ/Ewgp7
         pZONeZYXZFKFqK1RJsgsV9fraDOst7WAygPtFg49mVUgsi/1j08p/T40w6NHI1lAzfCU
         Ekl6fBk6ThP+Jq0VElHw3fQZ7RgS6CyPdYmKUKRibUlPHSivhbMA5sbO0zyJmsvjaTOs
         2sFyRhf+VYyPQaXU7UrQdMXDrsV51WLXppcRnGu0YxCPOqp/SFz9B9RLqfrAlytAaF0m
         IQRmJ0YEY63kNwDGN/kCl3TijaGsiGOsYQPnLP6KlgtWDKFhLO9ju1qoZedvNaDqeWbm
         zPmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756956308; x=1757561108;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g8IVXDPfVfTQfSyD2JC6av+KC9LMTLlhdSCNpR9/ISQ=;
        b=gumBJNzcr//Ts7LYtqvn5CcxDk+81KvMStCBXET/CBasPbiHRTCN2q9RUouLbsmiZk
         ElT/ONR+MoOQZLBOAEdhyKT3SuQeoHXOnnelFXJ8Mi1HBKL+lNC88dloDcn2eqJU93yA
         3rC1YBvEcXBHsFwOajsqnVr6Ba4+jsQ2dikm3/lzZrGcyPwJ6CO2gF/dlLAkEz41HJ+V
         rdv4MYV/8SERw3zEpjmtMu9wrybaC4adHM8249MH/jGL8IbuOifGZhKSmA9VS9YPwc65
         xK63Xji+QW0M2gXXFEcigvZ0YivoZ6IJ0JD+gn4RLQ6zlLJG7doetoL5tZ0sj7AddEMT
         QNHw==
X-Forwarded-Encrypted: i=1; AJvYcCUV7kCVj3QvGQdwbjd7M+KJSDJQWYxdeFVaG82ydTtqcJvMHm/5czzMWJlpsdYSA0mjLIxrql/WJyw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAKFmvipQ+yuP+N0rgikP6TEhb2IXO/zExnD78JD4OyRmeUicW
	GAhlmfnaW15r7DZXL9xKEjcU3C4mydAd/uFbduJX89q20lueoNS9QKpFezdAfeyzXFY=
X-Gm-Gg: ASbGncuopiVVk2StfXNs3zBbJos7gdEJLcLjc+PQdq37ZfGiLNFiok6/H6hJ5SW7vkz
	VtWSXn+rChN0CpDViuTMXy83q1o+W7uBlUeKjzWhDFTgQFu5uzF+BccMccgdE6HtvrmdAoC33vZ
	Esv2vaPRrIwHWBcSvSFeKlxLwYCYP69xFHsslvsA1WMZdlb5jINBh2urgv05dO/SW2xYAf+2a+z
	o4IbbjjOKqZcyd9qDg6txSO9VF8UCOIwu8HT/5EaK7DB2kMz00rX0IyZoLXFbOl4Qd/uKb16+7D
	NPBDByYROKM27T0TWAf2V/G1WIk9kcpVndtv0b1IvMQYNHPiaFVcsRJch6vlM39iiCfZ08WYM5g
	oVQtywsaOz7997sQ9oVLu8Iu7gS1uHmSNOfLMRa108fTw5E2S+BTMH/DqK99G4sWn8K1kJ7ay0g
	==
X-Google-Smtp-Source: AGHT+IGPokrtQ6qsBbvsBepiUwDrdAfxvr1Lzp9+QDfGNNl/xzvkBYBjPLfXgVMHndffWiVU+/MZuQ==
X-Received: by 2002:a17:90b:1d81:b0:325:65ef:5961 with SMTP id 98e67ed59e1d1-328156e1203mr23341043a91.33.1756956307689;
        Wed, 03 Sep 2025 20:25:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4cd092e2aasm15717404a12.21.2025.09.03.20.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 20:25:07 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uu0au-0000000EzjC-2HuE;
	Thu, 04 Sep 2025 13:25:04 +1000
Date: Thu, 4 Sep 2025 13:25:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: "HONG, Yun" <yhong@link.cuhk.edu.hk>
Cc: "leah.rumancik@gmail.com" <leah.rumancik@gmail.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [Crash Report] BUG: kernel NULL pointer dereference in
 xlog_cil_commit on 5.15 LTS kernel
Message-ID: <aLkGkJzEu894LSU3@dread.disaster.area>
References: <TYCP286MB3686B583CB266916A4BB948EC101A@TYCP286MB3686.JPNP286.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYCP286MB3686B583CB266916A4BB948EC101A@TYCP286MB3686.JPNP286.PROD.OUTLOOK.COM>

On Thu, Sep 04, 2025 at 02:54:42AM +0000, HONG, Yun wrote:
> Hi,
> 
> We would like to kindly report a crash we encountered, identified as "BUG: unable to handle kernel NULL pointer dereference in xlog_cil_commit", during our fuzzing tests on Linux 5.15. This issue has been successfully reproduced on the long-term support release Linux 5.15.190.

Fixed a long time ago by commit 8dc9384b7d75 ("xfs: reduce kvmalloc
overhead for CIL shadow buffers").

Please only report fuzzer bugs if they can be reproduced on a
current top of tree kernel release. If they can't, then we've
already fixed it. In that case, you can easily do the work (e.g. a
bisect) to find which commit fixed it yourself....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
