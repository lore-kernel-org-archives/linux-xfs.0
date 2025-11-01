Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25132BEC53
	for <linux-xfs@vger.kernel.org>; Sat,  1 Nov 2025 09:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761989669; cv=none; b=YKIT8VnbuOdnSNuMSgWAlIr1KVXLW4tHcLJ8Kfzuylw6rE7YZdAZzVSuv10ZTsTCks0r2jTdOkfU8gU/Hlaf2R2/fnHyDwiS/IPb0eGRWuX3RxoGFG/7/IulZKL0SkEwpvu53NiFQXzbBb0EXhB2P3bexY9fHl8PK6k5QdrccHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761989669; c=relaxed/simple;
	bh=OvSXWv59YMDB5w77LCXU4APAUw6OWmhMXtgLwNAuw/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VOsGq7mM4/LVixLxbqnYIZ+mWIVwAnaUDtbj9ODiT4l7pdl9uuus2qVZAJGmUMXmAcffhX8jAHpKT3hhn8MpWp9ucKw3WoTsink35DPExbO7BqlQkADBxMmVviIQeeQi8vDuY3ItnMGmH+X3HPzFj6ITYYRupYMJRo7Tb7rx3+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JHWGNTa7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GLPObivd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JHWGNTa7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GLPObivd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761989666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6I8+PYpj4VSzvWtRvWrniQOXdcXFUBE7kuDCLe/jFhU=;
	b=JHWGNTa7R7l34+AS/ZQ4D/4/nnw0oEnRztcBrTNNu8L53o6/gP4aP0iwCZnWFh/ycrRjwm
	RE+L3pzgRtAVYRee3ieS0zS10m7Jx8zj9obnNTxkonKWYlTf3XJEc//hPdfalWdBas9FzL
	frdOTVQTiIWewPg7mjGBMb7XuinrNd0=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-u0-TAv0qMz2_p-3kK6fs1g-1; Sat, 01 Nov 2025 05:34:25 -0400
X-MC-Unique: u0-TAv0qMz2_p-3kK6fs1g-1
X-Mimecast-MFC-AGG-ID: u0-TAv0qMz2_p-3kK6fs1g_1761989664
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7810289cd5eso7633272b3a.1
        for <linux-xfs@vger.kernel.org>; Sat, 01 Nov 2025 02:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1761989664; x=1762594464; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6I8+PYpj4VSzvWtRvWrniQOXdcXFUBE7kuDCLe/jFhU=;
        b=GLPObivd6JkbEBhc44QbfhzSRwXlASx6BHP4y843KLtFISh5zoDSah4MO0/pCMl/Lp
         CjzvTR8kK/6rrbMLZ8LfBWRJxq2tAdm7V2hpCuU0woDotykGoYb0r63T811EUxWDcTCg
         Vghs10utuEYwRLYRh4RcOCojoC6lZGzPv6Z1AmKITX1Wl+OBZEoy/joQFWuc/a2N3P6/
         I0LlOMdWOqBMVmZS1Bh7zsas6KzdaGHTgEN9XF1Si6F/mncapbnNvYvL/vfyltXLKghp
         C+/v2Qqf5BzpbaaOKWTQcCEpCqqI/Zf0G8m7DLM13sKHH+oFgnL2jDEg3ZnM3Ol+vVlt
         cAhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761989664; x=1762594464;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6I8+PYpj4VSzvWtRvWrniQOXdcXFUBE7kuDCLe/jFhU=;
        b=gqYY8vRC+Gxc2FhFNWedmg0cEcYAE1xn94fIvGFGYB34jGmPE4XrM6SOb8nY/Qjcy9
         5LSVRpD0MQFWlXnX0Uu3Eia0dDRd07prFWyj6gVPPnwZJ7Xq56Jo60p+wLG61s9iYZIs
         hwQCR57dQNZBaEau9Fkrh1iBYy92A+rfNq03tHSF/EOmaM4IQdg4uDXmR0haSJLu0bZM
         hcmJfaQEPGD6DXRxVMdRfJUGRXfKoPlbFyzqEYO8yGzw06iao4uwu31ZLmunbMKUgea+
         Du4Td5uiA/sGftV+ZLZfFH609ippOPh4Uundv7FXAUTVXsDZELAdIS1PWu5/RYtx+0L/
         HVYw==
X-Forwarded-Encrypted: i=1; AJvYcCVH08SpqtLU25UXQWRXzYsAXLYn19MsSCASvF5uGpkrxMbTTdEAZ+uMwq/O1DH5TrRf6dO4nagLCVg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWMf2QdP+rEV7LTBMEVKbljKRBpKJoHt9/+89GwU0gYJSUOedj
	SsBEvWim3UPwu+DdkXG7qUD/hGHEp4fxjji+1KwBl3/BVR3EqjYMC26Rv8GNatSKZyEU9ydXqWc
	C1x/izMWcMp8UzG7Tl4cH0cJ515rNHd7qoAYMZAdyfq0eHqxw2KN3f/w3D44nkw==
X-Gm-Gg: ASbGncvcPVQo2Vo33wXNT4WLGB4eLGmOOm5nke0NDRm55d3vv5u8TVWasK8klgeVSPr
	Q1OKBA0hMOlCP8kho/Nlj38PEO36l+ZoSLuCsq8QXq3vvoscZVE0rg3zUZzglayJyTfIGMiv2ri
	5v+NRSFqYnxli/9n/iVd56K8Nd5bVDz4HmjR3H1e21kE6Y85y50muIloOEOovTpyGZj1A5omCU4
	btqV35LZiuD9nwCRYyiw1C/I/zwJ4PdPx7NQtKKdpnKZcvDu/SpJnrMDgVwjdDs1/Lu6S41Rfsw
	a5i8g1ieh/n/0YNtG32GuwwlgI1uYq3yXK0eQqp950FVuZlqkqiYGf2sRiBpITL5pKu7aO9Vbt+
	uFhcogZhX59c+4ZhmgbfAASou9wcZ3I8OxUje+uU=
X-Received: by 2002:a05:6a20:5483:b0:320:3da8:34d7 with SMTP id adf61e73a8af0-348ca75c030mr8773927637.22.1761989664192;
        Sat, 01 Nov 2025 02:34:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEf4BPTw+ye+CnUs6ChgmaJyZ3i45UwrxJYl8zw36ypBb5uUyo/awyluzaX+K9gQv6v6V3nUw==
X-Received: by 2002:a05:6a20:5483:b0:320:3da8:34d7 with SMTP id adf61e73a8af0-348ca75c030mr8773902637.22.1761989663594;
        Sat, 01 Nov 2025 02:34:23 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a7d8d72733sm4765002b3a.21.2025.11.01.02.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 02:34:22 -0700 (PDT)
Date: Sat, 1 Nov 2025 17:34:18 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] generic/778: fix severe performance problems
Message-ID: <20251101093418.wxv6w6diisvflrrp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
 <176107188833.4163693.9661686434641271120.stgit@frogsfrogsfrogs>
 <aPhbp5xf9DgX0If7@infradead.org>
 <20251022042731.GK3356773@frogsfrogsfrogs>
 <20251031174734.GD6178@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031174734.GD6178@frogsfrogsfrogs>

On Fri, Oct 31, 2025 at 10:47:34AM -0700, Darrick J. Wong wrote:
> On Tue, Oct 21, 2025 at 09:27:31PM -0700, Darrick J. Wong wrote:
> > On Tue, Oct 21, 2025 at 09:20:55PM -0700, Christoph Hellwig wrote:
> > > On Tue, Oct 21, 2025 at 11:41:33AM -0700, Darrick J. Wong wrote:
> > > > As a result, one loop through the test takes almost 4 minutes.  The test
> > > > loops 20 times, so it runs for 80 minutes(!!) which is a really long
> > > > time.
> > > 
> > > Heh.  I'm glade none of my usual test setups even supports atomics I
> > > guess :)
> > 
> > FWIW the failure was on a regular xfs, no hw atomics.  So in theory
> > you're affected, but only if you pulled the 20 Oct next branch.
> > 
> > > > So the first thing we do is observe that the giant slow loop is being
> > > > run as a single thread on an empty filesystem.  Most of the time the
> > > > allocator generates a mostly physically contiguous file.  We could
> > > > fallocate the whole file instead of fallocating one block every other
> > > > time through the loop.  This halves the setup time.
> > > > 
> > > > Next, we can also stuff the remaining pwrite commands into a bash array
> > > > and only invoke xfs_io once every 128x through the loop.  This amortizes
> > > > the xfs_io startup time, which reduces the test loop runtime to about 20
> > > > seconds.
> > > 
> > > Wouldn't it make sense to adopt src/punch-alternating.c to also be
> > > able to create unwritten extents instead of holes for the punched
> > > range and run all of this from a C program?
> > 
> > For the write sizes it comes up with I'm guessing that this test will
> > almost always be poking the software fallbacks so it probably doesn't
> > matter if the file is full of holes.
> 
> ...and now running this with 32k-fsblocks reveals that the
> atomic_write_loop code actually writes the wrong value into $tmp.aw and
> only runs the loop once, so the test fails because dry_run thinks the
> file size should be 0.
> 
> Also the cmds+=() line needs to insert its own -c or else you end up
> writing huge files to $here.  Ooops.
> 
> Will send a v2 once the brownpaperbag testing finishes.

Hi Darrick,

JFYI:) If you don't mind, as I haven't seen your v2, I'll try to merge this patchset
without this [09/11] at first. Then I can merge another patchset "[PATCH 0/3] generic/772:
split and fix" which bases on this patchset, and give them a test.

Thanks,
Zorro

> 
> --D
> 
> > > Otherwise this looks good:
> > > 
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > Thanks!
> > 
> > --D
> > 
> 

