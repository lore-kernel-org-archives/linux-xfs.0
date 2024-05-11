Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAFF11CBD
	for <linux-xfs@vger.kernel.org>; Sat, 11 May 2024 01:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715392609; cv=none; b=gAvoEdLixiDkITtnnbZngT0loMJ5TpgFM44AP1WSxF7IcZUXu9IJQflzqn+/g0cYrJEKkHBcnMaD95ZVBIjSsbGRuS/H98wLprUFG2GXfO571VbVNwnB4lnXBH66dES06j9Owr6/0QVWicdNGg/P+XC3jiNA5r9e9d8txG5QE8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715392609; c=relaxed/simple;
	bh=j+4QuYpjlffSZUdaRCT2EizOevsF0KsNqH1aK4t3Rlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qGa2JvML9HCyk2VMn/EjaoWE9DUsVD/CmcD5OMQgTLyLzDjmnzNSdHlx9s55bOWxq8m+8y5QikF0Ync8ewuQ40EiHUVXCpQJ4aS+TTsrUr1TsU9CJrnV3p675SX9W8a5RJ4sSmIDm8E+UxNnSH5Y4wq4RIU/o645kRtmOLUv0mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=SZkVt7M9; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="SZkVt7M9"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1ee0132a6f3so23188355ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 18:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1715392607; x=1715997407; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5ireWu1hgy3zg1Esk64WBzyqF6bEBG4eqnaD2ImmwY0=;
        b=SZkVt7M9GKIqikRQtaQYe7SM1S1Wseea1rCeZHnyIwSgvQGnO6cCnN4QjD+tNJcM/l
         MQt+2YTqAZdLJRlIcGB3U586SCcaYIofmxffmLyMAePdpZRW7WseNtFRHsbNXO9BuIYq
         gT/iqtLpCDCxVoBgTGUJ+7+ww5X/ETbPDAPEyx8Zmv9wux2bGRUGfjbsAIq6C4j+AhxA
         MEyCFlXhqHPqHeScBru1VP5G6+Xt41VHteIYERgbwqL3cn5fbjskODZWvjZiLYU99+WI
         QZzlDVFoQlmQw7DbQvKUHNwWAcBIQdRrzZMFWgMoCPWD0Il0FZxtrAUpHVmwhlGwNAK6
         PDcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715392607; x=1715997407;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ireWu1hgy3zg1Esk64WBzyqF6bEBG4eqnaD2ImmwY0=;
        b=O98sVMu/hJSqJPY5gfTXdhk+JeO640qAii7qOs+Q/BZBtMH6Pl+91Zfxmn3rmbCL9b
         LTMEjCQ1CO92lr0Qyl3ijr7Xx848M7xb7I9ARKzgB7DU9PiPAdYvcKffZfSeXqd9M0IZ
         5QQ/hl/HomvQ7HPSpZ2gNBzue+vHC38W5V3ohDaDVpjcvjLqFornFK1p9+nZ+bu628m6
         t9cgqGNwabLI7kpFaO3vwQx4hG1i6+D6fC8Sev12Y2JAaSGcw3JSrJMGwk5YxN+dvR58
         bNl2DUdxqpbJuFTuEzfD81RS8lSQ4oZfdV/qC5IQE7DSNVd3XIGsvuIUiLhMPVEcCWOB
         +9vg==
X-Gm-Message-State: AOJu0YyuhSv8vTv07j6m33Ll/ZfuwqGa+OHjTZVqhq7a1H6+AidSHraU
	ZRbiwoSbKnUthu/Iom3zksst/vtzkNbmDc+6min3qU0F/9+jqssecJW6kmx0wFM=
X-Google-Smtp-Source: AGHT+IE91r3yekcIRcnbFN8Wzy0Ykk2dtYCHUcq1+Nsx2m/JyYEm60gPKyu/j+UJqqTor49OoYXyMA==
X-Received: by 2002:a17:902:f790:b0:1e8:9054:1019 with SMTP id d9443c01a7336-1ef43f4cf01mr48760445ad.54.1715392606398;
        Fri, 10 May 2024 18:56:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0bf30fb1sm38841535ad.177.2024.05.10.18.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 18:56:31 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s5byH-00AqCd-1O;
	Sat, 11 May 2024 11:56:21 +1000
Date: Sat, 11 May 2024 11:56:21 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: allow changing extsize on file
Message-ID: <Zj7QRSyiXTJ6Kbli@dread.disaster.area>
References: <20240508170343.2774-1-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240508170343.2774-1-wen.gang.wang@oracle.com>

On Wed, May 08, 2024 at 10:03:43AM -0700, Wengang Wang wrote:
> Hi Dave, this is more a question than a patch.
> 
> We are current disallowing the change of extsize on files/dirs if the file/dir
> have blocks allocated. That's not that friendly to users. Say somehow the
> extsize was set very huge (1GiB), in the following cases, it's not that

The first problem is ensuring that "say somehow extsize was set very
huge" doesn't happen in the first place. Then all the other problems
just don't happen.

> convenient:
> case 1: the file now extends very little. -- 1GiB extsize leads a waste of
>         almost 1GiB.
> case 2: when CoW happens, 1GiB is preallocated. 1GiB is now too big for the
>         IO pattern, so the huge preallocting and then reclaiming is not necessary
>         and that cost extra time especially when the system if fragmented.
> 
> In above cases, changing extsize smaller is needed.
> 
> In theory, the exthint is a hint for future allocation,

It's not that simple because future allocation is influenced by past
allocation. e.g. What happens if the new extent size hint is not
aligned with the old one and we now have two different extent
alignments in the file?

What happens if an admin sees this when trying to triage some
other problem and doesn't know that the extent size hint has been
changed? They'll think there is a bug in the filesystem allocator
and report it.

What do we do with that report now? Do we waste hours trying to
reproduce it and fail, maybe never learning that the an extent
size hint change caused the issue? i.e. how do we determine that the
issue is a real allocation alignment bug versus it simply being a
result of "application did something whacky with extent size hints"?

Hence allowing extent size hints to change dynamically basically
makes it impossible to trust that the current extent size hint
defines the alignment for all the extents in the file. And at that
point, we completely lose the ability to triage allocation alignment
issues without an exact reproducer from the reporter...

Now, just disabling extent size hints avoids this issue (i.e. allow
return to zero if extents already exist) because there's now no
alignment restriction at all and nobody is going to care. However,
this creates new issues.

e.g it opens up the possibility that applications will scan existing
files for extent size hints set on them and be able to -override the
admin set alignment hints- used to create the data set.

The admin may have set inheritable extent size hints to ensure
allocation alignment to underlying storage because the applications
don't know about optimal storage alignments (e.g. for PMD alignment
on DAX storage). We don't want applications to be able to disable
these hints because the precise reason they are set is to optimise
storage alignment for better application performance....

IOWs, there are good reasons for not allowing extent size hints to
be overrridden by applications just by clearing/changing the inode
extent size field...

> I can't connect it
> to the blocks which are already allocated to the file/dir.
> So the only reason why we disallow that is that there might be some problems if
> we allow it.  Well, can we fix the real problem(s) rather than disallowing
> extsize changing?

The only reliable way to change extent size hints so allocation
alignment always matches the new extent size hint is to physically
realign the data in the file to the new extent size hint. i.e. do it
through xfs_fsr to "defrag" the file according to the new extent
size hint. Then when we swap the old and new data extents, we also
set the new extent size hint that matches the new data extents.

This extent size hint change is then enabled through a completely
different interface which is not one applications will use in
general operation. Hence it becomes an explicit admin operation,
enabling users to rectify the rare problems you document above
without compromising the existing behaviour of extent size hints for
everyone else.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
