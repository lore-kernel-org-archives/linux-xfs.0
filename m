Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DC3423EA7
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 08:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790067204; cv=none; b=hvA3cp+YgsQ4fL0KVoeWKOUMrCyDf87LWspnHtOqUTgJVvCKIPFeV/fzDZV0UVWLeZK4BNEhR9w13HxNHIoAdP4MvacklI0Z1a9ulWtR6/10N15qLdL7TznA7SPE/FhfF5hv1TV5rqtrL565LEFuMZHyadD6J0UrAbIhPVJc5PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790067204; c=relaxed/simple;
	bh=cwkQkF8AomV2dnbKJf7T2kOh90w6b9kYZ0Q3BS/MIos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IUu7LG2pZTeiYptQykSrwv+KoLhthQmnHcSFXVwk0aZiRbPj70JkxKW/hm3fV0a1oxr93wtvlcyajpD3RO74ZJpSWW7eQ3QzrAdMuyyJhi0gLrafdX5Uf9N3U+aun5OFOxn5mSDkwpLVbpRE/hFuypjDCgAWy2EHY0A7geD+UL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U3uYbXx/; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U3uYbXx/"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccead2aecso18783735e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 01:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790067201; x=1790672001; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0GErKr9K3VAL0iFgFHZZrAHFzNuomMjoi+stMILpMQk=;
        b=U3uYbXx/8vyGkMOwkCoDp5bAjLPUR7AWh0B6hx3lKkSU4aa9YBNuFshTbmkMp/3Vay
         uDMRe9fj63AeYQ/xJSeekI73IN3cQCzJkwan4pcSVs8SFBX33iuytK7FRYf6RmmpS0lW
         pJsyz9k2hItYA0XOQGc8/jrN5SEs1Lz1yvAon15q+qciLMR42iylsMuQhcrudqxwVUy8
         PDotFqE3vGXKJwhE+I4Gzb0En3HBd7mk//jgm4yL796SbW7ISBClWBqRyFWVyU/Bw7RZ
         OdJcyepTOcOsEJuzIMJQ3Pa6VwB8qk2YW27vFLs0K3wUN2DkaT1NT7rt16BegZqDqYht
         VHFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790067201; x=1790672001;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0GErKr9K3VAL0iFgFHZZrAHFzNuomMjoi+stMILpMQk=;
        b=Nu/8PBpiW6iZvZNpJ7tBOBOL9JYV+f/iL+xZ/vUBmffXQmV+KkCeX8CmxRwekZwe7p
         uwPQ7DEpijP1A4ICWqPaqbB6s6KQ8F+/FkFnrKAwwTzcXiBE2gYfwtKK8oYe13jSS4ro
         UCo6vKdtgJrEDOHrn3OdxfvCHEOaN+PTEkMD53kNO/rvMxlmD+ktz26MimBtlQ0svQlH
         PBqQqSsAo0qyoAM7OhEbsxBH9aZ2eu49TQYZS3WDXUvbu4PI8+oSD9N4+eFs8Cwb+noa
         5jGFpKDRa7XGTiWAoHbPieXkiji7BA4zTQqtRyVkxqlQQo32Ywsvhk76MmO1ojQBd01z
         ujrA==
X-Forwarded-Encrypted: i=1; AKwUvByDHMG41bFPHt/BwKSPZpD99xr9QHHMyNeefXAXlbLgskx3dLtdGho5CCqDZMAqQeHEVH1LSIK8NVE=@vger.kernel.org
X-Gm-Message-State: AFuF++kBC5zpyFS/Crglgs2sXcS6w81zZlcugSae9ivcbSesoVsDuMHG
	MM1LagzjDonWh+QuaAn1/9tQsXS3gEKvXUyjgqi6/cY1YMpojneN28rS
X-Gm-Gg: AYBFou2hcCLGBVw6h+2Y3gn1MDvdYcuakgX1BALNLw2VrHpARrIu3P0NuO6u6xHxGTG
	xuGZbm4xm8LgaQDesIObvlp+8j6y2iPo75hz7Rcuwx7gGQXppiGvh3dOO0Jxet8sXgwhXroiYBD
	exGmm3FIFHiclR5XzAWsT613vQKc3Rb2oQENgQu01ytuBXKz73GLP4uCpCZS3sIiXvjoymJBG4L
	THX6+aL+8X/qAmLi0bykFsB6XuGOQhiro7txgxezpSW8HunUJTUaVsBYE3n6CHJH3cm3Be1xdfT
	Jd2ESLjz3cKgq9mV40+gdZ2Imx5KwPOk8hX04K3NFsheA7C+4vhZF4ANSXuxSk0r+pVtr2NGpfj
	vRmTEsB0k9MFSMQX50+TE8siA22QFrkDNVnttjA3iTb1B8ymMq63cBvSgoVeVhrZt7T2sQLRaPO
	+OHGS8MV9yLUGwY/3jr6gclZBmVaSeqmQeGGJHB4ypuyPYv8cbd/Kspnjx8HAY/zhb+ZJ+5eJ0Y
	TWsvDWAW5bEqDYzyhurX6kgIXL0bepxViRx9EIes6PDZidxN+9Ssq3uFxmKEQMcBig26G74N+Tq
	T/po
X-Received: by 2002:a05:600c:8584:b0:49f:cbf1:e76d with SMTP id 5b1f17b1804b1-49fcbf1e9a5mr119933255e9.0.1790067200729;
        Tue, 22 Sep 2026 01:53:20 -0700 (PDT)
Received: from andreayoga.localdomain (93-42-14-189.ip84.fastwebnet.it. [93.42.14.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdad36439sm52688975e9.6.2026.09.22.01.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:53:20 -0700 (PDT)
Date: Tue, 22 Sep 2026 10:53:14 +0200
From: Andrea Parri <parri.andrea@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] iomap: don't resubmit an ioend after
 ->writeback_submit() failed
Message-ID: <arJB-tAZTbcuPaZJ@andreayoga.localdomain>
References: <20260921083133.2960-1-parri.andrea@gmail.com>
 <20260921083133.2960-2-parri.andrea@gmail.com>
 <20260921222953.GM6283@frogsfrogsfrogs>
 <arITXTsUhrA0N-qr@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arITXTsUhrA0N-qr@infradead.org>

> > Do you need to do the same thing for the ->writeback_submit call in
> > iomap_writepages?
> 
> No, after that the wpc is not reused.

Matches what I found too, thanks for confirming, Christoph.

Darrick, I'll pick up the v6.17 stable tag for v2.

Thanks!
  Andrea
