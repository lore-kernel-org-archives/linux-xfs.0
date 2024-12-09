Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C22919D083
	for <linux-xfs@vger.kernel.org>; Mon,  9 Dec 2024 22:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733783023; cv=none; b=hpDQMyR9BntvbvVzZ1ro7esSCEpwNBlQrcZltlkyzU1HPBnFTq7avj/uv+WVSlnJmCy/LDXrBfGZRdcIduWyRAZSKnjrPt3MK3hMBnaxC2eEHrICJhNBa+MJIDzV7qDw6RLQwqLj96pYnjW6xeRce0nONZggIWIvxpMUgbAB3bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733783023; c=relaxed/simple;
	bh=y60+WkDIoDksfJbLUcmqYmWt8AI73AHojlSc05XnQQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BdE/zKEsxsOaHTVPwa5/p4kKT3J3fbyPsmFfz7/nE+RAMn4DrAh5weaDvMh7yl5aPXqerF5SJmuEeejZcFq9vsAK9IFh2iFF37SKCAXrNjLdTS6n3sqqGuOH+ysSjf+qvrz6z3mAfl8gEheambVsrYPKY/Kc6Hjq7ISi/d4jOOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=j41kUQtM; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="j41kUQtM"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-21644aca3a0so18025915ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 09 Dec 2024 14:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1733783021; x=1734387821; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xqiC4C8fc5tfBeVUWU5CDHxc0RuIt2ztL3i4yk62p9g=;
        b=j41kUQtMO+S/xEWUMC3Hy8RboFF4I8Gc5LJsyUOvL0aR4c/I7yceq95WQ1RMxj9hC+
         k3OdaKiW/TK9QFduUOM7MRNm1pBrYSHZXck3R0Lw4HeKWug3YdDXbvJeQePGjZcBK17Y
         i0xjcBEOJ8kuyZ/enDhk0qJ5nPuBnZJN7tTgWc4HsMZAhdgziBBubx2/VFsQHkCBiAqM
         9j4dsoBezAa33gQxSjTw+848cq98rLjtuR52727VHN01lhYUpbSZpXuOd84Oq4mhIyi5
         tMr9OVaom83AzVVgMdTfzyMiTJ/hesikP/wFLS8d6gkSvjJ6WxVopGdXgP78T9fz0rFL
         GM8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733783021; x=1734387821;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xqiC4C8fc5tfBeVUWU5CDHxc0RuIt2ztL3i4yk62p9g=;
        b=VJcsyy4p4K/fWgH1b1yyMZ/Ef1sRGzbKJCvqu2m//YEyfroPuPEGRV2c5A/bGr3nF1
         yn3+YC1MFnUsK3z756joXhntcYlf2CpYwZYia/0hw5tcWb2XTw5Q6pcv1z4IHY00yn+J
         wumc22qMw3ChbWiqnbbqOBp+mnKFm9GPHnd8ddGdq0qc5raGdSiUiqZs2c/uO017kXGX
         BvWRTtP6KgwruCZ4hgwFNErjlGOd+HtSlTb1s9HPJFO83VOJncW12xeEVBsuHqlWiV/7
         UjWgYWw7iEs8Ms1dFswsNWTFp86KFUerP1cdJGDCbQ8EaDlYDshY4DAxDRjfTW7qNnsF
         wdHQ==
X-Gm-Message-State: AOJu0YwPCDYegTUvnHJJmzsyvc8/LozYhW2pFC/GjkPM8AkWJFR51dKV
	NHAT6xkbkzQaLw/PgyCfvBTlJLq4Z2moar5/h6uYgEYakzWdUaiCr5XxE4ODhLCm6YVbrLKozxc
	s
X-Gm-Gg: ASbGncuD7nv2f4VEjtJKQ6nG3XQxtd0anWBX7ohv7A3hqkvQokLDnQhERQPbb5Ioh1l
	UlKn3UUVjtjS6i7PQcUN7oJRPRvCuQQzxuqqQQBvEsYmKfjFfGh1hSKBewTgTdeTM7pf4ysjWD/
	hAssE9QPDSkLvBhawGX2MK+qTnCmhEWfUE6yv+eU2C5fjmTKlAnjmh7edfiqNvbAdBvzdf5MlZ3
	WCvMGTBUKzfkDRaapBPPbrt3XU6nKDbAZzweMu43a12thP6KpsRBOFZano4m/IolRp+ZFeVntf0
	FIX6Q7G5/X0wwxxWBxQvloRUQjg=
X-Google-Smtp-Source: AGHT+IFQYLWf6tbUQzYkpKUndm1pOAewIRDm1lRSy9XE/+VkyuZ+FQsunrzJDymwRfdKn5CNZVqWsQ==
X-Received: by 2002:a17:903:2445:b0:216:4e9f:4ed4 with SMTP id d9443c01a7336-2166a0777dfmr36049485ad.36.1733783021545;
        Mon, 09 Dec 2024 14:23:41 -0800 (PST)
Received: from dread.disaster.area (pa49-195-9-235.pa.nsw.optusnet.com.au. [49.195.9.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-216728cf4cbsm1268325ad.219.2024.12.09.14.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 14:23:40 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tKmAD-00000008k9S-2hq8;
	Tue, 10 Dec 2024 09:23:37 +1100
Date: Tue, 10 Dec 2024 09:23:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mitta Sai Chaithanya <mittas@microsoft.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Nilesh Awate <Nilesh.Awate@microsoft.com>,
	Ganesan Kalyanasundaram <ganesanka@microsoft.com>,
	Pawan Sharma <sharmapawan@microsoft.com>
Subject: Re: [EXTERNAL] Re: XFS: Approach to persist data & metadata changes
 on original file before IO acknowledgment when file is reflinked
Message-ID: <Z1dt6RmCyMtIlCPW@dread.disaster.area>
References: <PUZP153MB07280F8AE7FA1BB00946E25CD7352@PUZP153MB0728.APCP153.PROD.OUTLOOK.COM>
 <Z05FXA2ScHuEf2UW@dread.disaster.area>
 <PUZP153MB07284BD46AB65F734B0FBB76D7312@PUZP153MB0728.APCP153.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PUZP153MB07284BD46AB65F734B0FBB76D7312@PUZP153MB0728.APCP153.PROD.OUTLOOK.COM>

On Fri, Dec 06, 2024 at 12:43:03PM +0000, Mitta Sai Chaithanya
wrote:
> Thanks Dave Chinner for taking time and explaining in detail, we
> are exposing XFS files through SPDK mechanism and as you pointed

I have no idea what a "SPDK mechanism" is - there isn't a single hit
in the kernel tree on "SPDK"....

> for having low latencies we are writing to the file asynchronously
> (using uring as default configuration). I have one follow up
> question "Will be there any journal updates for future IOs when
> entire file is explicitly zeroe'd and synced for future IOs"?

Yes: mtime updates.

These are asynchronous transactions, though, and if you are using
O_DSYNC/RWF_DSYNC will not directly trigger journal flushes.  If you
use fsync/O_SYNC/RWF_SYNC, then mtime update will trigger journal
flushes.

You can use the lazytime mount option to avoid transactional mtime
updates if necessary (only syncs mtime updates from write() calls
when the file is otherwise modified or evicted from cache).

-Dave.

-- 
Dave Chinner
david@fromorbit.com
