Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0161E478E42
	for <linux-xfs@vger.kernel.org>; Tue,  5 May 2026 17:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778001145; cv=none; b=gs6cwSrR0/5s7wFJIvneEW4OD5gfQDwxAIKPW6Q/09DOH3LfwYR0Bjzr2xgLqiYkrNEdzr/KrZYKDm9eD0M/tfTFQqrdpi5Ea/vYFtFSGXepTy87tCrgKo7sGFkMzagdP5Ro62IgjOs4X/LVztUIMvRG3rkQG2TR6L8SOZkziJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778001145; c=relaxed/simple;
	bh=BOAMLhGibzY8dU+TYqRAVazmmze2Z+LNTokPHSs/RMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CCvgay7Nbcvt0Dx3kaXyZDhZ746nDoMJW245Lnr+NSbSNh1eyxaECHc9ZlAcrq54yugtV3sfkBoEE2qrqqlglZFINq7CZkljFpoVywM+I2Iq8DElFb9pQkgmY1sGsYVzP3wcQHdy+YMbqtkKPNuNbMFnltuV6u6kF9jY1xdmLQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g0kpIo2q; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SxAwx8Wz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g0kpIo2q";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SxAwx8Wz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778001143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Re8L5VNQ6X7Ul65xsY7zZhFOtn1lHBQxtKJrczxY8jI=;
	b=g0kpIo2qiPSoMe+MLkD96hea87EE/C9Sy7PKQ8osMce1PVv9ui6VwJrNIngQLHtM0usRGR
	9En5Yu3P3jwh0s9Wfdzgb+TYMey6RaZKVm5zl68XI5Ju/SNHpbhXKBU15ZsAqv5TFLaCV6
	EfMj928QWdFlkvzZc4XcuMBVniQoJT4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-438sozZfMguAXQTV3gnqQw-1; Tue, 05 May 2026 13:12:21 -0400
X-MC-Unique: 438sozZfMguAXQTV3gnqQw-1
X-Mimecast-MFC-AGG-ID: 438sozZfMguAXQTV3gnqQw_1778001139
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4836abfc742so48829165e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2026 10:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778001139; x=1778605939; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Re8L5VNQ6X7Ul65xsY7zZhFOtn1lHBQxtKJrczxY8jI=;
        b=SxAwx8WztDie6iu/LLmM59kP0odZbvq0i0sTMJtsfq0txEt/XGlizSLGP6zya8OnKv
         i8EyGMsljY3hoFMxrSdGSnjju643XncmBnO7sKt02DYEXK0ImovRNn5Rxwmiak5aRBBL
         dMqSDaakyrey7bMuMRVJUDUG4nRMkvyp9cfR7akS14cFv/7Ee7sXrN/9vzTmODHODzfm
         fa48upAhrSEwK5731GxaZ//InI5tk6vZk3RiK8D7c4tv7tM9RK/nCqXcrQVfkpfjTVnT
         a9rPSgxgu3birYu+tp5pJr91VS9BWI3ZaUPG+z+Jf9xLWgRanZeeVRIbx5FUZi/YruPo
         hVOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778001139; x=1778605939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Re8L5VNQ6X7Ul65xsY7zZhFOtn1lHBQxtKJrczxY8jI=;
        b=abKcSezEmqoa+NFzc7a3UWiy97WK9RqwMsBHA0ciFZsy1EMHbMWxN58rahveKW60bv
         6ZLHRn79Y5MhDR1YmKEtDkVrhSa+NkN30mm6BFawsgr4ZmmHspzNaAj64YftquYTmzOU
         tkpTbCLHLjLuU4J/wCKw8bj1zT6wcq34WSYn4PXTzUgPvJO1kdyEoVJ+WmezEohypwlu
         dsc0XLUVi/m6ANGYMLgQPHHEE+DNKuuCi1XC+iGwDe8tkrxPQhYSNMwAn8/5mFBLPrTt
         soqwI0KgHifRXiLOF7wcdizWEM1NXGcqw6M8Abp4NyQohmMBS3IgwZQIMgOm38NOQsy9
         8O9Q==
X-Gm-Message-State: AOJu0Yy98Zi6XrctX00uxc0xqORiVNUVlonQRyxFw9GlWBh/PYN49ZVQ
	YkK3MsO+/KzUscQL69d3LBCb/JZ39keaWlSPY9bfoM92AUo3sAHuwiey62XUt1tBdRNGIpVbTyX
	eWI5E/wXCzuziKCmcgk8ZHfJAPi89Sum9TLnJJBqW32n9Zk902fGqPgUB7ew2
X-Gm-Gg: AeBDieukkTcBA23qlGd16KBD3dmvhQ3y12mCHXPL4fOr3KWgXkzF/NqKjGURALcNL/D
	yJ+j5dzUtpDZnNt8mUjVJ88yW+w0BQMj4mi71s0aCA6gs9jC1aLuZA2LfNia+de/IsW9x79h/Uh
	bFUm39ZiynY21QcxtQ5Tuwr0Ve+IcCKl8vjztViez/8vaKsRjQNKU7BtTxuvYMTmaD8Y4aYYdRQ
	6AXzgbdyQYWcJXgFaJq+BLas5YcRrKiw6nThipY47LzzCSXtOpjthnNAbMY34+fpk1npGN0Gcea
	de6zh2uRUitUW+/1kuW+ZTJVxPt2eHNgsKI74CbJB/EUW47ky/JS3IXxIDfHsSSamOwkybuwt0G
	RLrf4aMmOeHds0+LPfOg/3A==
X-Received: by 2002:a05:600c:6dcc:b0:48a:5301:bb5c with SMTP id 5b1f17b1804b1-48e51f2f786mr1281365e9.16.1778001139236;
        Tue, 05 May 2026 10:12:19 -0700 (PDT)
X-Received: by 2002:a05:600c:6dcc:b0:48a:5301:bb5c with SMTP id 5b1f17b1804b1-48e51f2f786mr1280995e9.16.1778001138741;
        Tue, 05 May 2026 10:12:18 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45055960aa2sm5698737f8f.29.2026.05.05.10.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 10:12:18 -0700 (PDT)
Date: Tue, 5 May 2026 19:12:17 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Donald Douwsma <ddouwsma@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsrestore: only process subtrees that are selected
Message-ID: <cz3pjkyt3it3cgopz7rhd6jljo2z7pa4dwsqaxf6e4zwyurkk3@3fibareria4k>
References: <20260326025443.1569874-1-ddouwsma@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326025443.1569874-1-ddouwsma@redhat.com>

On 2026-03-26 13:54:43, Donald Douwsma wrote:
> We are getting reports from the field where xfsrestore is aborting due
> to the failed assertion:
> 
>   # xfsrestore -r -f /tmp/l0.dump -s somedir /mnt/scratch
>   ...
>   # xfsrestore -r -f /tmp/l2.dump /mnt/scratch
>   ...
>   xfsrestore: 8 directories and 7 entries processed
>   xfsrestore: directory post-processing
>   xfsrestore: tree.c:1369: noref_elim_recurse: Assertion `isrealpr' failed.
> 
> This occurs for cumulative restores where the initial restore has used
> the subtree option to limit the trees being restored. If a subsequent
> restore encounters a rename for a node outside of the selected trees it
> aborts when It cannot find the directory to rename.
> 
> Make sure we skip processing for directories outside the selected trees
> when eliminating unreferenced nodes in tree post processing.
> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

