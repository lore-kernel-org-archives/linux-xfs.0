Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732C0F503
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 04:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711600597; cv=none; b=YSpnGtsK635XonDXwP4lbeA1N+alYevS9xxWN6v1kfIqB2BmAjG9sFNEbwrj8xcrI/w7AiRbfLUFR1MkUBc+cmacY+8GM8AL+gg9mx3W50PUYpqpultpZc3k/IhY8bFEdUTl8V28A4zEqcFXc2ECtjSZHjDLvcBZYkV/76rNR94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711600597; c=relaxed/simple;
	bh=YqGMfBjv9xo5LhKlbLzHBI+l2CK+dqz+ALqqFt+8vcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oW/0Xb27No2IICZiy32DU9vQo2IrULT1ksolCHar3LbJDX+kq6xGG4VnTmnwKFvp2+QPYYF9jNcjiTPduidKkuHacIfliRcuatJMuw1dTkIHSGoApSSdUFjPqO4rqQe1KHJNy0kvYqbJGPsLSdtZ/smJEBkYVoI7h4pCdWuZU2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=TKIHSWgr; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="TKIHSWgr"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5ce6b5e3c4eso283704a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 21:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711600596; x=1712205396; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G50enAfrOtqtfMhtAqoiTY30sMf9KKFkPC5SCEsPWz0=;
        b=TKIHSWgrvvf29IoJbOo0gmHqceYFC55R6zlAl48nK9Rb/TJBwC0riNTdQaiENmFBHF
         EH+k7ul5eejkqGudOEtrcPS7AssYYf2OiUQYNyoPJQqdQnDsLQVuOWSrXqn2h58C+H7R
         FvwteDxhlkqIDUkNagg1f8T3qEQxk2I0IFdXSDKICTDNzR0MSl7B0EQZOrc/FYL5/DTB
         GUKrO4TSA6uXk/op5PJeNJut+3cuTkaoskrds7Hm52bkCIVW6KkI8Tr3zuwBD5q4Ynqa
         MSdRKrzeGJvbD/Xxyj4f3LuSbHsOhOepzkXgVisOAICtYlwG4reimOIQXVtS6xG6SLPE
         gEqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711600596; x=1712205396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G50enAfrOtqtfMhtAqoiTY30sMf9KKFkPC5SCEsPWz0=;
        b=mjg+tg9U1DBGjmN1GKZsMXMojfXwW7BvGvKv10u1FtR0N5uYSv5fMUAdiXMlfYmhUM
         vkZv/yas+Q0D0QEjZbV6PSnVpkmgXLwDEZWWv9BRPAZpHqZykYztwopdF4irZIOZZNfz
         LtRFKIXykrFEt7z2tJsbsEMBHCI9J5xXwJ+pyJuTL91YeBK55A4xQyoUaRzowExWj7bX
         ClrH8ZznZg65DS9THBZz2ytqFQSy7bPpLpUwqnYtOAsJVj2LlpJvWkVeQMVwMf1FTo35
         Qi91FFDwTCcahrWiPQAos9B+KN/pFnOWFs7wk6IJcX00VHOnA1aXd1X6wJ2vK2FiUfsP
         iY9g==
X-Forwarded-Encrypted: i=1; AJvYcCUZ6OamIOcW+koVlESZPWD/f7a+YhIcyOuUtzoNnfslZWFSsz/ySb7Lrt6OyOaICjTLgXUgWR8gWU8gWlU99xIAiEjn1yxc9CGp
X-Gm-Message-State: AOJu0Yx4uSqfIF/zU+rZRszG9Zo0kInfQXhleSPvJqOKsiAYOH5AD/qo
	9MoUWq60MRbbAtsuVjpY5WqKlTx4IiuGy7HsgqkHFI76IZ4FzsLwY0CD5mDkc+Q=
X-Google-Smtp-Source: AGHT+IFzvW+GiIjeC9RO2COXfbqJ1Z3uYBGe4b4yoVDTUDCkvuA509UnNZ2184G6ZkvQ3LkCIPvdpQ==
X-Received: by 2002:a17:90a:8b13:b0:29f:ac52:9ae2 with SMTP id y19-20020a17090a8b1300b0029fac529ae2mr1752847pjn.42.1711600595703;
        Wed, 27 Mar 2024 21:36:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id hx20-20020a17090b441400b0029c61521eb5sm2059585pjb.43.2024.03.27.21.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 21:36:35 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rphVA-00ChGs-2z;
	Thu, 28 Mar 2024 15:36:32 +1100
Date: Thu, 28 Mar 2024 15:36:32 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/13] xfs: stop the steal (of data blocks for RT
 indirect blocks)
Message-ID: <ZgTz0DeNm9rRroNR@dread.disaster.area>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327110318.2776850-13-hch@lst.de>

On Wed, Mar 27, 2024 at 12:03:17PM +0100, Christoph Hellwig wrote:
> When xfs_bmap_del_extent_delay has to split an indirect block it tries
> to steal blocks from the the part that gets unmapped to increase the
> indirect block reservation that now needs to cover for two extents
> instead of one.
> 
> This works perfectly fine on the data device, where the data and
> indirect blocks come from the same pool.  It has no chance of working
> when the inode sits on the RT device.  To support re-enabling delalloc
> for inodes on the RT device, make this behavior conditional on not
> beeing for rt extents.
> 
> Note that split of delalloc extents should only happen on writeback
> failure, as for other kinds of hole punching we first write back all
> data and thus convert the delalloc reservations covering the hole to
> a real allocation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
