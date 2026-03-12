Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BE340B6C7
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 23:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773359585; cv=none; b=PUDGdLHY4n0TL3yMoY6aVwEPfBfTK3x/v18ywI90F/ErmmqCdDmBWqk9tNr4cTqdlNcy7JUX6F8/v2dMyFFYhk8kag6fHB9MJaqFFxvGOiEgSpxnJKv1GqAttOrnwPGC/dhB6fpthMjjv79Va+vnjODFHFL3AkVVujLhrkhmwx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773359585; c=relaxed/simple;
	bh=wOUC16WI4/reo5GvoZO5ESmt8rfD7PE3++Xf9novjKE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gazXYJ8QcBbBTVv8GGK13S6av5fCaJvl9jBWM8KLB57hacSpLecLVZBiw37aRwKYQYHwn3/NFwNdJzy6eveob4s38F9nsi0aigC+b4lrPtY5UfxJFs35N7UCmZUNBVGGJi8c5lmkcebpDOoySsfNOdenQTrMoxEyaVr2N8MJpmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F+ac4wex; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F+ac4wex"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-662fc12ac5bso3135638a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 16:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1773359582; x=1773964382; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pkgvHL0resGmXTqRBi16uC1NxLEncxIx9i+VLjGIXAo=;
        b=F+ac4wex0RFbHoRUlycHgCrmYUMd88hpNDedsXlEhwvnWTaKKBN8pCBtXJ/O01Zgiu
         bzOFeJhufH0FDeb5BI8CcmSycoqKo68pFhnYLDZLvo6xrcgHY2EUzGPpkOqm4e5kqFLl
         yOKAb7xA8iPrKyNU7lY9wqb5Yk1C6nKFu48R8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773359582; x=1773964382;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pkgvHL0resGmXTqRBi16uC1NxLEncxIx9i+VLjGIXAo=;
        b=iSpKbG/lvWDjuWj3xApfXzgYVhJQ9ZiuAdrycTf8M/CWl/imnsr+yDdfbrXnFsDI/V
         R8Og0VOe3ueRXhGpEb0PvNnYZo9XOzH22IAoiJrpgMGxMkpkS+xGXuNu0zVSOQrhEi95
         A9z8uMR+tg97/194BOKbzXYZo/3uiLj3+L0VcpdxlIyQ5s7qa7XXzzrQkxj4GEW+Q8fo
         yc1KMvB7soV+zZhfEtj079Vsqu0FJtPR7nuidQO8y0z/eCkngoko6ulqqJdHtx5807TC
         Qe2h7Qrrk8yFLYHdJMm/OdtA3+J0eP/y5dbJ4qU7PCCk+5MBB9BIMQJdcCwzdfAOioG4
         c9og==
X-Forwarded-Encrypted: i=1; AJvYcCUn9ITdr284rBW1fD5nIrPFlL0VI07WjYHPnK3yolHn4Ya2p7rERiXvef8sWo/JdLjfQDFhPcGlsBM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOQh6xILLRTWajX9gvhnTvk8gMUFdgFmnsppFTyAcTwFQf+0BX
	24DLVtZwyBqTtVsHJAXICQ2fTCIC5q/7FsdBkb0ugllnb/JGKLDI9xzIFMJCYr86mhR/VBOGSO2
	Q6lLOQBw=
X-Gm-Gg: ATEYQzxoZ4iSzRGerzHfnYC45i8d1wFYBvXWQuHLlelbMAv3AmZCsV3W46To6vxNGBT
	7z144QUGHbwi1pP56m1FioFtu9InClzamhnwKcJUeQOj3hk7Swfh5v//unjSCraqNZyZzY2UcY5
	iYyC9jR1zK+9ukatfAwe6n7R1A91y639McnF78/CAY0kT7uM7yFRO8/1Cddj8S4nqee1mQp/WI1
	eqR10ArABn9vNCxIEx2ZbnG/+KSchiGPmkPl5HU9ZcTeHPTcoZa5HX4Ohzweo8h3s3Uf+gQ4Gb2
	tdaFo43AjMO6cnLybzyPv7Z+sUSwv79uiH53XKb5zBChFSHYtL7A4IPSTpiU1gfUX5E9R4I3Sg9
	SfpnjeRYcAFhCLMFYzoXukVUAT5Yx+iJvsuK0JuoTMQIyCyVm6l314meC6dA5qFcGGlwfdYgW4t
	t8c0Df/ddAaZ0fpat3ZKkHN9gxIWnwwGZq4w6l5gnQjbIw0wZadvF36zIHxWHjkV9+HAUXO5Hf
X-Received: by 2002:a17:906:f407:b0:b96:f0a0:c791 with SMTP id a640c23a62f3a-b9764f76b38mr57930766b.9.1773359582384;
        Thu, 12 Mar 2026 16:53:02 -0700 (PDT)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b976cba6e8bsm3412666b.6.2026.03.12.16.53.01
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 16:53:01 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b96e579c0fcso272378666b.3
        for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 16:53:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUjQbzRBtSdQYi92k1CoPrGjEX9d7U9Y+efKUJCQZyeot9QwNlSSev1byAVp0wNaWpdok168dpSCQ4=@vger.kernel.org
X-Received: by 2002:a17:907:c5c9:b0:b96:d802:8b41 with SMTP id
 a640c23a62f3a-b9764fd8722mr66207066b.15.1773359215961; Thu, 12 Mar 2026
 16:46:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312214330.3885211-1-neilb@ownmail.net>
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Mar 2026 16:46:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh92deXvH5iXCo9mThXCBYt-jRcVu=z4kiH-f3+wZQOHA@mail.gmail.com>
X-Gm-Features: AaiRm503fTaccEgKNbxF9h_dDHM9fUsSr52XJuxzTwCI0G9L03uDq8g5di1zchk
Message-ID: <CAHk-=wh92deXvH5iXCo9mThXCBYt-jRcVu=z4kiH-f3+wZQOHA@mail.gmail.com>
Subject: Re: [PATCH RFC 00/53] lift lookup out of exclive lock for dir ops
To: NeilBrown <neil@brown.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jeff Layton <jlayton@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Carlos Maiolino <cem@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, Jan Harkes <jaharkes@cs.cmu.edu>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Steve French <sfrench@samba.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, Tyler Hicks <code@tyhicks.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, coda@cs.cmu.edu, linux-mm@kvack.org, 
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, 
	ecryptfs@vger.kernel.org, gfs2@lists.linux.dev, linux-um@lists.infradead.org, 
	linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Mar 2026 at 14:44, NeilBrown <neilb@ownmail.net> wrote:
>
> This patch set progresses my effort to improve concurrency of
> directory operations and specifically to allow concurrent updates
> in a given directory.

I only got about half the patches, but the ones I did get didn't raise
my hackles.

HOWEVER.

This is very much a "absolutely requires ACKs from Al" series. Al?

Also, because I only got about half the patches, and there's 53 of
them total, I'd really like to see a git branch for something like
this. It makes it easier to review for me, and I suspect it makes it
easier for some of the test robots too.

But again - this needs Al to look at it. Iirc he had some fundamental
concern with the last version - hopefully now fixed, but ...

                 Linus
