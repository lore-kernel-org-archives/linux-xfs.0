Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB53B386C2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 May 2026 11:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777980490; cv=none; b=t1wuKiUkSwbCsjok1+BBh+cvjh0eJZ7zm5S64haT/hkEpq+5GuJXmaHmg5nOx0uZfMf1aULtbWoHqV3f8PqEezqqZnki9z5v2pZALyGfi7HGAK435jSAVRUbBzceHW/BNRbFwUjI4TPoiqGugGYs9mRUgLMkZV2lTUHOU26Sbro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777980490; c=relaxed/simple;
	bh=A9+bBwRm4tcI9WqXvMLTg4Z680bMdwokTJxmA2KvchE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cF4a6MMzCoUPX2UbuKb+reT1LdpJdPM+HpgBIpy3P4lxSTYQJ3CV3/FuaejF/Buas5xC/vepxdColwj2Cps+3GBb4H7MwN4iF1clpQf0B6d/MmmUze1WZt4ps4oBF/tJauu4X7C69bYDNebQq5qnwz6tFPNO8/PSPMMXDPYt3eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=epHlIBJ9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=o2/B0VtI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="epHlIBJ9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="o2/B0VtI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777980487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wlJXkICY7/NJxL/9AYhO8zivjAii1TrRuI2FlSWeJFM=;
	b=epHlIBJ9D/+mUITrHp2KnPgvzubkrTmRmXtYeN7TQMsb5L8IKecatXnxo//puEG0DkcCz8
	gQOxhgicvx4aq7I1cU49GwVs4y0fWxcrxs8ZXYoTuhpnUCMeRjOCmipnEyz9RXg3N4LaJg
	AG6bvXIpvP9RxBLtcNOA4j2b7KOHufI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-4APVOrvQMhizwc1IckV46g-1; Tue, 05 May 2026 07:28:06 -0400
X-MC-Unique: 4APVOrvQMhizwc1IckV46g-1
X-Mimecast-MFC-AGG-ID: 4APVOrvQMhizwc1IckV46g_1777980485
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4411a36715dso3643901f8f.2
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2026 04:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777980485; x=1778585285; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wlJXkICY7/NJxL/9AYhO8zivjAii1TrRuI2FlSWeJFM=;
        b=o2/B0VtIb6/BernGmmgepHCgwIgba7FnzhWcBDIZstAkgaT5fUNyGgCNv19ZKV3xNd
         9xf8uR54/L6zuVU+B6jrhywjP+AHYHoCjqG3lQKtvXarLTb1Z52oqP6nNYn//lRoJOhV
         3FtZDwJec6TLhcjC7WJye3FSxMU6jyyuxGvPk74/T4k9ZAI0RECNUOaWHRCebAWWX7bi
         vhLG637/XtIISKPW2sj7xoK84E/VtCHhAm6lNwmPE+vT31CRBT1zmks9pXSOToXvAkcb
         bgBO6DJoAyfHJO7rhJ7nlh8Qq5E+VeV7MkTl9sOAfyYEG7KDknZfTr90lWkFRjh0t5Ux
         NxBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777980485; x=1778585285;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wlJXkICY7/NJxL/9AYhO8zivjAii1TrRuI2FlSWeJFM=;
        b=P6vfELmkEwNQRIB1dMIBc+7wj1Udh4M6i2OmDM3o+rTv96DVp2i+LQXJ8xdsGl7ErK
         lt2Prnr1PQyj8YL2uVyztjXArbeiIM1HC0th8WK4eXEzK4iTNtiuq6SQdAdGmmu9k/Kj
         tzDaJyANMd4hvLzItvjuBzmOPGQTGdcDWHy1kVtGdTZxtgdlrbkNr3Nue2nZOWDDXitd
         vFHKfDQTCuAGnip27/WusXGuZ0BspMTRGDi9E5b+1Hx37sILf7/DzJ/09BZc+218UAni
         u2MqdvRad7jIqvK358Rt/01z9KwmecmC/8si0l3wp7bRUQcno3mBfsclw8kIgG+eQ/ep
         jcyA==
X-Forwarded-Encrypted: i=1; AFNElJ8aEzUtpUhekIkf4L5pRfXT++RGsltNZkdxwsFP+O77n5KoAXgbdyC4u4nxedjBb6jj46XFLttSdBI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr9GB8bOQF4lwZbs+shzPvQwqXswSaqVpy/fGMFlrLK0+zu1BG
	ICu3VF7141yZJGcRQSOAYD0HAxWhEt5+IbseiuqS+af9p/fmXPIzxQSaDI1eaG3mR6OHp71Bh0P
	OL7IGddN+3lgrPvw8nafJV98oqgy4rGCX8knXZpV/NMOGVi6w8qWval9RPXilJGKOc+cH
X-Gm-Gg: AeBDievM4AFqP0m1DAyoINU5Zuryq3vmUYGJvk+qozoZRxPf5k84Ygs8pJmMO6NHS0U
	GDC3I+AjoOi+nsqH8/zDrbNM3j5SvFq+i3dxHApXmqxsgqfBnd/Bnmk4AnSTRvz7nE5nbCw06Wq
	DvcUKhRiOUi0UE3zg8JJRw/EVeCy8Uehq1Ri+WttaLgSAocJg0Cq8d17qWRvXglnyb9uZS1mh6l
	awEV46cfp0P8bCp/dhHqenn0yfSQZZmgG9j7LHOfrISEZ2HVSq17xwPDbbT9+hQybcEfsCK02qe
	oBjNlbyfoVqEBsK2Ha9GjaMsg+I2Bp7Jb1hCS//j6NHPBKom0ZgBYU73pp/XwT2HPGFYMhA63H4
	g/0d4JXT5OQEePMaNW+q/Rw==
X-Received: by 2002:a05:6000:240f:b0:44a:198a:5256 with SMTP id ffacd0b85a97d-45005a97615mr5024019f8f.24.1777980484836;
        Tue, 05 May 2026 04:28:04 -0700 (PDT)
X-Received: by 2002:a05:6000:240f:b0:44a:198a:5256 with SMTP id ffacd0b85a97d-45005a97615mr5023843f8f.24.1777980483733;
        Tue, 05 May 2026 04:28:03 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45055960811sm3953225f8f.27.2026.05.05.04.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 04:28:03 -0700 (PDT)
Date: Tue, 5 May 2026 13:28:02 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Gedalya <gedalya@gedalya.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_scrub: drop the warning about mixed bidirectional
 codepoints in names
Message-ID: <vl3rhbudi4352qxtf32tg46xujdh35swx5y7ridcweklm2q3su@fp3whcm6fcyy>
References: <20260504170852.GH7751@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260504170852.GH7751@frogsfrogsfrogs>

On 2026-05-04 10:08:52, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Gedalya complained about receiving warnings about mixed bidirectional
> codepoints in a filename:
> 
> "First, well-known file name extensions are not internationalized. While
> the file name can be in non-latin letters, the extension will be in
> latin. Hence you would expect to see file names such as עברית.pdf ."
> 
> Gedalya goes on to point out that file names can be created from (say)
> the title of an article, which might itself mix RTL and LTR characters.
> Both uses are totally fair, but regrettably unfamiliar to 2018-era me.
> 
> Unicode TR 36 even weasel-words its own recommendation: "As much as
> possible, avoid mixing right-to-left and left-to-right characters in a
> single name."  Maybe I should have paid more attention to weasel
> wording in specifications. :P
> 
> Let's fix this by removing the warning altogether.
> 
> Reported-by: gedalya@gedalya.net
> Link: https://lore.kernel.org/linux-xfs/8961ee4a-3830-498b-a432-5545695db599@gedalya.net/
> Link: https://www.unicode.org/reports/tr36/tr36-15.html#Bidirectional_Text_Spoofing
> Cc: <linux-xfs@vger.kernel.org> # v4.16.0
> Fixes: baa9ed8dca213f ("xfs_scrub: check name for suspicious characters")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

lgtm
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

