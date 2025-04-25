Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35B7235C14
	for <linux-xfs@vger.kernel.org>; Fri, 25 Apr 2025 12:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745583865; cv=none; b=M61zyGozXq4h5xZ8Z64Hvn98yuwEaSE5LQ7Z1W3Tey6UcNA8uWvhS5JZ7mUcSxRIoeS6l/tQQ8FXvVRaoueKhyRv87TjS8WzGE6Qm+XvifIbNM2G+HfE0wbJR8WRjLPAPNK/EfE0fWBTtuGmmvmJDGWBefspW8Ci9MKsuEWVPT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745583865; c=relaxed/simple;
	bh=3u+XWkdH/OhqRywkR910oXo/r1LYabItRlXfssqaCQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V2LdlMvuZqtfA8Rj8cvpn4HLEf92EQZ1FS2cpJ7UKlmt4m5MUkl41tmOmm2odBjRl2fJG3yc2gGkOlef9C3hpXSB+1VLtQtnv5tPi0xF806RPXCLt6tOLRgnU8l4vo5AX/G07k8/h8HPArJgLT+iIgAiKyTLJMyFIjDnC56d7G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OtbiZcjw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OtbiZcjw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745583862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IMHafoWB6/X/OlqkxsERkQzyJ9SW7FAPJAtASo8yIV8=;
	b=OtbiZcjwq+k2cRH4HnljPEQlZ5iunsnwi75LKD0g7e+FIb3f4SUndquQ6FZ9OfFmA4a5VH
	e+lW9mWGfcdmUBSIS2qu//62Wn4aI8/IcKNWt732ARflI2ThVTeVy1RHXR5sN9mPk3Mk3w
	vvJAsaLO+AUjeiAUTIshhkWK7nJbrQA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-aBZ3RrxJNluAmwN_oHgTEw-1; Fri, 25 Apr 2025 08:24:21 -0400
X-MC-Unique: aBZ3RrxJNluAmwN_oHgTEw-1
X-Mimecast-MFC-AGG-ID: aBZ3RrxJNluAmwN_oHgTEw_1745583860
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43947a0919aso15706895e9.0
        for <linux-xfs@vger.kernel.org>; Fri, 25 Apr 2025 05:24:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745583860; x=1746188660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IMHafoWB6/X/OlqkxsERkQzyJ9SW7FAPJAtASo8yIV8=;
        b=mpdBGGBdlt/9+Slyo9j6VPCkESSAm409gD4r/Rcng9e0Aqs0ANer/TjiUY85vRiXLe
         8OU2pTUaBT1GOQPMvgqPP8E8YoCpwdYMTZfPEwTMcctl+EM2H0ol3LXKUCHUxVagKXdx
         +8wpH8021xe5p3hCL3tocjvRvzNTU2783ttOHvWA//np0971IhfxoGajVAvS+5dt1FFM
         ZPh/mOWEJ+T2DixdwM5KY3mE0/jKSFB8PHEhAq/2thu8Okri1ZmSg0/qtc6E87MfzaE0
         D0bHiIs2uY6i6fkUrTOQdCx3CyZYVPUuGrtI+a+aXoVEHUzm4lRqXvSydLmGiwwnF30h
         j7qg==
X-Forwarded-Encrypted: i=1; AJvYcCX/mZIcWM4WQWhsG+H9TojaI9opdqNQJ5TYYoaZcBes2DzOsPCKXKSgHST4vaYgLv0Bz/uSeyAgi7w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxE11FqTHBikgDiYfb5qxLzZzI5TNx6wDJW9hPBFQBsJBy6yxG+
	fa3CaQVWw2G0WmochT6hSJKr2KdHuuEgK3Bapsi2yVE0XwU0Z8fKnLQ7KpjABtKQuy2uttVhcUi
	L3ws2UuvQBSyrgRw3Vc6mTASQRCJkbFrjLvjGo2Xo3swweuTtGfz3IQNu
X-Gm-Gg: ASbGncs499+JBgfjCnmamZjJyhTlG0bbTXe/37JDKJYxEXFtIcguSq8ugPjwZg2Vzhu
	aYIDOt1Obvdib+swxM0X74/YeonLpMHq2fFo7k1cMJCQi/0rz+9jyxGI38pzwbN305ZubN8Na9C
	AMR6xUnabmyDAoYh5BGmtbD6MvNOToyKjOkgr5uNetWrpe6RLmna8b86Sflf9FL/CHVPrd4eqOY
	5wBxa2AkY3XKv9lMKEzLrhYqH+5mSCHKa7nyexKLlnR25t56SPEQf4YqlrJGKoy32Xxda+nZEZK
	ki5wQ7LUlvBa8aWdz3JJS9GsP8KpbhU=
X-Received: by 2002:a05:600c:b95:b0:440:8fcd:cf16 with SMTP id 5b1f17b1804b1-440a660c267mr16046955e9.19.1745583859981;
        Fri, 25 Apr 2025 05:24:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEU8vN+lAUdswZoaGEMYIAjGGnaQ/ylNSb2zoB00rPOjLij1prCM+/AbvJsUqoNnhKl+ZQsnQ==
X-Received: by 2002:a05:600c:b95:b0:440:8fcd:cf16 with SMTP id 5b1f17b1804b1-440a660c267mr16046705e9.19.1745583859514;
        Fri, 25 Apr 2025 05:24:19 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d29ba29sm57499615e9.7.2025.04.25.05.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 05:24:19 -0700 (PDT)
Date: Fri, 25 Apr 2025 14:24:18 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs_io: make statx mask parsing more generally useful
Message-ID: <mxosstlk6jazbwu7gtoa5vw6wibyaefwmj7no3cfz3mqtx2sg6@ubtpx6mv7h4n>
References: <174553149300.1175632.8668620970430396494.stgit@frogsfrogsfrogs>
 <174553149393.1175632.5228793003628060330.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174553149393.1175632.5228793003628060330.stgit@frogsfrogsfrogs>

On 2025-04-24 14:53:39, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Enhance the statx -m parsing to be more useful:
> 
> Add words for all the new STATX_* field flags added in the previous
> patch.
> 
> Allow "+" and "-" prefixes to add or remove flags from the mask.
> 
> Allow multiple arguments to be specified as a comma separated list.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

lgtm
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

