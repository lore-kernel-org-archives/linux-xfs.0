Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEA256B7D
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 21:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HJX6xxE4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705007829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ridr0ybuTqtA9azn6VD/mrq54bMt03k+kb/KRYVYM7g=;
	b=HJX6xxE4Z62y0sxpC6PrftY2b0DXylSpSbLfgEUriUZLZexLKdGACpKODAzy7yUaSNlVja
	lJndX5oyLEqQ3giFTsC7sg50xmaxNy3l1r8wkF9T1rdyUempGgQjg/LmEot4w5iEaoz2I+
	xCZ9sdph8UlflX6CwYcU7++P0AZGi7Y=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-mLYKWw31OdKcc0G5Lnvbcg-1; Thu, 11 Jan 2024 16:17:07 -0500
X-MC-Unique: mLYKWw31OdKcc0G5Lnvbcg-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5cf2714e392so1434404a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 13:17:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705007826; x=1705612626;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ridr0ybuTqtA9azn6VD/mrq54bMt03k+kb/KRYVYM7g=;
        b=j4c3MBMdbn3AuoGUNTZBsrr5SjkQ+ynW3AQY3fsUlAJnSZGu8pyhU6/z/0myqOJFY5
         6faPt3dT76qqDhtWxclSFcxyUUZgI3/TfuiA/HJb5sltoXYOeXisjVuQOlqfYudsACzp
         9Vj7fRWKbxpUepxuR/zS2Aw9y0Yyb1/g40uukdn2fHUjtXIbAX+eTpUI5eKNlQzskEe/
         02dRwxkFMf5FIcsMfZVn+cIhdKkBuQgftf/X20ka0U0gP+KM1wxHaW9JsCnGibz7lsPb
         xDzCRYQVFn1tyIdDp8oRxgqW2WGiOSg6x9WEIeqIwsBFmBY9F5s3asm6OOW0Ndap4cmh
         tr7A==
X-Gm-Message-State: AOJu0YznRcigyouRSN5Ney6WdMcJYcd3L+yZs/zn7HQ9pnubIkOAxT2t
	NA8aPKzxzCpTw/26eJjT+wzx6x2pc9OZL6VhIhKKp4JNh65BHkjx3gY3hlu1k5dH0aHxlaBiB2y
	JpWt0bWmvSlskJ5OP3O45rby5hVvj
X-Received: by 2002:a05:6a20:da84:b0:19a:5257:9828 with SMTP id iy4-20020a056a20da8400b0019a52579828mr674051pzb.22.1705007826606;
        Thu, 11 Jan 2024 13:17:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHPFfSygW1gHzAgtb3mvGZ0NfDuM/5mo+7IQXyjViC6trvyNk/vEZ2LcWJxPpYU3LGDPK3xfw==
X-Received: by 2002:a05:6a20:da84:b0:19a:5257:9828 with SMTP id iy4-20020a056a20da8400b0019a52579828mr674039pzb.22.1705007826274;
        Thu, 11 Jan 2024 13:17:06 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c23-20020aa78817000000b006d095553f2asm1650966pfo.81.2024.01.11.13.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jan 2024 13:17:05 -0800 (PST)
Date: Fri, 12 Jan 2024 05:17:02 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: check that the mountpoint is actually mounted
 in _supports_xfs_scrub
Message-ID: <20240111211702.baimcixgpuhoqbib@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240111142407.2163578-1-hch@lst.de>
 <20240111142407.2163578-2-hch@lst.de>
 <20240111172022.GO723010@frogsfrogsfrogs>
 <20240111172556.GB22255@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240111172556.GB22255@lst.de>

On Thu, Jan 11, 2024 at 06:25:56PM +0100, Christoph Hellwig wrote:
> On Thu, Jan 11, 2024 at 09:20:22AM -0800, Darrick J. Wong wrote:
> > > +	mountpoint $mountpoint >/dev/null || echo "$mountpoint is not mounted"
> > 
> > The helper needs to return nonzero on failure, e.g.
> > 
> > 	if ! mountpoint -q $mountpoint; then
> > 		echo "$mountpoint is not mounted"
> > 		return 1
> > 	fi
> 
> No, it doesn't..  I actually did exactly that first, but that causes the
> test to be _notrun instead of reporting the error and thus telling the
> author that they usage of this helper is wrong.

So below "usage" message won't be gotten either, if a _notrun be called
after this helper return 1 .

        if [ -z "$device" ] || [ -z "$mountpoint" ]; then
                echo "Usage: _supports_xfs_scrub mountpoint device"
                return 1
        fi

If there's not _notrun after that, the message will be gotten I think.
So I think the "return 1" makes sense.

What do both of you think ?

Thanks,
Zorro

> 

