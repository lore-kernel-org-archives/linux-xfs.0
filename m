Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D884DA0F
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 05:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709010214; cv=none; b=EdtT6EruRGiJ/4QNJI/Y3Ig27FmYH9GW4sS6RUXdw0oytm0sVUJ3FfSsmNgiBMfZJ/LPuU9BZ8M8a6JWepqXwLXxM7uhqlXxxOA24fZg8p9McmQOh2VmdCW2XAhn7tJroc9F+p70vxcXsqea+b9thUpoRZs25LbIYECV3iZFEk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709010214; c=relaxed/simple;
	bh=jiAU4pvQm4HhFd9xaMVtKokNTFvi4bXWtW+WRNzcXpw=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=Vd/RMQhmtmveTVIwdiBOP+8X7TruXorBA8KvVM6g3Qi0xhWBBF5XmK1erBJG/Ichc9fBx/bNKH4ENzNjQ9c+b3PU33UXUiUlxBxxLgEm03s95+8AqTnqTeQXz070Y6G8aA7Vzv/VIVqSKuLPeeKM/2GazLMRxjZcu762/lLLPu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R6O5HCg8; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R6O5HCg8"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e54c791996so55059b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 21:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709010212; x=1709615012; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J7lxZ6ZnnW6n/tjC6roqqfxmo0+YlzqNpcqImIIdj+c=;
        b=R6O5HCg8fxWaM5GOoYU0GgxIaTplNS5BHkm+qGAfHz3RiogBFNIW/YxdvHlx6r8bTB
         nDUZGuLzBjKZsuFCmF59BtVcNfRvZwPzmED7OxPCeEeCdX+cnMH7x0+WvYH0Qzm7ujKM
         5byujt/MLr4071luSpKqbZLQnrYGWfU6uj7rwgE3IWtNGoTHSOZxThy2OoutGGmnsVNW
         d/qAh5rh2kUi9EFLqvf8TvDeMTdCqbXBDxqCO+mqkHTYz7YQS6KjZhpqpEfGx2RQt8NE
         Ci5J9jZ3HfnvaNLV0wZDwsBvkJSqtATKI9ZZaTL5A8oqov0IynUoOm4yREZRpp99ErzH
         mlJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709010212; x=1709615012;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=J7lxZ6ZnnW6n/tjC6roqqfxmo0+YlzqNpcqImIIdj+c=;
        b=Jz7wmhfZGKy7f1eZfpuk0vkcac8mf1OZYJMdnac6XuYQd2wb9a20XfKzx8/eYScWox
         +GQL/KewwpKPglaI8aDhNdR8AHX1JrkbsdLW7Mf8uH8fGoMD/kVG7kAhq3nz08Q7BNSb
         6sObPc2mer+0vYw2dlc7JiIKU+LlAFndtzK8RL+y4l/EDnBD+rP+qD5dNLwoRs7GkYAv
         ASJxtIOixIveb+fuQIa/HcyiF8FuRNNvfKiweU30gNn3xcrz0TUcTkwAKz3/C2jAzOPY
         Cttc7jrtiPHNeNXm61ssG+iDy1C+95ludnSz9KZmqnFoaZiMnZevKupYdI+XAkKZYxd6
         gJOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHBHoa5sltT3PzLPeXXTk4Yh00rmnlfK0nskV5UKpro90WTyaqD1AZtF7YlwAUimI81B3AcIyM0za0lZOd2J9ibVXqDxFDKIjz
X-Gm-Message-State: AOJu0YzJDbOtO+NfyYvVjS5NorN0rIZVde/+GwDpaCMlkkqR7Ef5UP5R
	h2oe2tW5+kDkwfFXtwoApjAn8Y1d5DF5Wyi/YG6dmzJ9TO9H+AI3
X-Google-Smtp-Source: AGHT+IHF3Sse7HlMV0zt3tUexnG7qsxjE7Rl6h2yQNqySiEn6dP67CJ1ebFwKXg6WOYXqM+h1QHecA==
X-Received: by 2002:a17:902:eccb:b0:1dc:a282:365f with SMTP id a11-20020a170902eccb00b001dca282365fmr5258126plh.40.1709010211660;
        Mon, 26 Feb 2024 21:03:31 -0800 (PST)
Received: from [10.0.2.15] (KD106167171201.ppp-bb.dion.ne.jp. [106.167.171.201])
        by smtp.gmail.com with ESMTPSA id kw4-20020a170902f90400b001db67377e8dsm537447plb.248.2024.02.26.21.03.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 21:03:31 -0800 (PST)
Message-ID: <fa7249e6-0656-4daa-985d-28d350a452ac@gmail.com>
Date: Tue, 27 Feb 2024 14:03:30 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Chandan Babu R <chandan.babu@oracle.com>, Christoph Hellwig <hch@lst.de>
From: Akira Yokosawa <akiyks@gmail.com>
Subject: [PATCH 1/2] kernel-doc: Add unary operator * to $type_param_ref
Cc: Jonathan Corbet <corbet@lwn.net>,
 Mauro Carvalho Chehab <mchehab@kernel.org>,
 Stephen Rothwell <sfr@canb.auug.org.au>,
 Andrew Morton <akpm@linux-foundation.org>, linux-xfs@vger.kernel.org,
 linux-mm@kvack.org, Akira Yokosawa <akiyks@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

In kernel-doc comments, unary operator * collides with Sphinx/
docutil's markdown for emphasizing.

This resulted in additional warnings from "make htmldocs":

    WARNING: Inline emphasis start-string without end-string.

, as reported recently [1].

Those have been worked around either by escaping * (like \*param) or by
using inline-literal form of ``*param``, both of which are specific
to Sphinx/docutils.

Such workarounds are against the kenrel-doc's ideal and should better
be avoided.

Instead, add "*" to the list of unary operators kernel-doc recognizes
and make the form of *@param available in kernel-doc comments.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Link: [1] https://lore.kernel.org/r/20240223153636.41358be5@canb.auug.org.au/
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
---
Note for Chandan

As both of patches 1/2 and 2/2 are needed to resolve the warning from
Sphinx which commit d7468609ee0f ("shmem: export shmem_get_folio") in
the xfs tree introduced, I'd like you to pick them up.

        Thanks, Akira
---
 scripts/kernel-doc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index e8aefd258a29..d2f3fa3505c6 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -64,7 +64,7 @@ my $type_constant = '\b``([^\`]+)``\b';
 my $type_constant2 = '\%([-_\w]+)';
 my $type_func = '(\w+)\(\)';
 my $type_param = '\@(\w*((\.\w+)|(->\w+))*(\.\.\.)?)';
-my $type_param_ref = '([\!~]?)\@(\w*((\.\w+)|(->\w+))*(\.\.\.)?)';
+my $type_param_ref = '([\!~\*]?)\@(\w*((\.\w+)|(->\w+))*(\.\.\.)?)';
 my $type_fp_param = '\@(\w+)\(\)';  # Special RST handling for func ptr params
 my $type_fp_param2 = '\@(\w+->\S+)\(\)';  # Special RST handling for structs with func ptr params
 my $type_env = '(\$\w+)';

base-commit: 4b2f459d86252619448455013f581836c8b1b7da
-- 
2.34.1

