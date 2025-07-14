Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52261239E6B
	for <linux-xfs@vger.kernel.org>; Mon, 14 Jul 2025 20:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752526415; cv=none; b=O/ZSlyLn1re9h0ur6HtNkSDUVcJ/tjS9nanrkn8ICBcW+63IodDccRCPBvbFujtZPs+zhHe+m/pZNiqOZIrtKPcMy1wZVAu0JRe+wPVL4J9X/Orebv1Ajhe7WWO/CRFXI/GWaRKTr6iV3EMRMk/9XHkZzK3SaCJtXynaWcBl2ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752526415; c=relaxed/simple;
	bh=tawgDwkEVojw2NKv3CCTeFgxnOZvyRkv0Ij9fIpT1q8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uW+DkSwBhohAWtjAcE2FGb96Ikbhm46ZGnyhvS6dbc4tauAViT7ByPscRLh1jQGoURNE8QL5g2OYGGk/rovHJCx2BcUeuBv9Upowp8W23jWkUAbekUXpZ01vK67lwh1fqt4X5MVwgb+fO9SoAs/+5Y7M1TF+7SuyzntvsoXWIFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=WVcUu3Ec; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="WVcUu3Ec"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-73972a54919so4312502b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jul 2025 13:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1752526413; x=1753131213; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5cPjSq9x4JfK6ES05iG56c2eRWJnFpbKNKAZhIdXJx4=;
        b=WVcUu3EcyUWDMr4Db3o/k3d1rGqBToLoC4m6y7TOnYgaQF6NVsoW4Qz1hJFxqVy/rb
         yvdvB03zGshWUydtQl9Ki5USN8M3JvnCiRk4CcgPUUez8WYwn0P7dbK0l4Hh1kWZN41k
         PY8OQjJbpphLNFzraemZ3WHnLqXoxZzvOPGRm11OWCLmq0hngEuvVQWZUTMx3h9MGkPp
         rtlXoS3MNwRzraFe7JqspyFbBI1XFkWRnkDAhEvzTxblL35OJxF5WRuo/XVkFV8v2KMW
         FRNYxf114pSiL+L60F/xcUneJewAOmZueur0anMFLWpMh8skgjCWAD0enfSDvYnC68nq
         k5dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752526413; x=1753131213;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5cPjSq9x4JfK6ES05iG56c2eRWJnFpbKNKAZhIdXJx4=;
        b=RsNtirQ4/9JqnO4VGv5v7Bd1riIlZR3D3I8CarUSH+R22L/tR/3RChe9R7RirB5xLk
         O5qipAK1KUPaGjRBoSZ4o7QbpkL9X3yknPnHPENp+nSE2a4hzSSwI9MSxU4Xt3bu/1dM
         nZYFt1OQM83VncUOham5l2C3bFLBhCzDX1dLXuzIJ1EVckZxlF2hce4AuAdnGRPvSQ2m
         t8I0gU+TRfQJJvDNb+XCTfxqhdfBZq1/R1yL7MH5aeLNc08D6tFWA83eNSPseS7OZFGT
         9zvjGiDLSnCSAfJRAFYgTGoaKhbz+L7G5dp9x+Rsx7cZGb3nxS91OenlNl4NvEIXVIj6
         lXHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOLiI62mlOcziTd7sZn+gu5XkTUDPiiT7EB+nGgR0sGg4VeKQtYGntMxZ4wyuZawkuo0PL7N5TY2Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvAgZ7w1jKhmADsvO2tQpeV5W8VFZgaOvLIO2AKNQbGnhidi3W
	GX2QZSfu2FSm5nNCXxTyPQRSrODnyRSUXG/M9/GWOPRADY/Epo+0tPfZ/Ll/BTLf1k8=
X-Gm-Gg: ASbGnctbg0WEn1R6FocFHUsELtmXgF7uh1I7aV0Tf0Bw8+Dw3vh9V9YhkTQo2PPaeTR
	+JgYARwIqiHoU1eT0NBQr/vDOYm8bz+C1WuqBFepqLuV0q6/6qEUAx2Z7+k1km3VWinyTvc7Rvq
	2+Mn4kT9xHvfjVwPVF4Egb9cif/wqAmOeYH0ExfAQFL6h3WFGyV0PUnORvwTmRr5GwUazA54Vq4
	vZy+KTmV1q+JdF5+6FL4A8+ATjD+nDhRXcMkwZEtj+UsrTLaRXGj3OJN7PWyuLOg/bkyIxa6QfW
	RIjPDFjLmkYm/gUN9dwV+GV7AYEgXckVzdMJe67J/mMWaUoyQI2wD2NFjp/dinaRGMFc/k6pTqh
	r9SSSjIvCG/Hdj+vG9fOy+X8kxtDJavKRQDT8rNdFSGP2kvMm1vW4Klkplayy+gn4oLpChquPwQ
	==
X-Google-Smtp-Source: AGHT+IHnv77H5wfprCmfDWdElJKQH3XAqXLK31tfmThyrslKpxVkW1UVIPHA5IdRfKXL32HPE3IWSA==
X-Received: by 2002:a05:6300:40f:b0:232:1668:848d with SMTP id adf61e73a8af0-23216688519mr15759146637.27.1752526413510;
        Mon, 14 Jul 2025 13:53:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3bbe7297bcsm10529816a12.73.2025.07.14.13.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jul 2025 13:53:32 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1ubQAz-0000000B4D2-3tkT;
	Tue, 15 Jul 2025 06:53:29 +1000
Date: Tue, 15 Jul 2025 06:53:29 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: Do we need an opt-in for file systems use of hw atomic writes?
Message-ID: <aHVuSU3TB4eNRq8V@dread.disaster.area>
References: <20250714131713.GA8742@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250714131713.GA8742@lst.de>

On Mon, Jul 14, 2025 at 03:17:13PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> I'm currently trying to sort out the nvme atomics limits mess, and
> between that, the lack of a atomic write command in nvme, and the
> overall degrading quality of cheap consumer nvme devices I'm starting
> to free really uneasy about XFS using hardware atomics by default without
> an explicit opt-in, as broken atomics implementations will lead to
> really subtle data corruption.
> 
> Is is just me, or would it be a good idea to require an explicit
> opt-in to user hardware atomics?

This isn't a filesystem question - this is a question about what
features the block device should expose by default to the
user/filesystem by default.

Block device feature configuration is typically done at hotplug time
with udev rules.  Require the user to add a custom udev rule for the
block device to enable hardware atomics if you are concerned that
hardware atomic writes are problematic.

Once the user has opted in to having their bdev feature activated,
then the filesystem should be able to detect and use it
automatically.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
