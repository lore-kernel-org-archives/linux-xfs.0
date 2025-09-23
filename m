Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B61313D48
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 10:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758625104; cv=none; b=LLg6foLR83GU3CZMWuxFLLHN2wRvMBnElR2zwdui1ET9LL1ty5hIgKLl8eJqAjjVB4r6IXNm2Mz/CWa9XH1SlUhOpqkDqByQ3Qwgr863Fug80G78GUQXiZB8nLuAmVFk4DsJ1bvrpDMQu6WPtHlQ8aED6GaKaRJ8VLmtATAnCko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758625104; c=relaxed/simple;
	bh=u05A7RSPrMA23Ioo5xBvgm7DFkSo7Zh74Ae5+s5YCP0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LO6X2R3i66n+uDnKoqwM9SAGsSo5uLVhl+SvjeBFlifu6Cumemn9uZE45Lz5thCYppnBUsmVp1GWixzrdCNTwycH2Rqok7Ft+gVfF8HWHquRxJ38XjauTg8CQloQ//05AOzf8iR+xpNPp6DcjbvCfvVlzhH72RLydVxzLgCAQng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=pckSlIWt; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="pckSlIWt"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b38d4de61aso64434491cf.0
        for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 03:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1758625102; x=1759229902; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vzx50T9NIjBgPuSwI92zqQFIGqvfQ+lLip04R8s9Q7A=;
        b=pckSlIWtmfH16LL9bwznZhlh9pDtE75iroRDSv/In9M7IKTkkHkT+umF0p1CtIJxMN
         fgOU/Jltu2H6wvRGYqvIktXsPO6yEvbzTfH9jzh/IBuOG+ZWsWbRnR2lAnDa8hfbqixg
         Kv4m+hnZh827ySyZJSawcfuQEMQc8VcwZ+aKw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758625102; x=1759229902;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vzx50T9NIjBgPuSwI92zqQFIGqvfQ+lLip04R8s9Q7A=;
        b=rRY/iZvs1eGstKTL3/dsXjf7Q7IfJgvC2oAe+J4dlnph/ctR0Nn01JOuIXpKiKOZ3M
         4g7um+f4ETHybQJ8LU+TA9SBGgH+bThIQe1uM5Xd1S/N/NZzbn3+ncSIP0ov9/BL57hB
         SlUeI38PMlYAWFVZmmaEXxcbHBhqVbNbndXETHlANUvNnmgxJRV8qOuygfrv2d31vead
         wwzSl0KpBHIkJMj+Iml9bwEHNCWWx8kLbnmBNKqSg9Zqv1KI28pCQWNufuTbfV6BplPf
         J8Zn97wA1a2Qzl63CBF53fb896KmyOpizCu/dKBrNJkxIQgQOrYbcx5K9pu1PxBqi++9
         M2uw==
X-Forwarded-Encrypted: i=1; AJvYcCWELUVO/WU6Nwp/t+LhvYyEWnx7Io7Lu5eomln8YjcyyND0r2H9455aGliQHO9gF50H6E/uw+Fs8Bk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBamHpV+JX9oq7tbn56cLwAIdBRzGm5Ij9FIWHX+Z6cFe1zHJE
	4UEt9trDBzdc1udkdo2d95BiJ3ykLVJi9sw3XLHeP9j6inHgkoOkdfT7ZwU084NQHOtldBS2CFu
	D7PSWPMZxFNRjry3KvcBIvz7NGit3ogbyxmJrmSUtpA==
X-Gm-Gg: ASbGnct9B0SzUUDJd17TOBKK2IGuc7oaBsEqJvDEDgpzPS99KOt7DKfhFr8DyILm81c
	o3/d1ZwGvlJKEXbR+0Ax7L1SEgGAwA8f90xlHCmKNVNZTPSyeJS7HFbCZDMRTdgHa7huPL1YEch
	9vUsS56TbKDNOFS5OPMY5z7u650sfOVqpGnLUG92dMKPjEkmAOQMjwQM+QlqYtmOkl0Kh/RhIwi
	7CvyqQIdjSpV5JcM1igrAk2O/Vr2KftsMq8wl4=
X-Google-Smtp-Source: AGHT+IHrBdqbxgU/C0Vi+Ne+IrUvy3ET6zpgpaEITlNHyHR5ORplHmslGcfwWozRKSAxLwI0YrnqgAa9S7f648Zh3Jc=
X-Received: by 2002:a05:622a:2619:b0:4b5:d60c:2fc8 with SMTP id
 d75a77b69052e-4d372c2729fmr24484011cf.71.1758625101848; Tue, 23 Sep 2025
 03:58:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798149979.381990.14913079500562122255.stgit@frogsfrogsfrogs> <175798150092.381990.6046110863068073279.stgit@frogsfrogsfrogs>
In-Reply-To: <175798150092.381990.6046110863068073279.stgit@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 23 Sep 2025 12:58:10 +0200
X-Gm-Features: AS18NWC45Lz3Ni2C3kcZ99E2IaRQEufZKgXrRrF26XmsmK0JttNV2M5b7uffbKA
Message-ID: <CAJfpegtTtjWkH6d_-3QmdEPYiZBWxRfaY07JSboFxd3AgJLjOA@mail.gmail.com>
Subject: Re: [PATCH 3/8] fuse: capture the unique id of fuse commands being sent
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: bernd@bsbernd.com, linux-xfs@vger.kernel.org, John@groves.net, 
	linux-fsdevel@vger.kernel.org, neal@gompa.dev, joannelkoong@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 16 Sept 2025 at 02:24, Darrick J. Wong <djwong@kernel.org> wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> The fuse_request_{send,end} tracepoints capture the value of
> req->in.h.unique in the trace output.  It would be really nice if we
> could use this to match a request to its response for debugging and
> latency analysis, but the call to trace_fuse_request_send occurs before
> the unique id has been set:
>
> fuse_request_send:    connection 8388608 req 0 opcode 1 (FUSE_LOOKUP) len 107
> fuse_request_end:     connection 8388608 req 6 len 16 error -2
>
> (Notice that req moves from 0 to 6)
>
> Move the callsites to trace_fuse_request_send to after the unique id has
> been set by introducing a helper to do that for standard fuse_req
> requests.  FUSE_FORGET requests are not covered by this because they
> appear to be synthesized into the event stream without a fuse_req
> object and are never replied to.
>
> Requests that are aborted without ever having been submitted to the fuse
> server retain the behavior that only the fuse_request_end tracepoint
> shows up in the trace record, and with req==0.
>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Applied, thanks.

Miklos
