Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5935C228381
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 01:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738717524; cv=none; b=gO3ZcKriNvi0USkCPvLo1LIcdAYgVI++RLcTg+R+Sxtw3mfJmu9puuShJbNXYYiFuLWBRT9vBoTK3LUo2cdiEiihP3Lf1fJzcBSfm1MrHe7E1iLVXuKf8AnkhVUQNniPdc8SxVbVGfr+WoIunC0WqZ5kem1wIow9MGW+rdGDa1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738717524; c=relaxed/simple;
	bh=fVKn6Iz8IKh+0DNQ0aNBJ7f00vOHRIsDlPlJmlNzfM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ye8DFJddQUyMuf74vyUsvqDdTo0qWRHvqlasopK1YPocumrpt5rUivi09hXi84yZzB3O4yI6Ki6U1h0h+ilSQBP0fo2Bxyex8174mACT2dCiCQzd+Hs9ocSFrVSu/pDMUD8+bpjswPujucBDRctWXT9AzQg4rW4RfU6MN3rVp9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=XnK/bYBb; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="XnK/bYBb"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-21670dce0a7so129838375ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 17:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738717522; x=1739322322; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CW0QjOABX7MTkerfBJJ5Bd2xyK0wa13rFDmOVWxIs/U=;
        b=XnK/bYBbFmuIpedMalV9g5sMOShi3h+NIFqAojTpOWbsn1A23e0PjnVnzhCMkNhlQD
         2vHUK9niBnkwAG1eydisPs8+NA3vX/N7nRMqm1hJITkA1DRKTj5kElmGxQmnzINFy4X0
         W6AyHt9e6rNrFQq0LzgqjpFxQlyuHNSC8jVEmCMI7rQtA23GKrSnC2+tu9qFI2CyfSLn
         1NfXbFzs1lidOmDuwAMUL7ir1letvm6s5b41HICqylF6J3t6B+GuBuYXfYeSBhrzFRz7
         3yTQdfiwcQVCGbM3WjDrl4wtkxaMOX16yFXLbIttvvlQ3UHntm6YN5uZb+LVUAGKdgtl
         iZ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738717522; x=1739322322;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CW0QjOABX7MTkerfBJJ5Bd2xyK0wa13rFDmOVWxIs/U=;
        b=vna3XNtJBPytrKx5VYC43Xkd3OmZpmNb9Ug3iKTp4OseBiOMW4rb3P9MLqlrIB/VMU
         9cv6a9MB4PMRboAD4Th4+jthbsiGJX3/+H/eNKfC66HSn2rJUaYjUndBw7byMgCtm/23
         37nnoa+Q5YuDgZUowmwjVo/ovhQLd4NQxIIJox2xtr9K168JNp/ctwG+3W7b/l57oJYV
         BS8kzaee45qXsYRB+6fQufimAIJcyyPBBQTalCiIbkz4b3TJ6BTmD9xppQjaS1mXfV0H
         yS4qYhQBA4HqfPyQbhAzvCIjc2NPEh/iDO5ISUCt/tC5vPPwO85pK95fLatdkuBdhrLR
         UJ2A==
X-Forwarded-Encrypted: i=1; AJvYcCUUYDyS59DrO5YxfTZ2avgEZ1+iJ8K41SFO71kXoumTtzMQIH6nmdWWXwjU2pHD/Lrlb3bKAFYV48E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyE3J0rFHQjNOT5fm4rBeHRVX+ChPy8fd2Te2TR8G9mpqsMsrZT
	8/CauL+XPaGHRPK3bpnrvTXUp46xqrhf+Kk1F4FBylRJPRyESsUfDTEKaxGbMIID0yxyd37IDRA
	c
X-Gm-Gg: ASbGncuc9RcRygh8+IvpU5LywwHz1OVDQPG7nK5m55EsixfJkm1v/DW/9f2hQsVT78h
	iGxHVG2Ft6MnB7yIkIcCJiU24MG4DNsjTGEV8lK5mrygopobbc1enZw1M7c+6uSs05f363gz6sX
	iPv+0YeAfkyZriHIWmqI3JiYod2dgEX9++8tca9Jcj7vsgy035HDnwEgXlKzMD1UwwZQZs1LM96
	vaw5Mg3n2V6zG6YV8o0+FrGCGGJtzh1arTR+l5c7IFzPT6CwYPwsMnMpCh+s4OzC4FmNMUR9sH8
	XzfgS9mz1az8LhjRQgp8mqqGoCd1DOEk2zFyAy+Ty09t4V1E7dHI3RGC
X-Google-Smtp-Source: AGHT+IEI0CLBmrTtFqKb/GboEHeIC6gM0Ng2CaLFO7ui/3NWGa8Y+xXP18DklDabVttPRslsa6U6jQ==
X-Received: by 2002:a05:6a20:c90d:b0:1e1:a647:8a54 with SMTP id adf61e73a8af0-1ede8842bf3mr1477146637.20.1738717522596;
        Tue, 04 Feb 2025 17:05:22 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-acec0a66a57sm9097208a12.75.2025.02.04.17.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 17:05:22 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfTqx-0000000Ejru-07WE;
	Wed, 05 Feb 2025 12:05:19 +1100
Date: Wed, 5 Feb 2025 12:05:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 34/34] build: initialize stack variables to zero by
 default
Message-ID: <Z6K5TzOxg6RAwFLY@dread.disaster.area>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406625.546134.7067216243468836148.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173870406625.546134.7067216243468836148.stgit@frogsfrogsfrogs>

On Tue, Feb 04, 2025 at 01:31:10PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Newer versions of gcc and clang can include the ability to zero stack
> variables by default.  Let's enable it so that we (a) reduce the risk of
> writing stack contents to disk somewhere and (b) try to reduce
> unpredictable program behavior based on random stack contents.  The
> kernel added this 6 years ago, so I think it's mature enough for
> fstests.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  configure.ac          |    1 +
>  include/builddefs.in  |    3 ++-
>  m4/package_libcdev.m4 |   14 ++++++++++++++
>  3 files changed, 17 insertions(+), 1 deletion(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
