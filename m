Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D6F146018
	for <linux-xfs@vger.kernel.org>; Sun, 13 Oct 2024 22:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728859828; cv=none; b=so93TXHtzqrAjg5twCA6PkmlWFmhFUxPx3KfmcgLbo+4eOeBjM1ZAqBWnpos6lHC5ysqSCDAdAhFGNutByiLaPEdnMS+5POMYnE/JqLkQdW6fEYAR0xSjCfcvDSFEZTIrgBS+FN5v6DeS8Ra5rTjHgp0D5WHxDP3WHRRr9ZyGbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728859828; c=relaxed/simple;
	bh=uK2bGqq2ZoyiB4N6oR+TwlQNMug08PNtolCetpfX2YA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MwceWWAsTt/TPO1exWCyVKJa1/izUpGJyD9Pw7rgCLep1gkANIeFgxSrmkqrqWwR0InKME9n/k7PqiKaOnWPDPHH8DA5zNMSrQExRxvPOwyIgqL2pyeVCIA7QdI+CL/H7MJRJgzRaZMymrNQfT+aOunmNT8H/CTdqKE5em6Bc6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=kA5y8k3R; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="kA5y8k3R"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-20c8c50fdd9so19994595ad.0
        for <linux-xfs@vger.kernel.org>; Sun, 13 Oct 2024 15:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1728859826; x=1729464626; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b0+lmUyHCI6kEhaZF5ZEyy9HziAvatjtgIBFzvidxv4=;
        b=kA5y8k3RaR0uXJCt+zhJtK8+1L/a1OwI48vXnQTZZH1WNu0dlPVg18D0PiIEKsZeff
         DyOWrDcuPnYCJ26j22H9ix0/LCTcgujo2nFLkKSceK30z59Mb7V0n+0g2VVGDR1X0v5y
         GFSHlTCk4tITAKHANiudFDrAuDmmtldRL5AxwF1UKK7rjPmbtqqOB1rKmQrRHl0r2VB3
         qVY6zQAcLog+Ch9Iv9JdrtNciULe17DBr58Dpu34Wd477H0Yelb4aPiIrm588DG0DztN
         n/Vsxtnj5WSTsMMv9t/oPw1cuU0+wPAH5CyNvh938zKPpar+YxYLGJcbCPQdnadJL8fW
         qPSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728859826; x=1729464626;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b0+lmUyHCI6kEhaZF5ZEyy9HziAvatjtgIBFzvidxv4=;
        b=roLzqpG2ZnxPgetjMNaTIaesvweuANACdN8O2mmIZaiK++ETehbKFAH48BgQiD5rsl
         r8a3+q45n5QEAZodiiqxvNVFLsbW+gq46zpaGAyqcxUNYVZW3phxcdj4u/7EZYyTf1NX
         lzMRY7fSFd8d/xK/7ffcHPkRNLyaLJiU0SKc/OpQJhzmDHWuafL65eVgUSTdqRpShJSq
         eP2dwNyvjxecaD+KKx5bOK34Qet0Ryx++jAAQr7xGYODoRa/aR//rp0yOd7T2+QnTrqi
         o2vw2DZfBid0S/H+J8blbBLVq0Ejm/COq8FEvFQSSQZusy1y4RVSNSLRzMLlmDJMPOoY
         JGHA==
X-Forwarded-Encrypted: i=1; AJvYcCWSjc/meQox3T5sopmUPKguK1aCVfM3ek/9V77auFQjH9AAuj7ccz7PKmm0S9xpjcyDisvwvqA3gUw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkzJVv8NXJYcQy6be/4iEQEUZVqPDoBaw0wiDx8727PcCzaJlz
	s6qDLIpXoAL7+7xigq5WFe5+XmTLYTtcm0Wf/t7IRzv9LgxArUyFR5MbF0a6a1s=
X-Google-Smtp-Source: AGHT+IEUFVR/Ok4sTNqJW2BL8VzDGb807GfXVKHVOwc05thRlrRgPIHm9zdaG/KUIZk2lH9rUSBwyg==
X-Received: by 2002:a17:902:d2cf:b0:20a:fd4e:fef6 with SMTP id d9443c01a7336-20c8045d5ecmr197916145ad.8.1728859825849;
        Sun, 13 Oct 2024 15:50:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-209-182.pa.vic.optusnet.com.au. [49.186.209.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c0e747fsm54625215ad.143.2024.10.13.15.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 15:50:25 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t07Pp-000OWw-0l;
	Mon, 14 Oct 2024 09:50:21 +1100
Date: Mon, 14 Oct 2024 09:50:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chi Zhiling <chizhiling@163.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	chizhiling <chizhiling@kylinos.cn>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs_logprint: Fix super block buffer interpretation issue
Message-ID: <ZwxOrVCJ/+2GoGjg@dread.disaster.area>
References: <20241011030810.1083636-1-chizhiling@163.com>
 <20241011032415.GC21877@frogsfrogsfrogs>
 <97501a36-d001-b3fa-5b57-8672bc7d71da@163.com>
 <ZwrzxggtS96n72Bm@dread.disaster.area>
 <e0ae8eb7-360a-40c4-8c84-dd439d7161fd@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e0ae8eb7-360a-40c4-8c84-dd439d7161fd@163.com>

On Sun, Oct 13, 2024 at 12:00:22PM +0800, Chi Zhiling wrote:
> On 2024/10/13 06:10, Dave Chinner wrote:
> > On Fri, Oct 11, 2024 at 11:54:08AM +0800, Chi Zhiling wrote:
> > > On 2024/10/11 11:24, Darrick J. Wong wrote:
> > > > On Fri, Oct 11, 2024 at 11:08:10AM +0800, Chi Zhiling wrote:
> > > > > From: chizhiling<chizhiling@kylinos.cn>
> > > > > 
> > > > > When using xfs_logprint to interpret the buffer of the super block, the
> > > > > icount will always be 6360863066640355328 (0x5846534200001000). This is
> > > > > because the offset of icount is incorrect, causing xfs_logprint to
> > > > > misinterpret the MAGIC number as icount.
> > > > > This patch fixes the offset value of the SB counters in xfs_logprint.
> > > > > 
> > > > > Before this patch:
> > > > > icount: 6360863066640355328  ifree: 5242880  fdblks: 0  frext: 0
> > > > > 
> > > > > After this patch:
> > > > > icount: 10240  ifree: 4906  fdblks: 37  frext: 0
> > > > > 
> > > > > Signed-off-by: chizhiling<chizhiling@kylinos.cn>
> > > > > ---
> > > > >    logprint/log_misc.c | 8 ++++----
> > > > >    1 file changed, 4 insertions(+), 4 deletions(-)
> > > > > 
> > > > > diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> > > > > index 8e86ac34..21da5b8b 100644
> > > > > --- a/logprint/log_misc.c
> > > > > +++ b/logprint/log_misc.c
> > > > > @@ -288,13 +288,13 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
> > > > >    			/*
> > > > >    			 * memmove because *ptr may not be 8-byte aligned
> >                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > This is important. I'll come back to it.
> > 
> > > > >    			 */
> > > > > -			memmove(&a, *ptr, sizeof(__be64));
> > > > > -			memmove(&b, *ptr+8, sizeof(__be64));
> > > > How did this ever work??  This even looks wrong in "Release_1.0.0".
> > > > 
> > > Yes, I was surprised when I find this issue
> > I"ve never cared about these values when doing diagnosis because
> > lazy-count means they aren't guaranteed to be correct except at
> > unmount. At which point, the correct values are generally found
> > in the superblock. IOWs, the values are largely meaningless whether
> > they are correct or not, so nobody has really cared enough about
> > this to bother fixing it...
> 
> Because I got a log which shows that the fdblocks was (-8),   it caused
> the filesystem to fail mounting again. 'SB summary counter sanity check failed'

What kernel? Because AFAIK, that was fixed in commit 58f880711f2b
("xfs: make sure sb_fdblocks is non-negative") in 6.10...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
