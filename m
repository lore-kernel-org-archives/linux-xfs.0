Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D1AA55
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2025 05:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737435944; cv=none; b=GznEz+aQIgws/JsP51sa6abgftHf2GZsL3I5kW7SkLawqekh2IZFH3BLFNTbxm4+tak/VfBe0fagG/1Sgovrpw80EftIonLCihAbSnHwoJCk1PIIKFnx+2DwZZgjnYbOy0eQFKMcshtw7uai6A6E5ezilmKVytOTh4mTxMLAMH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737435944; c=relaxed/simple;
	bh=9AgjCU94iKFSziUK02zntvNLKKOMcZeTw0AdftAwmLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lhe0rgc08bDHLu7QYXnlJrx4BGdVr8vclgyAixsK5R3vBjALD57B7A9fR928xi7+dJlxHN1ZIrhscOP/fLAcpiB59IfMuVpcyUXgdpvsKDQLgW0wRUY1GXPoEWZlzw39qOgEKUm5jzT16Bp+OucPRAX/vORSXeE8a2Ay+w71ypQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=UOkPRzBU; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="UOkPRzBU"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2166f1e589cso125124685ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 21:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737435940; x=1738040740; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q3GiVAFs1hWZcRMN8J8SkS1g40L+McR+ktoC2/c+Pxw=;
        b=UOkPRzBUAok0hJLSNpIoAGxKyxoWQ2O2UYW+w5skf7+wovQlVE4ZySsyJ3cpgFmtZW
         ozq73rq0FffCnAL9URrymgrpYydIztrAzJQfHysWj2KZwHbAnNq4RWQ1tFMD64PAH7r6
         fwlLpVfkEQR5rP/srtdCBD4iXqDiRQ6VlId2EYcQEFofjS0wFjh0Yw0eXxlzzokd74J2
         ivLJ2QnybClRIdgz+TJmBE4YbaiT0lMHaR2uxMGpxoVhSBfQdF3HWjga2zWYSD0Us5Lu
         8VRIq41KpofD11Nr1ao6TckP8LrNUKbt9GyKIIjB4pq51nKyuZqWO+Y8vBbdi8wBqhdQ
         pG9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737435940; x=1738040740;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q3GiVAFs1hWZcRMN8J8SkS1g40L+McR+ktoC2/c+Pxw=;
        b=wN9wGUwIzo1KI81tKIXxT9ulOLHXaqMTLz18PcaEkuTbfPQcCdjwkFfFvgnstIDRsg
         NYriXYB2t5PDOLb3vwuH6PfBXF54oMUaVnDtiC9iJFWkBCeFAZRlxc7d+i55zDlFqXa1
         JRiFqz8mrVUdeqv5ZM3qAQIxrYvdTVVl1i9qqpv1D8MiJSbJx55mEkDX/iUANtAJptrP
         vv91F3/g0nbTTdZRHbHRR2MN9tsoC+uWcD9s939jhqMCJByvrALkLwe+CaVBPpEbL950
         wdM3X7wPXM64h7k71BbkMJjLZHmE2UpgNO+M48rwnsys6AK/nmFBx6y+61eKmml4/5vw
         HVvg==
X-Forwarded-Encrypted: i=1; AJvYcCVZ1SeO7lM5fY+Se1Jkc1HHVx+M2U8qZKjzGJJ41MZ59S3KJkFEScsX3I20e+DZRVdg13QFZXaXnKg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyvi+IbEzc+o3u5rwwZDC6yfu2/iCEZGPhhghrCC69+o8YcJCCM
	SzaD0rvY1/u5E1xJVPtOaoI1hqRaxEF6kTmpKPZHg8imKTau7lD9qB45bzVf5GgVVDfVJfu1pfp
	W
X-Gm-Gg: ASbGncuQ8KUM4tSpmyvb5UvnHNR9nhqUrNMQU9i1Q9lK6GT9Ji/ShiYtJGZrz/uNVHX
	CvwuLumm6HZPRpueuhcuMxR7sgis5yelj395IiXhDfTzHsrku616Mxfg62P5n9+CtoHZYGU3vGj
	0oKLNhRxLK6mL6HLwmjv3IFWWaXkt7Sg7NjCI4dToQejQiF5KJj8zByAyUALebZ8ccMLshoRW57
	KQ0RAKN0ECohjfOII4XDUTX+CbWYtwlns4t4B1AqqfBMwZNo8zgBJ3TrXhN47IDtVg2WTSznEB8
	APsoML/ONBUIZ6GWDmmV84i99MbQjPMu4AA=
X-Google-Smtp-Source: AGHT+IF901/HmLl1mKMPqNtTPkup7hlmBd227QT6jLMAxRnhGeJjMPyWLCJ+0vlu8chunsP0YBBTpg==
X-Received: by 2002:a17:902:d4d2:b0:215:94eb:adb6 with SMTP id d9443c01a7336-21c3563c51amr240971375ad.40.1737435940762;
        Mon, 20 Jan 2025 21:05:40 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2d42cb7csm69074285ad.259.2025.01.20.21.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 21:05:40 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1ta6SI-00000008XJI-0O6T;
	Tue, 21 Jan 2025 16:05:38 +1100
Date: Tue, 21 Jan 2025 16:05:38 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/23] common/rc: don't copy fsstress to $TEST_DIR
Message-ID: <Z48rIh_I5PTrwJrh@dread.disaster.area>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974363.1927324.3221404706023084828.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173706974363.1927324.3221404706023084828.stgit@frogsfrogsfrogs>

On Thu, Jan 16, 2025 at 03:30:07PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we can pkill only processes that were started by this test, we
> don't need to copy the fsstress binary to $TEST_DIR to avoid killing the
> wrong program instances.  This avoids a whole slew of ETXTBSY problems
> with scrub stress tests that run multiple copies of fsstress in the
> background.
> 
> Revert most of the changes to generic/270, because it wants to do
> something fancy with the fsstress binary, so it needs to control the
> process directly.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Change looks fine, though this should be a lot further up near the
top of the patchset so that the change to g/482 and the revert here
is not necessary at all.

With that reordering done:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
