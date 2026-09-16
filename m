Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F50B4C1505
	for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 12:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789560420; cv=none; b=VZc6TbRg4+dgPgXT5y45+f4Fdj+AWIXq1W/ojKmowu4ouKW/qns1CerthOw8kxFNinPqtF/9BK6ayT5LJRSJ1y/Jfx0mgKj4VqeSujFw6Kd8u1B1+gQ4dzfz4ipBHl4C9/3ohQ4YdOXY2q87Vp8pGiarLx9FXkctec6ua1wSBGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789560420; c=relaxed/simple;
	bh=/KTO33Y/LCAi9l9jukHByy7Qkbf4BO6532OP5ffXIec=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Z/xuv8MB6ffZq6gGHH6OJoLiyzV3mb9oAT7TVWGyTLlQYAr7m4iCjjNXITRbvu/LVCXi/kScs2xqo8whEtS1tIYNDzjcm39+CA8dXJiv9TS7Or2+zOI1WhsGDikVzyw8RptWB6oE8TwrQpWROZn6dJ2X0VFj/jjgbddA4917kD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hG2qJxLi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hG2qJxLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA5B1F0089B;
	Wed, 16 Sep 2026 12:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560407;
	bh=MJCrzpT5K8Ox0xhJWZaRW441um5W1rdS5nwynqfl7cM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=hG2qJxLi1oiTs2Qivthy4Bb0DY9uIVxdd7n1JMT2VMT2ZoWlbyoCLUwhAn/a4yJoa
	 1Gi3iPf0iKPJmjskazmlN2J8OCd2TPFP+u3tTrdTAV4iDFa+l39acm5zYDCcFHciDs
	 61jVJZviNapXyVaRItO3Yb5dgGRnHzhyJYLoV4lDZXVDjLFqm2pxKpAgKIKsE2x6UJ
	 WKyZ3VTpHn24iazlGF0IQABeRJ5B4stE+ADG9K8Ojesko1dl9LwVcp3TCp8BHIrF+t
	 xyofBguLO/ocCnkS/GCyqsDvnm/yFir9QhVCgb/gaBfbdrOwjVnUqXVjPqMyCywRup
	 HXMd5JAv14uvw==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, Anuj Gupta <anuj1072538@gmail.com>
Cc: linux-xfs@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
In-Reply-To: <20260904123641.3028007-1-anuj1072538@gmail.com>
References: <20260904123641.3028007-1-anuj1072538@gmail.com>
Subject: Re: [PATCH] xfs: remove unused xfs_reflink_remap_range declaration
Message-Id: <178956040592.10466.17590154857529836539.b4-ty@kernel.org>
Date: Wed, 16 Sep 2026 14:06:45 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Fri, 04 Sep 2026 18:06:41 +0530, Anuj Gupta wrote:
> The implementation was inlined into xfs_file_remap_range() by commit
> 3fc9f5e40931 ("xfs: remove xfs_reflink_remap_range"), leaving this
> declaration orphaned.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: remove unused xfs_reflink_remap_range declaration
      commit: c16b885ad6b589b233534ee99ade82110d2bc381

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

