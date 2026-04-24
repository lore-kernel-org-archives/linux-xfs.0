Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD5038AC78
	for <linux-xfs@vger.kernel.org>; Fri, 24 Apr 2026 09:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777023798; cv=none; b=oTXtu6OHEIuKXr3ygCR+dDMCSB5jRiGZb3xpd3/ebstULkHM7iNBsEsY+jTusFG7IGFETh9F6oFrXLgLjunPw2SjqyXukGaH09rCIe1N46daUWjvdWlWeZwZmAJEGiUyXT1eVzp07JcSRrKTkeAS+xHuiEx2GAUw8wvCTUSSxTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777023798; c=relaxed/simple;
	bh=MrcSnLe6Ux6kcQj5f0tMveq8oHzcASzmk4IJBHN189M=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-version:Content-type; b=b9J4kO3OGHzshcDOTGWsCDuDybylSCpMJX5XFeUnkkj7yuP99PbciECGab0x2Jn+FlMLzvzZDv3WeWvBmI71RY6bKlG+l1GrKysRHRjAb9DsB+9aAIwKQUb8TL+/Z6tQhoICgclVFJUSyfZD4B86UW1kob8CmfFj9pC7YWVwz/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aU5p0iv8; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aU5p0iv8"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-35da9c0c007so6818299a91.2
        for <linux-xfs@vger.kernel.org>; Fri, 24 Apr 2026 02:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777023797; x=1777628597; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9uqmyrQ8gLBUo18xHMn5xEIDMtFyh4GdfcnRwtOqeI8=;
        b=aU5p0iv8JcVpNeRlFvao7Mgb6AzAHZYlXk82l2PKjhYEjpDBqKISoIjZwUUje6AkYl
         ZNZaUyNosMTYgSKtkdDfSW/dTBKeVMd/Q59w7apQHwFp1quVRfsX5HhTr+2HaZDsx83L
         VYgQ5d8oT59raLVXGL8BL2Kg1aJ5raspIWfoKmC7FznSMF4QZw6hGPJOj+op2DW4jvuU
         xknZdxl5tHLY5lhqQvrmkl+4S1WgnoiGCVOxog8RK+QqAbt30RJ1hfAG6+3h6sJ94mTC
         BqsMZYHbAaLN2ZQmYFVG1R14Hkmb1nmtX5viZ0Cg9oxXiYeyrs5tjIrRSi9Z2mmHk0XC
         luaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777023797; x=1777628597;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9uqmyrQ8gLBUo18xHMn5xEIDMtFyh4GdfcnRwtOqeI8=;
        b=gqCfukVpkQx30fkJXGlbLracOW9dzgL8pzVE7oYbAV7Vh8JesO0ApANtsxQdv7NCek
         UaNohBp69+FYtGXipxgS0T5I1MvlX3PaHtNUu4MsMRf4geipwo/JQi02M8TndyudDPft
         TfKPAdVMmIcGVmiXGhXDoTX25RycGmFtERXadHD7dHl9aBvT7+n1p90XwPuulfZYjkK9
         qY+hBZGFY4eQ5gS5tm8uy6ybkdB0tBuOYVrs1GDvNo3wS3RopiDo/YaogDr8usRh5/p6
         cFJmCMvQbfqermdjnW6OlzT/i17wi1xLtecv+AgLVQlBJLToCChIkgZbXzmMNCyf0dHz
         +fpA==
X-Forwarded-Encrypted: i=1; AFNElJ+OfEFwRgYynK6X1PLvwVHUmY4fMwT9p9dqQJe11J84v/EXd+rcow6/IhwKY/dZ3XYFjoDci06QPDM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwT7fHlCHrDlo9V58eEncAqGZihiioZIpX5R6tnAoYn8ineIdYz
	UB4EzT3UVHXPWUY482ia5bnygomETJkrMF3SiB9OXo+/yp/K+LnXG4iL
X-Gm-Gg: AeBDieu2ton+KKBe7n+tjml3WIhw8DAnEtgibdrw/5wG+va+w1730wHD+uYwGMbUt9p
	8BtYGKqrnDBLmPwih+8LKuz7lLhKqotyxDPV4pmvrw0t8ckBpLXH0sMCik4UYWKcgo+cd9x/8W8
	3OWycDF6a8XGZqGubD/Ft+XclF2qD6XE14u/iwneubX8THZ6pTtgcCEKSuJp+0frnrBo2RBEYXx
	GXoiLkB7VBSdk+ZNvwiHCWOPgTzHd7uyTjC0/pWFk/OhASXnPq9/WF2/of2V60P4EZ6TRDNu2Qg
	aoEVOJF3yX0vh9nU1WTIGhA84K/K3gKrnwWcRToGUqnHFXIFwUbuCXU50YHl4G6cgIsQ8xaSi7s
	HgMcZh5f1Gmf5GE8kRYpMx/YRSXZ6fpUpsm3OZDQ/yD7E8TUVTr7picFlfAWuu40DuEzyGe8Y8H
	8Npy//UK85k+97IH9ubx9vmeVMBWxwawY4
X-Received: by 2002:a17:90b:3909:b0:35e:3e86:e2d3 with SMTP id 98e67ed59e1d1-361403f12fcmr33224296a91.10.1777023796902;
        Fri, 24 Apr 2026 02:43:16 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab20c4fsm274121025ad.59.2026.04.24.02.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 02:43:16 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>, Matthew Wilcox <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, lsf-pc@lists.linux-foundation.org, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, Pankaj Raghav <pankaj.raghav@linux.dev>, Andres Freund <andres@anarazel.de>, djwong@kernel.org, john.g.garry@oracle.com, hch@lst.de, Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
In-Reply-To: <CAOQ4uxi0bTwj7oCWR1iOhqzPkB94cVgh=9Prh1kHxnObuLCz0g@mail.gmail.com>
Date: Fri, 24 Apr 2026 15:10:58 +0530
Message-ID: <tst0snkl.ritesh.list@gmail.com>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev> <wlxxrx10.ritesh.list@gmail.com> <aer0wd2Ig0hjN3R0@casper.infradead.org> <v7dhrmgc.ritesh.list@gmail.com> <CAOQ4uxi0bTwj7oCWR1iOhqzPkB94cVgh=9Prh1kHxnObuLCz0g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Amir Goldstein <amir73il@gmail.com> writes:

> On Fri, Apr 24, 2026 at 7:07 AM Ritesh Harjani <ritesh.list@gmail.com> wrote:
>>
>> Matthew Wilcox <willy@infradead.org> writes:
>>
>> > On Fri, Apr 24, 2026 at 06:32:03AM +0530, Ritesh Harjani wrote:
>> >> We were thinking if it is possible to extend the Buffered Atomic Write
>> >> session into two "continuous" halves of 30mins each (total of 60mins)?
>> >
>> > This is painful because you've requested me, plus both Storage and FS.
>> > FS has lots of space, but I don't, and Storage is also pretty full.
>>
>> I see, sorry about making your (and PC) life difficult here. I know it's
>> a lot of planning :(
>>
>> I think, both FS+IO folks will be interested to discuss both of these
>> topics. Do you think breaking this into two discontiguous session help
>> us plan better maybe? In case if we don't have any continuous slot, then
>> maybe we can split those into two.
>>
>
> I scheduled the two sessions as you requested 9:30-10:30
> for FS+IO and moved Parallel Writeback to Wednesday
> across the MM CXL session.
>

Thanks Amir. Yes, I think this will be very helpful.


>> >
>> > Do you need me for the full hour or just half of it?
>>
>> Although I understand buffered writethrough is an FS related area, but I
>> am sure a new writethrough I/O path is an overlap for you in page cache
>> as well :)  So, yes, it will be good to have your feedback on the second
>> part of this discussion which is - buffered write-through for buffered
>> atomic writes.
>>
>
> Matthew,
>
> I don't know why Parallel Writeback was scheduled as an MM session,
> but if you think it should include MM, could you move the CXL session
> to the now free MM slot on Monday 9:30, so that we can extend
> Parallel Writeback into MM?
>
> This will allow you to participate in the atomic buffered write sessions.
>

Thanks again!

-ritesh
