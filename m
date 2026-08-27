Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4974F40DB42
	for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2026 09:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787822621; cv=none; b=WugHFweKbuSXSJTnI7+mtJzmjzskHFzcCLu70ekUQbRuWyCqfd2E83iHwnQosSqQNQjxuLApZgYN2QS6JS3gjY8VgmAD4l+8/XRKfpYPJn+Cm0l5U/ht4oOP19gzU0O9Jj7k/8BOmyxDfbz5d+iMTpPp+2eplQFjizwES/q4sI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787822621; c=relaxed/simple;
	bh=6WR8884LY0TtV5ElOIlb37OS79lPFmuaRakjeJ6MOTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UzDHYR5nwuAtdwgoKNu1WnhT3JhqUNez/ImECcl+bb+CQcGF1/v0b0SoWkM8wddqw4MBEEN1uYRjPj3dD+B5SkMhx5WNrAr2oJrbE7U9ZfikU3OUX0pYxqzht6RsYkOkFvwGDr7yHOaycMs628OYU0d4z8Me1W7YYCv4c/G0IGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TU/2g+4h; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TU/2g+4h"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38fdeaed181so867193a91.1
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2026 02:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787822618; x=1788427418; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dLjX7Vy9D0KXw4jNAF/ipY1hN9b99YKc4pBJA5PGSk0=;
        b=TU/2g+4hA4BYJthC/dpX8/oag+sh11886P8STofYXcqKckK6V2RboOkMfaC13rOOP6
         WT8rwd9K8xCyGtzpwJaXM+ZhfNl61A/0/oItD0gGEEBIEZ+dtHjQezkr23lqeo2vBhxz
         tiVASrHXh9GaFFUqn4yAN7LekG2RRCLCgNOp4OydFaBo1kS3hnlp4OHvtn6gY5qfM5+l
         nuJB+6q+4avHfe3qujoBJI1pbmdcPIQrpdscH+/H0mlt9z+dbtvMWml9FD6PZr+PQr23
         XQGqoTuekEn6gQUF9aZo23RDtP0RqJ9X0ytmN6eHikpsZA922bKgozk2oQHKJyTnpQxX
         A/sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787822618; x=1788427418;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dLjX7Vy9D0KXw4jNAF/ipY1hN9b99YKc4pBJA5PGSk0=;
        b=QfhWcgxrjMw9cfCqb91JImGakP5lg4YfE0iT6dCyZ2qBanE71sOh3j9k+qu2eKZArg
         +qZ0hg1hoJRSTq70Dn3RbcnQtJbIFeqC8rRUaXTF4HNmklHLzzgU6vKzHVTxUwfT9qyi
         BtYVa/EC/EIgS/rCXl8f1JgupEOgLDLmUVEWTc9BtOGvFV64QbRizlAU0xhiZQJjDIsf
         B6G9It1qoFc1xf3PtI3QTfub4Dxz5qDz63KjPO7JSd7aGglbFMlb8/9Lwy4oKru3Gh+V
         k64LASYRdpCkrQ60JhbWYmGEKq+LoF9aKQeerpnXAh3CDdbYckvhn7oDHJy/vKEcNO2j
         x+oQ==
X-Forwarded-Encrypted: i=1; AHgh+RrEUtmUJ94RfhNWbQaZJ9viNgR7eKMAEZ7z1LuuJEG7MFTMlwBHDIw26ZrrWlg1oiGRXKKS5QL0BcY=@vger.kernel.org
X-Gm-Message-State: AFuF++lY7svDdLbqz8keyDumIWnWnvXXHZczj8VWkFR+5geBAYStXeBD
	6CL2CArrCSTnore2B2RXqSJamJGwUhvL6fSeHnTQnZlkbFa9pqsJpaU=
X-Gm-Gg: AR+sD135c6dS26R/X7EIDKrpPziNCFtV2VDVhYB5QbzJ2SjL9ekWTfDj0UcjCJu7WhC
	4nuxhEM1oK5H/cWEHgAXDr59EVfq8581HMy0TyistC5sf9jRldrdSKHwkEV+QXWYDstN4+0qumC
	sbBRrOjh/+wdvrXKWMmqEqTmghd5ZO+JzS6czAq58S0MC9M9M1go5pwjNbxLfwI0uF9LZ9hYCqj
	sFKKpUGzgyJSG6QfCdB6r2Z1hmaXYRob0Cg3hiwrUdZck8zea3SNI0PsuRBQ4KGypEYM6RnlG/3
	xKITzVVCLhgIH0gq9pwEHVH4lKXv5lj5daVDnhcj18eZBCE8Hk3shZjD/CqxjDXx+OpLfUsbl3s
	fdBOd1ItHK+eSt0duktJvlyFHR31UI/NhaCE8n/1lVkmM0DcnbccSSfndxU8izjbmwBh22fKiek
	JuoP8XL/Jjs8F4ifnDeaBPhNpZf/OocoLIK4VSnWBHvMq/hlW6uDyDVqB0PXstiaiNJs+kNmOvk
	IPA6svaax8zUt7Fu48SLioa143x
X-Received: by 2002:a17:90b:17d1:b0:38e:8300:af51 with SMTP id 98e67ed59e1d1-3966d20b09fmr25374301a91.8.1787822618053;
        Thu, 27 Aug 2026 02:23:38 -0700 (PDT)
Received: from anuj-MacBookPro ([2406:7400:63:4a2f:cca2:d012:36c1:4a36])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3283d884d5esm16830396eec.17.2026.08.27.02.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 02:23:37 -0700 (PDT)
Date: Thu, 27 Aug 2026 14:53:30 +0530
From: Anuj Gupta <anuj1072538@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: handle reconnecting metadir subdirectories
Message-ID: <ux7q7mg7mp32uekxtei4vrunv53opqwthv2er7gk5l2z3ztnok@mp76pxytxzmt>
References: <178780640140.3528187.6786220801490019229.stgit@frogsfrogsfrogs>
 <178780640282.3528187.11511654116002480699.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178780640282.3528187.11511654116002480699.stgit@frogsfrogsfrogs>

> +	error = xfs_dir_createname(tp, dp, name, I_INO(ip), resblks);
> +	if (error)
> +		return error;
> +
> +	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);

should we update dp's mtime/ctime after creating the dirent using
xfs_trans_ichgtime()?

> +		/*
> +		 * subdir didn't give us a dotdot entry, so we just give up
> +		 * and let the repair get marked as failed.
> +		 */
> +		if (old_dotdot == NULLFSINO)
> +			return 0;
> +	}

The comment says "let the repair get marked as failed" but return 0 here
looks like it reports success.
