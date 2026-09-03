Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400133F5BDC
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 08:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788424326; cv=none; b=f1o+FmW0QVxkzWEtADuR3cX/9p9liTn08cLDVTdK+4Z8odNjMWoQrmutqzra+SFWlB3TUe92p6yzYkE7S3tVpkE+on9W8fvUadM1XcH5Izr/7w5L9M7KkcYq6KbdbVHeuTuzSVeIBMIqyum5/MzEvIhrGld8cjah7nX+D5P4Gms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788424326; c=relaxed/simple;
	bh=BNbYlX09kh4qdoGiq+7yFzj3ttO9GR22rE5gdx2gMLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iNdbuONOTUgZ30uCpCJC5qB3+XxskfVjq/cmTYiO8EzwjNyKnACZ2vpS1F2bYrkLWoqLw2s4/w0P5wtL99PNcVEY0PeDxPpXkQxyZfwsMgUP5BhQN/AQwzcqQTDfbqBPbt9tvTc4FddhBhqo34C0ng3+wXYltn21blcXta3uwnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OON2u6TF; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=alCrCdvt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OON2u6TF";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="alCrCdvt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788424324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ogGzNZa5gsK9u5I5fEWc5bMO9Svs2RAfGHetZAFSDjo=;
	b=OON2u6TFwlh4qqxGg029C9vqAOiHY1BVdhhZqX0XdYHOYdWAjRcPqL4F3dn6s2qLp2AKYE
	va9/zhQAWxHPeHcN6XapHKyz1GStb2bKKmkbapv8njP4VxyCEgIIdrmH6w8gEz3hDeUajI
	wqz3y0D+4WQezBO0GB5vdvGYkI2T9Cs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-kv2LonIkNh-XNY0l2dolWQ-1; Thu, 03 Sep 2026 04:32:02 -0400
X-MC-Unique: kv2LonIkNh-XNY0l2dolWQ-1
X-Mimecast-MFC-AGG-ID: kv2LonIkNh-XNY0l2dolWQ_1788424321
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49cc954a3edso13593985e9.2
        for <linux-xfs@vger.kernel.org>; Thu, 03 Sep 2026 01:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788424321; x=1789029121; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ogGzNZa5gsK9u5I5fEWc5bMO9Svs2RAfGHetZAFSDjo=;
        b=alCrCdvt4EdFDMRRGGemPF/Bef07LNsWz7gauCc/coDqvg8H5dkpDsdwjMV2F5nzr5
         QfXJTnwfcECoBrrfBIJ6TpAv/Jp4UJtugVbjlw9c/V4n9gkcGcEAmxeEvzoxLtQfI/0q
         zV/B6ixDD+3qblWY/b+/ErUiZEffvXv/C9bbwqjr0KVKzEYXOYbl9xxfBXqBDXw8dTmB
         P8DTpF8/2WTWAQKs2TxzZUPl8CoxYQDxKxAGTupaerxyrKCXs+G6MofuhXQsoBnH1Xtq
         prf5EDI7/Etc8vKEaQ0lo6+LCm0nEpRsg4+zMxFa0gmtmMKFXc8Dlr0QuK0D1cPkJs6u
         eZTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788424321; x=1789029121;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ogGzNZa5gsK9u5I5fEWc5bMO9Svs2RAfGHetZAFSDjo=;
        b=qOz5yZTx4UsstFVr8yZiqUHF+uzD3cDctaysAUcfdXnC2kNxbIhqwLvlshudFe64Yk
         l85clPhTF42dqLwofUs2ubfeocXQL9ywlQI28o0iderKotSJFJG+u362zLC3D5Tj1ITv
         A3Dh5yN/PO8CWM0Hi2gRRxEXrP3nTvitYfJ896231VUXipGNk05di9W4WwUBndSFczeB
         dsxs38H5nhd9IwY6LtZdAJn/cHDFvIaK2HHzREkG1pSxOKHOFXIlTL8jNZrqiaqW2Aeh
         5Mh66W2wreB11wmA4OI8rjb+W6JP6PiUaMRYZzfhh+zyeHnAobYThK+GFPMyoi/dCbKW
         OYHw==
X-Forwarded-Encrypted: i=1; AKwUvBykRONq/efSrbzttgJheB2JHqE66ynZGu/Qjgdl0O18vZUGLnP42I65EZwMAKMJY1afWGu2mA4Mu+c=@vger.kernel.org
X-Gm-Message-State: AFuF++nF1WL0kzxih6C8XOjy7bkanVvDXxH6mjAElrbnwBFVRh3g1zxx
	70wvovN9ULIviXU8IPNXr5LP6+9KdJ7jAOvViKwsAy2uROtqkj6OrXElRVNOiNPfA5BxbghihOu
	zLcbV1t6vvcDJYpEVt9LANK8pvcJw0uGSyLL+PiG+ZKbTXJnBzd17IHn2Laf/
X-Gm-Gg: AYBFou3h/uTqKK6ATGto4+gCOOjVrGD1MVpRV7B8oZP4BekdAZiZ4AH4pUyH8OgBoGz
	LNkmfUb7VUysKS5CCtyPQVG+2oTx87LxFhQAcPA7kF6kBYWy3eGV85VzlGEs8i8LXaSuLq2G4y8
	5oK4MOy51aivpKg2JrHEPLIfR04HJgHRlpGlm0TGuLZOjKvMZZ8VlVr3+SltSNpuJnmxLB47eD3
	d+AEQmmSWBmRz67H1wVrgTHOkRpB/MjXt4cFJUey199bVjjGyElmBdAKSJ0i8lTqpPm6fAxSTUq
	gcaRbeaa9H1kdGpNxsBO5j29lazZp+nJUcbnXgxIaGpUFtZgOWEsgXYfU4Y06IViGEpr84bmcdb
	XsU6J4c8FvTO2cr1dSa66AB1FOUs8lSyPPw==
X-Received: by 2002:a05:600c:1c27:b0:49c:dcec:bd27 with SMTP id 5b1f17b1804b1-49ce57fd7bamr169949885e9.8.1788424321435;
        Thu, 03 Sep 2026 01:32:01 -0700 (PDT)
X-Received: by 2002:a05:600c:1c27:b0:49c:dcec:bd27 with SMTP id 5b1f17b1804b1-49ce57fd7bamr169948785e9.8.1788424320922;
        Thu, 03 Sep 2026 01:32:00 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce58da3acsm227922825e9.0.2026.09.03.01.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 01:32:00 -0700 (PDT)
Date: Thu, 3 Sep 2026 10:31:59 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	bestswngs@gmail.com, brauner@kernel.org, cem@kernel.org, chuck.lever@oracle.com, 
	cmaiolino@redhat.com, dawei.feng@seu.edu.cn, gaoyingjie@uniontech.com, hch@lst.de, 
	jiapenglin@tencent.com, roland.mainz@nrubsig.org, xmei5@asu.edu
Subject: Re: [PATCH 00/21] xfsprogs: libxfs sync for v7.2
Message-ID: <apkoOtfg4WE86PgQ@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260824104022.420566-1-aalbersh@kernel.org>
 <20260824181431.GN6072@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824181431.GN6072@frogsfrogsfrogs>

On 2026-08-24 11:14:31, Darrick J. Wong wrote:
> On Mon, Aug 24, 2026 at 12:39:58PM +0200, Andrey Albershteyn wrote:
> > Hi all,
> > 
> > This is libxfs sync for v7.1..v7.2.
> > 
> > ...
> >  
> > -	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
> > +	return I_INO(ba->bi_owner) - I_INO(bb->bi_owner);
> 
> I did some cmp_init conversion for this file:
> https://lore.kernel.org/linux-xfs/178302226322.845537.14974268104031687429.stgit@frogsfrogsfrogs/

Oh I forgot that you already did the sync, I will rebase those
"Fixes" on top of your version then and resend it.

-- 
- Andrey

