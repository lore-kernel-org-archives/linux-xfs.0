Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834A32522AC
	for <linux-xfs@vger.kernel.org>; Thu, 17 Apr 2025 18:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915910; cv=none; b=aptIUyOZRLJFq6WLJGrfDSeUUYA/KDEqfOdmLZ79K/Vnc2XmFFiKZ77zn+SEUZBINadMXgcT5IquErn7vXpVPqGFP8YzTXIMc1dOOMrc19kBfalXs2bdVt3bUJZ8XvCalIrN4RkDuZAbrxcL6av348t08cIxT2sNDFGWr6KBOQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915910; c=relaxed/simple;
	bh=EiSDT7B5V3INo4xW5fVIzLbB+yyFWvx8ClcV0iouG/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sFO56byC1Er1P8WwPpfjss6QzE9kmWyN6MJeK3oTwLjYjCGpe+jzdEBJtePUqD2AbfulYpjmLBEqazFFV+0+vFQurTZQNKuzRL9GKClsna+dwDv0XHyrVWJBvm/+4bHJkeyYBSXvTuKcqf3wlJLmw6ocg3xav8Xb3YNIMywc3xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aryjY4kS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aryjY4kS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744915907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BR0w5JVmOPioxeEkwX3HYhzK8fFFSjlUBd3Mssu8IiI=;
	b=aryjY4kSR2FtezyzCoWydfOLP7o3b1ANsIGKsfKQn3JI9VNIDJGqP3mb0C+XyunLLF5eWP
	UDnuCcCaw5wW27E+i5C+Kb+Db4bTHzj0Ax7Ockg39Q2NQr6lVdcCzfUrBWt6KbNiGH/gx6
	rFY9oBP/xTzVsb5UxltzkkH3VKqlnHs=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-282-MrgjetP1MVqwn885sJFzzg-1; Thu, 17 Apr 2025 14:51:45 -0400
X-MC-Unique: MrgjetP1MVqwn885sJFzzg-1
X-Mimecast-MFC-AGG-ID: MrgjetP1MVqwn885sJFzzg_1744915904
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d44dc8a9b4so12216435ab.3
        for <linux-xfs@vger.kernel.org>; Thu, 17 Apr 2025 11:51:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744915904; x=1745520704;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BR0w5JVmOPioxeEkwX3HYhzK8fFFSjlUBd3Mssu8IiI=;
        b=ZJ2xGXlkji/oR4y60eFpUy8q/OlzUc/RMqxzwbCjWT/Sq4QmnusjjATHe8gyIEBEs5
         Wmop8nAqS/qvBT37OqUHED0TlRavCEUvUnXL9AMk6yz1DaNjrn0Su9zuNl/qkLwJXXzL
         o1InjWsRCpNr+lkkc98bTb5qI8kGjKE5+h2yHeV1jnsc5EQQURh05TKHaDyQc8f4w1Uw
         4ufeCdXSq5gmGGPPfqgYUID3jzT7xc3/oGf0JkHoxaTmW8N0/NMGATFpFjx3t/9wKNpM
         Qa4SaPpCoaQh1UrzAQOuoETEMlqTR5mKNuq0yk9xPVBnbIAAAPmh3fvGgUtrVUxT2tbY
         65oQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6A0z1c06eVLxkJOduRjyahuJm6Au9VEGNN34ju7b0E+010LtGcLm7bhU4Ukhny/6fgW1LZiSkpCs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4c3robWzUjnzHZDAxr5uSchh+rweHkPgL18/BcUCVeTH15q6U
	urDcqKBWIL0GYPXdg99eawpU/DoXzhZeyWvzS5KkSG8IpqK2E7Rm5M13OS2kMetwdplWvlTQZZP
	y8qZEuu0CVjMN/alkU68cltCNTSclXBRBgIcuGfy2PsR2ZFDvdYzH/8+aRA==
X-Gm-Gg: ASbGnctrAjdLhvniR5UNhs3PjWEOKxMPsUAu708/K7EWj31FY3OmP6lW2i25LSZeyb+
	Wsbwbes0MmujSuZ5Y9jCU80B8UddDdXeVTYrHxfADKvjt+l+fOu2chSv7ALw4iZyXslUXGDMMK4
	xedht/5v+XWr25wv38j1h/gQNTdvm3vfqE+iFqu4kwKzy6k+90dF73ffXIxsQxzjYOid6HoQMbo
	C0ANY4GPh4zpG3eua16FL3eZqzazjo2sz7GGFVDtvTkoGTkAoL7ljcd3rCUC6wB2wDZ8/fkgPoB
	0OcQe2gyp145ZMLTXuY=
X-Received: by 2002:a05:6e02:b45:b0:3d4:6ff4:261e with SMTP id e9e14a558f8ab-3d889021a0dmr3873045ab.0.1744915904436;
        Thu, 17 Apr 2025 11:51:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5YX/yiVZivIo3N9uAKbRD/3Tbx0ZU8dcf9mmc/9LluxRgvTwwE8254oDcpC+lfJ+HYdPIvQ==
X-Received: by 2002:a05:6e02:b45:b0:3d4:6ff4:261e with SMTP id e9e14a558f8ab-3d889021a0dmr3872855ab.0.1744915904163;
        Thu, 17 Apr 2025 11:51:44 -0700 (PDT)
Received: from [10.0.0.82] ([65.128.104.55])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a383345bsm78469173.61.2025.04.17.11.51.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Apr 2025 11:51:43 -0700 (PDT)
Message-ID: <1973de19-ff37-4aa5-9ace-2fc499ea5c4f@redhat.com>
Date: Thu, 17 Apr 2025 13:51:42 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH GRUB] fs/xfs: fix large extent counters incompat feature
 support
To: Daniel Kiper <dkiper@net-space.pl>
Cc: grub-devel@gnu.org, linux-xfs@vger.kernel.org,
 Anthony Iliopoulos <ailiop@suse.com>, Marta Lewandowska
 <mlewando@redhat.com>, Jon DeVree <nuxi@vault24.org>
References: <985816b8-35e6-4083-994f-ec9138bd35d2@redhat.com>
 <0e47cb04-542c-460a-a5b9-e9b0f3ef6c1f@redhat.com>
 <5c60155e-baa6-4a6c-a872-587397cf677a@redhat.com>
 <20250417183453.75qm4nt6otdktjij@tomti.i.net-space.pl>
Content-Language: en-US
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <20250417183453.75qm4nt6otdktjij@tomti.i.net-space.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/17/25 1:34 PM, Daniel Kiper wrote:
> On Tue, Apr 15, 2025 at 08:08:12PM -0500, Eric Sandeen via Grub-devel wrote:
>> Can I bribe someone to merge this fix, perhaps? ;)
>>
>> On 3/27/25 2:48 PM, Eric Sandeen wrote:
>>> Grub folks, ping on this? It has 2 reviews and testing but I don't see it
>>> merged yet.
> 
> Huh! This somehow fallen through the cracks. Sorry about that...
> 
> Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>
> 
> Daniel
> 

Thanks Daniel!

-Eric

