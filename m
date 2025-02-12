Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDB81FF5EA
	for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 21:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739394101; cv=none; b=FsG+ncRcz2HF+RkqY+6C3reU/GLNRhpDjUWU2Triu7d9CQEQsLzjQVH1So66XKJJI+jbHPZmHkFXGiQZ7f2IKNfqqhd7O59aJGpe7PDq9ii5u1wNch/R6BmJgEoB4VtrfLVmBCzYe1DvlmU61whAoNJ7yIWzM49OCAJjP4m8VFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739394101; c=relaxed/simple;
	bh=1VyAEiQDS2q9VkRGK+qwT+LU5/8emzrXoHFxIXPyBLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=II98ZtLDl04lcu77B+TEgc0CjgnxpJLwv7aNw7+nbRipqcxGYek0bsZbfHW8kENHYi446/W7u77RZeodEqg4bFm4SRTPKQcIg3qjX2BvD7RKAMVnLyVbXlx46xtSL2JfaqNEyZgxsOjO/6HIpdxGp8I5f3qDpeVNRbgYah0swY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=dXkaMLAi; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="dXkaMLAi"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-21f6d2642faso2848505ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 13:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1739394099; x=1739998899; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JIR6zZ2LFfRJBDmVHzXDNp6ZFUCOkYJZeyqW+eFjzG8=;
        b=dXkaMLAiRFcefsSibZnHaWvEIsJnViDbvC4+W3iGzjZxhcLZT4Cxe9mWzWgjiuzIND
         pTpmDbiquuCq58KfFGME0uGDvFmed2973V033u3wJi/ySi37h5jmL1YUM1z5Rr8i04w2
         wplHBC7pIoG0Lk0bMH6HlqJmMRVPjyQ+Hn6+T/BkLm48GEE9nYa5wDRLEahW8H4BqG9s
         ST/IBhVE2F275QdgOJJStNBhB+ZUrtQPxAfv1NvpXyZdO9tiBrScpH9LaCrXO8NL/B6x
         rJV/69IrpGRA/1aduMAnSxhGQ0R4WQ+dASBSFD4HmwSBAUghZmpnOjHUHMfNxEfIt4ME
         os0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739394099; x=1739998899;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JIR6zZ2LFfRJBDmVHzXDNp6ZFUCOkYJZeyqW+eFjzG8=;
        b=p5CHpPuJjZWWxUj0vbEGGE+lvendjcc2WD+AsaDkIBtqsPaiF+WXRJBi8T3l0yef2S
         iaN6WbPcUhJjEyOA5ps3EwWOKaTJNWtNZRIVfBelYHp+NPYZz1XCQD1awHEPPwxGREO/
         nFRjTfNS98cWzixxFoy9PV03N4yKCh45XhCBovjUzTgdYQhCYgYc5zE0jHcnNN2x6qN4
         6g+LYlMRXpVZabTkK8oIm077H2QkuHZOuBHb1PS1sfsqezZO6DJMdTYBR/sxfhRfuTxd
         B26DKCHsSOaQhsz3WJRvTDB9rYs8nkrv22hhMrNoSjjw+/T06UX/xLhvckGo73XJhABD
         c7nA==
X-Forwarded-Encrypted: i=1; AJvYcCUVJcKg28JkzSrY1apmTzH/rCJ9SsbTby3cR5NF3QlDEVgaviVITI7MpDJZsU2tkpDxeKCmcaQk3Mw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWA1P+6WNB6bU43TkBYBIQJmBKLGEO/hC9jjYQDBqfICJmnz/z
	s8QBKkzfQUMPK3Sxmx7KCTa+RdVjs21SVLNhxgPoaw27Q7V1byPQOLvl12lf694=
X-Gm-Gg: ASbGnctrdSud/Hjnz3EACaE8EEzxLfTK7UNEEDrIdssFPCgMcwt3m/eVaSd/pFcFPuh
	Sfwni5wVMsDeiZcwkZpy4sHMX5kDibqprFUJmw6sp0vqxHwxQ2Z5H7FKa/2iyLuU3SQj38DYPAb
	XjfSb9Vs4sglCD/xBm2rK0n0TdnxsA/sLEcIhF8hEvXs0WiJ6qLpZmyEpXfOu6eOHE8vNiuudu6
	Mx0SfNuzXlfIe3OK66UsdMXDx3GgfYrLT9ftUkPzy4P/6X9J8qshUF3gMwLUMm+n5tQUjyl/sHx
	c12sSMpvtUCBkbl1vAbgA866ZhRZ22aCcSSfaseGkBwsg4bB08BxNOIJ9IqObLcRuFo=
X-Google-Smtp-Source: AGHT+IFZQ+UkMOepNiqiOeT5081AklEp/hOZMtQlwn6wyDVLQoiCCEa+ujVvRZhLWXYZgNe74j04vQ==
X-Received: by 2002:a05:6a21:482:b0:1ee:668f:4230 with SMTP id adf61e73a8af0-1ee668f42e9mr5152871637.33.1739394099547;
        Wed, 12 Feb 2025 13:01:39 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ad6019204c5sm4418595a12.60.2025.02.12.13.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 13:01:39 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tiJrU-00000000RG6-1CPB;
	Thu, 13 Feb 2025 08:01:36 +1100
Date: Thu, 13 Feb 2025 08:01:36 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org
Subject: Re: [PATCH v1 1/3] xfs/539: Skip noattr2 remount option on v5
 filesystems
Message-ID: <Z60MMI3mbC9ou6rC@dread.disaster.area>
References: <cover.1739363803.git.nirjhar.roy.lists@gmail.com>
 <8704e5bd46d9f8dc37cec2781104704fa7213aa3.1739363803.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8704e5bd46d9f8dc37cec2781104704fa7213aa3.1739363803.git.nirjhar.roy.lists@gmail.com>

On Wed, Feb 12, 2025 at 12:39:56PM +0000, Nirjhar Roy (IBM) wrote:
> This test is to verify that repeated warnings are not printed
> for default options (attr2, noikeep) and warnings are
> printed for non default options (noattr2, ikeep). Remount
> with noattr2 fails on a v5 filesystem, so skip the mount option.

Why do we care if remount succeeds or fails? That's not what the
test is exercising.

i.e. We are testing to see if the appropriate deprecation warning
for a deprecated mount option has been issued or not, and that
should happen regardless of whether the mount option is valid or not
for the given filesysetm format....

Hence I don't see any reason for changing the test to exclude
noattr2 testing on v5 filesystems...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
