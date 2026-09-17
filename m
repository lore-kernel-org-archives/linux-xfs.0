Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A652F8E84
	for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2026 03:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789617079; cv=none; b=tmbkf0hQZqn2KEhJFUXpGhL5G+7Enxc7v8CUYpkUHv+xVr0NZe5SmcPetueO4MgXPImGRqvGGnc8j1B9uhDi1+t5CnxvZBIj/vM2jG7wFLaOe99fH+CwmEPiS720z5VXKCW5dU9K9ZMxNTmFR/VkUJJtFHAhox9Ix4YVo71oXAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789617079; c=relaxed/simple;
	bh=0/lTK2oUPp2WJTmHlX8v9sdqVImUGtpcz9XDcsTgqKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kE8ruGZROu6vpHX3izCoJs8AU/fkSAoTkEXD5qQaPKJb5JMqbr+jCshWsxBbCSbpToTvi24JoTqmKuNgBMrnMlLLCjV2FzeWUPOIPuz7JVPTioSpGc/BAsS5xseUDAg1OLBaZqTVnT83qc/exWZq9l8/ya+ybd6kL8e1wF0/yPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NHc7XHz/; arc=none smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NHc7XHz/"
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc4d04d740cso233113a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 20:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789617077; x=1790221877; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JRmdnL9sNsJDGBqUtbxtJpJaFIxSIcgheyfrXvLiSpc=;
        b=NHc7XHz/GXIMcYUqA59R4ibfDOIo+E8MCw2Eem7Tqj+4lZWjvh8CZW9UQwoTEFPkMM
         +tIWFpaVjgJPLFLoSt74sBBKIF+0COwDs/5vIZkaZN7oTnjdYFpxOWrPRFjYFo/xymQC
         JkT8wAdYSqP9FT1LZCMg6HlFiJ+pjgAn3xzD5pqZARGli0YUImqrQKdQhTNW0vjsJxEh
         us7gJ76G/YB7S3kkeSgbQeWA8Z37uGBItFMzcmL0s7FPATbUZzPSnqOA8CWXQ1OX6xc2
         Nk476kzm9ZEiNHOc0lAR0SmE8LRoxZxnDXnYE2bJzRGnOnebwIEoaURaAVc5x1uZP19c
         8SkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617077; x=1790221877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JRmdnL9sNsJDGBqUtbxtJpJaFIxSIcgheyfrXvLiSpc=;
        b=D280ZqWjnULkZsmZMQa2utr3MlzslWGEKc5yg0Eya2EvyWXvwJaQ9KDytKh/cPuNqQ
         JKMkjTcmtblSqdiI6fvjakIA7mKIdNilQLGOGNbKcPCU06KdWDUvMa2IZj1O4h3NjAD4
         tVOwoQdgvlPYIB8OmN2lPhbKF9/cpO9bIr+sYYOKLARCkOV0x1PQ+3VACP5gLVe+xO+l
         pezKabCTipnWb/How4e4gGjkDiCAblNc6+7EfFFsnIaX20uWH8oyMaxq0QNR4BjMLelB
         MmWO/ZHP0L6Vv6ZafVeF1ABsXP2+5RMAkP4C6eSCIJoCjXAmGBh+EIK0YXs2Wdk/knVd
         i/fA==
X-Forwarded-Encrypted: i=1; AKwUvBzi0KgDFtBkRu/JGDXFMT+g/5hlAgFjRrvaFHX2GyLjz7xiSIwGuWcGZ9jGlhg1OCQ8ZhNhJAnQNbQ=@vger.kernel.org
X-Gm-Message-State: AFuF++leBCZtOaB5HCAD30db7fTJLyvu9/LrwMrb1OAmXtwoXQvmkI7w
	oX+ZbvX8qYSgXqrOXhP1TRxRSyrdmhPC+8wCCH7fu7hqxlPkUdgTxRKA
X-Gm-Gg: AYBFou2/5Kg9bnNaveVI/SXrP18uQJM4iB5sv85HrBLyEESisF2K25uUMKyEot+RTis
	3G1hOHEFMaiKONEnK3v4Z68yajR/p4nJkQtIJ2jiR/AQnyWHmplEEgHN0e4Rx5FWqgtEbXV/D2t
	w6W+bDAOm3h8ZRjeVkPspZrsSySw4oK3in/TABEM+80PBIeqxKfr3ZNy+bRNgueSSb/yWjrAoF3
	ATiR98VG5pkoICTcz2qH4g5E9Z768eNaP65eSPyTrWuTmSu/VQXuJVQi6Z7qup39fW1RpouvSi3
	Wh1hBzWiqNPOSPx4VjL7r+MD3/1GFSQC+ysmMHU/Ihtj1AOH8d2ou1q0KP2gg+yHbMYv/H3uBwa
	LbxcG6ZNOcYw2ksYG1ok0LXPFr8tsVf7jxPUTjRWjSkbufoCJKFES+qI9cu08icsY1vjbwoPW9l
	0wgCXMpMQ1KUQjjrgK6Olx6DfPM+GXdO0K70ArGWPJDK3XJQ8556SYOrETZ8Px0cegSfW1sNUmy
	w1GHLwvCsvpyig=
X-Received: by 2002:a05:6a21:6b10:b0:3da:3bdb:b22a with SMTP id adf61e73a8af0-3dd5f71a912mr13402383637.20.1789617077327;
        Wed, 16 Sep 2026 20:51:17 -0700 (PDT)
Received: from Default ([2409:40f4:1034:933e:9332:d934:54b1:70e5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf596e1f6sm13906581eec.1.2026.09.16.20.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 20:51:16 -0700 (PDT)
From: Jeffin Philip <jeffinphilip14@gmail.com>
To: dgc@kernel.org
Cc: cem@kernel.org,
	jeffinphilip14@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] xfs: change xfs log item refcount design
Date: Thu, 17 Sep 2026 09:21:04 +0530
Message-ID: <20260917035104.10762-1-jeffinphilip14@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <aqsYHjEp-7TM1h8F@dread>
References: <aqsYHjEp-7TM1h8F@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, September 16 2026 at 10:28 PM, Dave Chinner wrote:
>On Fri, Sep 11, 2026 at 03:55:00PM +0530, Jeffin Philip wrote:
>> This patch series is the first of the series where we attempt to convert
>> the XFS Log item reference counting design to be more generic
>> compared to the previous type-specific state to fix the "zero
>> refcount but in AIL means alive" state. The patch series follows
>> instructions outlined here[1].
>> 
>> Obviously, the wrappers will be integrated in type-specific functions
>> later on.
>> 
>> No behavioral change as of yet.
>> 
>> [1]: https://lore.kernel.org/all/aqI6v-_dc2DDSbgB@dread/
>> 
>> Jeffin Philip (2):
>>   xfs: add lockref and generic helpers for refcounting
>>   xfs: change xfs_trans_ail_delete return type to bool
>
>It's great to see you starting on this, but there's not much point
>in just posting wrappers that aren't used by anything. Until there
>is code that uses them, we can't really say anythign useful about
>the wrappers. e.g.
>
>Is the API optimal? Don't know.
>
>Is open coding the init correct for the generic case or is that just
>projecting an antipattern from the BLI reference counting? Don't
>know.
>
>And so on. Hence it's best to present the wrappers with the code
>that then uses them so we have the necessary context with which to
>review them.

The BLI changes have almost been finished and I am testing them. The
reason I did not post it is because I wanted it to face more proper
review and that is likely to be stricter when the patches are
few. I could still write the entire implementation and post it as a
giant patch series provided it does not fatigue the reviewers from
reviewing several tens of patches at a time. Until then, I feel like
it mould be much better to post 1 implementation step at a time in 1
patchset. If you prefer otherwise, that can be done too.

Thanks,
Jeffin.
