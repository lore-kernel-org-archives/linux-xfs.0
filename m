Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B23D3CA49D
	for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2026 11:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783079154; cv=pass; b=u7Gi9LO5aUkEyiYGK33j/WyXIy9l6DUus6mPHaP93T47/kB4yh7vRN/Gt6alhOfUKNsyi27zm0re5dRn8rVNcezX1u+hqM7Fv0dXKbUqn99JLo4ZyaOIVi2Y8FVU3tNhCGqFY9p+mmfrlBlsBWEYVXv3L1Upu+JO0iy0jgSYaDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783079154; c=relaxed/simple;
	bh=GeUDSjrHAWkuRRsR++4INezbx04TBh6B1L1rO/GgWvo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NRbhHCrqe8UyYL8Ki6A58Sj+lpjnVxzKMsuVNUd75V35eiqCDHxWFxCppoL13385LVAbRk0niycL0zHtDeb1N/89+rRjRd1JklJ8+Nmi+Gz6//hWNl8epA8rXN4lmlQ+zrVn5BMbDc68aI3aOQ9QXz8p0W6mo5wlOhbQoGMO64U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WBYcasxf; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gpVlvvjN; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WBYcasxf";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gpVlvvjN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783079152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GeUDSjrHAWkuRRsR++4INezbx04TBh6B1L1rO/GgWvo=;
	b=WBYcasxftFmBZ8uM45rDWAtpulSQ1NZXxQlNmU/Bcxrp97t3xeVsGvv1iMmQUwaQSMn2e9
	PbAKWl+zMPeHpocqUrSroAkLJPW7QhjyBKAW+RfMLHITvYy5IbpfwBlOhtYZ2OyZYPrnsx
	EIa//Qx8K9gcwGwQYMPR9tHzte3EGtw=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-pW91sjAqPLOAff0OtrGvVw-1; Fri, 03 Jul 2026 07:45:49 -0400
X-MC-Unique: pW91sjAqPLOAff0OtrGvVw-1
X-Mimecast-MFC-AGG-ID: pW91sjAqPLOAff0OtrGvVw_1783079149
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-809ed87d66eso13382527b3.1
        for <linux-xfs@vger.kernel.org>; Fri, 03 Jul 2026 04:45:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783079149; cv=none;
        d=google.com; s=arc-20260327;
        b=OA04FwP581amR8rPDPkWRxXTAcN65jE6qZTDK/ABX/YDsxr5O52qO40DuGZRfiaUY/
         f1hIv9Hjt6Ta6DrD8jV1lrkvh4a0EFVYe+LXE4gW1RYNycxqh3CsLl96dj2J7hS7G7IZ
         pvkOb+B1K3IFLXUWqyUHFTUeQotx+CMXudrX5XIZlWvyiGtVSe2bQb+2XvxXbTOPn8VI
         VkXRh6fZdccSTTmi+V2YJscT89WbLzm47D4Wv8fDNV2RZA4l9jFfSjJZsI7lCGoz7FEA
         hfuwB0JSqAn+PbtiZbZKpXttv9dKg1LSANQheqwqOcoe3YCOMIqaFP/VtUTdUcqeKdac
         pcYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=GeUDSjrHAWkuRRsR++4INezbx04TBh6B1L1rO/GgWvo=;
        fh=GoJO5UN6ODLqRLDalT7TSGiztzAJlfEZhaGYPdjUjkQ=;
        b=dx2MYtlo8EIe/saiNtOG79B753NIRfUxim3bD2JzT2eKjWsU8OS+u2V8f1XadegYoR
         aO2AE7zde63U7sqDRhfpUc5UWoTEoX1rNnSlP03eQtAmK3MCaK05D5y6H0bnooBXa2Qh
         8IjQ57PCqDjqql7YU9bGGEzuZTH8QU3YyQQyCB4Mcs8CcEUJhx5/67KL6gXmrGdG14m9
         6FAf1/bziKKVqfXClgxpdZuxwyZcdhQ7ZhZKh97nvwTevcaT8Q652GFWA8yOuMo0jmFK
         g+Ha8D8PbFxd83zAQuOg6zjen6QgpvmeK8KfMWVfrrpHo5YlwhVpVrbKFCmiFCdsohC+
         yNCA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783079149; x=1783683949; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GeUDSjrHAWkuRRsR++4INezbx04TBh6B1L1rO/GgWvo=;
        b=gpVlvvjNWqv6inkXDAzUGekF7rJksIpyQSqAz1/JeiPQZAyAdKiRY1TRQr+ZsEQTDa
         dOvrnHlHNk2uaYstKxwjyDSXbUqclwp3hfmAJQnGydMtQz0FPre5xpoVEWVMgszZTdSB
         b9CteiS+gWE4/uqwr86+KkDj1kWqiVwzUJtwYfERaZZBjC7n0xMubtHQXSAYlWzanc3y
         rbOMUYpQ83tZ2fad4vMOnkztzjk0zE01NwQy+ys5zwdnaGtMQaTVFc2grTLEea62qkoC
         SfSr7tduEQPybp0pxJYUvGKgbHJpzqXgrgxD9BLroJ+MmEQovsPbKcOYcdF1ZZotr1UQ
         rpeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783079149; x=1783683949;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GeUDSjrHAWkuRRsR++4INezbx04TBh6B1L1rO/GgWvo=;
        b=YETszAPupjWSqDHZAsE1FUrm70Sqw7dHC3ZaYyMMjdvy3mFDCRDzXkFai+37u4CKLb
         wl96eAEl7HN2wx/6AbWMujxlSrcsazSCj3W2IW3G017/mZuxidFdCdL1Adc/DLex2BoA
         vq8Fk2QfMRfiM5rGIu7uKQrqFVod/yXI2ohI0X65byEcG6vMb2w6B5gU1HWWgDppRCZC
         DD//pnXHsMPPC50B/fPxv+H40OA1LhZ2G99nPH+oljY2KUGmmmxWD3XwwrTkFg/OflC0
         kSXqkISQHC5dNn0HeyXthyTCaW4Jyx3PeE3LZtw0ow2sX/FDVOVT4UrpVYWtzE1H3Qty
         MAqQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr8FApKl+SODScaFO9ZsWYvi2zVw/SOETFYlaoZWy+MHc3xYZz1kFwj37aKTVktUJVbCPJHQvCpzVc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwY3v3dbCvaRiRxJeVUGqTx2jC/3abOfM2smA3cvsKBwSlvLUqe
	H8sE+ZvgcQ4xXqgpnMuSkyVhKXgW9pIQvJaoVpn4VBPkGAmG3B27Xu6rhX5UTfc6Um1dRpX1cmE
	U948bHM2y250o/b/7z0FcuIea90fnAZjWb1yZmnKEh4kX0xIE7/ouVDastVgEUBc399KydYKMz4
	Yy16CyJv3hFg5vxbYBZyvWyhLwgPkKl5t3QrREO+hcgGgUzZE=
X-Gm-Gg: AfdE7ckfJ11xTt5XdLhaFwsRHIrNHSwQdDr81COiExeSbvbEpcuY3Ua2CW04x9RcAnv
	/2iBTbjfb6LYgx1tW6plpz8iyvhiYbQZbDa/I35sIm0lYzTHONASkJOxIGYIAi70zoRKPSCUgD1
	1k81yjAcLy8nYab3lSlLTvYos9QS+/9pe8rvWrjdzvb+a8vK/CGSfJWmh2Xk75Pm3DW02tCPlBG
	LzRb9UaUDpPkuoeJWHBt5jfDj0yz1P4vxkyq6EeT2tcwz56U/Xajjs=
X-Received: by 2002:a05:690c:6e0f:b0:806:1ec8:9626 with SMTP id 00721157ae682-812eae80545mr104664857b3.39.1783079148659;
        Fri, 03 Jul 2026 04:45:48 -0700 (PDT)
X-Received: by 2002:a05:690c:6e0f:b0:806:1ec8:9626 with SMTP id
 00721157ae682-812eae80545mr104664337b3.39.1783079148147; Fri, 03 Jul 2026
 04:45:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com> <20260701000949.1666714-13-joannelkoong@gmail.com>
In-Reply-To: <20260701000949.1666714-13-joannelkoong@gmail.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 3 Jul 2026 13:45:36 +0200
X-Gm-Features: AVVi8CdOnoIEUsSqGG1Lvbx5AQnAbjO-BXv_ely4Zi6OZQFZeWID1WZjNQSTcpA
Message-ID: <CAHc6FU76J-YYRd2B=ZPN2DMabQjkzgG9qSzbP_S1s9AsSJNh=w@mail.gmail.com>
Subject: Re: [PATCH v2 12/18] gfs2: convert iomap ops to ->iomap_next()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, 
	"open list:GFS2 FILE SYSTEM" <gfs2@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Joanne,

you say in the cover letter that

>This series is submitted against Christian's vfs iomap tree, and is based
> on top of the current head of his tree (commit f2727952b21d1).

which repository and branch is that? It's not vfs.iomap in
git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git; I don't
have a proper merge point.

Thanks,
Andreas

