Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD5E383B0
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 05:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720677162; cv=none; b=t+vaCH28sw6ckYY4TC4TEZ2oagTlQaA6ToL9w3NaPdffXEcwbHz9F1zHZMS4qyh45POS5Y85WxvcEPIoDF6qQF5HZGk82YtN42RCmnVwCU+YWrR8IJ4WZ1ZUgB8nWfKI10vphT3m7gp47iLzUYIbCf3HGJa+nOylszoELrUn9YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720677162; c=relaxed/simple;
	bh=2GAe9ybnnpmDkef15hr8EdoTTZsqJG8g4qtQzYyUFGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XEC5UlIbpIx1qCxHUPPk7u9MDokMScRdARqSOnCo6v/im2d+mwW4gUejyZfkcQz5nB6qnKVbcVFbYT83/udsZXMBYbanlkK5uH0tSaIIdqOmExT2Hkmxnyfl0CrBtxIYKZqjlZMRpQT510yXQhayfA+ipYB/2xejOjZbJlZsOLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=C6kOEUOa; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="C6kOEUOa"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1fbc09ef46aso3304925ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2024 22:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1720677161; x=1721281961; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aD1kfQ0v6ONTdNx6GM4veJ2yGOBk/Fzfixe0W4OrhUQ=;
        b=C6kOEUOa43REat529yNWgEmBSCIyHc1nrXHdfPFCfLKfQYky1OLIPKP2Ln0QKyR5pQ
         KpaMAHFpq308/fthh0t1C/ZeohvPvFHpoSVpCmzxim0TgD4o0WZbfQwM2j/47w76jVsp
         TgVJavl2/khUq9twt7W1LxctqTMSxe8Em8WUCiJEDaWxf0uyyUSe+pBhHiiw2Q6z8AM2
         88//ZwuIHDM5KtZd2wEP8I3OnadoX/Pejx3t5dn7bb/aBssZyE2BAl4jxsBF45BYz3BM
         s04m8nNSbyVIslkVhxHwx2BiSiNWs+tY2hU269ClHKqWAJeUwlTzvTjIQm/KfO2mdclS
         yl6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720677161; x=1721281961;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aD1kfQ0v6ONTdNx6GM4veJ2yGOBk/Fzfixe0W4OrhUQ=;
        b=aK3BsdW1rVywEQ13FTZGTAoDosRhhNB38c1R/aA3F1RP9g6tHotLcPssPRn3qWJqoh
         +jh8Tto3n7fACvIEU5nlF/YifbD1o1Ylyt47VWN1TtqQl7wzj1kaI/C6IrRm1+eAngVj
         wNopseR7vcYS5LcXBwFOKAwBxFe2KXh5AvEmiWfOKDuUvDOW3BkIbr6rGhNTR9xUkzRC
         BPzPi3xkiCsPk0WYFqTy3EtmPz3ORddlMVEKGqjIvH7CV1/zR10rqUlVgAnRSez2kkpd
         q66veyAuxK35L/QjczDqDF2sng1USRbMxDskvGA801ps8fFk/sVIzP6PcEGYJv9BNmRy
         GpIA==
X-Forwarded-Encrypted: i=1; AJvYcCUN4Ky+sIhdmwMZM0GALmriel0H64W3KG7m4m5qVLtp+5MRKtePoLkggZzCHOVyoemAh3AsEA6epUW2c7aJlq3rKfZijWcl3V8F
X-Gm-Message-State: AOJu0YzWGI0KoC9gdNXyHkIjEH89iMuFCXMPobkvnJCZ7OjpIomNMHjH
	GxFdo0gcOi5jQdmWCek4SXNPnI8X8OvzuGjSZ4zazeOO61awhB4IOZcws8RqlU8dFzQ4CZ8Tcwp
	I
X-Google-Smtp-Source: AGHT+IHThVNFQBJv9601JCSTUsx1AvpbS5CcECi4/FIvLZjRSZaBRSNuUSXsd7H99kbjN7G6SnVVFA==
X-Received: by 2002:a17:902:d2d1:b0:1fb:8620:e12c with SMTP id d9443c01a7336-1fbb6cd198fmr55839875ad.5.1720677160784;
        Wed, 10 Jul 2024 22:52:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6a290e2sm42724895ad.70.2024.07.10.22.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 22:52:40 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sRmjO-00Bi26-1K;
	Thu, 11 Jul 2024 15:52:38 +1000
Date: Thu, 11 Jul 2024 15:52:38 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: update XFS_IOC_DIOINFO memory alignment value
Message-ID: <Zo9zJsVjFX8Hn9JT@dread.disaster.area>
References: <20240711003637.2979807-1-david@fromorbit.com>
 <20240711025206.GG612460@frogsfrogsfrogs>
 <Zo9Zg762urtBzY1w@infradead.org>
 <20240711043614.GL612460@frogsfrogsfrogs>
 <Zo9jSWWE4fP9Icdx@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zo9jSWWE4fP9Icdx@infradead.org>

On Wed, Jul 10, 2024 at 09:44:57PM -0700, Christoph Hellwig wrote:
> On Wed, Jul 10, 2024 at 09:36:14PM -0700, Darrick J. Wong wrote:
> > <shrug> Is there anything that DIOINFO provides that statx doesn't?
> > AFAICT XFS is the only fs that implements DIOINFO, so why expand that?
> 
> Because it'll just make all the existing software using it do the right
> thing everywhere?

I'm just fixing a bug. If you want to make DIOINFO a VFS ioctl, I'll
review the patches but it's way outside the scope of fixing a minor
oversight in a recent feature addition...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
