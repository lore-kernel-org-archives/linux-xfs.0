Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCAE4207F
	for <linux-xfs@vger.kernel.org>; Fri, 21 Feb 2025 05:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740116496; cv=none; b=IaEgvHP94D1fFN2bpBTCBqImrmLqx+FRLQ5wYZnpnL89Ca6q2AveHBzYsdtrkbBkJnuCX3KABcMJOOJONJYadWwguywPMTqo4VoK6iecMGUM+tsi/zI8cfWOADOeHz5agzXL7KMmb3xvKwyeXGcl/Ihp0g2x1qC6SSpUAH1XwgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740116496; c=relaxed/simple;
	bh=5fuovXFrDZ8KYVg0h+wpIEGPyV+6lpQ6s46/HL9+lQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=czs8N5u9MsQUoRaXnwX7GtuWtxOrW20CUKPPmm15liaC+e34L9C086JaCgX8opmoAfp/YtOJ1G5qmtj9gNaPK832yxsYZvUWCAKYsl5swAXu2hRNv0z/Y2XmFsJVkhCv/OUNMgBtDNQsUUxdVLVSpRFMqaI2bpbHwFKE0EfE324=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cmxt+hCD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cmxt+hCD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740116493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u8Brdm8UHimvP2GLPRaXcpovMp4fF9jG2VOJ+R4tZX4=;
	b=cmxt+hCDxqLh1e3/pDKF2QnWJZOecbjW7vnP7Py83rs74SYG5QG7TzGmaAYF8U/XEXBUtz
	Ch/TRn574+AOI8OeoJEI3dF910Sb3pqQKrfnAZbDGQ2HVf/Hi+x0IoqYhlyAmzzDAiOftP
	kWh1k/cPTQYZWRKGQgV9efmukxW3MV4=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-tCDS1DvMMnWtHreBWC8RXw-1; Fri, 21 Feb 2025 00:41:31 -0500
X-MC-Unique: tCDS1DvMMnWtHreBWC8RXw-1
X-Mimecast-MFC-AGG-ID: tCDS1DvMMnWtHreBWC8RXw_1740116491
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2210121ac27so37153015ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 21:41:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740116491; x=1740721291;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u8Brdm8UHimvP2GLPRaXcpovMp4fF9jG2VOJ+R4tZX4=;
        b=luVAIcR5Ed1E+RlQtG+iYQhNZrm03grCR9MBWM7FQCbxrcvbZnuPNnmV7DB/ZW6WK4
         aeMkZVnILzLJx/EMFmjYcfgO30ebt2aS6zThkYF3G6D08kl/+rSMCqy0hgWhfFJPmLVu
         WE4rZq/uiICjNpv4f1UJBNpgb8ETEG9eJpUjjkH2VbLAcFE/2iAVrmhS2exRrNKsCEHH
         n0KjP/qVSsnWrEj41R1WQBnn1nqXcRJEaViqdLFB4owQ15j+KWIAnlhTDPxCFds2wpUR
         j6Zbgwxo9XzQd1Djgtak+itw1jmemHwLOmxEk/ZuJpfTZMaUMs2WvO4ctz8Kiq5yiUpw
         IFgw==
X-Forwarded-Encrypted: i=1; AJvYcCUS2rmPRuaK4vAvjYqXVcA6gRWV0GEO29ysoJAbpFDNqQ86nl3RqjDHY+oEkHuJ97L8ZSoepdmQ2Uk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIPilSDO427MYDvD6zKfRIddOW/MnSsgb6qtjuh2nJ8HBQAE/h
	RzO7kyFrwsiGxm37rbWDULOeBbak4l13I6+AA39BtoQWBDQ9VpXG60U07T6bufsuzKia3s8070B
	tmMv+7HHlLx36SPCsuMaW45gT3Zv66Uu+jjFiNVQZYWPaEPR2k/nRwoOyMQ==
X-Gm-Gg: ASbGncuhcPf67sHA/Qbu6g9CahlwUnb+SSwJ7dUrNujRFhLOdco54sgfPoVy1d3fEP2
	bBBoY7exCagmJvo+obu01YD79aqoelO820fkd9iFAqWoXdYsDqCx6REawd0MP3FR7m/C85EmEQV
	fZtJ+V6X+qP9LTmy0WDt8Q4kc8jTYIYoK5CN+8X1NZoQFqK55l8ahABoySha/CeRhFv7j5QJGXZ
	94RyEuF0wrYy9K7vilO7mRRV1LivT5n5nFjQHpOFbbwu1BktLQP/8/xXx52YI31haW+B6nwdnmV
	g5e4yOkaZc6IBfW6mwM300G3AWV6N23gH2yWnn7yqjEV0/nwKTqBDxq4
X-Received: by 2002:a17:902:f68e:b0:220:dfbd:55ed with SMTP id d9443c01a7336-2219ffbed96mr32846175ad.43.1740116490793;
        Thu, 20 Feb 2025 21:41:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEZ9iUM9EQ+dNrGAkhC0cXA77Xz9jRN1YoTWlbVACW2tFsNrND4c00d0LtQ6LTUtqQq7J4V6Q==
X-Received: by 2002:a17:902:f68e:b0:220:dfbd:55ed with SMTP id d9443c01a7336-2219ffbed96mr32845875ad.43.1740116490459;
        Thu, 20 Feb 2025 21:41:30 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d53644e2sm130837865ad.65.2025.02.20.21.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 21:41:29 -0800 (PST)
Date: Fri, 21 Feb 2025 13:41:26 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [GIT PULLBOMB] fstests: catch us up to 6.12-6.14
Message-ID: <20250221054126.x5dc5wiidsnhen5g@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250220220245.GW21799@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220220245.GW21799@frogsfrogsfrogs>

On Thu, Feb 20, 2025 at 02:02:45PM -0800, Darrick J. Wong wrote:
> Hi Zorro,
> 
> Please accept these pull requests with all the changes needed to bring
> fstests for-next uptodate with kernel 6.12-6.14.  These PRs are
> generated against your patches-in-queue branch, with the hope that not
> too much of that will get changed.

Hi Darrick,

Are you much hurry to have this large "PR BOMB"? It's Friday for me, I'm
going to test and release fstests of this week. I planned to have a stable
fstests release this week, which contains your large random-fixes and some
other fixes/updates. Then we can move forward after that big feature change
last time.

I'll try to make a release next week too, for your big PR bomb. Good news
is they "nearly" don't affect other filesystems. So if they can through
my basic regression test, I'll merge them soon. Or merge part of them at
first.

I'll merge them to the patches-in-queue branch at first (after the release
of this week). Then test it and talk with you about more details.

Thanks,
Zorro

> 
> --D
> 

