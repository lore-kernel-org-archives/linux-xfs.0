Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FED2EB1D
	for <linux-xfs@vger.kernel.org>; Thu,  1 May 2025 07:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746084322; cv=none; b=VfXhQoseAVIgfpowfNAN8nqUGLlUE7XB0MD/VlRl+7tA0sjwNrNxKPhBOyesFWCrqDuVPQ3HsL1exLz4+nwDDwttg+T+3EEQMuF53GF0U/P113z0HF+qxmFt0eOyrKnDk0RQLiXkG2SbT6olA99ApNNtyvLHTzu34QED8KNQ/UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746084322; c=relaxed/simple;
	bh=gyt+/C6LtHuATDIq6dOfgoMtbhlm3s0zkwnnoD5DuW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rl0V2NuF8K5nRpmjDOT9O4qP4DRK1EvHOLMMXEsblpMQqCp18VE/wLrCZx6hSCaDB/fC/eUBmRfR1hbYHEPLAhKkySxQveMcqPJsXcXWXAwet7G3EwhOV7VfEIxbsvcWubaS7rei3TIPfLj6WwOXitH5lainHhksNusq+ZGn9oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=aQDifFAg; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="aQDifFAg"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7396f13b750so889667b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 01 May 2025 00:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1746084320; x=1746689120; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kSk74CWzfi2DL+JEFeRXFfxI5lUoIVOBhTlv96xyPnA=;
        b=aQDifFAgWYQXWAkm87oVPzzva6WWGALOKvS3S4u4fjUnkRLbEXD7dsuEAN+Jc6maWr
         yNRoHThTMN7Vqu55SiR+HoTqQnJOC7asnB3heB/Z8LmQeQ1No/xWu5U0dG27gtzjhPec
         0o+mBnSxNT2Sc4kxACqJqSpytgqcuG3xmZRd7Mdg5iUtQFrp6E4nWxZkid4Zz7YmNfTQ
         TbNKpif7zj4AeeSuEHIesKvMNHeEGr5NG7oBj7+2ilHp2fcEPbTNlukR4RsnJxP4SvzG
         mCdO0RbBc/3XFQ3zOE2TYgWRP0R1kchxO7sY+TeCT5fdiegR9PL9c9u92cokEkgNi+O+
         pTQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746084320; x=1746689120;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kSk74CWzfi2DL+JEFeRXFfxI5lUoIVOBhTlv96xyPnA=;
        b=MFbgjDDPQNihFZqFNiZYKtlXTcXwx8CxtOBIpdP9XCB1/K4ab8dXInhE0wGpfPSm66
         +sfx46/y4OqEPzlGuC4Jifd2iaBXisCd+srb7nIqZuwsQv3Slv8rZrotbaZ5woJ2bi/L
         2GfFvCEbbuoJE3hosdgfaxo7vwhWgchO4FZ+yq9e5qldo9fvTMWhdbi2C918GuodkNtn
         68JycIn5xswiNlf4D8G10Ac33Kcrl1DTrMSueKuUJis+6MBoA5/zwYz8EiP/T1r3/enu
         L8AYB8VtnPHVVT1MQztjM64BGmT0LkhjfMCKBJMj9jP079f+BfwGu9IQnFzvViJUUo4c
         8UCg==
X-Gm-Message-State: AOJu0YxS5Oz+Uw/br7GW2uYwP/5JjAQvN0sAdSeh4YLFAwmFY2IR/cts
	vb3qtfJAt6lR4//CmIaZhD3rvJf55BQLYJXhEUpiKEntcJdHQyYE53PPTye/kBusMa/jRPdeQzw
	y
X-Gm-Gg: ASbGnct5OkSI6VIZrZ61dOc4NK0+7a0x8qmkq3fiBI+FnUKgAb63XyeO97ye3rzC1ha
	yS+GWMEej5oJ3dKZKzQjw3DJ3/HdH1ACvI1dbHkCrGNzVMvLlOnp7yRssMrXc5Vm6U8Z10t/sSW
	3eqrcNrmhT1GCHR8856zh7gNUdc5Nkq5sgjodpmG3loL2c4FJX/0cR3eNOyydt5Fu3qEymOQUon
	s+OwmtepAlanYVs30dUxTRdkh1ZHfR/wDk7yVw44SWW/GDBQQdjuvn6rEPME4wKtSvw8P0wkbMq
	bXic270UzmC5znKXj0PatsDzR3XnOomT71OhrHrjeJIcd16V129QklT2dLpeekNjKLM4G6neAYa
	9Xzv31mU4+w3vf6x/xA84GBuR
X-Google-Smtp-Source: AGHT+IE1gfE5Hy72g+zyJj0i1Knng82f1mqkHDN227Lrxw0nhNelezuyxiHr1+FNz8MKTOe0xvNMUg==
X-Received: by 2002:a05:6a20:6f05:b0:1ee:e33d:f477 with SMTP id adf61e73a8af0-20ba6ff8e7emr2922878637.15.1746084320231;
        Thu, 01 May 2025 00:25:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fe55csm205840b3a.104.2025.05.01.00.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 00:25:19 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uAOIG-0000000FY6w-2lRa;
	Thu, 01 May 2025 17:25:16 +1000
Date: Thu, 1 May 2025 17:25:16 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't assume perags are initialised when trimming
 AGs
Message-ID: <aBMh3PJLrHqHGY4B@dread.disaster.area>
References: <20250430232724.475092-1-david@fromorbit.com>
 <20250501043735.GZ25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501043735.GZ25675@frogsfrogsfrogs>

On Wed, Apr 30, 2025 at 09:37:35PM -0700, Darrick J. Wong wrote:
> On Thu, May 01, 2025 at 09:27:24AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When running fstrim immediately after mounting a V4 filesystem,
> > the fstrim fails to trim all the free space in the filesystem. It
> > only trims the first extent in the by-size free space tree in each
> > AG and then returns. If a second fstrim is then run, it runs
> > correctly and the entire free space in the filesystem is iterated
> > and discarded correctly.
> > 
> > The problem lies in the setup of the trim cursor - it assumes that
> > pag->pagf_longest is valid without either reading the AGF first or
> > checking if xfs_perag_initialised_agf(pag) is true or not.
> > 
> > As a result, when a filesystem is mounted without reading the AGF
> > (e.g. a clean mount on a v4 filesystem) and the first operation is a
> > fstrim call, pag->pagf_longest is zero and so the free extent search
> > starts at the wrong end of the by-size btree and exits after
> > discarding the first record in the tree.
> > 
> > Fix this by deferring the initialisation of tcur->count to after
> > we have locked the AGF and guaranteed that the perag is properly
> > initialised. We trigger this on tcur->count == 0 after locking the
> > AGF, as this will only occur on the first call to
> > xfs_trim_gather_extents() for each AG. If we need to iterate,
> > tcur->count will be set to the length of the record we need to
> > restart at, so we can use this to ensure we only sample a valid
> > pag->pagf_longest value for the iteration.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Makes sense to me.  Please add the following trailers on merge:
> 
> Cc: <stable@vger.kernel.org> # v6.10
> Fixes: b0ffe661fab4b9 ("xfs: fix performance problems when fstrimming a subset of a fragmented AG")

Those tags are incorrect. The regression was introduced by commit
89cfa899608f ("xfs: reduce AGF hold times during fstrim operations")
a few releases before that change....

> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thanks.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
