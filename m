Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE2314B097
	for <linux-xfs@vger.kernel.org>; Wed, 31 Jul 2024 22:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722464745; cv=none; b=Lf+Tkk/gwECrEngoI9WZjOrDavCwPNsV9nA3Sqn98XxWS+O0OsCdyceK4tXKo2J21/f0bMY00hqxGcrd8TJZSAHxPrytaOQ4kEAvhTk/kARNcu3rDSUWRxyFPUHhP1GUQ21PpFhQTUYwMytyLHQOraEea2rK9RhQVbtSwdS762Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722464745; c=relaxed/simple;
	bh=UajfdjBz88YJNHIqGPz6wk59tp0c3ZUPEWggWgCkqVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mkHMfHIl0ajlNpJiK1s0DmbcFX4WT3Km1I06txP6VivtULuIZdlIlPN0lRzUzB7w2n/SnpsTelEUkINR9SmS/WYIVk6+AO9+gL4pQIfvjBJDKrLHJrJxmT4PujcZuA+iRkhMJ8B+lEKrju5SsPbuMgks7Yg8joppQ1Ldmhj01SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=IRwZ4d0Q; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="IRwZ4d0Q"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1fd69e44596so11297225ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 31 Jul 2024 15:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1722464743; x=1723069543; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T+l6Yo5k73bjFmLKj0qvP5wu9gnO0ysLiWfvo9xFFDU=;
        b=IRwZ4d0QsAhYpNhsqFHoCc7mTN4rwC6yBH0nQpOwOK19+XVxU+QS0ktn2XSGEIf5hp
         dQt3mkL1syY9j1A4JIcvpTgtZKzVTldohSKWTtYbyuoo7tCn9pbN4YJJ2k0uke+jX3dE
         ZNbiQh76EQlRuiemZ2SsoATVtf+q3gdKVWMcClPUpYlq/2bxCjZao9Y/aau0oP6M0WZ1
         SabJt0LiMKzehOnEQF7XdqLqfWxCaX1VeMN3Z6qgQPl6ciZLgfaNH0t+c5GuikPfB+9r
         9ekzp9kp8kDigNoce/BjmMNFvvyjQvDSHzkaNZbNotXPrmJbTfAwIejn3sGIJA8I+ifK
         mZQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722464743; x=1723069543;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T+l6Yo5k73bjFmLKj0qvP5wu9gnO0ysLiWfvo9xFFDU=;
        b=S0Z4j8CqH15hBVdVsE+Opa0agvj8BoGqgn2g6YtQa6l24FPyNsSdvurDbsCT+YcVBt
         UB6tdMrd9SElOUeP967U54O6m7MpfQtvl7tNpOZEf5Upw2bC7HLM9UA4vDpxlglttzyN
         VxSH7btTW3pNWSOacKP6dXbCAgWznGkGSXvdKDC8bprC/NYOsLZuk9kdO6p+Mxr1ZiAG
         w1MIrO6r78kGO0UXqVigIOJsMva/VU/qMDJnl8+fncVj45RHx9k/U4WEGQwXxGLjEOlA
         5+Ef3/s4ol9tBOcJBkJM31uaEKKv1snEZmW+SnatlXvVCOXUodf7raVqvrw3C+IVX+qB
         l7HQ==
X-Gm-Message-State: AOJu0Yz13aRIh5dOuNYSNDbBJ22FPDlykpRUadw//7Ctu/FxeNgH//bV
	VZ/ue6bk1f2KULILhjo1melx4PlhvaRrpMPcYjjYHniUnM2Threar+f+kQCYvRsLtXyKozRmn1q
	8
X-Google-Smtp-Source: AGHT+IGqwHBSAd3NyJN9FveKKfZDSWOI4wmZwDy5AxVz1041L26IQFVEN19uwFJzrHdRE2WgNPZUmA==
X-Received: by 2002:a17:902:a618:b0:1fb:d07c:64cd with SMTP id d9443c01a7336-1ff37c201b9mr93793695ad.21.1722464742742;
        Wed, 31 Jul 2024 15:25:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7a9f884be53sm10986028a12.46.2024.07.31.15.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jul 2024 15:25:42 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sZHlL-000nBp-0V;
	Thu, 01 Aug 2024 08:25:39 +1000
Date: Thu, 1 Aug 2024 08:25:39 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] spaceman/defrag: workaround kernel
 xfs_reflink_try_clear_inode_flag()
Message-ID: <Zqq544tguW6FWIkm@dread.disaster.area>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-7-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709191028.2329-7-wen.gang.wang@oracle.com>

On Tue, Jul 09, 2024 at 12:10:25PM -0700, Wengang Wang wrote:
> xfs_reflink_try_clear_inode_flag() takes very long in case file has huge number
> of extents and none of the extents are shared.
> 
> workaround:
> share the first real extent so that xfs_reflink_try_clear_inode_flag() returns
> quickly to save cpu times and speed up defrag significantly.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  spaceman/defrag.c | 174 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 172 insertions(+), 2 deletions(-)

I had some insight on this late last night. The source of the issue
is that both the kernel and the defrag algorithm are walking
forwards across the file. Hence as we get t higher offsets in the
file during defrag which unshares shared ranges, we are moving the
first shared range to be higher in the file.

Hence the act of unsharing the file in ascending offset order
results in the ascending offset search for shared extents done by
the kernel growing in time.

The solution to this is to make defrag work backwards through the
file, so it leaves the low offset shared extents intact for the
kernel to find until the defrag process unshares them. At which
point the kernel will clear the reflink flag and the searching
stops.

IOWs, we either need to change the kernel code to do reverse order
shared extent searching, or change the defrag operation to work in
reverse sequential order, and then the performance problem relating
to unsharing having to determine if the file being defragged is
still shared or not goes away.

That said, I still think that the fact the defrag is completely
unsharing the source file is wrong. If we leave shared extents
intact as we defrag the file, then this problem doesn't need solving
at all because xfs_reflink_try_clear_inode_flag() will hit the same
shared extent near the front of the file every time...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
