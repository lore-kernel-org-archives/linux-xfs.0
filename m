Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62A42BE7B3
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 18:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757960471; cv=none; b=tRx5v7rYMre3o/WopFATK6H/kuusK4oM/rYkgWq6VZGktz02NAA6SdLkvPjhwM01H4L+iR2JaXIqbdpX79u/3A7PbXL4X06Ks5ueFw8QzjeVQAy8oR0yRKIvh2DNmKhicviUcsMv/JqQHPM+CU6cW4em3ARVw6YrSY+eiosNVO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757960471; c=relaxed/simple;
	bh=0aDdECbcFnvzK6gvTk++iDWF1gYYmeS5TIpHZBB7Yb4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WtHXyFVNP76v91t3+Y6eiiI/yNGWFSaoaAacmGlzuoIpOWjkiO8WsVq2WDNGZDXeNdM3Uia71SUapePG8p2Wi3Ejz/SmNxz3FtjD6O1RXahVTZbtq7kUptUdyMbF7a5K9f2jTfhtHJui425GnWkVX2JdFVKAWiEtOAewbiQSdOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=VyAopmCP; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="VyAopmCP"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-72267c05111so34665927b3.2
        for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 11:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1757960469; x=1758565269; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D+GliT1Pd8d53HWEdMQBU1YHyq1rnSI3P+2j/fil2q0=;
        b=VyAopmCPFu7azUOHo0iM0H7C1iay8VW3m34YkV5/b7mkIrzNgdYj5gIB3MfbOgXNdw
         An1WLWvxpwHETRBOl6tExv14asHr/pcrwj+azTUyrRbWDdskINTs5rsmOapntNqNXL95
         t81vuvAhPUOVXnTPbrGYMDEg5e3GgK/d72EbDKkpXRHbEahmQtKj5f/MPk/JGqiHY7Pq
         En+4QRjrwFfGtSEBIVtYCHLnbd1yI+elNGt3Lf9l0fJMxlbjMhQIfYtIIsyzRsBAdvNH
         TG6/v5FypG6rdlO1ex/QEMEoZhYXH47Yn/9WI67xG2S1GDFt4p3nCwKGtO8N1hyud4OA
         XhBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757960469; x=1758565269;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D+GliT1Pd8d53HWEdMQBU1YHyq1rnSI3P+2j/fil2q0=;
        b=vs7NL2SfzqQ+p7rMSOzzUlB13MgwL38GgsWP/pzhLOLfpOdSAuLge1RJ9YRpw7dT2j
         2dA1IWMk/v504dKzCxh1J1Pu+DxMeJEbUKIRUjQVI8X0UTQC0VZ7sphsC4qQQk66G1jI
         4vaN79f3V25N1CQz0PZeE11ZeJJcHyQrvso/D5QxWlVPnT0OhIQP9QTuR6TQvFp9Pykc
         UK5yDarY6oxUE4ho0Ud5j0mYmGeeWkoy5Ck8dHp56siLoUcpn8c+wDoOGdMmVCEi4anD
         WCVDNQgS9DzQDTKcX2Yv5MuWDJjrfxM7qaxqdt3rowgOeX6SBKB5VXHABBg9mlXeibCt
         am4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWeib7YEWsDDF/ZVep5E8cC0NPxwp8Y2+jVIugSYT00cVV2HF82gFjZFASUL4VZB/sSZGo5lBkikW4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKGJOF9OaQH9RECeND7chVowKtXpgBbVDSN8kGyJR1G+1vbIjE
	COmpB4M7xpdI8zrLPwDxG8GFNGc+YESgeCVXRuPnJbDEvifGpOG1ipQx5cUrpD5PyKhj5Ujuy0q
	MyVzD825bWbwF6UVm1C6gEiYnoxdBT44OXeWJf0EwQg==
X-Gm-Gg: ASbGncsPi84fjFuaU0VOngn6CfdoDLT8iiZtnfjM/X5hQ4XONKEx9bIbOQo0SQqg495
	kRCB/M2t6QenDN4RM5u4VztTLrx/mxxcT35kwxUmOI5irmi7XiLDR+a9tdT27+Eo0xyVAFJKMoY
	JdILbEF/yFqoLeQuQyMimb+ZUDr0ONWLZYRq9j1G/4FbN7qQJK6BsYOdfYDDcTC2RGDYdDzk47M
	j7CaUMyibGchiU=
X-Google-Smtp-Source: AGHT+IEDp5ZYxkbjon4yCrRZanz3ywO+1Dqvmg43vzDGc4l+oL6FL33NrpAa1korZr0/WJwLYzGBFv1kfMtD4v4LVjo=
X-Received: by 2002:a05:690c:9c0c:b0:71c:1a46:48d5 with SMTP id
 00721157ae682-73063480b69mr133022797b3.21.1757960468639; Mon, 15 Sep 2025
 11:21:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <8957c526-d05c-4c0d-bfed-0eb6e6d2476c@linux.ibm.com>
 <BAEAC2F7-7D7F-49E4-AB21-10FC0E4BF5F3@linux.ibm.com> <CAHSKhteHC26yXVFtjgdanfM7+vsOVZ+HHWnBYD01A4eiRHibVQ@mail.gmail.com>
 <240A7968-D530-4135-856A-CE90D269D5E6@linux.ibm.com> <20250915142612.1412769A80-agordeev@linux.ibm.com>
In-Reply-To: <20250915142612.1412769A80-agordeev@linux.ibm.com>
From: Julian Sun <sunjunchao@bytedance.com>
Date: Tue, 16 Sep 2025 02:20:55 +0800
X-Gm-Features: Ac12FXz4gtGN6Jqt9p3sI4NDKpM8RKfj3WgCz5dLwYdzbiuc_wRBtKzbSNJCafg
Message-ID: <CAHSKhtc-514tQoyCSukK1sLbDbc+Ne_TnwEks-h+gQWv8ZKHOA@mail.gmail.com>
Subject: Re: [External] Re: [linux-next20250911]Kernel OOPs while running
 generic/256 on Pmem device
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Venkat <venkat88@linux.ibm.com>, tj@kernel.org, akpm@linux-foundation.org, 
	stable@vger.kernel.org, songmuchun@bytedance.com, shakeelb@google.com, 
	hannes@cmpxchg.org, roman.gushchin@linux.dev, mhocko@suse.com, 
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, riteshh@linux.ibm.com, 
	ojaswin@linux.ibm.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Linux Next Mailing List <linux-next@vger.kernel.org>, 
	cgroups@vger.kernel.org, linux-mm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 15, 2025 at 10:26=E2=80=AFPM Alexander Gordeev
<agordeev@linux.ibm.com> wrote:
>
> On Mon, Sep 15, 2025 at 07:49:26PM +0530, Venkat wrote:
> > Hello,
> >
> > Thanks for the fix. This is fixing the reported issue.
> >
> > While sending out the patch please add below tag as well.
> >
> > Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
>
> And Reported-by as well, if I may add ;)
>

I'd like to but I will resend the whole patch which is used to address
another issue.  Thanks a lot for reporting anyway =E2=80=94 it=E2=80=99s ve=
ry helpful!
> > Regards,
> > Venkat.
>
> Thanks!


Thanks,
--=20
Julian Sun <sunjunchao@bytedance.com>
