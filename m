Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E77A85C4E
	for <linux-xfs@vger.kernel.org>; Wed, 20 Mar 2024 21:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710971930; cv=none; b=n85nQB+CU9s4d08K9fBwE5ajND3jD6pq75dfpsg8N4PF4wUbVuODJ691sSbCWLXz4JpaViB0/0SpV1ooFPxLSPauUOBNzBRykZSG/dE5cRS4y3p2khqt37pqBWQaDi2bdl9AkUoAEjvHYxv/McQSAV0NEhQtejv8/bS4VcOTqL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710971930; c=relaxed/simple;
	bh=vgyJyCbszmKEZEHWfC566YXrZWt3Ka8ieYleC+bP89s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gu98vhjddoagJkDugSvBEau2ZymgGsj7+KXWQp4Fz9axnWj1PKGZgfYif19dEHMTuowwHYHa5Vxt2Q+y/onpeftGBiCikonX4X2zSe8+GG/AQOLFA+xWrTNfRcQLX5p8NS9FOqfa8yXmGoJBCDEozNODMRm/HpJQ5kwdSD5+Eck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=KR1XxQEe; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="KR1XxQEe"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dd9568fc51so2304875ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 20 Mar 2024 14:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710971928; x=1711576728; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FtD9kf4wDHKVcwkYI8p1h5SiuIAJytBUiRtHLBrj4+k=;
        b=KR1XxQEey0ec/rH0FssCAc3zCqviPkV6ib1MvqevPoEbU/78qFDKGXEu/lhLoiwE6R
         14F0aidKS2hCaqOotQwnIp6ee/VpcnO/Da0eIud39ldq7oDyPruqHsewMbpnwJ1xPMT1
         FDEeHQ1B7gKIRTMdYm9Ws/uosdnCNd5zR3QF61TQ3Rxi+jTM7/fpVrTGREswz6urj1Yi
         uetaneCCv9t4X2WeQtsnTkDro+nbAm6Coz3wtwLBqR3NUL1uy39EE3eqqq1LsvaHodhl
         o7i/08AeGljoOImpGNlyhoFHMkHLMC27dqZSdViN8C8uiTAC+EX/Hnh1fQPzeolPvL4L
         njaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710971928; x=1711576728;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FtD9kf4wDHKVcwkYI8p1h5SiuIAJytBUiRtHLBrj4+k=;
        b=lXXAA1kRvgcnFmsJxUQ7JPVqZfIm6xvb2L8lcYfQM3tknTNfmaDEeCGWHNdUMrxaSh
         vw7VaQRvEj0cRHn1bf4+B0zRW3SoZ9/rzejDr/52zBWrlsxJ8uOE/u142Ji0M95XwlW1
         HGhKaT3PCGF+5/8aK+1t98m+ZztyrbDBRgFD+5yNjBlebt/2JWY7MudbVUVoQe0cl8u+
         fs2HjJyhop617lRhiu3dtggA6g2jZWC7jzOemnBnKK5coPWoxAYE9DxoUIkSJcOCkGbw
         p6YBhjqCwdW/hC7jbaUjnqs4fiNOE6Vr/JdJo9l2jBjbJ0TcQofDh08VHpY3RYWAgfqd
         hR+w==
X-Gm-Message-State: AOJu0Yyt0nHhEjeX6I+CvYX1lPzu5E7ORbmHWXUCqE9MO71jmztgNzYw
	6x0LFH7PjB/DsaqXGhU+9vMcN0PXGGXe4U3LwOVhtgpmSYT+dkhYvfcMUxjw58U=
X-Google-Smtp-Source: AGHT+IEvir0qn2HS7bJeyHVEsXmG9K6SnlrGQUY5OaC46XsWWpLIvMvfSbzQdV3Yg0W+aisFHRkkUg==
X-Received: by 2002:a17:903:32cc:b0:1de:f18c:cdd with SMTP id i12-20020a17090332cc00b001def18c0cddmr3796338plr.3.1710971927322;
        Wed, 20 Mar 2024 14:58:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902a3cc00b001dd744f97d0sm12905499plb.273.2024.03.20.14.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 14:58:46 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rn3xM-004ku9-1C;
	Thu, 21 Mar 2024 08:58:44 +1100
Date: Thu, 21 Mar 2024 08:58:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andre Noll <maan@tuebingen.mpg.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: reactivate XFS_NEED_INACTIVE inodes from
 xfs_iget
Message-ID: <ZftcFITAcRjyTR0N@dread.disaster.area>
References: <20240319001707.3430251-1-david@fromorbit.com>
 <20240319001707.3430251-5-david@fromorbit.com>
 <Zfqg3b3mC8Se7GMU@tuebingen.mpg.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zfqg3b3mC8Se7GMU@tuebingen.mpg.de>

On Wed, Mar 20, 2024 at 09:39:57AM +0100, Andre Noll wrote:
> On Tue, Mar 19, 11:16, Dave Chinner wrote
> > +		/*
> > +		 * Well, that sucks. Put the inode back on the inactive queue.
> > +		 * Do this while still under the ILOCK so that we can set the
> > +		 * NEED_INACTIVE flag and clear the INACTIVATING flag an not
> > +		 * have another lookup race with us before we've finished
> > +		 * putting the inode back on the inodegc queue.
> > +		 */
> > +		spin_unlock(&ip->i_flags_lock);
> > +		ip->i_flags |= XFS_NEED_INACTIVE;
> > +		ip->i_flags &= ~XFS_INACTIVATING;
> > +		spin_unlock(&ip->i_flags_lock);
> 
> This doesn't look right. Shouldn't the first spin_unlock() be spin_lock()?

Good catch. Fixed.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
