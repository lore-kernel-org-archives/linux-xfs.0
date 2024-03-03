Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF797A715
	for <linux-xfs@vger.kernel.org>; Sun,  3 Mar 2024 23:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709508960; cv=none; b=Ge6RSVdtc2GvXnnNrrnC9AikmSjPtQIqjpuTwbLaaOlRk0zqwU7unj1ujNdn1lCQ4+6N/HLhIHpGwLoiMgPVnKcc79GHWMu+mo7ftQE9AJQESGdszRtslbN+aZ0cf3nK0eoXZFAsEN1ehz40xkStc5tdBmQChVjjbO1PSqMSZ/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709508960; c=relaxed/simple;
	bh=Ti9X/FXMtXdtuklTuMvWh2IRJi0XWj0Xg42tOKGD9hs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ogqFxYwQaNdx8h7IsMDC+Zp2K2MaMf9ZXY0XbEk3r/ponlr+1Dd8WPQiRZLXBbVfiYWMYW9XZidA8gZqwx37kH29DqkrYO5ChCBXF11Ka6x0n+kE3fE+aa0Wwr1vzimFlB5kpJCwsX+r4KYkaSfHcpZT6kEQ2R6LNkiU1sBsEkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Kv/it71G; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Kv/it71G"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1dccb2edc6dso31769765ad.3
        for <linux-xfs@vger.kernel.org>; Sun, 03 Mar 2024 15:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709508958; x=1710113758; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L50ZscUmxGgE9iPP8Ug5iQ6+RFUl71GujpMGxH2pRSA=;
        b=Kv/it71Gp3ffo/PeJd8EmRO2p6bfpwku/a+6aUxHqiA6+VmvzhVu1U5FMjcHEdU5DY
         ua2vnXDxTIAy5WDch05tm0AXjaLh3QwjwWdivBePJv5GyXL3IztgcspV62vfllFpQC35
         pJVi5rB7qbHbDofk0l/wuwEo5n69TwF/VcTLdPNkD2GkLVbX8CagAS4nTnu6VjAPwiSb
         qY0BAGxlArfR9lHLwp60s+CPuaeCoYRBPqlKo3k+qml1oqkA/2r1ssJ6fqJWi5mgCgCM
         hCkI/ABYyXp5u+oY6tBY5eruXmfSdqBnf5CMmEF1no5q21cxpb9N+kHydiyn98KsBFpk
         I7QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709508958; x=1710113758;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L50ZscUmxGgE9iPP8Ug5iQ6+RFUl71GujpMGxH2pRSA=;
        b=MjapgFHkOMTNbI3/cn81bFNHiduf/JfXKg3HBpR249jsqN/bvyIOxYyAelMixtoRwl
         MVEIvv4YhamnSKLNkWnkwWiHAVKKhbcKdBMUuk8abW1WLgTTNzqCJn/a/A2SNMOLLN3M
         72xq0yUAJa0coLLGncgErKsty+2ZHcovwn1CHz1DyGLV6LuiLC8rAaYCV2wJBxgkYbnN
         RCdxJJgncmJMOxkxowZYHqIeXyAa5fUUuEe/XvRIWwXbPZ+o+Co0GeFKRFd1vruxQYhu
         GWPRnH3fIqYEPhrHm31UqZBWgIyBH8bmEUXPDn2hBwigOC21tCc9GqMWuVyot7nUwu+c
         d16g==
X-Gm-Message-State: AOJu0YyXxs8IyPPRCt/bJUDJfG/h0pUh6oCYHPDu/7w78IQd1HKXFALe
	WgqwGBY+VJEFYfRnLDT/Bh6/uwDarNLc8Kp+te/Q53Hv7XrYQ5MdaFRttDAi5UY=
X-Google-Smtp-Source: AGHT+IF4RZyHgKHM9fsl+rIVxIHTZH6T4VoeOXKZYPJoGWFDqqasplhyEot9OhnGwKfPC1VTE1IhEQ==
X-Received: by 2002:a17:902:e5d2:b0:1dd:7b2:3b19 with SMTP id u18-20020a170902e5d200b001dd07b23b19mr3130999plf.9.1709508958144;
        Sun, 03 Mar 2024 15:35:58 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id jv11-20020a170903058b00b001dc96c5fa13sm7107930plb.295.2024.03.03.15.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Mar 2024 15:35:57 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rgvN4-00Ef2o-1m;
	Mon, 04 Mar 2024 10:35:54 +1100
Date: Mon, 4 Mar 2024 10:35:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] xfs: stop advertising SB_I_VERSION
Message-ID: <ZeUJWuO8TkuoodIx@dread.disaster.area>
References: <20240228042859.841623-1-david@fromorbit.com>
 <726abff82e992e3e0765e8711e90bf0accb37b2a.camel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <726abff82e992e3e0765e8711e90bf0accb37b2a.camel@kernel.org>

On Fri, Mar 01, 2024 at 08:42:17AM -0500, Jeff Layton wrote:
> On Wed, 2024-02-28 at 15:28 +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The redefinition of how NFS wants inode->i_version to be updated is
> > incomaptible with the XFS i_version mechanism. The VFS now wants
> > inode->i_version to only change when ctime changes (i.e. it has
> > become a ctime change counter, not an inode change counter). XFS has
> > fine grained timestamps, so it can just use ctime for the NFS change
> > cookie like it still does for V4 XFS filesystems.
> > 
> 
> Are you saying that XFS has timestamp granularity finer than
> current_time() reports?

No.

> I thought XFS used the same clocksource as
> everyone else.

It does.

> At LPC, you mentioned you had some patches in progress to use the unused
> bits in the tv_nsec field as a change counter to track changes that
> occurred within the same timer tick.

Still a possibility, but I wasn't going to do anything in that
direction because it still seemed like you were still trying to make
progress down the path of generic timestamp granularity
improvements.

> Did that not pan out for some reason? I'd like to understand why if so.
> It sounded like a reasonable solution to the problem.

Time. And the fact that ctime granularity isn't SB_I_VERSION at all,
so whilst we might support statx change cookies in the future, that
will not be via a SB_I_VERSION mechanism.

i.e. statx doesn't require us to support SB_I_VERSION for the change
cookies, so until we are in a position to present a higher
resolution change cookie via ctime we're just going to remove
support for both.

> Acked-by: Jeff Layton <jlayton@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
