Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9046124B26
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 19:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718910398; cv=none; b=uXhmW3w8b0D71wuzQ57/qvk8b9kkTxWxy8OdCdsWqatwe0lU9JrCiVWCTBINE3TzsSXdOnLDnOKlicA/hNt4qnPppNfWSH1xpocpsr6pjSPiPJFP3ZSf2HMagg1rOZ63VquLu//yfDYloasqiuLlW4jrOJhhJ9nkU8vfvdQ8XTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718910398; c=relaxed/simple;
	bh=W2BNX/QqXofExpQf+EsIDOK5Tj4Rze/IXZZdtQxIkwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uDP0BZmkN7HgvnnilDka//YrSxAjHVAmAM378cURMwiX1PVFxX3n1plB1+yvqwR59NTpOihvb1ddDVZvd4ig15mKteeXCj5yRqYmC/CPFErgITf1mCKDZE2z7Jm3co1IZRKEbj+Q3nUlGns63HxYZ54LILLnl6AsHv0ImbtIgfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GFLjda/V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GFLjda/V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718910395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SyD90obcJxtERC+T2A8QHf8d04Li934BZAFpY2pAcoQ=;
	b=GFLjda/Vmv7d3thnpTjjMBLPzIlAZ3xw2xeOLEerr1n8UVddjqU16qbAIud9rjzSUmDFet
	vkp5LKJTGUp2iHL6hBNyv0EMMqreYWv8eVHDt8D7sSPb5vI6caFooGOja/v460CDHhwd/n
	n49EUGaTQql3tqcVzah+OM2W0lF/2Hs=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-RLNdwVZDND-6PYMDTFipDA-1; Thu, 20 Jun 2024 15:06:34 -0400
X-MC-Unique: RLNdwVZDND-6PYMDTFipDA-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-70ab3bc4a69so1135566a12.3
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 12:06:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718910393; x=1719515193;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SyD90obcJxtERC+T2A8QHf8d04Li934BZAFpY2pAcoQ=;
        b=aGOkxpklZIxt9PpaZT+pl6SNjJT80rKyqnz6LoJClfGIFZmwexsHfnkKfmvI2kI2lF
         ZM2nPR6wDcPXPLv7lMWbMfWZqTOGkZjWJC1mavIbkX7ZDLLT3ipwmlVnwGd1xpGZSikK
         BQ1GtbASyT4h+Gom2vrTj94H2kHvYT7bBBSFfA/J/N+qckqw6XuSBXkV6inxDfeRtRNr
         s+5E95aMpPR5VRssdzwbljgmv4qJq8Xm9/sQ3diNoQwbNoMLQpmu6FHC+y9cCjlbwUFU
         j0NLB++dXKOURXzeT27B+MGGgy2XxizxAp7Ua0YyNKsw1kWigTifDEyvVQ2N33FU4din
         0mfA==
X-Forwarded-Encrypted: i=1; AJvYcCXxySSmn46i55LcG1biimPnSFGzT9tczsNsycy5lGQrwQT3lTgF1eDg7NPrOpTTKgW25ARWi5qI7+ZiAAzVP0doBJ1+RqwfZm5+
X-Gm-Message-State: AOJu0Yy5Xj8th/S107AFUAC/GWXRWnVbDFKJ6UuhCBjb/0LVlC3g+24i
	8kbdFtCGMPPLR0LGUz+Kcp2zMQEZwDtFGTheY8WqShlwmlzHgHzS1D/BWYfwHZLF1NV/ON/5N8n
	jgqivwxL0rV7iqCyItVsygaLDJF6ulWRSteaOIP3/jSshsRYp1YkohQNH4A==
X-Received: by 2002:a05:6a20:491e:b0:1b4:772d:2885 with SMTP id adf61e73a8af0-1bcbb45643emr6236913637.3.1718910392907;
        Thu, 20 Jun 2024 12:06:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHFpIBjqoWni1c+H+7iH37bv/hAfCDh8m81xZBwdNAhmlCvGUP4NEddogAqNm+f1Sj2sqEDQ==
X-Received: by 2002:a05:6a20:491e:b0:1b4:772d:2885 with SMTP id adf61e73a8af0-1bcbb45643emr6236875637.3.1718910392390;
        Thu, 20 Jun 2024 12:06:32 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-70ee5be7e00sm4277120a12.25.2024.06.20.12.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 12:06:32 -0700 (PDT)
Date: Fri, 21 Jun 2024 03:06:28 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] generic/710: repurpose this for exchangerange vs.
 quota testing
Message-ID: <20240620190628.onmsffjtscuoa2ca@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
 <171867145344.793463.2045134533110555641.stgit@frogsfrogsfrogs>
 <ZnJ15ZG1nWsCkxiG@infradead.org>
 <20240619172318.GR103034@frogsfrogsfrogs>
 <20240620165526.GW103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620165526.GW103034@frogsfrogsfrogs>

On Thu, Jun 20, 2024 at 09:55:26AM -0700, Darrick J. Wong wrote:
> On Wed, Jun 19, 2024 at 10:23:18AM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 18, 2024 at 11:08:37PM -0700, Christoph Hellwig wrote:
> > > On Mon, Jun 17, 2024 at 05:47:32PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > The exchange-range implementation is now completely separate from the
> > > > old swapext ioctl.  We're deprecating the old swapext ioctl, so let's
> > > > move this test to use exchangerange.
> > > 
> > > Do we really want to lost the swapext test coverage?  Even if it is
> > > deprecated, it will be with us for a long time.  My vote for copy and
> > > pasting this into a new test for exchrange.
> > 
> > Yeah, you're right that we should retain this test for the old swapext
> > ioctl.  I'll fork the test into two -- one for swapext, another for
> > exchangerange.
> 
> ...except that the swapext ioctl doesn't support swapping forks if quota
> is enabled and any of the user/group/project ids are different:
> 
> 
> 	/* User/group/project quota ids must match if quotas are enforced. */
> 	if (XFS_IS_QUOTA_ON(ip->i_mount) &&
> 	    (!uid_eq(VFS_I(ip)->i_uid, VFS_I(tip)->i_uid) ||
> 	     !gid_eq(VFS_I(ip)->i_gid, VFS_I(tip)->i_gid) ||
> 	     ip->i_projid != tip->i_projid))
> 		return -EINVAL;
> 
> I'll amend the commit message:
> 
> "There's no point in maintaining this test for the legacy swapext code
> because it returns EINVAL if any quota is enabled and the two files have
> different user/group/project ids.  Originally I had forward ported the
> old swapext ioctl to use commitrange as its backend, but that will be
> dropped in favor of porting xfs_fsr to use commitrange directly."

Hi Darrick,

I can help to change the patch [4/10] and [10/10] if you need. But for this
one, will you re-send this patch or the whole patchset?

Thanks,
Zorro

> 
> --D
> 

