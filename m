Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D39514AD23
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 16:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712074594; cv=none; b=QIwnGVx6vQU15POgFvFxS+SD//2WMkp1KBGIpXeKfab6dUFw+D1VlpJf2gFUmbPkTJJ+wS/9GouZ7Gjv8AM4svond80OoQKSm7B0UjvHlg/UU6dYdv1ukUx8bSedSGpJGHWj0xZyr61qStNN1HhpoPKVP2jYsnWPbY9xddjIc9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712074594; c=relaxed/simple;
	bh=OxlWVdxTEdD893sBNtktZlp9W+CSobIQEK3xYRBJ0BU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=daQ0aAXakxTsONrJ8BQs2IhuVbGgFvxzanat7R902CQH9aXRcKdA/Cv0Fo+5wetMIxSChTmVVjQVxsPYb49sdw0kgVyKe9MeWKo8NRj3kOvbZHAkppxO+6GzBWDfq+7tWDaJdHNRtHEd2Rde+QvGgi4itXGKUMyRQcpKwFuVLc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OAsgHno/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OAsgHno/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712074592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=poSTIC0rG2YkQpDe1N+vUApeRhMh2mNxpVONRYNd57c=;
	b=OAsgHno/57qgdWobmbufg6Hp2v5+bqwsb4xHGQuztuh5ziIVJtfLxTADPuazD1B+DPi0Lm
	gFno548oHQh3ivvY6DpFzEnC91HC5KDaQ5QgyOqqjV6+6YB0jF8hHR3VfjdINJx5fqAFBD
	8IHXqMEIfz/FK4/6EXyhDV9Ge+oK144=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-414-hBBmtN-TN166O9USsaBgSw-1; Tue, 02 Apr 2024 12:16:30 -0400
X-MC-Unique: hBBmtN-TN166O9USsaBgSw-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a4488afb812so333199266b.3
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 09:16:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712074589; x=1712679389;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=poSTIC0rG2YkQpDe1N+vUApeRhMh2mNxpVONRYNd57c=;
        b=cFwQvQnY48B3lVMXlGRpqSSpT08srESpFUpfIkc+MfGS6FANjjLmBYU2sRypvE8vHe
         oCpHVACLyYRS3SWljp35hb72IxMJeR2PyvJAsF5OfkytcaPzeNWHWM6ASxldn1llfKpW
         pU7WEBvztXwy7tP9GruL8WW/0fp3D54oz+6GLQI8xOlCEZBghp4Y0EU2bUTntEr3tQEp
         42GHh7EAtYqSxD319pS3Lk5VEXs2UM8mjToTXGKQZ+8Dags4EnwsgvWlNdDmYdw2hxko
         x/BAFApkotIEV+TQ0zHymQYt3gI/LtcX3q5cJdwUGn15tGfbqjOOLE/8Y1KPgpyQhjRc
         uGbw==
X-Forwarded-Encrypted: i=1; AJvYcCUx8JYmZWaaORm0B6SbsyEFKH1aWdt+uCXlbUtUBizX70yLtpRpGT31W5a4sSk/KXJKJcCzX1gCaIGMp2zzMoNV5+IoC25hJjss
X-Gm-Message-State: AOJu0Yw68Ii70yv/MJJ8CTB1AnJtr9uMzsntWrbpu1i29i2Zn1fZAn7l
	jl1dvTiJZyUbkf6gVrLFPivgIO9Z3KwAdx/UMl8tdFedhOkOw2zbocJmiv5bRYQVblJscsySDdz
	qYukchUO9QTFJmuKqJj7xz2otEuJCB+KxQKFegNcFseC7vuzm+KZm+we1
X-Received: by 2002:a17:906:2b5b:b0:a4e:60c0:6a98 with SMTP id b27-20020a1709062b5b00b00a4e60c06a98mr156981ejg.55.1712074589258;
        Tue, 02 Apr 2024 09:16:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF05AJXgDG172NMmyUH7ahWdx/rKSi/SG4rJfk01sHORjq/CrxsWQtDEe/ffiuLuuhSZJWGTw==
X-Received: by 2002:a17:906:2b5b:b0:a4e:60c0:6a98 with SMTP id b27-20020a1709062b5b00b00a4e60c06a98mr156961ejg.55.1712074588781;
        Tue, 02 Apr 2024 09:16:28 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id la1-20020a170907780100b00a4e8e080869sm774247ejc.176.2024.04.02.09.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 09:16:28 -0700 (PDT)
Date: Tue, 2 Apr 2024 18:16:27 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fsverity@lists.linux.dev
Subject: Re: [PATCH 25/29] xfs: report verity failures through the health
 system
Message-ID: <ruqr5tdxmmnwdb2kd6t4jsxzdtrurwiyovoguv4nf5suxfpx5s@ypic544cgqt7>
References: <171175868489.1988170.9803938936906955260.stgit@frogsfrogsfrogs>
 <171175868973.1988170.8154641065699724886.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171175868973.1988170.8154641065699724886.stgit@frogsfrogsfrogs>

On 2024-03-29 17:42:35, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Record verity failures and report them through the health system.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_fs.h     |    1 +
>  fs/xfs/libxfs/xfs_health.h |    4 +++-
>  fs/xfs/xfs_fsverity.c      |   11 +++++++++++
>  fs/xfs/xfs_health.c        |    1 +
>  4 files changed, 16 insertions(+), 1 deletion(-)
> 
> 

Looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

