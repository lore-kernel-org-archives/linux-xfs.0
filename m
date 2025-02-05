Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4ED84A28
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 01:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738717235; cv=none; b=qbtQG1P9aZ3kMe8dWa4InwtBNkeJFp+gW9Pv4svUYISe7617vHwhh2eEgtaO61VUNKb8sgmgub9zYQAZoimFDBl75LHCMERZD/bUv9dGfAXfjSi7/xuU01nQasa+ivlIgLpPjpoQpSbPOMSzmqYSTHuD07hTKRoipjzbSM9VKR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738717235; c=relaxed/simple;
	bh=Y7FWLQT8UE98ees+K4x9ur8zHcMK9xZCLk0+kQYJ7QM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nvmmuXeWJW0Mmx1TkdNI7h5W97BPs0YjXVi8iizJ9VmMdwtX0swWaspXvpM6c7ybmmf7wzUcl+oe8U4T+yOkDWKLdjXNT50igQ2/kb2KNXDiLBr30PoH00yI9zGfKGN0gbf1KuLWs64a3UuLIZGgJgZxTKwPTEgpb9RSqgWLlTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=hTujD7lm; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="hTujD7lm"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2f9cd9601b8so1821687a91.3
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 17:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738717232; x=1739322032; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OvpwC1Daks5VODIvN5vPWe1auzHRNpTS5gipILhdALM=;
        b=hTujD7lmTaz4MQdAJ3uv9TjFCICAYz3d1uZ6dZR1koAJ0YWXK3pqsjFEb0qNsveQ4k
         3JHshFUJJkzRxOLKAph+rPnAFXKTLqXvOMwQ3iZb3Gu8MvxnyVEwNrla6oYrzZdY1kMX
         knXvoJv+siJuJai4z3LlG5GfPPf0Kr6i+2iRixS7NvksgKexS5hImo1h2yXOpOyUL6kz
         9Gt/9XD1G5NmjhkJc0VwpQQyZfk/6Zv7iaUzf98xkq9eJaoU5uuHd7POgBJ7fH8HgjxG
         nQku4QL/Vyz0opfQymQLHivpz68pvEsZ32yuag6LqMODfhlfihLHG/EiyVx+EOyJe2h6
         x/WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738717232; x=1739322032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OvpwC1Daks5VODIvN5vPWe1auzHRNpTS5gipILhdALM=;
        b=S4sju1eDfUTaJ9KUjofX+d8O1sAUB9JzvQALuvMFCAC4sxWFITmDOLR3a0U2pzEY6c
         sBkbxXNQkZZM58WjI+/MbJKCDcPJnhjkjBnVoLXhCag7JmYFozs9XCfer0qcqL+OemFE
         O2RgXwjaANrw6v7GE4RHt/fMQ0kud9aomPdGKvYkNzqq0+67gAgtU/RONsEIN+wT23Iy
         yDkdBichIY3+aCa7N01bwLMlMwCGahSG6m0ncDFehGugB0kc62IkkLCjnsYmoQyJgxd2
         s576HNJIDVAtfivBhDIx0iFyzH5IXWsk0X38fTkr3rbS+1ONicSOQqU7Rjv+TkhVxhZW
         hTgg==
X-Forwarded-Encrypted: i=1; AJvYcCXBcKjcjb4YXXTap4A0Z+g+2pVJ9RicZdjr0jcLnQsbvm8IxiCtbkj51XW8YGg1vuRbG05LlYLhVVo=@vger.kernel.org
X-Gm-Message-State: AOJu0YztsxWwxFh3kbFwSFDg+k7E0ykeGo7QXvm2N320qTXGAPfzRdMp
	7adrg1rzBjjatiD3BWiavDtyGc0YsH9DXDMTFcexcRp23wvHeTEJA66wTGH/XY1EUf8/Q2lGbjf
	o
X-Gm-Gg: ASbGnctxRCkcUh4yBjFiNI8mLMI3rqIpDSUzOMgdL7Uit71h4TQhIzvn9piiqajJ4/l
	pE5R3unvhtb4/TRAKmCXNM1s8nCQRI2a61L0d1921X6SSrHlCg7fOzuCH1OmeDvW5zd4H/t+EwC
	QegUEcfYoAN3PwJjuHBzqdQYes5BGZy8mllzutZeNWubn65dTxAw7Ns/lMRdU0+OVgg7/wgDUVG
	T2mEaagqmndKkps4zHyUTL8t/wuhFCmx7+epl2OgCKnYeXvG+IFvVR1LiPIHj6HisASclSZxn8X
	mfji2hxrErS3tXh6+4rzSpsObHrPTyRHw3jnJo7+xeAzoBE0YStPa1lU
X-Google-Smtp-Source: AGHT+IFIGo/kCWBEfTnAwLT5cid1CedbRRsD8RlxdQgQpqJ66i1r3YqPlaqWlzvZ0EZvEFEg7MxhYA==
X-Received: by 2002:a17:90b:3b88:b0:2ee:b8ac:73b0 with SMTP id 98e67ed59e1d1-2f9e0753dc6mr1421920a91.2.1738717232125;
        Tue, 04 Feb 2025 17:00:32 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f9e1d8a791sm196539a91.28.2025.02.04.17.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 17:00:31 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfTmG-0000000EjoN-3RRu;
	Wed, 05 Feb 2025 12:00:28 +1100
Date: Wed, 5 Feb 2025 12:00:28 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 32/34] common/config: add $here to FSSTRESS_PROG
Message-ID: <Z6K4LIkO9zlu19HM@dread.disaster.area>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406595.546134.7063206926113803976.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173870406595.546134.7063206926113803976.stgit@frogsfrogsfrogs>

On Tue, Feb 04, 2025 at 01:30:39PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In general we're supposed to specify full paths to fstests binaries with
> $here so that subtests can change the current working directory without
> issues.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/config |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Makes sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
