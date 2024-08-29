Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FE619885D
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 12:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724935571; cv=none; b=ixZNZpqg6MmBzspy5OniGNCBxMKXSZ4POgYojVp2Gs1ySB99TZbLHveeF6kUnrTQnxfIFf+foOltww3i76MWHy46s5gjVYu8FG3l9Wnm0hmgCPpgEneEV9gIaY8W1u1n2DRANfTKg7KrgylbIoKY9GZqnD54ixKY2HpRMnmkUZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724935571; c=relaxed/simple;
	bh=AgFY0CuJppxazQdPyDFglzw3FHBPTJ3pB1JFaFZV/QA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1HtIJLnng7m1quLqiROM4D38MAsV85D/+KX4taTy3SdQP14Bi/XaWw/VryGB2IXgXCXdx9VuoJr1BwjVXLNeXj5LSDtYCCmTSRbtmO9AZeagSk4gT89CeV90ArUfHE2Fm3DcL1u0B2Kq2U+PzABfT6Kge7ypUUa3v1Zo0xweYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=QXfutRLZ; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="QXfutRLZ"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-44ff9281e93so2798751cf.2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 05:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1724935569; x=1725540369; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r7JkW1kGW/foMeqY4idmoG+qoBfKoOOnmzhQ4sgndEI=;
        b=QXfutRLZ75HtYhDo1cGFXD1XI2IsHKLvW1ezPLBZHhy7zaEyw+2ILE0xvl+HWgFVrI
         Epc8MMqoYq0Ay+c6t32NnTxDXOH8T3nKtKzrgp9OaGtiuTCzF6hL6AF8Hc69eOvDqgdn
         3gHwo9bTzU8ahGE2c3NZDf9ymZlO1gSahGioS/I7gzTmH4Kx5Ij/FtfTHZYifzum+s+a
         eqy4/1VW4/DZKY9k+n1J9DJXuK5Pk4581iFGPyEGg5EDl45DnMalctqwABQUDVBq1etr
         ZSyMzwnhbyr+NhWXHE2PwnkTaHpYAMUWvSXVP8itoAxts+F7reXzfKNWMme6pzsWS6rV
         EZQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724935569; x=1725540369;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r7JkW1kGW/foMeqY4idmoG+qoBfKoOOnmzhQ4sgndEI=;
        b=JjPRjtBgrvUmR80Mq6yNj6MAHL+ThxMMR1MrbTVpllyVkd7kULWmQuAFwToAGHfMo+
         M/fsFGjrb3xi5x8jF2RgbJALLrh/YeFkcyuRqoNGbkb1kAWR4flTjQ/9/NJygerX6X1X
         d4bBr3dta11DuyxbWnpaL1z2Au001Dm/dtki+2oJc9AwpEr2uI7I8UJkhE04sCDHp5Pe
         90kIzpSv0JpdoXnYbBoBo8TkqC8T9BwbqGn1GsSxtUF8oWGEzy9UgEUWUMC52sRzm6aK
         1PVoUGGLur5pludfSQtGHI32o/Z1dX9CyqAVTA+LV0kobrrFxX6CIkoh6+yA8n4g0Bn2
         ETaQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3yKLVTbAvgBi8mF27UNSa25UfK9LC+hlEDj7PD8wqg0QZZlStwLOYEgEkKxe8hWB1T/3E797RoIk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/iazwZB0Tvw/I0cx3T5V50FTa5NEJngHdhjpGXPe6crxmVS87
	bEFtpmPPWNDVoBgSwNQW3rPfNqLrupjdw0BuDjdElPs5HM/fEL2svGR2MpFkVnTmjBiCh5w1o9X
	6
X-Google-Smtp-Source: AGHT+IEjg71/rsVeutV6nh+K7FzjMZMNrg7qdXnGqs9sjXtDgQQ0paOoCdMyiPmGsrXRfVqUngI+Xw==
X-Received: by 2002:a05:622a:5585:b0:44f:fef0:70c7 with SMTP id d75a77b69052e-4567f710518mr29246131cf.44.1724935568801;
        Thu, 29 Aug 2024 05:46:08 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45682c98196sm4526271cf.31.2024.08.29.05.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 05:46:08 -0700 (PDT)
Date: Thu, 29 Aug 2024 08:46:07 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Jan Kara <jack@suse.cz>, kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org, amir73il@gmail.com,
	brauner@kernel.org, linux-xfs@vger.kernel.org, gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v4 14/16] bcachefs: add pre-content fsnotify hook to fault
Message-ID: <20240829124607.GC2995802@perftesting>
References: <cover.1723670362.git.josef@toxicpanda.com>
 <9627e80117638745c2f4341eb8ac94f63ea9acee.1723670362.git.josef@toxicpanda.com>
 <20240829111055.hyc4eke7a5e26z7r@quack3>
 <zzlv7xb76hkojmilxsvrsrhsh7yzglvrwofxcavjo4nluhjbdu@cl2c4iscmfg2>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zzlv7xb76hkojmilxsvrsrhsh7yzglvrwofxcavjo4nluhjbdu@cl2c4iscmfg2>

On Thu, Aug 29, 2024 at 07:26:42AM -0400, Kent Overstreet wrote:
> On Thu, Aug 29, 2024 at 01:10:55PM GMT, Jan Kara wrote:
> > On Wed 14-08-24 17:25:32, Josef Bacik wrote:
> > > bcachefs has its own locking around filemap_fault, so we have to make
> > > sure we do the fsnotify hook before the locking.  Add the check to emit
> > > the event before the locking and return VM_FAULT_RETRY to retrigger the
> > > fault once the event has been emitted.
> > > 
> > > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > 
> > Looks good to me. Would be nice to get ack from bcachefs guys. Kent?
> 
> I said I wanted the bcachefs side tested, and offered Josef CI access
> for that - still waiting to hear from him.

My bad I thought I had responded.  I tested bcachefs, xfs, ext4, and btrfs with
my tests.  I'll get those turned into fstests today/tomorrow.  Thanks,

Josef
