Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3659831D38F
	for <linux-xfs@vger.kernel.org>; Thu, 11 Dec 2025 20:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765484981; cv=none; b=dPGeCNeEioXAF5KYwu+0+eyNRiiQsyU3GHPj8silfQD21KfamftTcQK/o5f0rUbmG9d8Hs4ANZWehdpsEpSl5wtGoQnUFhbZe6hOnnqVxcE5qxRsvctaiJ/fOmnYO4oylxhg8bKPII44B0eKGd7kdLFKyFExU3feIyDMRMyDnz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765484981; c=relaxed/simple;
	bh=9DRRCSLEBB087PyuGppIjlXf6xvxWvNoT6XXU1Vh9Gg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=iDbaInB/F7/krgK+FoKppLYLuSW2xH97UGDO3yUTkcl1eW8sQWyPGOfpax23F1JRoK+P1aoHXlIKVtQPUD154anNWI1RsL1r8iq/d3lbXKfey6Iknh4UHzzA0uh6ReuyL5G7s3M9O2Ng9ajPOAADUkzJQOxqBoukUtiMja+cAMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=e823m0nw; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="e823m0nw"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-657c68a08a7so306171eaf.1
        for <linux-xfs@vger.kernel.org>; Thu, 11 Dec 2025 12:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1765484978; x=1766089778; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9DRRCSLEBB087PyuGppIjlXf6xvxWvNoT6XXU1Vh9Gg=;
        b=e823m0nwJkNkC3jZx7TG7mqG2hoLjbpwHIRBo0iPId9eJEy1W3v1CkVfoAFN/gVn0t
         4ualeUJxefTZ52wS4zDYjcd6iqp445apkpfcx0pQAr9+fhfYM2aAKNMAWq4JQ4o6QGvE
         EgO8pt+6HGTESsG7/xMhPZW/jzGQKSNbXMH2h3Q5iOd4pqNbopg+1FGOahufBpULYDjg
         SmteJ7T0JrCsLC3YR1mpw6GLRkIwGIVDLCn9jo0KXKcXjjrRV+M5u8RbAzhtrtQvm7ey
         U11ngNqucxofrx5gcjAWmzllQ5Ze+B1p+svhdgE5Ijk4blM3ubvPI+NUuo5Pn28Nwo7l
         64qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765484978; x=1766089778;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9DRRCSLEBB087PyuGppIjlXf6xvxWvNoT6XXU1Vh9Gg=;
        b=LwEoTGDY9IZOi17xVrGSEQrisbB8YmtzsmNTmkOaEFA6STd/KshMSVLt2p7VHs0jCI
         xVlw1a18KuQNB1OC1Xo+gGe0CXV42ZBrU9e7tD6nVVk4YNED5XGzUiSceezKyYIrbi5y
         7jFnZbHShne3WPs+40pu7P5jlTHnExrndM8GProBYxBbBAzZJP/38XPCNfHVfKBmL5gA
         naNa0dXMb1L3/AexmPTBgJ0gmDlEVcDTuQnd7B3HoVkcUk2mkbwfYknzyONJ+XUBp8Pg
         zLi76hC7cZNv6HTN6tMEIWnasS4IE/ozniAZl5jdRfFlhh/n068ZeViyClW8824JQ/eM
         DYqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWLunqQrwImzz1kWcqn3QsbbFVobspRZBHE8igM+Gx+gSvICLXgktpaU+esj7Y9PqqGbX6y7Z5+ck=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkzaO30UNt98h5CP3J69A6MQF9x/LcscVyl9LiIRlzVcwIZnQY
	JJXZGcSwGtXgqjRa0stl50YQipnhDKEpnYGSVf1WYZ0SUnfJ/wdoJE6sAiFMO2Y3SFI+DyoHUUJ
	w8wZqTGU=
X-Gm-Gg: AY/fxX6GsruZw0SogSsOjl8J2rRPkng6tWk7xSNNHVFXEukOrH+4zIN4csXv6dK/Ppy
	j7gZ0AOSguePtmphcDTXIN69JSrh1DyCBLvIhE9+NZu580AoVRIgXQ/AQM30hiH9Kbc9GIiripL
	YJZjeACcT+8wPGJtL6UUc7El0hRJmcBCD7C5MSys1W0viMNleQ3hi5QyN2Gyp4gDT7UJw9RzmBq
	QW8POn/3YzKldz8H6g0fHLm4wO/NMNs63NxeAO4G9c1JktFVmlz4M0VPNYhK3RLL6hED5vNwhaZ
	D7/HeweACvN0geYxU34FuijP6532xJXhTWJVncp4I/YxKlAjKJ5Z1fjoOlTnYmrfjgZZb2w+pX8
	5gYbf4QujFK6t4lakiLWONHP/gVVxF/VD+wHDxRzQSEaMrQzTPCSrXwxDgxEidGyZfnw=
X-Google-Smtp-Source: AGHT+IGXgSVW4B5tlWc5GJSs37cpa/Qy9qqjFq/iATd96ugTpEgoseFG1mReqoD0ZC/0hihQZErMHw==
X-Received: by 2002:a05:6820:2019:b0:65b:257b:a898 with SMTP id 006d021491bc7-65b2abebd32mr3716006eaf.29.1765484978148;
        Thu, 11 Dec 2025 12:29:38 -0800 (PST)
Received: from CMGLRV3 ([2a09:bac5:947d:1b37::2b6:8])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65b35f4ec54sm1700561eaf.6.2025.12.11.12.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 12:29:37 -0800 (PST)
Date: Thu, 11 Dec 2025 14:29:35 -0600
From: Frederick Lawler <fred@cloudflare.com>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	Roberto Sassu <roberto.sassu@huawei.com>,
	kernel-team@cloudflare.com
Subject: xfs/ima: Regression caching i_version
Message-ID: <aTspr4_h9IU4EyrR@CMGLRV3>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jeff,

While testing 6.18, I think I found a regression with
commit 1cf7e834a6fb ("xfs: switch to multigrain timestamps") since 6.13
where IMA is no longer able to properly cache i_version when we overlay
tmpfs on top of XFS. Each measurement diff check in function
process_measurement() reports that the i_version is
always set to zero for iint->real_inode.version.

The function ima_collect_measurement() is looking to extract the version
from the cookie on next measurement to cache i_version.

I'm unclear from the commit description what the right approach here is:
update in IMA land by checking for time changes, or do
something else such as adding the cookie back.

Thanks,
Fred
