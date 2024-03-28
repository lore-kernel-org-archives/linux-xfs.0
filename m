Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B50E63B9
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 03:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711595710; cv=none; b=D7NPEPYJZWkRcaKncYdeI2l3nZBCkUIIwh8chpUPOaxQ2INxMzKF1/d06qcBUQd9lvuJ8Y4dK4ZWOuKZ+Q1EJMRyaB9BG1cDj0HeqglzOP6p6ExFFYvbdXDGXpfZcrRfLJIxlRpEtCZzJhZHSMEknjVPGRNsMKS8kTdKY9E0yzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711595710; c=relaxed/simple;
	bh=jOudKxOMk5Qt0xtXap9jdpLISaSAOO4E/e6lje8qszg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oCdusRjJo5qRGfFWr23Y6WY7M3e0YRt9SDzBUpwLXVhya4kb0/EO9H+O3rcDhBqEODBmWBcAEKK/Ui4fia7ukhZzkFEkN2rfAjDpqNOeCr/GzwzIzDqPAQg3jN/COnmx3I/T6dt25NgSLfp1IwIUGm+UIzPv5RaK2ZUN9KHTuKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=tNG8e+Ex; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="tNG8e+Ex"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e709e0c123so507187b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 20:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711595708; x=1712200508; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ztyMESS8D4LU0lEYheemb5JxxS2h91RVpOlWx5XaApY=;
        b=tNG8e+ExM8bhrb/633hd02Up7t38/WTcH0c5Gu1gdTUQyefWAFnwqqoHG5m0TrLbXM
         KTAUyJD+c8pa7Py8DO+qbZnfyaRjIIDGsai53A99Sd6IPoZe/+9PmNv8/LyCsUX3DE/w
         hiq11XjtpzT5raEWyDDTuGMWKNFVu4Aap7bFeXFAcAcYOd/KogREheR5Rk10zA0yKrWa
         5ee2tQ7/fcLXxGu03rcVx5fJqrP3xdJP30yKI4gaQBsuDNHJCoO1DsIc1KIRhSZUtABl
         L/Pk4JQUBi/JT6w/psjFYDIR97ZwcbcNgL3hEeSEaX1OkTYWyGvV3Eqt5b9bmJCZlKEu
         52bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711595708; x=1712200508;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ztyMESS8D4LU0lEYheemb5JxxS2h91RVpOlWx5XaApY=;
        b=OcZjU8AzwFuKGe4FCCqj8X+Wrir9aoDHZ07ZgPmJbDBAPEiEZCMG3P/EVtaQ7sbbqg
         KKzgwbVVIsv1uG3CrrR9tP64rDGDpZwXtkCeJfstV6FBTzvNXNqIK4l1sjZekuWr/Voc
         8qZd7ArX6VI8KQqCCLqDxcAuPNMz2ZikM6pwNwEcBvS2dGU6ziA5UI62qFytuyC3WynR
         jXnvrscrXEWtfh5Penj61Y6+RaQIkAwGB6Nr3DSMtb2A8jWkkddXI4tRz9Psa6c70mF3
         r/6H5C0l2BJjP6DRWsj8eyrOfD+gIaPlM5geQ0TrDJW/c9S8Mxo43Zh8WZGDK91t+F/G
         RaQw==
X-Forwarded-Encrypted: i=1; AJvYcCXvv1xqvFGFIQ23FzWeihpl5uFw+lZVbCP3bRKbZT+b1wMvst2eQ86vSqtOsZOFWy9mkmYhown0UcZ+RS86HiM0qzNQ+ImWddOb
X-Gm-Message-State: AOJu0YxdI0TrBstem/v8L6MeV7/21q6hHBG62aQzx3CQNhY3dnw5oc5z
	gksbSR0lRc6dlAApivP/2yxKsCWehKS2q47COEfqCKyLPfCNpAb0VqGLAUpj2Zw=
X-Google-Smtp-Source: AGHT+IHGQ92P+jV4SeP70QoI5tPRKLGcjkyxlws88RkAwyfi8BVsWJW63btd8vDCEzEWqgiQdksJiw==
X-Received: by 2002:a05:6a21:a5a2:b0:1a3:dc33:2e47 with SMTP id gd34-20020a056a21a5a200b001a3dc332e47mr2078861pzc.4.1711595708454;
        Wed, 27 Mar 2024 20:15:08 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902c94600b001e0b3c9fe60sm305774pla.46.2024.03.27.20.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 20:15:08 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rpgEL-00Cd5m-1j;
	Thu, 28 Mar 2024 14:15:05 +1100
Date: Thu, 28 Mar 2024 14:15:05 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/13] xfs: refactor realtime inode locking
Message-ID: <ZgTguYdNwDYPdpNU@dread.disaster.area>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327110318.2776850-3-hch@lst.de>

On Wed, Mar 27, 2024 at 12:03:07PM +0100, Christoph Hellwig wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Create helper functions to deal with locking realtime metadata inodes.
> This enables us to maintain correct locking order once we start adding
> the realtime rmap and refcount btree inodes.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
