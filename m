Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3390E158535
	for <linux-xfs@vger.kernel.org>; Fri, 29 Nov 2024 22:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732918467; cv=none; b=nneK5e2TSVkJK0viDDi5cMBFfhZIVE447K6ctjbmzTs5jr+CXaZhq20Et914nNFaRM3BdY7jrfKUB67zSkayma6W2FRKXEIntMU2ObeHD+cc9ZIes9eygf+wbPkNun+Dq5BUrAyRqdMOXTER11dddjKWRLFNHk7hq4Ql8FiZIek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732918467; c=relaxed/simple;
	bh=KTTCQsoqRN+e+ENdypKQGHRhCnR6NJGAJJ9qJUEv94s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G2c0XLPbs9RPnFfbF+M9mm8D2jGkMzwCJPPmxC+OQgH5KZ1f5GYfTFggGovmDI0hi7ch5JIsMignJq1YOvvEzIGQz5gFOagJ+Qb8dc3K31ob1pPnDjW3jkneJwhGleErIE31hUJGmyVNtxo3QO6cO6Clwa5VcTPudXhOpYcv7+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=wbRkZ+b8; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="wbRkZ+b8"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7252f48acf2so1634437b3a.2
        for <linux-xfs@vger.kernel.org>; Fri, 29 Nov 2024 14:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1732918464; x=1733523264; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rp7QjdqthhawfpSGL9enTaAIuCCNZOUR22PLIKYotVQ=;
        b=wbRkZ+b8AASDFwXE1HASo2pnQ4+UlU32OjZ35QRxjs3al8v/0JZW3Jg2uAH1dK+t7u
         j95w2mKyeJ4V2DzI/5AOkCPeQAfuaPx8F2AyLryxAd+j27VJwTXKqcrtw4E4yXiQYvpV
         MQTI3XACPci5pr9h8igZ7DXSPNxi7iGWHI5B85tZJoFFxcp+E5leElVHIRMi0uPJ9hei
         rHFvxZGqfoKIx54TCzDT77+jht40DdAj96DdbNT1PqyDGPc146VFBJHP+4vVYcWzomgU
         np54jaaH0vYtlB9JDANSeP0rl513UTK8xn+wP+7S8pFqMdKJpTVeNfyfAnsIJsqBECEC
         AXWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732918464; x=1733523264;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rp7QjdqthhawfpSGL9enTaAIuCCNZOUR22PLIKYotVQ=;
        b=R0DknrWx6GCtf6FOlk5MjvzYBshnSkVCtYWpoZcrf1UplxeCY2mSXiCRghFA1SUNjc
         cq3ObMIlWofxiQmHEwe2VyWhv/hpRDrzPuHMBq9ALTLV9siBhIh7Cf9ELcZ85uMXDMOB
         7iw55C8j8W57tkwUM+XDolF9q823CSd3Yp2eU197ja8OO2I2yrPfQkZzO6yFU2wNNKFg
         Ag49Qv7lHuFNXaP/S7mwXj5qDxoHj3fN+UFl+SdCXLyzvKDuTha9cSoU1utxEKg51vaW
         cN1geLAJBAA16a6XHPFbSpOtGA4H1hXNQOyO7GzH3/aR94HAVqFDz0l9qiM/RDMAw/nk
         JBKA==
X-Gm-Message-State: AOJu0Yx6H8B4uRLfKHEAiZaS3/fR1HTnmrfsswnN7lFv3FxffJmV/ZlR
	PeI+yNkGXMuK6s0AxyRooizhNxS1FQd1sC1jdqwoTscK9pRC1oEbeZ9PZscnw2GVU4IBIixYUkv
	d
X-Gm-Gg: ASbGncsmUrZkA9A1JAJHQfE3RpZQYJuEZyIAOqdto0fAHAFmHTAKTDL/T9KEWwn7Igj
	Zy/RvfwpbwdvrhZUNRMXl/kbZRRJ4Zy2bDP0XqsWQ8RZM6xkX2qd2YtAPb6kX73JZYAi724Wd9o
	v4T9ToPEUtGifQYhuaTMkIJv2IMFWhVWNuruSm/SfWVdOAyOIXgsP9WgD8m3219PVBWLvAny6DQ
	BcF7oX8NbHHWsJcwQVDsqVqbH5JOcG9CM27DIAVGjJuQ9g0RpniReFmvrtApnz4WaSP9lfrZhKp
	ToINgToPQQto8bYCq1x/NtV6uw==
X-Google-Smtp-Source: AGHT+IHMg4vUpuCT+/cMQVSWsZ6yupnAnfk+xyYpjjByq6smBAEWN5UR3cUoGwbeKa6rcIVgu+SrDw==
X-Received: by 2002:aa7:88c3:0:b0:724:5815:62c1 with SMTP id d2e1a72fcca58-72530133103mr19739762b3a.19.1732918464517;
        Fri, 29 Nov 2024 14:14:24 -0800 (PST)
Received: from dread.disaster.area (pa49-180-121-96.pa.nsw.optusnet.com.au. [49.180.121.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725417614e7sm3978115b3a.9.2024.11.29.14.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 14:14:23 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tH9Fk-00000004frF-4Bhr;
	Sat, 30 Nov 2024 09:14:21 +1100
Date: Sat, 30 Nov 2024 09:14:20 +1100
From: Dave Chinner <david@fromorbit.com>
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Weird behaviour with project quotas
Message-ID: <Z0o8vE4MlIg-jQeR@dread.disaster.area>
References: <20241128171458.37dc80ed@harpe.intellique.com>
 <Z0jbffI2A6Fn7LfO@dread.disaster.area>
 <20241129103332.4a6b452e@harpe.intellique.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241129103332.4a6b452e@harpe.intellique.com>

On Fri, Nov 29, 2024 at 10:33:32AM +0100, Emmanuel Florac wrote:
> Le Fri, 29 Nov 2024 08:07:09 +1100
> Dave Chinner <david@fromorbit.com> écrivait:
> 
> > > As far as I understand, and from my tests, on folders on which a
> > > project quota is applied, either the available quota or the actually
> > > avialable space should be reported when using "df".  
> > 
> > Only if you are using project quotas as directories quotas. i.e.
> > the directory you are querying with df needs to have the
> > XFS_DIFLAG_PROJINHERIT flag set on it for df to behave this way.
> 
> Interesting, and how is this set ? I basically set up quotas using
> something like
> 
> xfs_quota -x -c 'project -s -p /mnt/raid/project1 10' /mnt/raid
> 
> xfs_quota -x -c "limit -p bhard=30000g 10" /mnt/raid

That should set it up appropriately, hence the need to check if it
has actually been set up correctly on disk.

> > > However on a
> > > running system (Debian 12, kernel 6.1 Debian) I have incoherent
> > > results:  
> > 
> > 32 bit or 64 bit architecture?
> 
> AMD64, the most common one.
>  
> > > The volume /mnt/raid is 100 TB and has 500GB free.
> > > 
> > > There are several folders like /mnt/raid/project1,
> > > /mnt/raid/project2 etc with various quotas (20TB, 30TB, etc).  
> > 
> > Output of df and a project quota report showing usage and limits
> > would be useful here.
> > 
> > Then, for each of the top level project directories you are querying
> > with df, also run `xfs_io -rxc "stat" <dir>` and post the output.
> > This will tell us if the project quota is set up correctly for df to
> > report quota limits for them.
> > 
> > It would also be useful to know if the actual quota usage is correct
> > - having the output of `du -s /mnt/raid/project1` to count the
> > blocks and `find /mnt/raid/project1 -print |wc -l` to count the
> > files in quota controlled directories. That'll give us some idea if
> > there's a quota accounting issue.

iAnother thought occurred to me - can you also check that
/etc/projid and /etc/projects is similar on all machines, and post
the contents of them from the bad machine?

> OK, I'll run these as soon as I have a connection to the system. There
> seemed to be no error with the reported used space though, only
> available remaining space in quota'ed directories; however df reports
> actually available space for directories without quota set.

Ok - it would be helpful to post the commands you run and the output
so that we both know exactly what behaviour you are seeing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
