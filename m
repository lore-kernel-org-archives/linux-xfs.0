Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249272D63E5
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 05:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771996718; cv=none; b=LNrtMGjTKTPuj6muDymba9WLNqzK2fa7o4KNt3d91OA5ni6posNW8+lDxSPTaFw6aurOAYXV9JsHB9DfkcqZmtI2Ep7TB6gfX5rn76yGpt4B7OHncrF2DMZzE6hXQ4mb+njUCRE2wi4umQ+3waWCYsZDltp4vAREz1m998dXv9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771996718; c=relaxed/simple;
	bh=C/wN3yfQ9G9UkppJlbjel0p2ELNuDRdLtDCjB5j1cuU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=QbU5b73s4C7hcpE/fq1eaAAwH519bc5BXordbDRH7gxnbTwhUe0PAl1IuL0J41nEfuzOXDGhM7I9yA6jJRsbblOBVbWWnp4WXtmn7O8faHyz7UfBG6iiLLizAckFyJd9h7Wk8nM/q60FIH0z7UNiHU97rU4zJcZy+6NfPO7qaMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iMVzZP9/; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iMVzZP9/"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2adae92249eso11672365ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 21:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771996716; x=1772601516; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AlEL/5agn86aOLJOKSSL+66MwmfqUNVuVfSZ6HRleS0=;
        b=iMVzZP9/Qiquj6w3jfj+I3hplVbyExN0DRXR3+V4pfLV8OLdkxnIMPalPeHZdtg2GG
         Wdy2oSU3yy2Lpp95iDm/61rFMY2X4z1d7LFBS2s5KHu+2KYzFPnvpALPZPsWwYu5ah5s
         27F7HzckNJP+gjOTUc4hcL9KO88XpZCJWpDL9EGx0q/JR2Heo5RKWOr1ut4q1SAme459
         BvlsyJHEHlXYioGiYgEq3XizqeZ9W81UXcENCYHDNvj5zX9ocXUnTHCEmlc4HQru4z5j
         3//Hlo6/BIQxRfiSeYfRbamIxTRCOulPiFpUQUATRXYaDCFIICGGP18ggD8Kqo/hpxdQ
         GzcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771996716; x=1772601516;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AlEL/5agn86aOLJOKSSL+66MwmfqUNVuVfSZ6HRleS0=;
        b=Omtm9b+PVIr0MywUGIMCMFA4hsK+GwAkS3n9cjN0SYNCWbmBoxCEU5m+t7M2Zu72Ah
         ZY5qz8VM5SYodY6JdtPOtmx06o287KeAED9t55O51465j63ZksnbbJzQRgXAA5NzF15f
         x/FLdCGJ3zn9PuOZRxAUljxovHRuKok/pvtT3EfarJH2zogvZPFSOYKyTafAhoxGlU1x
         kJBkuYjeVFp3I5RAVGpDrbWS2VdnZRzzuXU+Jhl/kzUwasEWykoSZVay+byErPAhqq8T
         oWOZRhZfz0KwPfB+D4mkr/8ml/yWOQNHSUjvBvBFBBtTDNlsfKGYyi74kz80W4g6LV5K
         ZMKg==
X-Forwarded-Encrypted: i=1; AJvYcCX0Au6i3yk+f6niSYzCJUmUlXqV0TKJ95bKVsWQ3goBb5KDF+TKr0NiRcJMTQmxXZfRWs2U35R/QL4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yws8QT0gP6yTRWBGSX8+BOf68RhGDWXFnoJ8+BSR4rpDb4AKO1N
	wvjaDwO2lDCPAgq84M1AijKAQxJsT51g4noMKlVJdeUYmhPUj9+yJASJ
X-Gm-Gg: ATEYQzwRC6X240VKbGxuJbcQ5zi2EAVSEZOen7jhPFUp8JlanUM6BttTcqCJNd7BX6l
	ZIQhkO9HRZ5irF2w20Oy0u+LjpXzDsl3QqkH9PlEJTfTNtEdp68a/RFhQpAfVzUvseoJ5YGxoMw
	3+csy45pl1vLAzUq4G4rGr3KMXC5rIUc+THy9mI6VcJDsSS8XtLFHAETSOc2PEmUUSQ7VmqYm51
	Jg4BpxBWuHU98oDuAuAGzeuHRIxQDUe/LRjgtbT1wL0h7raWXXMsblbAyzQLmFvGeqzE162Fr8n
	I5yYOtF6AhYnQBiR6g+Z+/muiR6I4Dtqb45vFR5qu0MnpeVCl0sDSjasGIKtUpQC3Kj+vp6UeKI
	+87nAoI0T39sEb7MwhEuEvv016wai04y4DIMQpLv/hWpMys9DZ+NNoahvhRswg6TwLziPISX+kD
	1tj5gaQMvW8PsBCZ9I8NJ58Ix5ijgqFV7vIqwGLfWSOK4q82vTo7oTvseAQxl8I6yasJfwulBjS
	EE=
X-Received: by 2002:a17:902:f60f:b0:2ab:3cba:42fa with SMTP id d9443c01a7336-2ad7453257bmr148390895ad.46.1771996716506;
        Tue, 24 Feb 2026 21:18:36 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.233.55])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7500e1c0sm130118045ad.45.2026.02.24.21.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 21:18:36 -0800 (PST)
Message-ID: <dba862052a60544058d6e7e9cadd52e6870eb11b.camel@gmail.com>
Subject: Re: [RFC v1 2/4] xfs: Introduce xfs_rtginodes_ensure_all()
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: djwong@kernel.org, cem@kernel.org, david@fromorbit.com, 
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com, 
	ojaswin@linux.ibm.com, hsiangkao@linux.alibaba.com
Date: Wed, 25 Feb 2026 10:48:31 +0530
In-Reply-To: <aZaqZSUKUJDpuVQK@infradead.org>
References: <cover.1771418537.git.nirjhar.roy.lists@gmail.com>
	 <38947e4ca2d01828e7e7033f115770efe6ac9651.1771418537.git.nirjhar.roy.lists@gmail.com>
	 <aZaqZSUKUJDpuVQK@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2026-02-18 at 22:15 -0800, Christoph Hellwig wrote:
> > +int
> > +xfs_rtginodes_ensure_all(struct xfs_rtgroup *rtg)
> 
> Please use the usual XFS function definition style.

Will fix this.
> 
> > +{
> > +	int	i = 0;
> 
> The for loop already does this.
> 
> > +	int	error = 0;
> > +
> > +	ASSERT(rtg);
> 
> The assert isn't needed.
> 
> > +
> > +	for (i = 0; i < XFS_RTGI_MAX; i++) {
> > +		error = xfs_rtginode_ensure(rtg, i);
> > +		if (error)
> > +			break;
> > +	}
> > +	return error;
> 
> Just return the error directly from the loop and 0 if you make it
> through, then there is no need for the error initialization at the
> top either.
+1 for all of the above.
--NR

