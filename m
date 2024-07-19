Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE58C147
	for <linux-xfs@vger.kernel.org>; Fri, 19 Jul 2024 04:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721365167; cv=none; b=JSm8vOm/Celuk4t1uyc4VPe+dxacNV2rq+yCwdT8Rt9XHMQ/QOswx+kj7IGsA2QA0D2+bD3qg1ayYWfE6DP0xpBuZ/hNXz9KcTMGkWTDlm5KcoCX7QSyFtjBme2Qj6BlhUX4zh/H2ugSA8+HYciRDRQoso8qaXKPS3Rp6mcFPNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721365167; c=relaxed/simple;
	bh=rddWGhrZf6BbDgj4gQVtfSTzEA5NWFOql4aQT4D0Mt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HSNNPwLQBYHo9pxDJ/JqEygaV5BN7HE3OXElHJORFMNoj8yltCCC0QRKvjBBgAf8JcvUKGZud7TH1I3POkf+dTcKQ/ZxYiftQUmKokYHg8tZYieRNveHrRiwjSsd5cPPeCyjizggNnJxxyvvguHAUViUq1LEkBr8mQVMQuj0CwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=wouDPcFc; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="wouDPcFc"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-656d8b346d2so1024796a12.2
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2024 21:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721365165; x=1721969965; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0tYRc4VvMXK45r7WoKemJ0UrsyCXesVpzvDjA+dvtCg=;
        b=wouDPcFceeHCdGr8FdKx1/K3Z1xuyDAQ/v/TUhnH57/pBTvo2zp5KFWXvP7eTrKS2A
         n0uI92gyljBQYGu/PmQBPUEUpmB2PFxoE8vKmsSnVjWLDzgVduq9gSRoGrgWccfwX5ub
         xeZrSQC26E0ZFyxiKpSkV5oTWtfptvwy/Kyv45xv37vyZnt4r9OclDYni9LpofpUL90/
         IEE6fF1wd6Zsrh8Jxeegd3IcW9moNuOep660rFThD/cFGd7bpfsBvZ5Y1o0jYJPbIcU9
         pi0l1DOKod5kTrUaodCn/5urGObw48QTLhCpuybQfc9Z098a+o6fGWe5M5qXBlml18Zv
         hNmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721365165; x=1721969965;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0tYRc4VvMXK45r7WoKemJ0UrsyCXesVpzvDjA+dvtCg=;
        b=H5UdvIPswafrUSYNEpkHjBn+DTljj2OR/GlcACGjtJFn6bmsjfP13rC5CrAkGlQY+t
         DY8pmiyYASh9DXAO+P1UZphUKbx9fUpa7t/jX8hc0wWpbhXY4XcHnZQHZTUHkqVTJSrz
         vMlKdUXWhBioaN4+Q6uEmxY5FzUzFI/PI2P6nexYLKsfDWkJy8K+0mhWMDt+Ae7BBtSO
         tEtagQNs1MojPvsdChH2EvoCt0JtL8QzYmmsDnicvwlVpXT1AFX7+fne/T3EzGz2Y3kg
         pFVeX3RIK8/5WKdWti9upkf/jYJmmppnxZWp5corn6TH4dqjCuv+C3gdIRcfpP1NSt9t
         r6lg==
X-Gm-Message-State: AOJu0Yx0TV8soqsaRmoJ71eGvBHueIAcGONZF73kPgzsaPubz4eVK9M5
	yfeNWwxnTpxtP0K0P7aKKIZG4f/lSf9yMV7bart6wVUmxVXHxRAz8Fm41RCeNNub6pvE4rrQb2D
	y
X-Google-Smtp-Source: AGHT+IGnWqKEHFaBfeRKZ32U59thhRVTYYs2Hg5SoEhWhFPjD18E7QgFn9SrdRCow9zoSzKm8tvpOQ==
X-Received: by 2002:a05:6300:4043:b0:1c3:a63a:cf01 with SMTP id adf61e73a8af0-1c3fdcc8b8bmr7322457637.8.1721365164613;
        Thu, 18 Jul 2024 21:59:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd64d071dfsm4694575ad.171.2024.07.18.21.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 21:59:24 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sUfiD-003Rbj-0v;
	Fri, 19 Jul 2024 14:59:21 +1000
Date: Fri, 19 Jul 2024 14:59:21 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/9] spaceman/defrag: pick up segments from target file
Message-ID: <ZpnyqVLX+7K7Xyxw@dread.disaster.area>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-3-wen.gang.wang@oracle.com>
 <ZpWzg9Jnko76tAx5@dread.disaster.area>
 <65CF7656-6B69-47A3-90E4-462E052D2543@oracle.com>
 <ZpdEZOWDbg5SKauo@dread.disaster.area>
 <13B63D08-4EC3-48B3-B043-D38DF345611F@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13B63D08-4EC3-48B3-B043-D38DF345611F@oracle.com>

On Thu, Jul 18, 2024 at 07:03:40PM +0000, Wengang Wang wrote:
> 
> 
> > On Jul 16, 2024, at 9:11 PM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > On Tue, Jul 16, 2024 at 08:23:35PM +0000, Wengang Wang wrote:
> >>> Ok, so this is a linear iteration of all extents in the file that
> >>> filters extents for the specific "segment" that is going to be
> >>> processed. I still have no idea why fixed length segments are
> >>> important, but "linear extent scan for filtering" seems somewhat
> >>> expensive.
> >> 
> >> Hm… fixed length segments — actually not fixed length segments, but segment
> >> size can’t exceed the limitation.  So segment.ds_length <=  LIMIT.
> > 
> > Which is effectively fixed length segments....
> > 
> >> Larger segment take longer time (with filed locked) to defrag. The
> >> segment size limit is a way to balance the defrag and the parallel
> >> IO latency.
> > 
> > Yes, I know why you've done it. These were the same arguments made a
> > while back for a new way of cloning files on XFS. We solved those
> > problems just with a small change to the locking, and didn't need
> > new ioctls or lots of new code just to solve the "clone blocks
> > concurrent IO" problem.
> 
> I didn’t check the code history, but I am thinking you solved the problem
> by allow reads to go while cloning is in progress? Correct me if I'm wrong.
> The problem we hit is (heart beat) write timeout.  

The reason this worked (allowing shared reads through and not
writes) was that the VM infrastructure this was being done for uses
a sidecar write channel to redirect writes while a clone is being
done. i.e. writes are not blocked by the clone in progress because
they are being done to a different file.

When the clone completes, those writes are folded back into the
original image file. e.g. see the `qemu-img commit -b <backing file>
<file with delta writes>` which will fold writes to a sidecar write
file back into the original backing file that was just cloned....

What I'm suggesting is that when you run an backing file
defragmentation, you use the same sidecar write setup as cloning
whilst the defrag is done. Reads go straight through to the backing
file, and writes get written to a delta write file. When the defrag
is done the delta write file gets folded back into the backing file.

But for this to work, UNSHARE needs to use shared read locking so
that read IO can be directed through the file at the same time as
the UNSHARE is running. If this works for CLONE to avoid read and
write blocking whilst the operation is in progress, the same
mechanism should be able to be used for UNSHARE, too. At this point
defrag using CLONE+UNSHARE shouldn't ever block read IO and
shouldn't block write IO for any significant period of time,
either...

-Dave.

-- 
Dave Chinner
david@fromorbit.com
