Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF951C84DD
	for <linux-xfs@vger.kernel.org>; Thu, 31 Jul 2025 14:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753973694; cv=none; b=J+X5xu0ELBT4EhCbxI5vkWsZxWvzUQ9s66ngkInRJGVamhYW7d5DF3xxkUiN+HOhg4E+13Nq517TcYUso5DIig5cV+CcaeTlux+45+aoorVk/UbYRGYu7xKzjK26hFo3d23A5GXbTZAH39SSdEYYSLAgddmO9DHHqeZ6kbObRk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753973694; c=relaxed/simple;
	bh=PTsHhQ/kGe0Fu+dlTBpQcyKEL+I08vmxkGV2copBL7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bIG4Ffy2ov90S3S5JWPBpBiK0KhZJUTrcNUgeDXMIjmCuwm/fPclFaHH6ocp1bH3gDqX2wEv+2E28t60artZQb3SHuxLpOxM5GA/UPb6MvKMM63VZbSD2drHHeXl6/xYuYglLk17hnu2UuiJrCX+xpPRS6bp+hgHEMqiIaGm9VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cS5pYJ9p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cS5pYJ9p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753973691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BrfdQfBwi1hWO79GIcUjuPsQVqZpwzL238pikFlNxhM=;
	b=cS5pYJ9pD37zbGIYMqP3vcG1bzqBeb6sDJhxtodH/v1wdkUnhlXXPgypMczMCmY2mYXjR7
	WEPZ+07n2AicTJXwfjXkSE6tyJbSTGUD1sZWgIEZ1mWsyqERJ5rgDueDExOZH4DxrokOtp
	5B2W82ZvMb3J+J9Bj65Sb/1TYAfD5Xs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-2VymLSI0MbW_ziL4_lgzyA-1; Thu, 31 Jul 2025 10:54:50 -0400
X-MC-Unique: 2VymLSI0MbW_ziL4_lgzyA-1
X-Mimecast-MFC-AGG-ID: 2VymLSI0MbW_ziL4_lgzyA_1753973689
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-adb33457610so124376266b.3
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jul 2025 07:54:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753973689; x=1754578489;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BrfdQfBwi1hWO79GIcUjuPsQVqZpwzL238pikFlNxhM=;
        b=MDSlDO/C3SOlEAHI6jiw/6bAy4YC0qhNkrKf4L5eO3ds1TDGarYm9JPKXXTsLsMvVb
         +1Z1QDcB/pbX12F2SiWLc8yM+a3Agr2kQuBmQfdocqUmNMHFym0h5rZTFLvkV8YqyDbE
         4iqSPFgQQWbzJQR/kLSyVt/nng6SPhRTINPOxms0+cnkuyPbGD8xV3WA0KG7g95+rCEL
         lDIn/B0SLwz0UFZ7SwW1Z6P6E0bOSoHcliUrdZlWrl+rTO7eHa0XYSK9S555tgu9r29L
         Vo/etD2iRrhdpM8VBTHk//v+ls5vdIYFF6BeOfwI/hz8UnHHlH6L2GX+TRfwJ4ImJxHD
         8n1g==
X-Forwarded-Encrypted: i=1; AJvYcCXSpbP6NwJNc7SeEiG9uyBJs+f4wxSyvaDjYcbvSlrYfvgDm/iF45B+rzkQBiVlLb2STWJV+CmTBIo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc8q0WweTSlqmWxozOJaBYNjlTdwYIGow0XUpnhTtaxYocLuTJ
	edG9NEy6la9hnmLQOWwsmAuYKUMjRADbKMV8WBIoHF59Rv/zuYsC86F5vCTQf0ih5D/TYM18/rO
	aRkhYH+S9rLdLMUhmJs6pUzLbDYqiU2TL1vovRP7iOMdoDiY+NDcTlB2zwhus
X-Gm-Gg: ASbGnctvxvoVPOTpJ7VU9LG7tUw8mgW/KLwAV/pEE4XntZkwswrA1ZGSUrcXp6myMtV
	6kt1bkoR7QZyyci3bR0yIEAELUBIebGZRKuOJk++G7n55PzxBLk7nG9HvgPyCfCgYQd6YLHTVf9
	sVveM6YZA23lcBk+EyIspTcTtu07ug17Ve7/GPmjqe4aIOAOkTvIwgSjx/8Gl92DOUZkLJ02s/n
	t3ZS7nO0SBq6ps2Ft7qCR5zJcnQN0jGs8oT28kyMU4mbEq34jpUVWIvb4553g4IkC9F0+rH3DKX
	9UyMGXGFlCshMBLZ+QMWjgReqOZeH0K8LeN/Tn1Nn7WHz491oF8k2wIui24=
X-Received: by 2002:a17:907:728c:b0:ae0:ded9:7f54 with SMTP id a640c23a62f3a-af8fd97fc2fmr965811366b.28.1753973689106;
        Thu, 31 Jul 2025 07:54:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQ3bIkVHsPhtB7sHOYcgzjtiQWjSNXEBdItzzWHWGYY6piyQqHIyCNm3v0vApEyCqdPpdWZg==
X-Received: by 2002:a17:907:728c:b0:ae0:ded9:7f54 with SMTP id a640c23a62f3a-af8fd97fc2fmr965807266b.28.1753973688663;
        Thu, 31 Jul 2025 07:54:48 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a076409sm124698366b.12.2025.07.31.07.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 07:54:47 -0700 (PDT)
Date: Thu, 31 Jul 2025 16:54:46 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org
Cc: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, david@fromorbit.com, ebiggers@kernel.org, hch@lst.de, 
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH RFC 26/29] xfs: fix scrub trace with null pointer in
 quotacheck
Message-ID: <s36etkudrevqb35gfscyfeibrwetxyrepuc2z2xg2bcgp7dzpb@hhaaawzg7vjq>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
 <20250728-fsverity-v1-26-9e5443af0e34@kernel.org>
 <20250729152839.GC2672049@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729152839.GC2672049@frogsfrogsfrogs>

On 2025-07-29 08:28:39, Darrick J. Wong wrote:
> On Mon, Jul 28, 2025 at 10:30:30PM +0200, Andrey Albershteyn wrote:
> > The quotacheck doesn't initialize sc->ip.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> 
> Looks good,
> Cc: <stable@vger.kernel.org> # v6.8
> Fixes: 21d7500929c8a0 ("xfs: improve dquot iteration for scrub")
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

@cem, could pick this one? Or if you want I can resend it separately
with tags

-- 
- Andrey

