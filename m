Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6580C13B58D
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 21:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721771478; cv=none; b=BLrzVefRZ7QA7tXk+526yujSXgJ7HHHmPHzbSNhB6oCkqnI3UbEbdDOgRmqRZ+/CJ/j16brbjUKr9GghTivAMY9qjlL523Zr8x9Lxzmlm8tqzQ0um2tFru6s2zS+a9vbaJLk+6aqGzGxeqXePDgWLymbXeE74bhQOkhAp50a6n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721771478; c=relaxed/simple;
	bh=S9vxCPi3FYP944SG0cGaEN4e/532KsImogdrEyCp+U8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jLIpSu8SmpvqEusFkztG0kH2BQZ0yb5SJR6nhQwao2x6hkszb18BpDQDQ7S/kfQesokwYPoillvbwx/CK1xP1yqVsCSn9Ht/zkuVdgOMuTTGkbT4yI4Ij4ySZWtB4ti8vyPH9G7UwwGpWmOgqINj3AWBEyRF2IT8R7Ymv51p7t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=L3Hhte+r; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="L3Hhte+r"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2cd2f89825fso2030481a91.1
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 14:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721771476; x=1722376276; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VnmoY0BYHwchobVmmB+EbQYxjA7k5+h++nsu5yJyisI=;
        b=L3Hhte+rzeg8nc3h5RtLUfqi3rIttq8LT0/raLRAtcQpxks13B0IvZekGJys6rTKZI
         2JrCQSC+15OSm2cQp//Ju+j3JYmaeekjTiaa1gmTpknhoHdJ9ASBbbqGM5kC9y5ePoTM
         VcQBFQBgqSEYsA85fTpVjziqw7qb+H0tjR79P7pYQnHRR5lkDuybIXO/Y+8BYIzkIaHX
         QrHhuaea1AGEEwvU/g+RdHa+m7rAE3msmndrnlOI+LO2SRVhXPkix8L/k9rlFtSJj7/4
         f++q4hUQQKAsGoMU920Y4jWy+9E+L4WXYkBvIcoKmhb0WPmT0JOrNmOx6uC1VeflkRDm
         +0AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721771476; x=1722376276;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VnmoY0BYHwchobVmmB+EbQYxjA7k5+h++nsu5yJyisI=;
        b=WT6jZtFfAUXLIYZdOncCpFuR8DFTqVM7ChEYb1ko0zZjdZ0js1FZzXO9rPdje3PaSV
         hE2G3FqnyBcm5KseovKpHTcpwn1atYvto8LHYuTZ3urFKrtCuCy+GeoFbkjKXUJogRIS
         NrhA0t40CMGAe9p9X11wx6QWYJBM3RuJF1vLOKiJsENP1i26qSQSpDobJQMPbeFkrET7
         SvDqieyMb0/Ar4Ww7i/CAstoNj+YEPnCQ5CxGGF9B1Y3lcILNgvHp12JL0xRrYJrdVZQ
         egRHpEaklckJoBh1O/Z2jWVB8eQbrYs4KkA2muPCllFIa657LcsqKCUj3tvRU+tAPizv
         nRTg==
X-Gm-Message-State: AOJu0YyZLv1JnE4jI/YkYImteviid4+nZZlsSORPxRy0QxAu0QVbxKxk
	SkNihuNvln/ZQQvIw9drSKYII0QbbVF8ve5nmneDd1E1gcph4bNVSpgwjl42xxxhIp7WZKr+55Z
	+
X-Google-Smtp-Source: AGHT+IEWQdmgufnW1wDoKsJv9BjZL7HJWOSRDx33Fu5fBqHygcjv4dvYO+u7w65dLLTDyvTGxa/oyQ==
X-Received: by 2002:a17:90a:9a81:b0:2c9:5a85:f8dd with SMTP id 98e67ed59e1d1-2cd160586c4mr9021074a91.18.1721771475635;
        Tue, 23 Jul 2024 14:51:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cdb747f8a9sm85966a91.45.2024.07.23.14.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 14:51:15 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sWNPc-008xFv-0D;
	Wed, 24 Jul 2024 07:51:12 +1000
Date: Wed, 24 Jul 2024 07:51:12 +1000
From: Dave Chinner <david@fromorbit.com>
To: "P M, Priya" <pm.priya@hpe.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs issue
Message-ID: <ZqAl0CIXzsfAta0e@dread.disaster.area>
References: <MW4PR84MB1660F0405D5E26BD48C5DD7C88A82@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
 <MW4PR84MB16604A5EE24D0CA948F1D2B488A82@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
 <Zp7Z+vLH5qmyGXHV@dread.disaster.area>
 <MW4PR84MB1660C7929333CE85B3EE9DF288A92@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR84MB1660C7929333CE85B3EE9DF288A92@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>

On Tue, Jul 23, 2024 at 06:18:55AM +0000, P M, Priya wrote:
> Thanks, David, for the quick response. The kernel version is 3.10.0-1160.114.2. 

Ok, that's a highly modified downstream enterprise distro kernel and
far older than any kernel upstream actually supports. There's little
we can do as upstream developers here because we don't have access
to the source to help diagnose any problem, nor is there any way can
we fix any problem that might be found.

IOWs, you'll need to contact your distro vendor for further triage
and support of the problem you are having.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
