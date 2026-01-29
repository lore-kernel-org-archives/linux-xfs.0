Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2995C343D64
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 08:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769675271; cv=none; b=Zaj9AzNNAyGlrazTDAy4KJGUfg/ZmC8Kb3CqF1Px/irOCQEKOtXbHEWe/xU+qJSJaH/TPsYW2hyjYsL9d7MJTvB/72leyYIKElOnuSGnnotGVOzz7rL1Iqyv4Laq/1Ggi4vXrhTpM3BDi0yl3ON3Je+MKHQMJWbnVUPq3ItWR80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769675271; c=relaxed/simple;
	bh=oYrclBYwcLx07m86mPb+3u29j0/qpp5jiFq0BK4UWbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nz1w4RzHz74A+PmNC6St2wjjn6MwHSLgbMj3yguS0RFgG6vjq30ZUiKbRmj+FxIpAIluXYs6zCZ9w9yN1qkOxQ7DdmbTGybz6TlAmz/YEXM3UweiwOxX8j4KhRX+0q03/m9yjEeWnxOxVPgQfLxHbai3VqRNO5EXTMyKdhip9Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gM+5y3y+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ePmD6F9h; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gM+5y3y+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ePmD6F9h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769675266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z0YJmi1OAzukodfKJUTAQSnkLXHvbAKMCq1LzZsrBYA=;
	b=gM+5y3y+5SIkZVc1ueUacvgFjn03mGjXRTf0U0dvVNSFzc3b6afiJfGDxeaVKkbEjhjm8P
	E27g19COCbrmbeeXbIGhTmWDKdA1p19HOEKF5BtZa0aiG0m8G/u8YNgnjoe+/TygN3NGNA
	lTPAVdNe3FimyLngmGJpIwX5YGDDm/s=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-341-sOruN-2xNW2gjL0gpToaHg-1; Thu, 29 Jan 2026 03:27:45 -0500
X-MC-Unique: sOruN-2xNW2gjL0gpToaHg-1
X-Mimecast-MFC-AGG-ID: sOruN-2xNW2gjL0gpToaHg_1769675264
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a773db3803so8416145ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 00:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769675264; x=1770280064; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z0YJmi1OAzukodfKJUTAQSnkLXHvbAKMCq1LzZsrBYA=;
        b=ePmD6F9hTrrwTK94KRCMKAgA1ZCJRCwgCKUXAsiEcUynjUFHWs4E5LtfDmejH1wi5Z
         BO9NOjvaa1QhfemLS9jbHuI21qG2urK1miKs+NDhvxI7bYNFKvZBOR1JVw0O0TpLAgb4
         5as5ptbop7OT2Qr42ADS0a21udtqU5eoatn5RllCIZ2LzASdDWsWmiUsz7lY+WEynj6T
         CzxGULDyWLGIW/LDTyKDReK7Mom9eG1USX0hMWIQwIuYN17XooymraoGYQZxzKz8madr
         O7hJJBEUF6a7HCS0XlLXtD63aapO+KyrovZim8pvrikgYTjJ8FcnkOJqZwPSRQ7n4DMC
         Dslw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769675264; x=1770280064;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z0YJmi1OAzukodfKJUTAQSnkLXHvbAKMCq1LzZsrBYA=;
        b=wDTYFTNzHmnhuQiHUXZW7nFisnQJcss3iq7oQjgKmnkUngB+dvInI+Hj2BaafDPd7o
         di8ZeqnY9LUqL+CnfGI52BgoMxw9NnkTL/9j7keE6K2ItVRVS5oJ0FJOhGggCRWUyJ2n
         1Rt2aZl9Fc1I2wFqnAa6x5rEPe4eQ3/crSoga8+5PYgrdzusNGxq4kdO314iWMBIWkgT
         yaCt1Cz0y/uRmXZ+rjjR33Rg9ctjxrnMSgLVPpbBUIjcf1VRx0D1OzAwkFi38lvGrXhs
         etwqSjPvhQxiUaevtVCOeSfzu/tTz1k51MtQdzS4iQWgtxFkYJy3vZKeXOJBm+uqr3kN
         o5TQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfIt0GVP8DuOCiMSrwNlhL4yziyl2vpOqgYriXxL/Y804oxQGTWyef370gBifWr+JnCuG9R93A70k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1Ubbv2N+iRtNhMYfJ+MrG6K6AfTPQAIjAOZ9hAAetRdKgAyyj
	5dOYmLYOVJh+PixtC3HdXrvS7zA8Wp733j5niIIk6+3vjciQJJ5/tCco9ZMpNo3S2d0eGTc0249
	DclmnHUBFV8Z802L8oz/dEG3JnaFpmDAwBipDTb02v7fHeKcnP7SBw/lImRlgRtIbkYuILQ==
X-Gm-Gg: AZuq6aLhZIqMKMd+LW4+g6fUFJoW5T6fpxve8/Hlno9khurqksLqNCgm8V+0pKVmbc2
	Qk5J90MuYHubfSOTN9Grk0pUJbFMigVmpvlXki1mn6LZ25tnqQ7+Mw20vO9pIZnFmvHR75atbjz
	Yz+kFK6uToMnTA5LNnyYlBcYQtfJ73H8MAO2szG26VZkOwlwwV6GPirNZyAoCZcaocqd8/rU+1x
	FEnrwuXKNmOL6RNgeWQsYfPXR7R6kOhG5ID/3MGP04ILFa6O0rY2QFI1lvensxaSKPey9Ed3Esd
	LHEIjJ5w9HbnVsdRYFYQhmg8gpnzrzHiNpxMuWSDoCyqkhOnVDgLQI35HmdXQsrC0Fw0L2wZsOt
	51o6S4ZiD8p5XAzEYKmLBtjKYCnFpb5XPuxpfJT8sWXHzSB70tA==
X-Received: by 2002:a17:903:13ce:b0:2a7:bbe0:f01c with SMTP id d9443c01a7336-2a870d7765fmr76674905ad.17.1769675263661;
        Thu, 29 Jan 2026 00:27:43 -0800 (PST)
X-Received: by 2002:a17:903:13ce:b0:2a7:bbe0:f01c with SMTP id d9443c01a7336-2a870d7765fmr76674795ad.17.1769675263231;
        Thu, 29 Jan 2026 00:27:43 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c642a9f3d98sm4222129a12.24.2026.01.29.00.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 00:27:42 -0800 (PST)
Date: Thu, 29 Jan 2026 16:27:37 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org,
	linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] xfs/841: fix the fsstress invocation
Message-ID: <20260129082737.mq64ngmxehtp7ck5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20260126130816.11494-1-hch@lst.de>
 <20260126194404.GY5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126194404.GY5945@frogsfrogsfrogs>

On Mon, Jan 26, 2026 at 11:44:04AM -0800, Darrick J. Wong wrote:
> [cc fstests]
> 
> On Mon, Jan 26, 2026 at 02:08:16PM +0100, Christoph Hellwig wrote:
> > xfs/841 fails for me with:
> > 
> > +/root/xfstests-dev/tests/xfs/841: line 79: -f: command not found
> > 
> > Looks like the recent edits missed a \ escape.  Fix that.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Doh!
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thanks Christoph and Darrick, sorry I failed to push the lastest for-next
branch. You might find this failure on old patches-in-queue branch.
I did basic regression test on that branch, and I think I've found and
fixed this issue before merging into for-next last week. Could you please
pull the latest for-next branch again and see if the issue persists?

Thanks,
Zorro

> 
> --D
> 
> > ---
> >  tests/xfs/841 | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tests/xfs/841 b/tests/xfs/841
> > index b4bf538f1526..ee2368d4a746 100755
> > --- a/tests/xfs/841
> > +++ b/tests/xfs/841
> > @@ -64,7 +64,7 @@ _create_proto_dir()
> >  	rm -rf "$PROTO_DIR"
> >  	mkdir -p "$PROTO_DIR"
> >  
> > -	FSSTRESS_ARGS=`_scale_fsstress_args -d $PROTO_DIR -s 1 -n 2000 -p 2 -z
> > +	FSSTRESS_ARGS=`_scale_fsstress_args -d $PROTO_DIR -s 1 -n 2000 -p 2 -z \
> >  		-f creat=15 \
> >  		-f mkdir=8 \
> >  		-f write=15 \
> > -- 
> > 2.47.3
> > 
> > 
> 

