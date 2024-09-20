Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56AA847C
	for <linux-xfs@vger.kernel.org>; Fri, 20 Sep 2024 00:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726791960; cv=none; b=YXqkowvd57MgtjTXaUaefOPCYZq99wv/z3qBKn9vVR5TK8qag69ZiubBpYMdTQ1vw307kDnrMD+I8CkRLQ/A2u7ux+Dyq57x715tijXjAhIee6a9+iN7X22V1Vlvpw6iB2/g6D4LERl7dMOd7+qB2QUD9yA6Fu+C9JEE79/1jAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726791960; c=relaxed/simple;
	bh=z2dt4nzsJjknC2v3KkVTQJwIm+oqEF2Bl8t5YAKAkis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=apjPnHgUEPgPAUlIMd8+IfXQP3BbMKthuPau6PqASeCRI01Ut8RQJZNT0dgJmGFFiflx3jPnzNAvMtt+RKhUEOz0swttolmKa8l6zSGyC8losiekTl1GYQ/Xyz++Tmyxl+WczRDElqVQxNSK6ODAov9VxXdSmUH5KSq6MaxGHzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=zzZUsRx5; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="zzZUsRx5"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-71979bf5e7aso1051642b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2024 17:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1726791958; x=1727396758; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n0rQNifIodJ4c+JfI7/BChV1HaxjDpxyzVyQAeW2s7s=;
        b=zzZUsRx5bw/+eCH4mu0k8yc5ZnJwLvThLAg/ifkGArpw31FwKhsMAraRymguwhuuaR
         BRFkjq9NnnxZx2HK4gUR0j/oK/LaDBHD5h7Wv4HU9qOOaOa51YuziXIjt15EqwhyAs0I
         Lthg7NjVLpuzxBtmZQsDWr1LMxlzTRZsiczsx+o49ZpiPCvxbxIWmWXo0Zx5tk92+HH+
         mT9uHtEui900UH+gR1ZZhto/cfvuSpJnS4ET43PK0ho9a9Av98Gci8ng9XP2ryBuaqBK
         GfZD0RaB8PGZgWIw3xeV29jZC4KCytzcebZQR1/A+tQ/PGpFzNToeyAl5Jk79faNCBmx
         OyvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726791958; x=1727396758;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n0rQNifIodJ4c+JfI7/BChV1HaxjDpxyzVyQAeW2s7s=;
        b=u7qKLhPeJokM8E5TSveu8VZB2OqPS24qeDH0r64XCIFYpd5+8jZWqP7a8O8T2ASGhR
         BN1stBgSp3OyeL3QXRlA/52ixaI2s0iNZrcwem7G5ABhAGEHmC1w9QuSv4qV7f32R4xs
         npb95Z4kF/xv9xq7l4AIqCwVG0fcaVasnSvmDCs0Lq9rfyokDe8aoBvonQiLzY4GYHzN
         WNqf24MT+lF9TNl3CI5CqFVnep4DSHa4D/2Q8Azmr0iVZ/vvv/hHb/w1+ncSHLtF+uET
         /Iu9Zwl2cWf9d47kIxjt9aOiTMlaGpRWxs35dRT44y+7+V6fN27SiHcfw6jMzpDWRqil
         Bt7g==
X-Forwarded-Encrypted: i=1; AJvYcCWs6iPXzKNszjOf/4uMkR8fI7gIvdLzXp/i9NUVKCFr0xTEce+H45p3pMKRXi6JUg5C+SS/5iqlEYQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+eU78s9KXmRCNvJ1RZxds4JeGx0UdWGusq6WvxbS++7aLuZ54
	i4bjJyEALl6VIYLKT3s5D8/OmBGkajxbtptd4qfbctH25HrGmLX870Qr87RHQ6s=
X-Google-Smtp-Source: AGHT+IG+KYpzAqAx/8j01hP1kK9twzYmYzsP1hZP+XPr4BEacEJmI2i/FgTilyCixlxXOdzY0dDrHQ==
X-Received: by 2002:a05:6a00:cc4:b0:714:157a:bfc7 with SMTP id d2e1a72fcca58-7199cd8c263mr1268483b3a.15.1726791957941;
        Thu, 19 Sep 2024 17:25:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944b7aed3sm8881794b3a.114.2024.09.19.17.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2024 17:25:57 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1srRT8-007SKz-0Z;
	Fri, 20 Sep 2024 10:25:54 +1000
Date: Fri, 20 Sep 2024 10:25:54 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: factor out a xfs_file_write_zero_eof helper
Message-ID: <ZuzBElgA34H7FAEl@dread.disaster.area>
References: <20240910043949.3481298-1-hch@lst.de>
 <20240910043949.3481298-7-hch@lst.de>
 <20240917211419.GC182177@frogsfrogsfrogs>
 <20240918050936.GA31238@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240918050936.GA31238@lst.de>

On Wed, Sep 18, 2024 at 07:09:36AM +0200, Christoph Hellwig wrote:
> On Tue, Sep 17, 2024 at 02:14:19PM -0700, Darrick J. Wong wrote:
> > I gotta say, I'm not a big fan of the "return 1 to loop again" behavior.
> > Can you add a comment at the top stating that this is a possible return
> > value and why it gets returned?
> 
> Sure.  If you have a better idea I'm all ears, too.

I would have thought a -EBUSY error would have been appropriate.
i.e. there was an extending write in progress (busy doing IO) so we
couldn't perform the zeroing operation and hence the write needs to
be restarted now the IO has been drained...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
