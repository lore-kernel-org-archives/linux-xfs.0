Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C6337B
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jul 2024 00:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721089775; cv=none; b=D/dNqbJgrokhLn6zhvPU2uZxri2NyRlscVzO8rJ2M07bMpyMldFT3RUDcuDKbZTPdODty8+T6QNA0/mFXaJc1BFL4x2iLecMhP3+mOPYiUppzZo10a62HUcdejGIzx60RP/s7p1JXp6JzV0/DQK/y3q+s74wqJk/BIixhx9mY3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721089775; c=relaxed/simple;
	bh=KfDLSHdWTQsuizXSTXXCu5W8KRVT3wK48s1cg0wCxCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kVrvg6uUIwGYoECOtDAtTSv0TlwFDp6zOdseDW+nUY5W9BukVenu5LFg+ATNEfqU804Zqadt4FMLuRzcziY0zq0gpeyU4jLT8J4YB0FoVkqhDjfUPtCoQYXuxJ2cPnUsIdizuTa7sAUMhE9d97Q93+L/f3pSr/5BvbK+uuUg67Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=YvEg9U/P; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="YvEg9U/P"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5cce7626c87so1423332eaf.2
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jul 2024 17:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721089773; x=1721694573; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4g5h0f8017//9c96cX9mfFXA3zsA9fyHeMlt6kxHRWg=;
        b=YvEg9U/PyYgO3YWC40XI4hW2PhHPh8fF3VYgAmZR7nCFU2LYOFPMpRbswieZKwAqgO
         BpRa3XWTv4JD1f4tnHlsCMvTEdG6FzJ/B6DDo9ymj8/w+m/YOmq8sv2LorFhPvNo9OnD
         9L9kGMxSHUNpqkI8FQclhkoze2HkfwAAjnbx3DUrLah3/jopP8TnlgXESiwluGI9KEOD
         29/fXC/IMdVA7v4tsjCrQhKZcx1fwPqVAVXP8+B3zxDkmzdHwhJ3u/9TxI3FWqYUFhIb
         8DmqEMVqMOkJfAWohOhh98dgD/zAR9H5ElymDFwHkN23NeNF/bdccCyyexeW1au07zIg
         f4ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721089773; x=1721694573;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4g5h0f8017//9c96cX9mfFXA3zsA9fyHeMlt6kxHRWg=;
        b=TAMRbOAK6o1TBPOZjvnWGV6rEwUoMFQaXaAMTbS8mpv1TR1m10C8MERXdbqzr3ZtUy
         yw6bywbFnG5VPRORV+Ovljfx0D0nQFtpqiuO0fXUXPANKMW8OUppC2m2Lh/YlCvLNPE9
         ELZgQMpuCMp6IRozrDLxbkdUXGTRRGwnvCXK+DMbTzwcFISLIQAc0lzBOKyxtwdzaFUp
         Dv4tDYVU+Ixi366WJ92BLx9qHgkgn+6qPxQrMTmY4cTeD/+dtg5Q5ESIrGIApgJBj29f
         J0q2iPNkEX1d7NPIoWtKMgPDzDAWfFJN8PTt3eUZ1olygS2jdrfM0LtbSnqoI27a87PX
         JjbA==
X-Forwarded-Encrypted: i=1; AJvYcCXvxsx+K8RAMLPN2ii2JiHOoadXn6Lec4tLkQhYZkp5meUEUJP33FI17OXCkq1BSJrlckeWQ4q9PdHNJN2dOMovl5cTo/RwyeF9
X-Gm-Message-State: AOJu0YwM5XHOyKY/XB/w7+fnaaQ33KGmi4VzJfy7K6n4N8JgTMpfTfi9
	B3u/Q0Ylz4VkfLDGxE3TwB+vQL4tQgGSUCHYsft1AjcjXoSo+LNZVaQWPVO0/pI=
X-Google-Smtp-Source: AGHT+IF0w5ktxP9cMsiwqzclGeESUO21UNiz9xdpt5nrq8FqmwRmuhmFCzOPAZSzYGqRexDJdU1WNg==
X-Received: by 2002:a05:6358:7f11:b0:1a2:5bf6:2260 with SMTP id e5c5f4694b2df-1ac903b7f79mr44834355d.16.1721089773307;
        Mon, 15 Jul 2024 17:29:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-78e32b6ba5asm3929974a12.1.2024.07.15.17.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 17:29:32 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sTW4P-00HIwj-23;
	Tue, 16 Jul 2024 10:29:29 +1000
Date: Tue, 16 Jul 2024 10:29:29 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 9/9] spaceman/defrag: warn on extsize
Message-ID: <ZpW+6XCI4sf6kC+n@dread.disaster.area>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-10-wen.gang.wang@oracle.com>
 <20240709202155.GS612460@frogsfrogsfrogs>
 <3DC06E8A-486F-44D3-8CEA-22554F7A5C7E@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3DC06E8A-486F-44D3-8CEA-22554F7A5C7E@oracle.com>

On Thu, Jul 11, 2024 at 11:36:28PM +0000, Wengang Wang wrote:
> 
> 
> > On Jul 9, 2024, at 1:21 PM, Darrick J. Wong <djwong@kernel.org> wrote:
> > 
> > On Tue, Jul 09, 2024 at 12:10:28PM -0700, Wengang Wang wrote:
> >> According to current kernel implemenation, non-zero extsize might affect
> >> the result of defragmentation.
> >> Just print a warning on that if non-zero extsize is set on file.
> > 
> > I'm not sure what's the point of warning vaguely about extent size
> > hints?  I'd have thought that would help reduce the number of extents;
> > is that not the case?
> 
> Not exactly.
> 
> Same 1G file with about 54K extents,
> 
> The one with 16K extsize, after defrag, it’s extents drops to 13K.
> And the one with 0 extsize, after defrag, it’s extents dropped to 22.

extsize should not affect file contiguity like this at all. Are you
measuring fragmentation correctly? i.e. a contiguous region from an
larger extsize allocation that results in a bmap/fiemap output of
three extents in a unwritten/written/unwritten is not fragmentation.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
