Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB893B7773
	for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 12:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774440229; cv=none; b=Z3jV7W7KzJGLwJzdGmlWh3JP5EdzJV51O1gGdtx3RQ6/fyCjn37wS5VDtca7Aw37r+E35H1pPuk23Vp2cssqbharSFbDuhIvIKjMUUNX637HIamt3uhYKnkYg2vWag6jq4y5Jv/T+HRf//fko+JbDKY+eH9Xv2aGdMEM3oHLKYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774440229; c=relaxed/simple;
	bh=Es77No52KNJFPGo5T/ww8er3pjI2J58fF+DFC1d5WKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tpcByFn73xDoWz9EG+lRJY96go+0ibgPRFq0aa7073sF3Zq2A2CucQz0rxDCgRHkF2QjYEjdOhJ6z7JwNqXK9JwylxNlqiSsPhJmX9itMWPTdZjbQahhy3VALQboZIsVw1PzKucSwlJHoBoAolwyTDJEvhZd0ipUBSCJ6CkuzkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QVodV/EF; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UPY85kNK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QVodV/EF";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UPY85kNK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774440226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hHtDuEkZI5nETEV2K61pi5NwMLau14IczzFE7YDeBkk=;
	b=QVodV/EFlrt9bkI90fr4RKH4TIwfE+ntRGB2n9Joedx5YpIzaMArOZPk5eGgPt4XNnObcW
	/AzgBWD5WKUDLp4lSNIJKTeSbwh0dOC/4HYf+UJMgjlyx+gwEkmMWqSIu2yXVyS9MRkX9F
	fCiVzJOIwYqQvmA9znJthL2+dZzLkFg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-kYbmzJZMOieHlp8aEbedGA-1; Wed, 25 Mar 2026 08:03:45 -0400
X-MC-Unique: kYbmzJZMOieHlp8aEbedGA-1
X-Mimecast-MFC-AGG-ID: kYbmzJZMOieHlp8aEbedGA_1774440224
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b97d773ea61so197833666b.2
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 05:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774440224; x=1775045024; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hHtDuEkZI5nETEV2K61pi5NwMLau14IczzFE7YDeBkk=;
        b=UPY85kNKISxwUNJaz9fXarSB972DdMWQEnPwXztyKjQ1HH0D4sH480T4KKq+SRtwqw
         qoDk5VVHoj8UJRdfYHT+TSAGYmwpXcqixbOJ5DZ1+ZEXPYuB/1f98YTobC54Tii++3jy
         HxCfodC7sj6qShUYp+Kq1WE0MrlY86OVZ3ykJVqmh/RW3xSNrZULAimQeTWEUr9A0zSH
         JHeE7mJyO+Gw7nIQrr7Ar1lVXExGDPj+gGjrUFzx39Poi+yGoB+RrKKrNK4ASwlVc/I7
         smzeTJT8Z53psmWcQz1HHHHwTezoKmWuuKl9FgjZy3Y8+Jgvyd9JgxG7XpBA20gSRe3f
         QW/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774440224; x=1775045024;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hHtDuEkZI5nETEV2K61pi5NwMLau14IczzFE7YDeBkk=;
        b=Qx0TbugFKvOMBfLteLX+9PDzBSj/KkdkmiMyVEIY30qcqBxU9Eu8X5Ph4G9qFE5TUu
         sqX74sKDSPu8v0Eyf9EwF/qTyETm7XN+oSSqeCobFCBCq0cDtpHtfqVEzWIGHFhB3IOm
         5r7xC4CEdoT7pdGtz2/z5IClTv01ePSMbLqQbxvBD1Fk2tssY4pTOVv0cV3zhjRLD7Fy
         PTuOA0dnr59GjlINDiM34jthklh8KT6UM+TTocPDRR1yK+ppGv+zJBtq67dSAeisahPN
         w9s4J2rrXgvGVhx4t06rm26qri1T4yLhaEC/D6ecgRYrRt0c212T41i6u7+FR87BPIT2
         P3SQ==
X-Forwarded-Encrypted: i=1; AJvYcCVanxhJ2B/aAvrpsD6ZKIYHKK+0msOTDIHXqPHsreo2tWQwG8Kf3kFFzHBehSFg5KySX1g53DAPdX0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzolaOsNcQPj6D6WffyCiDUx8/K7rybj4VTY5Rg/pKEfP/74YHe
	SXcsa3TJrjeDHEyQUK92TJi66K7gLQN/2RiKTiWSRfNKLrwAk75NTKEDHxdT4AMImZDAUaOgEWw
	MWhnwzF3d+e7CKdWTxvXCd3XfjewRVfytBx8hIQJ6RHLRo5RlDyB4HWoY4nmz
X-Gm-Gg: ATEYQzyyFMFFPl/4qNHskhmqWYZ4pUzrJrZco9mqXoOyC7rJ6AYSj910KpXu36D373H
	xyeNHPA6Dw5yHJnloYOmyGntB2suUA64sjQWt+UhBnlq8QxOAqaK0tmAc0H7VbaFdfcch/+Y8Nh
	DSdCQZhQ3Pf6ue3261+/EeOkV49j6A3FE0kKjDHdfQ0ZNKBrD5KVpYP7mjaoiOXHPZO53P3w5Ig
	lPRD4oYv8AW4aR6l1tnU5tZX+A1bYal6ZyTF7Gbw3PBVbwfbZpe6YKRhvlSLF5WPYF34j3gsQwY
	FQswZAl6uY5RMAIZqhRmC1Pk2/7R2prcUmIqSSaZSMkx0S2bKIL6gagOQ8xmy+UStVW+DhWgeO3
	PALuznDtKovUTMA==
X-Received: by 2002:a17:907:3ea5:b0:b96:ff4f:11ea with SMTP id a640c23a62f3a-b9a542834b3mr225195466b.41.1774440224207;
        Wed, 25 Mar 2026 05:03:44 -0700 (PDT)
X-Received: by 2002:a17:907:3ea5:b0:b96:ff4f:11ea with SMTP id a640c23a62f3a-b9a542834b3mr225190866b.41.1774440223277;
        Wed, 25 Mar 2026 05:03:43 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b983365a159sm760453666b.44.2026.03.25.05.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 05:03:42 -0700 (PDT)
Date: Wed, 25 Mar 2026 13:03:40 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v5 03/25] fsverity: generate and store zero-block hash
Message-ID: <vatqzcvepp7z6iotzayuyh7fajwdqs76pn4o3sdn3f5thiwsjc@dt46ylrbjnkp>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
 <20260319170231.1455553-4-aalbersh@kernel.org>
 <20260325075700.GC952@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325075700.GC952@lst.de>

On 2026-03-25 08:57:00, Christoph Hellwig wrote:
> Shouldn't we still try to get this out of the fsverity_info first?

I don't really understand why, this hash depends on salt (inode
specific) and merkle tree block size (also inode specific).

-- 
- Andrey

