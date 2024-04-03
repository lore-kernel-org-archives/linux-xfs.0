Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7660C4D9FA
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 06:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712125023; cv=none; b=ZAzb/y77aBCrharsSs+KSnHU0gnUiUzaNCRWLmvc6bjAmNYkWh1gkqTg56BJU1tdhMP/dnz9eObhCztzzrC9k6VZUu1eWiQ2tpRhnJnj5qbjQRqIJ3iDgMn+fonW+fFl3UmizVVbjYF+jm28FeCYzKzLOknTpRACgwbbvTKcoOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712125023; c=relaxed/simple;
	bh=48EKo3Hq+tB6u3r0kAcD0hBjJgJWltGlopzGVOKXPgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=febX/4gx9NR7HstBif9p1nbVCi6h7X4Kj9fvKCBhRqpSKYNm9AAYBOL//ZPdisZOAkY8dWfg9xdgknFYObvSIGUUBt6JQSJu2eY23U9mnUTiyAkqpWbnzjXo32n03CiZuxiKM2zZ2q02zrF2RLEd42X5UdKre9g6iTPq5HTKPzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=s7gjkD9B; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="s7gjkD9B"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5e42b4bbfa4so3668825a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 23:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712125022; x=1712729822; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fL64+b44d/VAoBF2nvuCcW40ktzUeE8Q34AOh4RYKW4=;
        b=s7gjkD9BrGtNPtanmiEkZJysO5wiQnx1iUqMGupf0QZ/4YswLxmSVFV+LkCvCC4Rdq
         aH94zaUwb+NLGFy5gslaWMu6EIzbCYguoOspsv3+eJr6U/gbRh7TdOqbQb6zVQwscWY8
         k/NnDg+rh3nNYNB/t+FkWfVA9Y2li1OvnjFq1n8BLybkDhIXIZsxaodE1Xuks/KFzTx2
         zYjSm0rj2lq2KowFydOriTKpaNYl85eokWVSVS4FhfrQEj1mzGX+WCWGgVpWCMYs5LYi
         ZZqpvFg7hyKJPlcHYmQ+KbLVFLSZONW7W8TjUsu4YFgHnXyjXbO9m6pqYZGzP+v116kN
         gz/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712125022; x=1712729822;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fL64+b44d/VAoBF2nvuCcW40ktzUeE8Q34AOh4RYKW4=;
        b=tXjUJvxWw1CvqI9WSexF19RcztnytCgJNLsuA9craCe18BdDrgoN+xwb9zBBwp6TwD
         m4//lgFL9qLrw8o5ZO0uRsUSVbijYTk4HH9I3+9b0d/eVUbq7iNeQStINKLHRovEB/CY
         pI6Q/oGrbgYXldbLdUOpwrpaARZuKlheJGzGM9hV6Rdetyu4DJKOPIWTEzLAxBBCnEvW
         vjhV9KeKou6Tl+a4AuRFBzp/RpWKf1Iha8WcAeNGrFmnQOqKQq2xl82PpB6+rPLORXk/
         eD+KyeLKrEWjhDk7hAulr6i/dy8bG5j7a0oBiIV4hkeKocG0DCqVX0uFeeVhnGIudHqT
         rcAQ==
X-Gm-Message-State: AOJu0YxncPRLvmXf6nHV1yAXiEVmKoN95zzatI7b/BmZi52x/d8z5t2+
	L7H6RFQVmiu8uMrA9lxqJbZ1edo9eYP7DyNTpdjydXwjcWa17A1jbBlj5m9L3Gs=
X-Google-Smtp-Source: AGHT+IHc82Q+9cpDfCLuk09ONtItcRAs1fY32pxQFVJZyOiJZQ1T5nLeEjyDHF4HJiMJqafvGhRp5Q==
X-Received: by 2002:a05:6a20:3c94:b0:1a3:558f:13e9 with SMTP id b20-20020a056a203c9400b001a3558f13e9mr2354048pzj.19.1712125021615;
        Tue, 02 Apr 2024 23:17:01 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id t4-20020a170902e84400b001d8be6d1ec4sm12288962plg.39.2024.04.02.23.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 23:17:01 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rrtve-002DMv-2p;
	Wed, 03 Apr 2024 17:16:58 +1100
Date: Wed, 3 Apr 2024 17:16:58 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH 1/4] xfs: use kvmalloc for xattr buffers
Message-ID: <Zgz0WroNAbTDEpFu@dread.disaster.area>
References: <20240402221127.1200501-1-david@fromorbit.com>
 <20240402221127.1200501-2-david@fromorbit.com>
 <Zgzdk8GhHXGJpN5o@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zgzdk8GhHXGJpN5o@infradead.org>

On Tue, Apr 02, 2024 at 09:39:47PM -0700, Christoph Hellwig wrote:
> On Wed, Apr 03, 2024 at 08:38:16AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Pankaj Raghav reported that when filesystem block size is larger
> > than page size, the xattr code can use kmalloc() for high order
> > allocations. This triggers a useless warning in the allocator as it
> > is a __GFP_NOFAIL allocation here:
> 
> Can we just get the warning fixed in the MM code?

I'd love that, but until the MM developers actually agree to
supporting __GFP_NOFAIL as normal, guaranteed allocation policy this
isn't going to change. I don't want to hold up the LBS support work
by gating it on mm policy changes....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
