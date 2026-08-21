Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FD13655FD
	for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2026 20:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787345366; cv=none; b=KG69HM9pXJ/E2MzxeDxXVMEsSeDblNz5TNos3gYmgb67xT47MZz2FcFP38GxeWhyWXtF9CRvQ1q5dq3uRMnaQIEZfgpGtUHL4ZCnbNfyITLMsoH+T1awqr49VHhyuza60F7BDjiol3hd5oXaVwis96m7XhiUUOrAKj4D+zOseaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787345366; c=relaxed/simple;
	bh=kqSSIILac7u1pKPNOUJ/EuEid7Kx/XiiY4lOm0AmR9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D84cr3R21dHleTv1OZXpxgf3kERjPYnQywBnFW5HNVKkwa0B28KT7VmhUDuFtTXPnQVQkCTKxBMF529kOmELE1LVcGuRM1N5LijEoX0jDKclyD7EMWFa0sp72GHNSRMmaYylFeMB5CQKs5NLyF1vAG/1AWnDnMZAtQHmPzxGofE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=anthonyvardaro.com; spf=none smtp.mailfrom=anthonyvardaro.com; dkim=pass (2048-bit key) header.d=anthonyvardaro-com.20251104.gappssmtp.com header.i=@anthonyvardaro-com.20251104.gappssmtp.com header.b=pxNlgQO9; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=anthonyvardaro.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=anthonyvardaro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=anthonyvardaro-com.20251104.gappssmtp.com header.i=@anthonyvardaro-com.20251104.gappssmtp.com header.b="pxNlgQO9"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2d530328efbso13739015ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2026 13:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anthonyvardaro-com.20251104.gappssmtp.com; s=20251104; t=1787345365; x=1787950165; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kqSSIILac7u1pKPNOUJ/EuEid7Kx/XiiY4lOm0AmR9M=;
        b=pxNlgQO9mm++xzF4oXrefkBI65NmRj4cE0PEedeGWceXW7ZZqIwefKR8zJTqWW49pU
         vivmGkd3PuuoukiW21eRFTEM7xAUsAQt0Ej2guG4g3I7iUHnprHcwz5wKp1fSZ0GHW5z
         xGC7EXSYdCBIO2gkBV/eOcrggfcIHRgDw5dNp3rmTldysedffpxbUKAvqm72xFMBJO0o
         Fue3GwRV1Ag9amZ7js9v93rD8a1zIkdAPa4mhXIPCdy2YclpWWExTvsafOwo7AYPn0FF
         CvlNUtZXMvQhFOEweheJZFbgY7F2to6+7n8juJbTlHhkJeufngmMyA/3UZIpJBUkkoC6
         wd5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787345365; x=1787950165;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kqSSIILac7u1pKPNOUJ/EuEid7Kx/XiiY4lOm0AmR9M=;
        b=jurDlK5m64CLcjrp5HzHfLqlEaXWcc62gy5KQcnBfVdmVa7zAWkrd316y3vNfihYiv
         DzPnTN5HlWUNfsxU2KHRGkTuHA1I0FVESWSuJXSI1JEU5TeusCDoD3VXid+LU5MUicKP
         3+m89doMRSAdXHAa5WffA3Xw/t2IoC9J4IDGO9BuuY7wXP7uvQfe4CkfA7yLD7GdL0Wj
         c4c1ygLxk2c7AOUWCLdPS1wafcK+/iB/fZvfnD0eYqpkRtVOCtJI+9PP9wOcq909Or0r
         VWfTrDyZ0ftvZ6wpuFJP68R8xqrYXj+y2XLQ7OK7MA6VNzPsw+HdgBC/RcZpO+C8SGvH
         j+9g==
X-Forwarded-Encrypted: i=1; AHgh+RocD42zydYjZECBXadb8BsZkvryYq9QfPZoJA+aN+XJT09h4jPkxN3gxNlP/aUeyOcKcmNwDnrbmOE=@vger.kernel.org
X-Gm-Message-State: AFuF++l+CzzC8OtxIG39D47C9YuOZ6MAVaMfEhsUsUqBWiotiSylK6jo
	sd9GacVZig6Y4JVP8wHqiniKlYLQ0aKZ3wDvIGBBfLzjIzpYfH+ZXGzGpaAdONN+eXo=
X-Gm-Gg: AR+sD10JOJsY9j1cvMNWLcdPpV3CA+nGY/GCodv/D/jisTY41xR/82ic/ik1aNfQyVy
	wgBFBGfrzz1cMXlB0i5ekdwXFlofw4NRvYszlJNY+FNKYUop0ljYaiN7KZaR36ZDGV8LGTSq1QQ
	1PPX1febydWSVkrDLjLaCNpdElOiXRmtbOiDOyD7kS1z7Hc5sA/fCbkowFpS4/DAW97YL8sJ7tr
	iKS/2axHgpRPmKJGX1g2apawBMWhyO7MqCuwJrjXPbl0W31ZF/gEc2JAEn/NHL6jrpCU17c0AO8
	ofUwgh6SWnbfR7mztZm+YQbmZm8iJTLNwc2De4Uvk9n0qERHKH4iGD0SCd9Yve+1Vm/IG86tRkR
	ka+gn8XsNakL+WQzHL+R2a0zBdQ29ImRrAmUQHbHS9zHre85HT02OHJGcsn1qL1lbnq1kODWgvb
	NlAQDfkxTVcmD4nXgDpGlWy7nVlFs4yHVjMQJZC2LtOJyRd4CqDL+FpHm+OAYdsHCGAKg8jNdtl
	YjUGn0JJ2L52eP7Rz5RfpRiTcdlIi92ZYZdI79WEKMeINbcbBGVS938L49erItPqo2jChsh8o/1
	2KIbH23TLWAmzwnHBQCuTKDeujRwpXaE9NMp6QL/frWvtRgspGU=
X-Received: by 2002:a17:90b:6cb:b0:366:3517:1aa2 with SMTP id 98e67ed59e1d1-395c2f13243mr17933317a91.0.1787345364660;
        Fri, 21 Aug 2026 13:49:24 -0700 (PDT)
Received: from coder-vardaro-vardaro-2-0.tail2dda0.ts.net (ec2-16-145-69-213.us-west-2.compute.amazonaws.com. [16.145.69.213])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395e4b2af01sm101253a91.14.2026.08.21.13.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 13:49:24 -0700 (PDT)
From: "Anthony Vardaro (Anthropic)" <me@anthonyvardaro.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: "Anthony Vardaro (Anthropic)" <me@anthonyvardaro.com>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: revalidate cached COW fork mappings during writeback
Date: Fri, 21 Aug 2026 20:48:43 +0000
Message-ID: <20260821204843.3223395-1-me@anthonyvardaro.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260820161123.GH6072@frogsfrogsfrogs>
References: <20260820-b4-xfs-cow-wb-revalidate-v1-1-8a19080799ea@anthonyvardaro.com> <20260820161123.GH6072@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On Thu, Aug 20, 2026 at 09:11:23AM -0700, Darrick J. Wong wrote:
> The buffered write path has similar data/cow fork sequence counter
> revalidation code, so would it be a better idea to adapt the writeback
> path to sample the sequence counter via xfs_iomap_inode_sequence in
> xfs_map_blocks, and re-check that in xfs_imap_valid()?
>
> I weakly hinted at this a few years ago when we were adapting the
> buffered write path, see [1].
>
> [1] https://lore.kernel.org/linux-xfs/Y2mcOCpKiDb4nf1X@magnolia/

I think that's reasonable. It's mostly deletion since
xfs_bmapi_convert_one_delalloc() already fills
wpc->iomap.validity_cookie. I'd still like 1/2 to stay the small
private cow_seq check so it can go to older stable trees, which don't
have validity_cookie or xfs_iomap_inode_sequence().

So for v2 I'll send two patches: 1/2 for this fix, Cc stable; 2/2
samples xfs_iomap_inode_sequence() in xfs_map_blocks(), compares the
cookie in xfs_imap_valid(), and removes data_seq/cow_seq, with the cost
measured again.

Anthony
