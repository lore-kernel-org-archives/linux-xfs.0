Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC44537F8
	for <linux-xfs@vger.kernel.org>; Thu, 28 Nov 2024 21:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732828036; cv=none; b=UMLe8EdHVxIuqOMH1zUSx3AKLaQPcTZWR2mbKWOBrifqM6Xe8W5n6uyQX+EjqrPVnL/MjO1WRWQGkzsbZ0fN9A6yazZ+Lan74sI8gBAF74skX8/PCqzGHaZu8i+RYI/CQPOnnd20MSZVfaIFtqtK3AVgB8p6LcfcuHu5JSA0cxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732828036; c=relaxed/simple;
	bh=MRlF99NJGD3iAj160quF+UKelWDH0vZ9Pq6aQPeNXyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lXYw/0gBv7aj6Zomyldt6+kf314yPysjLJi9wNnps7/b3J+YXVC7sd+Rkzop7MyVToZWLw2FWqHl6WS/xpqcFfLF3kAfbVBQX7xEclzeH3lw1UtKsJswqegzg5tGfGrsl1C8KLfcAgucHLSuDa5hZ4qSzHKhThfhRptQ3pX+2Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=txo9foSq; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="txo9foSq"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-21260209c68so15447645ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 28 Nov 2024 13:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1732828033; x=1733432833; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IP8iVTNUbhWi06fROEzVGPgMN2Tbx5alRNB2v7c9tOE=;
        b=txo9foSqBxzDgfquCdtmREVzNY6MoBnRAL+GY5ZERQXfQGr7B4oUdTu7OwysfyEzmA
         7qvqCggbphElMKgljUc6g70X3DBHMYH3FbTFKBYqbq6m5s8VN1exLhoBE6RYIuVyMMZT
         4737PADIHLtBk/DVuc1mydFs6fY7XDmWJWA9YD7Exxyq6sgdRCtJ34p+wUTJOGJpcrTS
         48Fx8j5vDw7WgjNKJ00tGKNZGL330VzvGQiQNrTaynfle961BLDiYS7rbFKfmjIXL1Ge
         Me2Cvg2f/f6xRBx0P+jxJcgElIRLOVyoWSdRJwvpwiaXzg2rjOrn+8hTSMuT1tP2jRN7
         FaJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732828033; x=1733432833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IP8iVTNUbhWi06fROEzVGPgMN2Tbx5alRNB2v7c9tOE=;
        b=gTerKesCYB9r5NAdMVyJbK/0BXPi0eIiVcps9mB6NVDivoE2OdkgBTIlraf211ju2v
         zKnFb5wuMh+RLrr/9tviQXRuL/eVyZeoSjFUvwxvwgWw9dxveK+Ge3/6sFTW4D+7S+OD
         wUxPCYhs7v1JltCc/yPSxVoN/Gqpfsb+2Z+ho/sZulru1n/HBW3gcz/cUeUy/KmaBrpc
         2E25tNrach2IxhDVymHjM8T1Sncfhz+hePe4EOe8MAdNnTYiSKbO0nnhGjXUtm+0pc+N
         L5/p8zYy0b+NV6ooz6CRvdAbB80lBxDi6wUVR434xczDApaQWkCkE3CRY8Ve9o8A8/Eh
         VlUQ==
X-Gm-Message-State: AOJu0YypucZACtj4lnuo1mSqHx2Lsxcy6ifuUIZE0GP+tU9bNnQf00fB
	/nxuoc7ZkWrfhFSfsU9ik2Ywf+gM1jJBpZ3fuq32WCB43ezDGSsW/ov4ySSYNUA2om0TciL9m6R
	C
X-Gm-Gg: ASbGnctmUmvyynkCsAeVMXA1vIPCaTRJ6lGSaF+6Nc8k1mI/W5ZbJ5oJfhbrCNERRyr
	/Y+NZOMB5qXdXanf/CGWcLQbWhb3uc8lpHvoMR57g6/RQxyb3YvUfPBqwmi3e0OaHSGai0HyRTb
	AVBEyNUR0weMeQB7bJk7y2a3IFKpNQN+ZfAfSaVMNBD8M5PPzoJSO3XSQZ3OnX+bEe+iBxUqJ2z
	euHNaAAF4+c2TyjFxdf3BuXh3SQXZ1BGRsHXpoIlTXvHNzXZe2fQhYZ1EySVStbkn8Ho4Zytech
	A4X1mCo2WhA7706p9e+hufZoZA==
X-Google-Smtp-Source: AGHT+IHJZjgazYaQpQEZ7IuCQXcmQPY0p7YtI8Fn7stIk0oV62ggQeEvxo7zyq+kG9XCxYLDXMpllQ==
X-Received: by 2002:a17:902:ccd2:b0:205:5d71:561e with SMTP id d9443c01a7336-2151d8631a1mr86097365ad.26.1732828032974;
        Thu, 28 Nov 2024 13:07:12 -0800 (PST)
Received: from dread.disaster.area (pa49-180-121-96.pa.nsw.optusnet.com.au. [49.180.121.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2153d61aabfsm2480615ad.136.2024.11.28.13.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2024 13:07:12 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tGljB-00000004Fjb-0ujl;
	Fri, 29 Nov 2024 08:07:09 +1100
Date: Fri, 29 Nov 2024 08:07:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Weird behaviour with project quotas
Message-ID: <Z0jbffI2A6Fn7LfO@dread.disaster.area>
References: <20241128171458.37dc80ed@harpe.intellique.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241128171458.37dc80ed@harpe.intellique.com>

On Thu, Nov 28, 2024 at 05:14:58PM +0100, Emmanuel Florac wrote:
> 
> Hello,
> 
> As far as I understand, and from my tests, on folders on which a
> project quota is applied, either the available quota or the actually
> avialable space should be reported when using "df".

Only if you are using project quotas as directories quotas. i.e.
the directory you are querying with df needs to have the
XFS_DIFLAG_PROJINHERIT flag set on it for df to behave this way.

> However on a
> running system (Debian 12, kernel 6.1 Debian) I have incoherent results:

32 bit or 64 bit architecture?

> The volume /mnt/raid is 100 TB and has 500GB free.
> 
> There are several folders like /mnt/raid/project1, /mnt/raid/project2
> etc with various quotas (20TB, 30TB, etc).

Output of df and a project quota report showing usage and limits
would be useful here.

Then, for each of the top level project directories you are querying
with df, also run `xfs_io -rxc "stat" <dir>` and post the output.
This will tell us if the project quota is set up correctly for df to
report quota limits for them.

It would also be useful to know if the actual quota usage is correct
- having the output of `du -s /mnt/raid/project1` to count the
blocks and `find /mnt/raid/project1 -print |wc -l` to count the
files in quota controlled directories. That'll give us some idea if
there's a quota accounting issue.

> Any idea on what could be going wrong ?

No. There's nothing obvious that stands out in the current TOT
code...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
