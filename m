Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B13EB640
	for <linux-xfs@vger.kernel.org>; Tue, 12 Aug 2025 11:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754997479; cv=none; b=kSwNmexKUjLYj3Y5V9BnzHfdbBp/wq0P43GKR8Tc7FzkQGSsFA8hYkgsNTGiSt43Z4jr2YwXPXIrwlF6o9aX6a5j9dOfb1qA7/L+KsJ1OinBRzOGz+W6u7L5jA3Pk+RKHP/PCcXLp5Hn239lpDPir5kzkIbCaFDbMbwKsF/d4SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754997479; c=relaxed/simple;
	bh=uz/OccvxeyMRISc72M25e/ICJNuef/rRGH+18MgtYOg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FWhYZ4oj3h3lWPFWYLrX8V1ZcA38fi7cg8tryAEoVAWGYwxp/jFRzds6pzx4y0+17IAvwsLFpMnbn1OGeCq5UzdBS7JbiDF6VOOc1wBNJ0JR9suzEWmnfbpWcfLiCYgoCQCJqTre+gPAXLlJqiM01oqqWHwvcBglh8ZBY+begKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DoXTkegw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DoXTkegw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754997477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=YIWiNDONBJfVwJemh5Bs9NOsWk2zrzr9oGcu7F0jx50=;
	b=DoXTkegwuhrKbMMmpzMCd8b6wt3dnTT89kB7dva93+sRzv+IfhSJ8dHLc7IhP2rUWOt7fe
	3RKliZQ0RQaV+YPV64yJ8yiJHL9J3cgjcWt1h1kSww4JuNobibr2MsGwotfmDAxXneZ1uQ
	RIfJHwu9+w6LqX652CPWJuXBS38pBgc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-fzBFb3_MP6ylQt7ihg4nSQ-1; Tue, 12 Aug 2025 07:17:56 -0400
X-MC-Unique: fzBFb3_MP6ylQt7ihg4nSQ-1
X-Mimecast-MFC-AGG-ID: fzBFb3_MP6ylQt7ihg4nSQ_1754997475
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b793f76a46so3491059f8f.2
        for <linux-xfs@vger.kernel.org>; Tue, 12 Aug 2025 04:17:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754997474; x=1755602274;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YIWiNDONBJfVwJemh5Bs9NOsWk2zrzr9oGcu7F0jx50=;
        b=J8Ve7MHFAw8kptfFWJ8gIapDBK3tztGQOT3YmDonb5jWenD9h4d5VQXEqmZ0Y23sP0
         8KYugEE+y/cohD7ylo+dcYlv++kELyQGbiLFtdtGD49eM/XGsAgLDVdde4qqztxjv7gz
         8EOCtepRu5J62kYNH87u3UZJSmLfcZT2zM3ek51xYPVkI80lhdawx0YLCsk3J3vtBvBK
         RPOa/pGdPye2RXEdLrA/5Q1seDn4QjvrbuG+wkvpahKo//aS0WBV39mHidIiRhUzbIT7
         DAz4Lq/P7R5UypcyBQw8UTb1ouZ/FB1XI84HH4G877r4zyLBJJYIg0JgqKXdTNxORilM
         S9+w==
X-Gm-Message-State: AOJu0YwSgjOmWDBojfEdLt6NL6+gNCNK9aXGhKnV/IMUEP6wYI8jHZEk
	OBj59QG9JxH9FCmyo9wYEWHdMl1Aq5Nlu1qi8GRnCn+56kZdazl0Zfq26yXbjXZC90qx7WowWNP
	jhc6nfU65q9/WAaI/WPLmRiHhFJBy11WaaqnfUcEqIAC1qXp2XBOZPiuD37boeWdJyjOu3jgvX2
	S7qD+53qe0ODfcluyfG0WZ1vj05oGf55xq/bBb2B6+Zj9c
X-Gm-Gg: ASbGncvEv88Ae1SF6n1Bfxv2QVw3cBmoxhY3ahGikEC9BbG0eykZ4AAieuQ7rgFR5oY
	tpHFPWsHg+664jhlEAI9nyKg6q73fxPgjzkeyYWsgPcHu69d6/6GM9gOXm9KyZfVqbbzh+bQgzH
	ReBpru2q2NLAGAqxV+vRY0IBumO8Rcf0IwhKr38iGpv6tnWxk1RbZqY28zLbJ6IUszxVQtqr/t7
	tOH+HXFePJ2hfPVfW3B+cFcsIyWE28mU/IKJrAQ85SEpmuwD0bRpGVsZskivGF2wUnMu3xC7lvs
	5Jbibh++zLVOvWYqayjo3U8EW2agPvnbULtbN+hFu2Z3OsvDB/fe751OgTc=
X-Received: by 2002:a05:6000:2f86:b0:3b8:eb9f:e65 with SMTP id ffacd0b85a97d-3b910fce97bmr2672866f8f.5.1754997474284;
        Tue, 12 Aug 2025 04:17:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IES1DQhY7rrNcFOo1v1PrG5ytGPI33EZQMtCbxn6dI/iCbESg6q+VzEt8EbQXXuEQP+TUBYYg==
X-Received: by 2002:a05:6000:2f86:b0:3b8:eb9f:e65 with SMTP id ffacd0b85a97d-3b910fce97bmr2672836f8f.5.1754997473839;
        Tue, 12 Aug 2025 04:17:53 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e5862fd9sm314350855e9.16.2025.08.12.04.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 04:17:53 -0700 (PDT)
Date: Tue, 12 Aug 2025 13:17:52 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, dchinner@redhat.com, 
	djwong@kernel.org, hch@lst.de, john.g.garry@oracle.com
Subject: [ANNOUNCE] xfsprogs: for-next updated to 264762bb42b9
Message-ID: <vifmhk45tyxy5sbho754aj5r2j7iv3jr4w44bgkvudzxzmhzsy@zzesfmoopzgy>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the for-next branch is commit:

264762bb42b9d32793161c0d64c5a34e1f741fd3

New commits:

Christoph Hellwig (1):
      [f3fe5f5eecfa] xfs: don't allocate the xfs_extent_busy structure for zoned RTGs

Darrick J. Wong (1):
      [466e8aa6e0e8] misc: fix reversed calloc arguments

Dave Chinner (1):
      [68facb8397c5] xfs: catch stale AGF/AGF metadata

John Garry (1):
      [264762bb42b9] mkfs: require reflink for max_atomic_write option

Code Diffstat:

 db/namei.c          |  2 +-
 libxcmd/input.c     |  2 +-
 libxfs/xfs_alloc.c  | 41 +++++++++++++++++++++++++++++++++--------
 libxfs/xfs_group.c  | 14 +++++++++-----
 libxfs/xfs_ialloc.c | 31 +++++++++++++++++++++++++++----
 logprint/log_misc.c |  2 +-
 mkfs/xfs_mkfs.c     |  6 ++++++
 repair/phase3.c     |  2 +-
 repair/quotacheck.c |  2 +-
 9 files changed, 80 insertions(+), 22 deletions(-)

-- 
- Andrey

