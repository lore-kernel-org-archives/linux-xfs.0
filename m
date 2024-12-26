Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A8E19750B
	for <linux-xfs@vger.kernel.org>; Thu, 26 Dec 2024 21:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735249852; cv=none; b=afPxC6CkT1THDmrMdnWTPjqdqwdypPZD50mfWtvhp9z7P0H7mypCNHuZhHekL6Gek8QXlUz0xRqGnBWQnCukWPOSNvBdE2dw+FtuIiUu3SuZHe0zZfVIb9WlN97vlAyJRoCCUGjE7N/xebPxe4OkBZA0peKPG9IM5iDeaxsIyXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735249852; c=relaxed/simple;
	bh=dvN2lzuJjqh+PfwhVxvByHFBUi79VKH87uBl15ewL/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y6eMZ8L/0QlPad2ZqYPru1C9/JlaWEzjM6m0We7FoJUwQNMUyxAzov8vm0Nl/yDuPhJs9+KJSqaCMMXXefGujTb0YKlVVKfK/xB0Gv1QBXm2a4FQC12wvswZdiPUuZQgJ7sE/copmp4x4E7aiS5dTAWHB12AglCRM3XW3kYq7e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=xo4KiUrA; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="xo4KiUrA"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-21683192bf9so83721335ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 26 Dec 2024 13:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1735249850; x=1735854650; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wr9rqTNKfrszMFbe6gBAWrnjJVlbfYKXR7FEPGhqS+w=;
        b=xo4KiUrAEfOwxADhZhzDYyLLABAR8H4FBE4L4eeUEMGygkwtq0/bxBCrovCNZ7s+fT
         651O/DTaqqBfAZV89+khyhX5gpejEm0/tFBlCHz0lOjweXXu/SkEPYQ3j6atma60CZjm
         gQ7ieD4JQNQhr8tTh4CBHxKTf+Zp03UkPB80taRsVWgRIKb/kIzNAw7RETA1jP2KNel3
         wuVv4ZiiyapNOns9asM574SNTYVE10mK5S2tJcQheOrVPbOWaE8qetlhbBKGBLkIJpXD
         Yl6H+lRvCZ1LwN0E/LAr9u44rTDzPG527No+eSlU0JQ7dlzyxXexpAKx1B8UNjfDunZ2
         VTXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735249850; x=1735854650;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wr9rqTNKfrszMFbe6gBAWrnjJVlbfYKXR7FEPGhqS+w=;
        b=fEYuEbSOu+r3P0vtwWGeRbX/VqVEnK1EQqwEjdByt8deST+56zPZTOsAC7kqYJ5ar5
         BAgRRhkPYBmiSuyUa7/f2oqx3OInoNakpFqToE4oAj68uQWbfZBKa9HmZzp/sC36Oh0G
         ZD6R/5qcgb1JufyGvbxGmLy8DBLsfXFimdOWchhw8eb76tyJyciNdPcCMO4xkhyC0Ab9
         OgiNhwqTvD6d4QMzPcJY76A93tBuZuvohEw55ntLXy0kOb4mP2/yr05BYHj6km2K9vht
         /pxQcFXImZt90Sb9z+hqyzztl/omA1L2otAVhC/ojyI9fNEpx5A2kNrxhWTh1qy3isqQ
         m7QQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2w8rRidWynmoBovgD85SRbjM+3sV4qOfhk90KXtz2MyWb0tJK+CDm7qnvMmb7lfgzHWhboYEa5hE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6MiUnBAP2hBRWaOQQklGYRWtWkQw0/H5sT4kSS/pLSBrA+Uvl
	ny0ZHoJ4U+dfMRNL3n8o3L63kIaVg3T98c+f2selsgADFhSKo6PKQ/g4sepZtwI=
X-Gm-Gg: ASbGncs3BpG8V7AcaRbL6oAy7SDpGLDPwAWQPmRV7hBbvJ02VvNPL1E2rhnKey6fN07
	Bv6/Dbib7lAmBsHyP+n6fbILSH3ykcPE6XR8AmoCkBH0hGTqA4WGVyzjx6/nl+uiEuTibZ1e+MQ
	iLk44IMoGP9Mzvy8/urIthjRobZPofzEbgWOSWmMRjGyXUdGA7pj+Xa0qeHE3QrcDhoYlQXV2Wb
	oZgf5WtXyKbJSq3rLnYt5cWysbdRWkONyViS9AI1AlCrUI92nJ2AQruZYmxhtwOKt/KYwLVZ+B0
	WBbVLlzJrIhOLorQ40h0LRIqHqu/ToTB
X-Google-Smtp-Source: AGHT+IGk9ns5G4ClaQIYPLU52mtpz4s/jiWLmd1nFPHeo5VshhGXPfY/Dpcc9wUfE+lHiV9OxDrdTw==
X-Received: by 2002:a05:6a21:9017:b0:1e5:ddac:1eff with SMTP id adf61e73a8af0-1e5e04a0c7cmr37891986637.20.1735249850526;
        Thu, 26 Dec 2024 13:50:50 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad84eb45sm13322197b3a.88.2024.12.26.13.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2024 13:50:49 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tQvkk-0000000Fgtb-3h8r;
	Fri, 27 Dec 2024 08:50:46 +1100
Date: Fri, 27 Dec 2024 08:50:46 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chi Zhiling <chizhiling@163.com>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <Z23Ptl5cAnIiKx6W@dread.disaster.area>
References: <20241226061602.2222985-1-chizhiling@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241226061602.2222985-1-chizhiling@163.com>

On Thu, Dec 26, 2024 at 02:16:02PM +0800, Chi Zhiling wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> Using an rwsem to protect file data ensures that we can always obtain a
> completed modification. But due to the lock, we need to wait for the
> write process to release the rwsem before we can read it, even if we are
> reading a different region of the file. This could take a lot of time
> when many processes need to write and read this file.
> 
> On the other hand, The ext4 filesystem and others do not hold the lock
> during buffered reading, which make the ext4 have better performance in
> that case. Therefore, I think it will be fine if we remove the lock in
> xfs, as most applications can handle this situation.

Nope.

This means that XFS loses high level serialisation of incoming IO
against operations like truncate, fallocate, pnfs operations, etc.

We've been through this multiple times before; the solution lies in
doing the work to make buffered writes use shared locking, not
removing shared locking from buffered reads.

A couple of old discussions from the list:

https://lore.kernel.org/linux-xfs/CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com/
https://lore.kernel.org/linux-xfs/20190404165737.30889-1-amir73il@gmail.com/

There are likely others - you can search for them yourself to get
more background information.

Fundamentally, though, removing locking from the read side is not
the answer to this buffered write IO exclusion problem....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
