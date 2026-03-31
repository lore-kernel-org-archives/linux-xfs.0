Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAB54508E4
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 20:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774989593; cv=none; b=pnCh9snHG78wrJMRHK5YsIU7zPBqNxp56YwfGpvN2h/LFdH3wnGQV1num71z/23yFITk/LbBHhrrf6K8B9aUqsUy9ySZclzVzTLtTOA2F//qkW8v1QXBDPujf0cFQOoQjByIbyIox9cX7DHc+xrGCfmR39nVdM/VdqtiIuIYgCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774989593; c=relaxed/simple;
	bh=nKN5Q3bE47gLyVVSOtIOoSNhzjmrP/qfvzrVJtwlBEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DOtMMs5gL7XyqmqQw+x4njI6OqIyX9R2thLffa2AjyUifO4ic7c1+NMtrw2dMHFtnZS1253SaxxuAoZXhpt2k4appj4OEDa7DMqjxfXo/Kn/11F1oU6h0A4kl6o43CfeaIbfurlEKAVYMzg/2B0nXHb6gtJUOx0cS7OQmxmooUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ML8G5jVw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dHSJTNrP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ML8G5jVw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dHSJTNrP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774989591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xQCRyPp24y6G+kaXtWDfiexu44t7AhdGV8RncQdBurs=;
	b=ML8G5jVw1Ixu2q+VKmYRo3RGaqulejM739CyUzdv4IS2q/g57Xt4aqttx3GAYkP6CeexGS
	STLAdSF0UbSqV14G7vPwD647Dmasz9hwEoeQiDhAZOr2xGRR2R3drUzmCyF1+8n1dljl4k
	mKJZthtnUO05I3hMsIb8MUakDNvNpJg=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-n0cXvFekMB6fixn9pVnV5g-1; Tue, 31 Mar 2026 16:39:50 -0400
X-MC-Unique: n0cXvFekMB6fixn9pVnV5g-1
X-Mimecast-MFC-AGG-ID: n0cXvFekMB6fixn9pVnV5g_1774989589
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b62da7602a0so3659028a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 13:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774989589; x=1775594389; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xQCRyPp24y6G+kaXtWDfiexu44t7AhdGV8RncQdBurs=;
        b=dHSJTNrPOUdWfZZ92G4lc2hiSOsDs79decsqzin4GR/Je6D0iTjs1R9i9lr2u0IbZW
         ZZRvyje8oVwu8xp5r+KQlRRrmv4pjo0Ck7wuJKTzGcFU6JB1DNzhSMztY+vXKMuTAzP6
         gEgzR8nXfbKh9eqHt+s8xuC4H3YPoe52Tvrt8Y2jqYgFRCj62LUldKktubLyUMtkHOOB
         VFRNLkFynIIuUvjlU6YAC1atK7BTloHVIovoVFREC10lJ37sxeo9XKPapRXgxbLnWckf
         1FEerDjeBIV2DxXMpbiol/UWqDzsM4ZohlUMelQWo9GcToULKezd53JUWy8jca25YkFt
         cyug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774989589; x=1775594389;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xQCRyPp24y6G+kaXtWDfiexu44t7AhdGV8RncQdBurs=;
        b=gaohsAHidVL+vfsVABC6q+cC27SsZMFwWbKfvKXCzwzFswe2vbILY1GUPeaMFjpHpl
         dwWM8VEZpDInnxS0EDkiwU8mioQ6CorOYVYaGc2K02aW9KIHb2Fp6uXupYpzaMSE/ScB
         K9BYHJvlNQPEJ1uLGLrgc8+FQ/2yMxADKu/PyNriqY3R24Tbq/iF/ArvCpr39FMYKvp6
         oNs6fy5lvADy//OO+M8ojW6sdkauPbTPP0OGWlnj/qeE9k8Ho7tdd3OGQSA2g8cIyjwW
         vpg3/Ua/dKgPCw7l8n/Aa99hfLWmVCKnHmtbyEHjyxWe8TsDLqh5LvwcGiMEcvIO5/2/
         D7fg==
X-Forwarded-Encrypted: i=1; AJvYcCXFRI/uRxiC8ySYxxUngkohqBE3OCosD6sUSyT+/vzKn0/WLB6Gfy1XjfhCzOgHjYQFPRDCBJSD9sU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyqo+aZoGYlKm5kcZ1/IpdvEf6yHALjH3ZXnyAotx8je2uC1kt5
	gvJWY5jAV6iIQrOs3O1Jry8So4U2X+06hSZZBqTJv81Vgu0j/B2Yd0Mw2QGEOBZW8yYVJ+qkjJl
	Dk0FyY0CkWZ84d01ygXPkncS6cUJkgCkAU5k+8GcLfq4ZS8kbq+NzLB/heVtJdA==
X-Gm-Gg: ATEYQzzSUcS7hKV/wgGzDtbtucoEpSBWQc/woTZCnBKxqOMGrdV/0eDPdz/Z1SKc2sc
	jspGIjxjRAuog33XEfGOcUXciwk64w13kD6inKBUs1m2xUO4GDELmPfFvMlGRtK127laH+xFUKj
	21gvOIDVag7vtxgFlduPG1QDeihueDp1B4JjoGZtfGg4xI62po1K3rTwG427U3IyL++yQdSD5qj
	juJibv5uznj08cAWCPV52i1G6I3fLnLIhNvwlwtKYlOhFh+F0y8LRDwMYd0j4l/m+3tyZ3HUJug
	w/rtFsf0nNukAj8nWqZCiJZShqcY5air5+xk8zsoR5b6dk9OAGF7meYuGNe42h+dh21pxzC3XxR
	gsMf0YgVB09nbemqrMQ==
X-Received: by 2002:a05:6a20:918c:b0:39b:e837:5565 with SMTP id adf61e73a8af0-39ef75347d3mr691495637.28.1774989588942;
        Tue, 31 Mar 2026 13:39:48 -0700 (PDT)
X-Received: by 2002:a05:6a20:918c:b0:39b:e837:5565 with SMTP id adf61e73a8af0-39ef75347d3mr691461637.28.1774989588320;
        Tue, 31 Mar 2026 13:39:48 -0700 (PDT)
Received: from doltdoltdolt ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76916ba75esm9506628a12.6.2026.03.31.13.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 13:39:47 -0700 (PDT)
Date: Wed, 1 Apr 2026 04:39:42 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, zlang@kernel.org,
	fstests@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: test that zone_gc_low_space writes start gc
 for rw fses
Message-ID: <20260331203942.jvlahulg7x3zkjd6@doltdoltdolt>
References: <20260327123429.39330-1-hans.holmberg@wdc.com>
 <20260327123429.39330-3-hans.holmberg@wdc.com>
 <20260330053421.GC4876@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330053421.GC4876@lst.de>

On Mon, Mar 30, 2026 at 07:34:21AM +0200, Christoph Hellwig wrote:
> On Fri, Mar 27, 2026 at 01:34:29PM +0100, Hans Holmberg wrote:
> > Test that writes to the sysfs attribute zone_gc_low_space triggers
> > garbage collection for rw (but not ro) file systems.
> 
> .. and add common helpers for that.  I tend to split the helpers out
> into separate commit, but I'm not sure if Zorro cares all that much
> about it.

If a new case brings in a new helper, it doesn't matter to me if we separate
the helper into a standalone patch or just bundle it with the new case.
But if introduce a series of helpers, it makes more sense to split them out.

For this patch, I won't treat the "splitting" as a blocker. If the author
isn't keen on sending another patchset, I'm fine with the current version :)

Thanks,
Zorro

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> 

