Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523C512E1CD
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 01:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731980712; cv=none; b=q0ijyoBRugQqEspyDUQjx8zxzb4B+x+VzMcH58+ySsfyQDxX66cNYPajeukiT9BOQ9EIUbgbly3nctQWP3+cWVyWzCHt8eoFlCS3hXX+DTrSjqcpgyDkQCAwpsG0qVZBn+kXo1ooWpjNaPqzHc9/l7PZF46TUGhX3cquAva602k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731980712; c=relaxed/simple;
	bh=HWrScgmlSH9Ydnz/bo4mjiuum6SOXdt0BoQvzZRZ3nk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fkGQ0OPlP0wgInDIL2olEKdrploqYM8YePT/U/qz9Iey4XWQDRSYgYuswEKZjN9F3Rftn5pQTUAOlyHtHmgmbVIi/B+uUbwm3amV4kDIsaHL3ZfkialWvw6rhp7Bq900J+s7qLu43JQM3S1m4WjpCjC0+WaUfbC8ooQgo0njHIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ndRyz8WM; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ndRyz8WM"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-71e953f4e7cso1682237b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 17:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1731980709; x=1732585509; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PeNwmBH3uaE/2l4FFiktqBAtKgA+fiiSinSc7l/5l9I=;
        b=ndRyz8WMk6oCze/5UnZpUPtab1aagtKDg0DVw96Lz3AeWpESRq0/UwAPMFDtnc80xL
         WiB15cuyVVa5H4VuHonqcDflH6ThCG7CM2Hs1OeimMWOKdnd4nQ4oFAHywUM2jqaTQ2+
         9ggxQTv1oCVlDVYjxTH3QKd3OwLlEuCF+ct2JTRer8oLPwpmjYVfs61wAlkdP4qm52fo
         JI15OoH+HOIvzPhN7Dxt7Ge2uQ4YiyiuABEi+hlXCXPryNItCUiELz519kkxWElER8cz
         YS+bqZzOr0T0qqPQKtm7MtNlSEZ/dtCZ/ABIUY9pLANKjc1EzPpt//lNdwV7mMPfkTyP
         1FMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731980709; x=1732585509;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PeNwmBH3uaE/2l4FFiktqBAtKgA+fiiSinSc7l/5l9I=;
        b=MZ6reX6W27uREbJx3y1wHBFboRJk0Iv7BiqlJVex3CHkTjc9REGeik3z8ecqbSojKw
         /pw+fm+FhVjV8w9T14jIcPWfr1MEC9XKQPr6eoZ3kUahwwA8tZOOQL4yjJuFBwK4jftD
         P3Zon4A0YPGsHaTWhEFJE83RqZePfk2GvPxxL86wJDpAXf06G45279O1Gi1/4Kgh2EwO
         D+uCR/A32wgPA3/iKs62bz0R3P+XGbFJs9Df8BfS/0gX88TkqEyTJLvpngnXnBIceqRj
         ApL9p6yuzVZHNCslZqNm5t6iaIr0my615F/aTj/79Ma4FhEOPqHVx6HruoB2QTwxGlsw
         bTMA==
X-Forwarded-Encrypted: i=1; AJvYcCUHK4daHU1f/pwmE1no1963rpj4TSE2AcnL+zDuH1ZoQJnM3Y6kK/aIsSwAKNhvHu7uw0o5xRWy6Lo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5nxw4fgKOIMFGKHTAo99+M+QnKfXty4xptUyNTZzNLYedYczY
	RnW7prVSaDoVDTNzv9BPjzL4L8+GbaZ1ww5SRiWBiiwjnp161f0mDGis+NvRJLM=
X-Google-Smtp-Source: AGHT+IF0fL50jPCSnRcKjS0tjYHDPmqlfKZJ7apkYq7jMiNj0EpdvBI1rZkhGyagLjWd3CxJIWcBmw==
X-Received: by 2002:a05:6a20:244d:b0:1db:e884:6370 with SMTP id adf61e73a8af0-1dc90afc4d2mr22791496637.7.1731980709425;
        Mon, 18 Nov 2024 17:45:09 -0800 (PST)
Received: from dread.disaster.area (pa49-180-121-96.pa.nsw.optusnet.com.au. [49.180.121.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72477120bc8sm6909973b3a.70.2024.11.18.17.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2024 17:45:08 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tDDIf-00000000Hli-3dBl;
	Tue, 19 Nov 2024 12:45:05 +1100
Date: Tue, 19 Nov 2024 12:45:05 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 09/12] generic/251: constrain runtime via time/load/soak
 factors
Message-ID: <ZzvtoVID2ASv4IM2@dread.disaster.area>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064562.904310.6083759089693476713.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173197064562.904310.6083759089693476713.stgit@frogsfrogsfrogs>

On Mon, Nov 18, 2024 at 03:03:43PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On my test fleet, this test can run for well in excess of 20 minutes:
> 
>    613 generic/251
>    616 generic/251
>    624 generic/251
>    630 generic/251
>    634 generic/251
>    652 generic/251
>    675 generic/251
>    749 generic/251
>    777 generic/251
>    808 generic/251
>    832 generic/251
>    946 generic/251
>   1082 generic/251
>   1221 generic/251
>   1241 generic/251
>   1254 generic/251
>   1305 generic/251
>   1366 generic/251
>   1646 generic/251
>   1936 generic/251
>   1952 generic/251
>   2358 generic/251
>   4359 generic/251
>   5325 generic/251
>  34046 generic/251
> 
> because it hardcodes 20 threads and 10 copies.  It's not great to have a
> test that results in a significant fraction of the total test runtime.
> Fix the looping and load on this test to use LOAD and TIME_FACTOR to
> scale up its operations, along with the usual SOAK_DURATION override.
> That brings the default runtime down to less than a minute.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Question for you: Does your $here directory contain a .git subdir?

One of the causes of long runtime for me has been that $here might
only contain 30MB of files, but the .git subdir balloons to several
hundred MB over time, resulting is really long runtimes because it's
copying GBs of data from the .git subdir.

I have this patch in my tree:

--- a/tests/generic/251
+++ b/tests/generic/251
@@ -175,9 +175,12 @@ nproc=20
 # Copy $here to the scratch fs and make coipes of the replica.  The fstests
 # output (and hence $seqres.full) could be in $here, so we need to snapshot
 # $here before computing file checksums.
+#
+# $here/* as the files to copy so we avoid any .git directory that might be
+# much, much larger than the rest of the fstests source tree we are copying.
 content=$SCRATCH_MNT/orig
 mkdir -p $content
-cp -axT $here/ $content/
+cp -ax $here/* $content/

 mkdir -p $tmp

And that's made the runtime drop from (typically) 10-15 minutes
down to around 5 minutes....

Does this have any impact on the runtime on your test systems?

-Dave.

-- 
Dave Chinner
david@fromorbit.com
