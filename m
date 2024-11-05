Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50331FF032
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 06:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730789889; cv=none; b=sVmuPs45rR/Dz7wLnWfzFd7xhOzICRryO2SJUoGJrDd0FK5DbHImw8peSJr+L6fcPJAIChn/OsXLsKQC4fdt6cN5txW+nfl6woYOc//UM7SXBxMV23YjgSFLgzczEI5qBjYjYZsoBs8pcj8/8skyEJzxmSu8Cz6px+8s4ph1M6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730789889; c=relaxed/simple;
	bh=GRq/5MxJqPWaQHQqNIrO5QUW+kFA/FJ5frFukYPAlOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hou7KLy7xBc7FTutM9o9MomSOyPcibF4PVc1o6GA9ms2SqRQ9Kip4q895yiDDLC2JJuU0lE0t5YVunpHJ3m5O6kgE2yLMuaIZXGLG9RuY1Z0IpK9yPsNhJL8Y2vpezgugm5ilQGo/Oe3KFk08ZKSJyydjGTn3pQLtQJZC2BZhp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=oZ/7e97K; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="oZ/7e97K"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2e2ad9825a7so3701053a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 04 Nov 2024 22:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1730789887; x=1731394687; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I8PFRGsYeDBn3XKzJQkwWreItQtPwylQr+POiqRsPH4=;
        b=oZ/7e97KlU9g8eTQuXMKdn08M9B09vABqg+htRyhfY9wOgM/i0b0V8hhYjVO71QUI8
         JnrXbNcWEAnk6isVRF+aSXA/jhXBF8Y8vJ8ehYNYOLA8doRBm3Dz0+DKspxjCfKaufW9
         4Q4QOVc0PCKhd6rO6qLKqlU/abiiy3bYKClH3wjRAfI1qR6Ao3JZpVhBn1AS/DBq551x
         j5AIPSPVAzfiJt5ONc6KKpFDTzQOp9lbtg266FQov3eBmPayHQlgl0Q28JrQeets0Psi
         sE67fE3vRTfI/E8Vzhy4/+IthiuUQqfWev96bLAtYI1SCN7ed6OZgfYp6Fy6PUh14m1d
         ybnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730789887; x=1731394687;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I8PFRGsYeDBn3XKzJQkwWreItQtPwylQr+POiqRsPH4=;
        b=F3ccAVKXt/+2zpPBbUY4GZrn4F4pNZRYTK4AMStbbrQ61pRqV0DNeDz/4ua+r9DQWk
         IaME5F9Vpf1zwiYn1ZzgtGhYpnqePFY5wj/XRYxae+SGIEoXe3KqdNCugX+XScqbbMQ/
         e3qs7N5+LPFPIg4E2QBNp2vdjJD0xUCxY5tVTu/7TcrEMTJsgI4KhpdiZtZMZU/G885n
         wG88h696n01Y8dcFGI5DNwv8kJZVqc0Oh1P/HrZerS+RAKKpcI8Aq3xj2LpzxGY3Dk35
         gEXQbZ7J0nZ4AuRMvJJ7g7RY8kEKEYfPQ2jpwi9pMgx8Hb2fBozHZnXDQTjLOnSIJN1j
         N85w==
X-Forwarded-Encrypted: i=1; AJvYcCV6fhLAp2NKeog8OiwEHJf+N9dmlhWeBI7LCLvYdQaSWOq9kvcK1ntUQhDFxX68DwxbNym3p/Pmhqs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHC1C8YdwJipMp8PQ/cBmZAG+t4MuPXOfHMgn5OZbWQjPRuSzN
	tvK6A7Rr6ldpU62fBokj3EZAd81InnzraYw8EVlC7T6E7lf1eXEazCZPKe2lheB2AeCBJ60Hgkk
	v
X-Google-Smtp-Source: AGHT+IH3wwnPDlCFAjUQoY0+mrxedMCXFjjQpTR+mMBTqBiQi/Xsgtqhl0amhzVNopgmIyltdjO9Hw==
X-Received: by 2002:a17:90b:1c8e:b0:2e9:2bef:6552 with SMTP id 98e67ed59e1d1-2e92bef911cmr24290278a91.32.1730789886857;
        Mon, 04 Nov 2024 22:58:06 -0800 (PST)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e92fa262fasm11287424a91.21.2024.11.04.22.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2024 22:58:06 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t8DVr-00AON6-29;
	Tue, 05 Nov 2024 17:58:03 +1100
Date: Tue, 5 Nov 2024 17:58:03 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, Christoph Hellwig <hch@infradead.org>,
	Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/157: mkfs does not need a specific fssize
Message-ID: <ZynB+0hF1Bo6p0Df@dread.disaster.area>
References: <20241031193552.1171855-1-zlang@kernel.org>
 <20241031220821.GA2386201@frogsfrogsfrogs>
 <20241101054810.cu6zsjrxgfzdrnia@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241101214926.GW2578692@frogsfrogsfrogs>
 <Zyh8yP-FJUHKt2fK@infradead.org>
 <20241104130437.mutcy5mqzcqrbqf2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241104233426.GW21840@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104233426.GW21840@frogsfrogsfrogs>

On Mon, Nov 04, 2024 at 03:34:26PM -0800, Darrick J. Wong wrote:
> On Mon, Nov 04, 2024 at 09:04:37PM +0800, Zorro Lang wrote:
> > On Sun, Nov 03, 2024 at 11:50:32PM -0800, Christoph Hellwig wrote:
> > > On Fri, Nov 01, 2024 at 02:49:26PM -0700, Darrick J. Wong wrote:
> > > > > How about unset the MKFS_OPTIONS for this test? As it already tests rtdev
> > > > > and logdev by itself. Or call _notrun if MKFS_OPTIONS has "rmapbt=1"?
> > > > 
> > > > That will exclude quite a few configurations.  Also, how many people
> > > > actually turn on rmapbt explicitly now?
> > > > 
> > > > > Any better idea?
> > > > 
> > > > I'm afraid not.  Maybe I should restructure the test to force the rt
> > > > device to be 500MB even when we're not using the fake rtdev?
> > > 
> > > All of this is really just bandaids or the fundamental problem that:
> > > 
> > >  - we try to abitrarily mix config and test provided options without
> > >    checking that they are compatible in general, and with what the test
> > >    is trying to specifically
> > >  - some combination of options and devices (size, block size, sequential
> > >    required zoned) fundamentally can't work
> > > 
> > > I haven't really found an easy solution for them.  In the long run I
> > > suspect we need to split tests between those that just take the options
> > > from the config and are supposed to work with all options (maybe a few
> > > notruns that fundamentally can't work).  And those that want to test
> > > specific mkfs/mount options and hard code them but don't take options
> > > from the input.
> > 
> > So how about unset extra MKFS_OPTIONS in this case ? This test has its own
> > mkfs options (-L label and logdev and rtdev and fssize).
> 
> The trouble with clearing MKFS_OPTIONS is that you then have to adjust
> the other _scratch_* calls in check_label(), and then all you're doing
> is reducing fs configuration test coverage.  If (say) there was a bug
> when changing the fs label on a rtgroups filesystem with a rt section,
> you'd never see it.

Nobody need to overload MKFS_OPTIONS or unset it.  Local test
configs are supposed to be passed as function parameters, whilst
MKFS_OPTIONS defines the global defaults.

When the two conflict, _scratch_mkfs drops the global MKFS_OPTIONS
and uses only the local parameters so the filesystem is set up with
the configuration the test expects.

In this case, MKFS_OPTIONS="-m rmapbt=1" which conflicts with the
local RTDEV/USE_EXTERNAL test setup. Because the test icurrently
overloads the global MKFS_OPTIONS with local test options, the local
test parameters are dropped along with the global paramters when
there is a conflict. Hence the mkfs_scratch call fails to set the
filesystem up the way the test expects.

IOWs, Zorro's fix is correct and the right one to make - it fixes
the failures here on all the config sections I have that have
configs that aren't compatible with RT devices.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
