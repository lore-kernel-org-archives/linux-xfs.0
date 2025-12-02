Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E93222257E
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 08:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764664861; cv=none; b=Lxotgp0coPKoRIcCVOAwjrqfd5272Qc13vCv/l9oMBB/tUlwcwuYa5qIchL5tbmJwff/1XJaGVaJGer1pCdl0M7McISg8vvMEg6A9soFUk4ykUiWBfScHsAFVZSbK9emPiCSxLcOY5mRQBCGKy9XXnl1Xuj6vVptIsw63rIE25M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764664861; c=relaxed/simple;
	bh=urOl0/ilTRIE2ngNhcdXcQShDJ+rl7s9PhYPUw2FR64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NiggjJF+O14wilLKhclPC4etHL8GM/HBJmwAqbNgthkptRgcAjb2HLyDotSB49GJR++9GSmbJY9xJQQB17g2eBGn+UhDDbPvJfYIM4QSV6qJoX/SX478qkYa08rXPVNcOPVY3vfjm/6rJdY6++eMr5GeY5XN0GOBL32ulbgFVug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jecu5cZB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PbWNk3oC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jecu5cZB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PbWNk3oC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764664858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ml3X7hjq+7HD8M4YETYZOG/CzOIrOxOEiDCQgxxaIVw=;
	b=Jecu5cZBk+1Sdfyc71oHK1KKTHFfNjXBDM1yPi0g2p5UpriVzXV5rDK/3GnYX/QQ/GveCu
	Sxiu1hK2C4a/ZQ2SBCSRnoJFAj78u4pR/kS92dOAtXef8hBBXjIam/XxxnSQFa+Qt8snzz
	xnc0AqcyZ1/06p2JxrYg5tB6/ztYCl0=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-_RG4ctKJMYuBky6KoQqCug-1; Tue, 02 Dec 2025 03:40:57 -0500
X-MC-Unique: _RG4ctKJMYuBky6KoQqCug-1
X-Mimecast-MFC-AGG-ID: _RG4ctKJMYuBky6KoQqCug_1764664856
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-340c07119bfso8661435a91.2
        for <linux-xfs@vger.kernel.org>; Tue, 02 Dec 2025 00:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764664856; x=1765269656; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ml3X7hjq+7HD8M4YETYZOG/CzOIrOxOEiDCQgxxaIVw=;
        b=PbWNk3oCEQLGgDlb7mxclaypl8kEzs+EwzJDXjUwCIZ7nDTCGI2TrZ5knElNyoT7UQ
         n9Rp1ypBoR/ArgqW3lcXN42OoWh7Tg3cpndES1hNg6iHxpKTJKgBI3+1iFHhkRVSgqxn
         /iG0CFc5R4gOdmm/yzc/mJgKDbBf4LLUObY9Jg/6WrPc2hq5Hm4mqUkuDS0FZ3IrDLxd
         Kc8msTxVwZCWTZYOSYk59/GHvSv4h0yS7/u2ydqIvkAc1CJS8G5F7cc88PCx/G/MdtOB
         WC3jKjpDUVZ+AlbNhu7+DHW5/Sv2QFfNwYt9cSN7dy/U20PSajZqIMbcQ02DO2a6THJh
         9awA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764664856; x=1765269656;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ml3X7hjq+7HD8M4YETYZOG/CzOIrOxOEiDCQgxxaIVw=;
        b=EtJJom6+bSyQgQGVlQkU6rs9KOSvzbinWVEEQi8rThMSiMZmJojYAOJeIyUfz6gbhN
         Qw89N0NwigAn6g8GQVi7Ux95vYS4PNv0Ert8pOpSkQmDAc6PEv5Tx/ncNeyN7Mpy9Sny
         8WWAUvQQcBLWCZb1IwzCIKZ0Uy74ztxYhR2ll/xWozGTMVMUL+8CzevGWmEXvk7yWlcr
         sqPsjqRglOamovPAqarxpR943938DjG2dhHBRvXOOqcnnCqCuGSq0yydOYQXuLhosoY+
         Erkh/rlOprncaBu4Va+1PFOk398RWhsaMn4PcGhB1CzKSXCyyu/I1t6khmrGYX0iSdSY
         ZM3g==
X-Forwarded-Encrypted: i=1; AJvYcCWlbR8VM90wYD4TQD67QalWyWw1C4Ev3IBMCgs8OsWH4oJ6exxJ0RDpELwrWrCcM41UC4yTsnBNiJY=@vger.kernel.org
X-Gm-Message-State: AOJu0YypKGOKD5148CxSmHxpox5y33rE2+eGv5iDOd0/eIiCMa5f8fo0
	0CSbDLxxo8j6u6Dr0EH2IR9nfdjtioMhUnFcfsaflzKzIC6OIuy71ALaIwKI+m1rmrIrAguJOtH
	gC40XQBq/gL4Hoe9qBZaD4TRNsr/n1QWCj76VHU46NRa2he3p2XS8DyTKwWiC6Q==
X-Gm-Gg: ASbGnctykdwbhJxEHlMjBO58A4/+IPHYFSs0rLcYx5wXxYt9mFj0/g6PAJBH/s1s25W
	9cjjCwbioHyKmwqfxzdRXyBP3Qk+UfF40TrV8Ay8Xvjd1FF5f2e++QG2Fkbwh7x9AxqIbje/W/X
	AWoUsgF7O835nVZi/8u6AW9UetTgvUGZ0rwdASyJ5kZ5UTp0OL4qbuRTM1N5TDGxPnb+U9ywJSa
	hYsR8ry7X0HD9Kcjap3P2nwyVxLaSrWPtiLrnhD67eB2k6DxWxEKZ4BN8FkFWuQ5T70CHk8KLCi
	kLh92qmJRj+fS5PPwkuWSpx7S/wY2rcawumX4GGGKEfEtPkF2dPqMZa2KHD5nsees+7sQQUYHo0
	lbtNzrX7/V4MMutf05TWaPTlLuyHpefsc7okBj6R1Gil2tTP6dw==
X-Received: by 2002:a17:90b:5544:b0:340:2a59:45c6 with SMTP id 98e67ed59e1d1-34733e4ce8amr36382388a91.4.1764664855872;
        Tue, 02 Dec 2025 00:40:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFsMo6NAYa764YoUSeOHsCNiq1tcsunmvQ9GSaPEJEpghKcA3ExolBwlnvc5cAVk92k4mJzng==
X-Received: by 2002:a17:90b:5544:b0:340:2a59:45c6 with SMTP id 98e67ed59e1d1-34733e4ce8amr36382374a91.4.1764664855368;
        Tue, 02 Dec 2025 00:40:55 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-be4fc5a0957sm14732683a12.16.2025.12.02.00.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 00:40:54 -0800 (PST)
Date: Tue, 2 Dec 2025 16:40:50 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/158: _notrun when the file system can't be
 created
Message-ID: <20251202084050.3iovo3maspy2xo7k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251121071013.93927-1-hch@lst.de>
 <20251121071013.93927-4-hch@lst.de>
 <20251202044900.rdahcmhpf2t3gulx@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20251202073609.GA18426@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202073609.GA18426@lst.de>

On Tue, Dec 02, 2025 at 08:36:09AM +0100, Christoph Hellwig wrote:
> On Tue, Dec 02, 2025 at 12:49:00PM +0800, Zorro Lang wrote:
> > >  # Make sure we can't upgrade a filesystem to inobtcount without finobt.
> > > -_scratch_mkfs -m crc=1,inobtcount=0,finobt=0 >> $seqres.full
> > > +try_scratch_mkfs -m crc=1,inobtcount=0,finobt=0 || \
> > 
> > Hmm... is "try_scratch_mkfs" a function in your personal repo ?
> 
> This was supposed to be _try_scratch_mkfs.  But I guess that typo
> is a good way to make the test never fail :)

Hah, but there's not _try_scratch_mkfs in mainline fstests currently, there's
_try_scratch_mkfs_xfs .

> 

