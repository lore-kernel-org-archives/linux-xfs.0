Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAB047ECC1
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2026 10:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784630702; cv=none; b=STVl29K5oisVlG5QUjNROnbkx1cl5wLseVwZW+CBtaOJVmj5lKhkLdj9mvPUKln+BZ8kXr4EhFdCLZ95C/NKgQt94CDo/D3GwjZPQE6pShrY9M8LknNiJ9I020L0FwXlNS0TweWQQ5iq8qD2Hdxs6Gey7gE1jQSewOEYrZ3FNiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784630702; c=relaxed/simple;
	bh=Wc0R01EUMNRxOkk/jW0SDZIYu07TG8bknH8ES142hg0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=E3fjOjjMlKtHKmdHv2syq9p71GtCR3DecZ0IooQ0wQxad+arAlriAElWydIFuDHRDsWenf5/MhqU16NJEhnS1zCvvCu59Ovi4McR3geAkS4T5lKAOXBAVPfcT3tmgT/tHYtj0gboefOK1lDu7KfIJj5EJKgq6w8Gyu3L1ssD5/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nBSVQm1M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nBSVQm1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3D91F0155D;
	Tue, 21 Jul 2026 10:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784630683;
	bh=R6Gly+kjccCSIWhct4OzVpYcetExbExGuGpaNdLPTTM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=nBSVQm1MjOXfmV4zbjDSFt+RvVG1aGq/F1TUcW/o9fB4hlzclMb4MRvt4CdtHHbrk
	 f0QZ8WrMaiymGrNDQyi+qZRgWHFPtMuyAhiUXaXybjrKI1OY09PNUe4kceGSbAyTwp
	 sOBJ1xpGZmWGuNjVmPd+YzoQSsglsQ5oHkdDGvB0RnJlD3IOHUcBbtwPGsFoQXBnwX
	 A1A6N/ZIF2N8BYNYvOtkI+IXMkaoHgvuRVkpHdPudq4nipUMwLZyN9Z07IEUfKNpZW
	 FWHMHSeFXLRGGRd5FKc6J56NQ4+5PpgTSSvM2zFe7CrPvovA9T8J0cCP2dCkCAuv5q
	 kWj9K8Tb09kcA==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>
Cc: bfoster@redhat.com, lukas@herbolt.com, 
 "Darrick J . Wong" <djwong@kernel.org>, dgc@kernel.org, 
 gost.dev@samsung.com, Zhang Yi <yi.zhang@huaweicloud.com>, 
 pankaj.raghav@linux.dev, andres@anarazel.de, kundan.kumar@samsung.com, 
 hch@lst.de, hch@infradead.org
In-Reply-To: <20260706084117.1455204-1-p.raghav@samsung.com>
References: <20260706084117.1455204-1-p.raghav@samsung.com>
Subject: Re: [PATCH v9 0/2] add FALLOC_FL_WRITE_ZEROES support to xfs
Message-Id: <178463068061.324722.423636735414417020.b4-ty@b4>
Date: Tue, 21 Jul 2026 12:44:40 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Mon, 06 Jul 2026 10:41:15 +0200, Pankaj Raghav wrote:
> The benefits of FALLOC_FL_WRITE_ZEROES was already discussed as a part
> of Zhang Yi's initial patches[1]. Postgres developer Andres also
> mentioned they would like to use this feature in Postgres [2].
> 
> I tested the changes with fsstress and fsx based on the xfstests patch I
> sent recently to test this flag[4]. generic/363 helped me debug the
> crash I noticed when I did the initial implementation[3].
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: add an allocation mode to xfs_alloc_file_space()
      commit: a12a5f85daf0833473997a210a6480d423c94ad5
[2/2] xfs: add support for FALLOC_FL_WRITE_ZEROES
      commit: e105fd8ccfa5ae2e1ecfee6d3e3970eb88219e2b

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

