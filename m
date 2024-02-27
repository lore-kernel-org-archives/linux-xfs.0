Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545271947E
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 04:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709008117; cv=none; b=rmRAUoKmrKk7ipHHGjhlfp17nEySbVfa4oIInNmW7Dr1ax7SRBGHnhY6RCeusRQbmABL4m46CmjzjXtTKwhhBS8tJXdNIzT2qimEpKPz+yojS5sgYK7h0g/anv0Hhb6zzPWu8G5K5eXbMxZE5R2x2ecE7apQayra4dEQdnb7Igg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709008117; c=relaxed/simple;
	bh=3cg/MjJAV8rejg55H/2nCxPE719hq9lT8aJnFP2wthM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hOQrnigS/22qM37sr8mGMmnZg++VrbmSEeUaPH81LL/D+H1K27hIbW01Swef+Dr7qdnYvcFuXsQIkH9bGqcl99z/XIMAcc4hDuYm9zXxdnig1i0Wob29l26e30W29ai1iZzjiiuqwa4q0xesCevozGuW7+CdzOOfuahlvF63BMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZkIIYbfe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZkIIYbfe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709008115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n27fA5JcdPwsR5o8IRM4smQtVIbRrKZHJ809a2eXsFA=;
	b=ZkIIYbfe+mAnECIdUIDM3F3u9c3kwENtx8o8Jc342W6LD4Dqe5dvje/1l49JHEz30ki9HD
	fKzamOPM24wJnIEp3CxWEykre6rD3i//Opwt7+Vx7phVXOU9dztmWr7RG0BWQ52KEEL9Ey
	LVoDgadd5JkUUGo2T0mNnQULb3YPpxU=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-gNcd2XVaP_KpuU0T9DR3hQ-1; Mon, 26 Feb 2024 23:28:33 -0500
X-MC-Unique: gNcd2XVaP_KpuU0T9DR3hQ-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1dbe41ad98cso38615445ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 20:28:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709008112; x=1709612912;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n27fA5JcdPwsR5o8IRM4smQtVIbRrKZHJ809a2eXsFA=;
        b=c+jbbMmHqOnWV+l+2OL0H8s5hrjC9ZuZ2I0WKXtDNgZ21sIs1buhQS1O4eWQriCcNA
         zrOCn0DVV5Tp8wM5zNXQbwy30MWblps62hX6mCHh5CuFIe+EbnU0v2UDuAQvmUyEiSKy
         y7FpxrOCh1qr7sACx5jYtPfW4P4dXUIAD4TZjV4hJi/cFDJOQCoUD2e5yte8OHrf+BfU
         6nfWYg4ezYVXBY6vzSdrKHY98fujxwPpOIfBBmyW+uSBCyKPEKY3XHqHVmfaMCmA1F1Q
         gJHfPM59SEt8tRAOA6qQ7y1CqKGgB2ZukeF3xUD4VsHKDZGpPjy0NazcD4MWS1NFJt0p
         SWEw==
X-Gm-Message-State: AOJu0YyTy8qXoX5yiKL2J5xWl5tvg3zV1lQacs3EX9NIVk40ALbzvgqo
	UNWlyHAaNAATNp/fW7Ucj2bcSbt5Ild2R/azDBKKZoD5M6UPe1k8Y8qWWynvOPxvcJLEAJAsMha
	tJLCmDAS+6gBVvTxBEY2Z/aUFeM33rrSchLjgYQRQ89JRcjQ20z39ekxMM9h/Vty+KvEt
X-Received: by 2002:a17:902:cec8:b0:1d7:4353:aba5 with SMTP id d8-20020a170902cec800b001d74353aba5mr10285638plg.58.1709008112420;
        Mon, 26 Feb 2024 20:28:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEE3IjGec5q46Sse2FcWfKJwxUeQ03hyJqmYNnMV3TDTPXL7DpATP/5Xyb0Pz6u0OG8r2KN+w==
X-Received: by 2002:a17:902:cec8:b0:1d7:4353:aba5 with SMTP id d8-20020a170902cec800b001d74353aba5mr10285631plg.58.1709008112107;
        Mon, 26 Feb 2024 20:28:32 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ix14-20020a170902f80e00b001dc23e877c1sm482609plb.265.2024.02.26.20.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 20:28:31 -0800 (PST)
Date: Tue, 27 Feb 2024 12:28:28 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/8] generic/491: increase test timeout
Message-ID: <20240227042828.7jx4bvzw2bdcak3c@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915276.896550.7065004814140508980.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170899915276.896550.7065004814140508980.stgit@frogsfrogsfrogs>

On Mon, Feb 26, 2024 at 06:01:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Bump the read timeout in this test to a few seconds just in case it
> actually takes the IO system more than a second to retrieve the data
> (e.g. cloud storage network lag).
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/generic/491 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/tests/generic/491 b/tests/generic/491
> index 797b08d506..5a586c122a 100755
> --- a/tests/generic/491
> +++ b/tests/generic/491
> @@ -44,7 +44,7 @@ xfs_freeze -f $SCRATCH_MNT
>  
>  # Read file while filesystem is frozen should succeed
>  # without blocking
> -$TIMEOUT_PROG -s KILL 1s cat $testfile
> +$TIMEOUT_PROG -s KILL 5s cat $testfile
>  
>  xfs_freeze -u $SCRATCH_MNT
>  
> 

