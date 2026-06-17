Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5794071EC
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 10:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781692482; cv=none; b=gndjS7m1znQHh88JbbGgO9qp3ZRJQfpeddmXWV2z2KvPPHrHpro4MrCBIW6sNnPichAlSSVMoTGtUjk1xPqhvwNe9A7x+7l6GUwlzPHUWjVVDc0YmLwmeXzWZh7xKRycgReBr//G34QJtrj+zP+jV+P8cVeFaC+lquxul5QWES4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781692482; c=relaxed/simple;
	bh=9aW1rhkkIbM+Q+KgcsUjwLGzPDXVM//pQ4QgOMLunpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IgoF1B/0zciSgGRHiOwW8/A73LG9HzZhwFNu3z0Mwse2EHw46hr0D381G5WLxqtxeCDIoybliDIuSB96Qex9sqGKVfWjp9HD6m8X+xiczKui5Rhdkc9fUTfdTMjXClP9pPA5NkBv7RiUix0uEqiigVUHpBhhrIFomraR1DBkSww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NU2nirhG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WwkA0+5N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NU2nirhG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WwkA0+5N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781692477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qYQ25JXF2h3u5YJax92+p7fDtQAgPJjHiW8JQ4HKvkA=;
	b=NU2nirhGD9EOIJYsnYI6GRDcT21uRMbgzn8zVSa9k3c0zlwHX8ECr8edpzLvTfQ7BDQubh
	65+FR997exHAA7XUk4+EUN7MH+EittXW9NUfutXyXRNx+udElUai6ONFU+QyKMW8D2TjcP
	QdP1r2GlF1bOv9LojEgygYh575t6fwY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-DGToIMYSOiqwEL6A8qLKkA-1; Wed, 17 Jun 2026 06:34:36 -0400
X-MC-Unique: DGToIMYSOiqwEL6A8qLKkA-1
X-Mimecast-MFC-AGG-ID: DGToIMYSOiqwEL6A8qLKkA_1781692475
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-460129ef947so3837954f8f.1
        for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 03:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1781692475; x=1782297275; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qYQ25JXF2h3u5YJax92+p7fDtQAgPJjHiW8JQ4HKvkA=;
        b=WwkA0+5Nx9RSX8a5jW9koCWwET6ta9tv4vRa3nLRPbJkJ01hy0s/S2TMJJv354IXrn
         kwnJckrN1uHAlvPbAKETMGPyAsa/DgED6JE7sJHI7qsnY89rvYIbODXYoolyxpvOgSAX
         KuHStNLYN4jYDDBv8ixMqW+iOY7S2byGClbSppZ/kyMx+dHLgRgrhou1Nr86g1NEC3FE
         pRHTOxKIMgWro3OE7Te/dbvpjPLoWQ5Sjqh/lqdOn+TrieDnftrn+fbgIUjMtxJ5IdkB
         MFrpXfT/9nGmt7BnLJMaMbdihsXOIXzkzi9iHrCwmz4sRzWeWb5otqCsXhFNEC2YMjEH
         B3nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781692475; x=1782297275;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qYQ25JXF2h3u5YJax92+p7fDtQAgPJjHiW8JQ4HKvkA=;
        b=jEXn3wqCKkD2qHct6W/ZYVu0YbvlF2Z78BRcnaTrZO95C/sAy7fwAnkZKVLOEcPiZc
         ercHKkinXtRQBCKIdlmh5I9cq3k3ihRHcgXfjLuP9jBHsIWQ2Qhfdezgkadh84H8NbZp
         dofIaxmGf/mCq2he6sD5dU7RlVmk0yBRTLasPfh9SahI0NR0O+g3c9iDBxFpOpCGoMV3
         mDiELCNQe9rr7M4wT0lCYjalxFU9GdMhEvVSCkyTkN22xHJlFL3kzlmaZ1JmczIBuVeE
         Zn/xPOmrHLgDn1B+nYHtbE8WXOfFbmIiZR+h3pgj0ZehaCKd84t+kWrhwqj2DoNYTL9j
         FUZg==
X-Forwarded-Encrypted: i=1; AFNElJ9c0UCQFCsScnw0xBCu0KFoQtnz/Tp/X90+27oNiZI5eDsOrCjKyMVHFp9QiZ0zqRWBl8GvlAlF7gQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzo0cDjMD4KjcjWNj2Ih1ZlkWiFJ4O/xguA7ogFhQmnm1nUBYal
	r7zGI+75jzHpYMrrx9KDIEsDnQ9DRa7PpYPn5t7wvxLc3hx+0Gs7j2S4u16KPEu6UhGvf+mgi/W
	FvWg0BdWOVCarlCKYzV9p1asskca000amPBqtu1qeOJJWgYiyBeSxmK408oSR
X-Gm-Gg: Acq92OHaIXbb8GaJ+ojGsj/ykxE60Es4yFrPL/SUYNiW2BboIbnpj9IAVEwWC656Is3
	RG2GtBb+AJHW3FxJBYjmr6C8MdG9gVy76hiAzT3wFAZSxYijdHs4Ier+AVwj9xaX3o+3jj0iT2q
	XtTb/joossGTO+DwmrhRSeETuvWFwN3n6G3AjLUWfFsD2sNXSqp8Y1KM46dsKu9MXd3ysh/JQh1
	qfD7/mxKbcl29fUNts3MolteeE3hsQVmftKTF8Dl3SvBPD4ccz5ad844D+pAv5GJ+v18dJ5n93G
	IoFxSDxzN3D9ySa/gBWYwGt5A79BwAe7HWeDJHmGV3owcrjDU1A5WXV22qRXOA2fB8b/9Zq9fU+
	aQ8xgGmbo6weEwp34BEMz15iCcsdjwocwjHON9EQXpCjz1Q==
X-Received: by 2002:a05:600c:8189:b0:490:b355:9c70 with SMTP id 5b1f17b1804b1-492333aaa9emr53396635e9.11.1781692474631;
        Wed, 17 Jun 2026 03:34:34 -0700 (PDT)
X-Received: by 2002:a05:600c:8189:b0:490:b355:9c70 with SMTP id 5b1f17b1804b1-492333aaa9emr53395995e9.11.1781692474079;
        Wed, 17 Jun 2026 03:34:34 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492368602a6sm3752565e9.0.2026.06.17.03.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 03:34:33 -0700 (PDT)
Date: Wed, 17 Jun 2026 12:34:33 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs_healer_start: check listmount when doing a
 --check
Message-ID: <ajJ4KyLDOyhvHa9s@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
 <178118661298.728615.3080573416824854151.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178118661298.728615.3080573416824854151.stgit@frogsfrogsfrogs>

On 2026-06-11 07:05:37, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex noticed that xfs_healer_start doesn't try out listmount() when
> it's doing a --check.  Because systemd uses --check for an
> ExecCondition, if it's run on a pre-6.9 kernel (very unlikely) then the
> service will fail instead of simply not being run.  Fix that.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

