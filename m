Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277B038E126
	for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 11:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768303463; cv=none; b=cI42rAdVONjziMYqpVSeFUCH41ZIYXSFIi3jJpkaRvfZBUb9lWGgZj1e+04n/zSkqD5MEMGd0bfOcw0Z5VFtnexSg9HjWv7/40UCkPl0RlXkj03p1XRzwyX5Vnq4C93zhUDzI/gHcHpOpptKMVu/ebpZwZRBjN6YXNRj7gd1rWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768303463; c=relaxed/simple;
	bh=XgIYMzGgW0gHescGH608mwN1JydkPpadmv8jvJ6FIdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bruo/4VEj8iYNaAhxA+MgsQ/+Ootu9LWXMfyA78YPyqcvmJim54+E+gcimR87iG0oZbKF4nEh/9SgAzDOhTSypXSSQih67K8U8drYpCDUiYL7t2AUI8XMGHh7CwBpgpNTbZR1rIQriABum+dxAELNQkB+g7paNW7Tsy/f3UgQRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RCYTA6HG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bKOEc1TK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RCYTA6HG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bKOEc1TK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768303461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nRMkXI0DMI5p2B4y5x0zNltsIxM3cjoIg//7deRWL0Q=;
	b=RCYTA6HGIT+HolBnHwC9xDvFloF6Ga06tSPA+A75a12doitASZBP08liZP2sedS/49b7T4
	hs/HnpHwdQFqZBgR3YmE91YdLUcW6Khj6CvHiKOdCyIJ6haMIzI4mHh8ypzMj8TfME/JJf
	FCguJmBa0SYtyjzpRBGrxtBvSpQ+6b4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-X2msc0DPOFGs9a_olH8iyw-1; Tue, 13 Jan 2026 06:24:20 -0500
X-MC-Unique: X2msc0DPOFGs9a_olH8iyw-1
X-Mimecast-MFC-AGG-ID: X2msc0DPOFGs9a_olH8iyw_1768303459
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430f8866932so6293417f8f.1
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 03:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768303458; x=1768908258; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nRMkXI0DMI5p2B4y5x0zNltsIxM3cjoIg//7deRWL0Q=;
        b=bKOEc1TKDCRkwZUVPtHMBYh9IvCRRupO92hN6vKpogKPskZKewKNFAcdOMjZALdMMw
         gQo6ObGshRSCtNkbiTFnEgv2gGLYrYggIh7X58ZPjWnF/H+ElAmvgVlmwoWt+yVEM27I
         rhs8PiQqmZt55+os6iGdG7R61MZLglEXSagow5r8YurNu3hn0vnqJ5du3/4uBot/GPiO
         4CxsFtKWGIKiZe+ZIymG49GBosKV7FuZiKqJ0Fh4o8y8K3/FCUQ/XWxa7x7cbVjh+0ei
         +xaWBOxeE0l7X7eulOTMX3HZ6vseF0qJa36FQtP4osGs6OaVVVv/xp3lwQRqQDzrG9Ch
         zIFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768303458; x=1768908258;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nRMkXI0DMI5p2B4y5x0zNltsIxM3cjoIg//7deRWL0Q=;
        b=qAi1GRGJzj2qxIMkmNPpm8bGfR1JTEmZ4j8v7lHTx0TX8CdjNnVz+wH5wvT1CXtY+z
         OD/Efn7CqqRuOpms/tkUTYD3vkbw2j0JaMerGSRT/38OWEBT3pIRIXSJ5kf6FW9wdPIj
         fsJ92RF7nutyH9fwVdIrUUH96i5zm6t53yZH9oYZSmhDgAIFAZU5Cyxi67Glu8bZJRwT
         tZq1jNnYiPmoP9c3RY3vSUExbU62y6u5LEYzSI3t+zMLFo0InHrsp04lZKuofnJEwiA9
         pPY+KNnbSEql1FCE/QktwuMzL5Ms1sL0B67R30+qM7qtEDLtSIGxH3jeuBNQHflZd0Qu
         xxfw==
X-Forwarded-Encrypted: i=1; AJvYcCXVR/uEI4mRPt/3BdhYd6fnmY+qKugBBm3LiBwHFrDRp8cRrchFN5N/cx2gtGNz77uSYNcjpB8vdvY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJzsXQsNdBWdIIh6VnR9rvQFi1aKFxTCn0Or4lWS2cX1grjkTC
	+RVOOgfi2147D95gDH2BoMEaSIpddxpRZrOoCS5B44r8pvYkL2Q+wMUrnN25V2M5a1ut1g1gL0Y
	nvs3mh5LiEzIBMTb8vFPug6z6NwFgZfc8cp8fjhDEI7L2/kXiJSpUiYKccHLBhWCb6IlV
X-Gm-Gg: AY/fxX7AfHgbodkhcIV2fzIZ3rf3lfV1PlXZ3pE7RhLd8LxUcI6MlRER95JN1jTtgOl
	vzwBlQhbDDD5uVhqvvLyvSTEsVv0Ep8Y0aoRcyiDFs5xeH6PQ+zBwufMyF9jlCqPUXJTss9EEwQ
	WZLgF89/ogVn22GgUcemE+MRKf14024NrN6SM1Peb9lom9JRjtly/YxB0iMlO8xKcYgbGgJltnR
	2rss8Mr/DcII7pAgy6FgGL0hup3VqvgkeMVwcZFRuf63vjCRB98QNbfpqoRRXLSBbilcivT4s0u
	Xa/VmINHeAmjE+H0NIkA0wfKct5AM60dwCV4X3p8heS5Z/hAd9CupzQ1SAj+i/Ef8cp+y3nuqHQ
	=
X-Received: by 2002:a05:6000:3106:b0:432:c0b8:ee58 with SMTP id ffacd0b85a97d-432c3617c2cmr21757752f8f.0.1768303458658;
        Tue, 13 Jan 2026 03:24:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGrM747jJuZXqfgIkrgmr5TDL+50UKoPdv4m4RQQMEuwrd6aGEzUqe3Sgbk9CxIB87OJxTBug==
X-Received: by 2002:a05:6000:3106:b0:432:c0b8:ee58 with SMTP id ffacd0b85a97d-432c3617c2cmr21757724f8f.0.1768303458178;
        Tue, 13 Jan 2026 03:24:18 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0e199bsm43351636f8f.16.2026.01.13.03.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 03:24:17 -0800 (PST)
Date: Tue, 13 Jan 2026 12:24:17 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH v2 12/22] xfs: introduce XFS_FSVERITY_CONSTRUCTION inode
 flag
Message-ID: <64sjr2cxebvpupkhqi7hjcu4uy5xv6x5xxucrskh4dn4b5g2jk@kryfgma557js>
References: <cover.1768229271.patch-series@thinky>
 <bfcg5hug75qtvc2psw5yymfoudnz2uda3gg5dfzgnze46hwt6n@u67n3rdzzuo4>
 <20260112224213.GN15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112224213.GN15551@frogsfrogsfrogs>

On 2026-01-12 14:42:13, Darrick J. Wong wrote:
> On Mon, Jan 12, 2026 at 03:51:16PM +0100, Andrey Albershteyn wrote:
> > Add new flag meaning that merkle tree is being build on the inode.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> 
> Seems fine to me, with one nit below
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thanks!

> 
> --D
> 
> > ---
> >  fs/xfs/xfs_inode.h | 6 ++++++
> >  1 file changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index f149cb1eb5..9373bf146a 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -420,6 +420,12 @@
> >   */
> >  #define XFS_IREMAPPING		(1U << 15)
> >  
> > +/*
> > + * fs-verity's Merkle tree is under construction. The file is read-only, the
> > + * only writes happening is the ones with Merkle tree blocks.
> 
> "..the only writes happening are for the fsverity metadata."
> 
> since fsverity could in theory someday write more than just a merkle
> tree and a descriptor.

changed

-- 
- Andrey

