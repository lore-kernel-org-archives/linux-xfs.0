Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1B910F2
	for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 01:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711069253; cv=none; b=jA4ox0tOw5ImhxTHdRZCIhl9fdWGMkLLf+EPdZLq0zHV7sqHjPgHpbIJ2Oynn7A6ymWs47Bm+h7bLriXhh0Gz7vJWx3YUn9VQYlr9P6xMSyDFv30MtXapSsG9NWZiYDYI5k8v781ODCOMfI70Js7C5eLcR57f1xSvZGQA2w+xWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711069253; c=relaxed/simple;
	bh=KvoAF7df7YsAv4HtcPH8gUSIXw7LYl1fOSpxkpqRr3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sbYPCS2LAR90Dx0iC66+wUPAn7Xf+hlAV7SodZ+5gK74OuuXh85wtUxlIHMKMQNrytLKD4I8hHZxXAWVQscnFAq6TK79HYw3uqZkT+YRgjts94tngjAikzMhS0yYjaw1EUozYj8C+VC22sj2nkMmmRO2JA6BY2FBXkVdfLPlfYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=w3yYjdld; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="w3yYjdld"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6962e6fbf60so16052746d6.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 18:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711069251; x=1711674051; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:resent-to:resent-message-id:resent-date
         :resent-from:from:to:cc:subject:date:message-id:reply-to;
        bh=L2hcaTEbriam9/7FssVKUi7kol9l4gPNKSXgZqspLoI=;
        b=w3yYjdldJAh6p2iQ8qLxu5YR7Pop6APcdfATgZX6edOSUph5dic0NhlxNFAT737l/E
         Yo3NiYyDUgO+AdtUGLEdIOXaP1bds019A4/leWr18Rt8BapAWjy+HBqrOhWP0bMQC6BE
         buHEA85sAD1JqoElMMXNFzct18KbjEBjHRoepn/6IOX2w8MfnUTjNgUMApB9XWR6qRbS
         hNBxMJu3vhFX2u6SPx/jCN+YuiOaQnxXjjiXR7B5b7B193neH6zsOvMlUN6LoXdwcVn8
         cTfhFo7h6JaxlZb9ELI0BSvhWmjYs7mue1l0MxikmsOq4M812ze3ENe2IAdiH/aV6P6z
         amvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711069251; x=1711674051;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:resent-to:resent-message-id:resent-date
         :resent-from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L2hcaTEbriam9/7FssVKUi7kol9l4gPNKSXgZqspLoI=;
        b=ewXVmXNO0WNnWJsqehDrqqFRd6v4KFJfB5fe2h/rBu/K6gUkC2Gl0a89/3g23DV3Ga
         JW1yp8AhkpfhGLVRxtGk9q4ppSYDDbyUtTxObJiZlv/enLsbpXIcWMJ8it/i9QSDVjci
         NY3YoL3RfNX2wBqYVqwwrJAB867h//sojScHlDkE4RFgyO0LxOhtgHyjE3M+LRlMLlnU
         DWvwuX6stYWPkbhnLUcaCTHNMlTnGcN0TeOgX6Ppbp587nXV9vSvtL0DPWSgio/xnOmu
         XTYz2vemqSYQRBMh+XiaSb4aec5nWNht/SW3m08nd8lHqu8l9pa2eie+kE8CdNqHAPyp
         f1Kg==
X-Forwarded-Encrypted: i=1; AJvYcCXnI8ll8DX1fKDH+gcS6r+b8V/ytFe28rcnQR2I9Y0aNtl5X1cryCiHmQVnALT3RCksWSDXoj8xC+xTdkpei3RJ8wYXfS7I0nCn
X-Gm-Message-State: AOJu0Yy1WhqTvmNdIBUomphUvdNd3mkZhpR3qJoySMSYREsDdA3rLibq
	5qTlOl0a3Hzy7J7Xj98/1mHlonyQJ9fWepWH43E5rm1pTTO/Bp4io9HdFIuxs1ccbbUUmr4Gx2q
	t
X-Google-Smtp-Source: AGHT+IFQujk20HQNp07F05p6OBjCkSRXjL+9L9HkX0g5klynnlOCbrZc0os3Jsvcr82MNXxvqSbFnQ==
X-Received: by 2002:a05:6a20:3d8d:b0:1a1:484b:bb72 with SMTP id s13-20020a056a203d8d00b001a1484bbb72mr1398954pzi.51.1711068888492;
        Thu, 21 Mar 2024 17:54:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id 2-20020a056a00070200b006e58da8bb6asm451344pfl.132.2024.03.21.17.54.48
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 17:54:48 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rnTBF-005TZ2-32
	for linux-xfs@vger.kernel.org;
	Fri, 22 Mar 2024 11:54:45 +1100
Resent-From: Dave Chinner <david@fromorbit.com>
Resent-Date: Fri, 22 Mar 2024 11:54:45 +1100
Resent-Message-ID: <ZfzW1XmqVF66SXzq@dread.disaster.area>
Resent-To: linux-xfs@vger.kernel.org
Date: Wed, 20 Mar 2024 09:23:58 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: convert buffer cache to use high order folios
Message-ID: <ZfoQfsuxEoxrhiVP@dread.disaster.area>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-4-david@fromorbit.com>
 <20240319172909.GP1927156@frogsfrogsfrogs>
 <ZfoEVAxVyPxqzapN@infradead.org>
 <20240319213827.GQ1927156@frogsfrogsfrogs>
 <ZfoGh53HyJuZ_2EG@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfoGh53HyJuZ_2EG@infradead.org>

On Tue, Mar 19, 2024 at 02:41:27PM -0700, Christoph Hellwig wrote:
> On Tue, Mar 19, 2024 at 02:38:27PM -0700, Darrick J. Wong wrote:
> > 64k is the maximum xattr value size, yes.  But remote xattr value blocks
> > now have block headers complete with owner/uuid/magic/etc.  Each block
> > can only store $blksz-56 bytes now.  Hence that 64k value needs
> > ceil(65536 / 4040) == 17 blocks on a 4k fsb filesystem.
> 
> Uggg, ok.  I thought we'd just treat remote xattrs as data and don't
> add headers.

We needed CRCs for them, and they can be discontiguous so we also
needed self identifying information so xattrs could be reconstructed
from the header information.

If I was doing the v5 stuff again, I would have put a the
information in the remote xattr name structure held in the dabtree
record, not the actual xattr data extent. But hindsight is 20:20....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
