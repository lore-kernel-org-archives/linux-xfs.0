Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7482F2A
	for <linux-xfs@vger.kernel.org>; Fri, 25 Apr 2025 17:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745603906; cv=none; b=fWSpgU1J9bjxikdakJZYB67ELT8vulzi8CBz5SRwZbBWMAmQEZ/gNlF2lvMwKh1Q2bWTOfhiJgh0DSDXnXwR8uZ7xlhl2rQdaO9v8QcK+NSX9zl5oJlJ8pXUCc0b5OEHTPf/N9DRj9ougm4ZXhU6PSjabQ2ZK4tZimOTnljhSqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745603906; c=relaxed/simple;
	bh=nTEwwDmof5emSYLOMGSkzlLlqj60iEnPJ6hiNV3Xqqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kWkhSkTM70b70Dm1Z0ilL2PiAboSj0Y9oDKsFUb+F35f2aiNFrkO3EqkltgQpX2zJOWNdwIqcIjMWQmCPkbS6ST1g2amiA5ccaCBG88Y+g2fNgDNOEFwlMlCUfFihk78HRzKwP2+TfMM6L35pds+KE4SsfbHLBNeLPjWiZqjQjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k+M1nFvs; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k+M1nFvs"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-39ee5a5bb66so1535992f8f.3
        for <linux-xfs@vger.kernel.org>; Fri, 25 Apr 2025 10:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745603903; x=1746208703; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PEWrr0hDsSX5tuaeQjZoHIVzur2oO9oFfkl634sxTZI=;
        b=k+M1nFvsnnRR5Geu4AsWmnajG0mALuK2HpmxQy/YYxppqdwETS0Xu9QNKR9Z8rIokv
         MPCUbbxW77XB0/mTfJKZmHBtIKUHv+SN92cD9n4c7tgR3+jyeeC7+TgfBbHS2XYJ74gU
         bfJpAa+XlJMn4Ve6SQEBTOyjaMd7ihACEkj6Awzacmm5fFi3bz8x5CXM86D3qrI2FDts
         vFQ6g5KnYWzGW+Tom8fJJdtGTTWoVEU3OlYP4zhs3uHNHKw/BVQZwYkXFcEiUnVBL6Dy
         F7pOww7cyw4i7zwY3YbHdFBfM6hrikh807sJceyirY9OKzjn+c1PbKUPo8i9ndJXB8H1
         SE0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745603903; x=1746208703;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PEWrr0hDsSX5tuaeQjZoHIVzur2oO9oFfkl634sxTZI=;
        b=krQebDGuOWI+qszTh+uAERRs8aYSi7YlKZ1z8eJH/rntpZDDDqWnIWLXmAQNRA9X7Y
         5GDOKgJILgbOj2ARMQD0lj/vYf9Soq9C8kpU8pbdJRKP9ZVEv0/wqQjO6CrzeSRx7qEb
         Dr5uEjbqUT4ywyCaFbQI/LvIVG9kkB5ki08ibpux+yqH5T4E2PntKQx1/a2CKM4KUVmn
         faw4NVuv4wWfKbbnXA/suUAm6C3LT56Ra6SqTJwRUpgEIlyINUT6chlbenva8bUyEncY
         9CwNDltmQWSS8Qb6GZmS7veSnya5N9xFFtEiIA+c+MbbATFATEal2oFXJA3Tw/7PVh3U
         sGTQ==
X-Gm-Message-State: AOJu0YwO2lgnXWI2SEp8UJaRXaN4YitKTWANPCOzxqnRbRvYeqUI75Ic
	8CEr58jMUYuAeJPAtlKcm1kv8Tvu9r4WfVTzDtR1l+VZexh+QACmTeAzhxxF
X-Gm-Gg: ASbGnctRRkbLGMeWkhSe3rlK2eiBVfEiiLXX4vsedNnjbqn5ugPpXlI8mdgLvAuHeJx
	j7daN7zGrp+s+yh9lTrAhL6LGfXUYW+JFF52MtfwjjX8YQpPM2WSfO9xR/Eai+h9ZT2mVl2JfS3
	XCoN2Ph5b+diFKM3Zo8kPMogp0fi6h+ib9sJ5SmFRbQO+21UyR0TauQc49OMtBvVXRLO1c65ISg
	mBKjRmue/sS7VjgwkJrV886/UAqs9FczlrObzwwEXWHdnmw2SVP1vS1rUn+SD4KD5hxfFMC7QOI
	e1PZurdv
X-Google-Smtp-Source: AGHT+IHpMNPH6mtI6oBeaAgKv+i0lExKw780OWSn6i/x5h1SaJMfFQF6TKJNPQ2RlbmKT1p2JiAmqw==
X-Received: by 2002:a5d:648a:0:b0:39c:dcc:6451 with SMTP id ffacd0b85a97d-3a074f00c6bmr2815351f8f.43.1745603902633;
        Fri, 25 Apr 2025 10:58:22 -0700 (PDT)
Received: from framework13 ([78.211.184.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073ca497esm2982382f8f.24.2025.04.25.10.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 10:58:22 -0700 (PDT)
Date: Fri, 25 Apr 2025 19:58:19 +0200
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev, 
	smoser@chainguard.dev
Subject: Re: [PATCH v6 2/4] populate: add ability to populate a filesystem
 from a directory
Message-ID: <uyaizy2qbpg3ds3zepu5fzccp2zqioexp7tvnziyeayjhzpnph@cdv3gg5mr54m>
References: <20250423160319.810025-1-luca.dimaio1@gmail.com>
 <20250423160319.810025-3-luca.dimaio1@gmail.com>
 <20250423202358.GI25675@frogsfrogsfrogs>
 <vmiujkqli3d4c7ohgegpxvwacowl2tdaps6m4wyvwh6dcfado7@csca7fs5y7ss>
 <20250424220041.GK25675@frogsfrogsfrogs>
 <aAuJtnJQXOlZ6LLi@infradead.org>
 <20250425150055.GM25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425150055.GM25675@frogsfrogsfrogs>

Thanks Darrick, Christoph for the replies:

On Fri, Apr 25, 2025 at 08:00:55AM -0700, Darrick J. Wong wrote:
> On Fri, Apr 25, 2025 at 06:10:14AM -0700, Christoph Hellwig wrote:
> > On Thu, Apr 24, 2025 at 03:00:41PM -0700, Darrick J. Wong wrote:
> > > The thing is, if you were relying on atime/mtime for detection of "file
> > > data changed since last read" then /not/ copying atime into the
> > > filesystem breaks that property in the image.
> >
> > I don't think that matter for images, because no software will keep
> > running over the upgrade of the image.  Also plenty of people run
> > with noatime, and btrfs even defaulted to it for a while (not sure if
> > it still does).
> >
> > At the same time having the same behavior as mkfs.ext4 is a good thing
> > by itself because people obviously have been using it and consistency
> > is always a good thing.
>
> I don't see where mke2fs -d actually copies i_mtime into the filesystem.
> In misc/create_inode.c I see a lot of:
>
> 	now = fs->now ? fs->now : time(0);
> 	ext2fs_inode_xtime_set(&inode, i_atime, now);
> 	ext2fs_inode_xtime_set(&inode, i_ctime, now);
> 	ext2fs_inode_xtime_set(&inode, i_mtime, now);
>
> which implies that all three are set to a predetermined timestamp or the
> current timestamp.

I'm going to set them to current timestamp as a default (so noatime,
noctime will be true by default)

> Also while I'm scanning create_inode.c, do you want to preserve
> hardlinks?

Right, will work on this too

> > > How about copying [acm]time from the source file by default, but then
> > > add a new -p noatime option to skip the atime?
> >
> > I'd probably invert the polarity.  When building an image keeping
> > atime especially and also ctime is usually not very useful.  But that
> > would give folks who need it for some reason a way to do so.
>
> Either's fine with me.
>
> --D

Perfect, I'll default to current timestamp for [ac]time.

Thanks
