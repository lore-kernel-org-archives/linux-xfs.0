Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602EA14B078
	for <linux-xfs@vger.kernel.org>; Sat, 22 Jun 2024 16:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719072560; cv=none; b=rdw5ST+pZt2eEw49aNWZ9Rg35hvGgf9v5jQrNox0uT9u11PNghuyyIsF48P4JEpbj2k9Vx31l+rmYcWDSdwVXHv5VgddqdGzUlGeHfc6b+8pz+0ErLsm0Wz5kOFeG45BK7rk6gG2J2yqNdaHoW9lKiozF77vOqeR0++ZRGeb4BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719072560; c=relaxed/simple;
	bh=7oD18kfo9S+9Xuvhrtu9sHiM+uAEubp9xCH8YLvvgt4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OHNBntcSk3iCNgcWHCBu3SEpgrAARquDQJpqXHchXzlA6eoDtMVjj+SicIpme5sfZPm0KpSmmiN80Fewt17u1hH1tUWYba/fGFuhsgpOj8LVFoN6hOWoxyoLWCj6czZUMDvUW8CXUJztwkdi2VwONm9uYXK1rV4ojqSG45qmeEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Al0o19/e; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Al0o19/e"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a6f0e153eddso369388966b.0
        for <linux-xfs@vger.kernel.org>; Sat, 22 Jun 2024 09:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1719072557; x=1719677357; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BhxsWEG6wVUdE7DyqH5OsqefkRs3rcLJSmwisp4Ylt8=;
        b=Al0o19/ehNlzPHEYyp+5aJOrarBb4aP1YO6YGQhdPR9VMQI/BVVFhhPpgB4U6MdnuV
         in+0tIqIO1nLOEs18YDajqOiYTXIuP375ntUn3f2yMzZdnERF9P7aFExBCnUF02Z6swv
         R3IzyOja+yVjNU8DCggwlt54Z5bypSIUEajn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719072557; x=1719677357;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BhxsWEG6wVUdE7DyqH5OsqefkRs3rcLJSmwisp4Ylt8=;
        b=SGq4s0q+KVopzK5AETvs/9WzTGArUJVjnvakU4JEfCFzSW3yhNFP89CQfY0GYSI1q+
         5DOGpC73PtoL+RDKZopVgI8Reuk7c+LIJZjJ+81UfzMkQkIzuml0EcvF82vIhVzd6WUR
         95eGpllw+DdgQ86pkesk4Jr2kc7mbZ5FdiOXymZH9sjBBZOdbkgNRoVxNy1oXVTWLg6M
         lxRjtkecFg4bBfG6vwf/LnvsM0rL5UCrXE53QrQCAW8p5ec1FIoVHXpr65EmyYwfrf60
         TL8YVHcOYGBuWAL4ZkP7kU7koX/mnKbQNBc85B/C3P6elTNJh/9Evo3ol50DEZXF58jz
         aaEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUozSFGJlRbct+BcQR01ZGYkFxL5BFHfXtEFapBtRWrnFAR+ZNpItXzUkLxUXTm4klTCe3nmnTEaXhvVUsgUC7wAVDwrTCdhTze
X-Gm-Message-State: AOJu0YweSgZEKsQnb3RhqXm642tBigGApZDZSSI5InWhr2/sOAFRL1xw
	xdhGe00ANEqxxD8T4FREdoBQ6mHTgR6rfAyTnX5VyxlRd2Em1edf2FeBi5gtPfFi07G3909bkOo
	VSibCag==
X-Google-Smtp-Source: AGHT+IGk6uV41qI1bODJGqwA/zfNxtZf6SC6csWESxUJoqMni82acn6hw6ozU0BI2sAiVy/InJS9fg==
X-Received: by 2002:a17:906:f88d:b0:a6f:796d:c747 with SMTP id a640c23a62f3a-a715f978a57mr80710566b.39.1719072556786;
        Sat, 22 Jun 2024 09:09:16 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a72440ebcc1sm22370166b.180.2024.06.22.09.09.16
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Jun 2024 09:09:16 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a6f09eaf420so342026066b.3
        for <linux-xfs@vger.kernel.org>; Sat, 22 Jun 2024 09:09:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUWUUQOtm24mxbmCnJLYfOVOaAY+IeV9hvM1v6kFazeXTXF9th0Ka3wH6MQHqIDDHxLJfn0ZZFyCAA1V9YMVeFPOBu6EKu8ciRn
X-Received: by 2002:a17:906:ba8c:b0:a6f:ad2f:ac5d with SMTP id
 a640c23a62f3a-a714d72c2b8mr81567666b.6.1719072555785; Sat, 22 Jun 2024
 09:09:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <87r0cpw104.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20240622160058.GZ3058325@frogsfrogsfrogs> <20240622160502.GA3058325@frogsfrogsfrogs>
In-Reply-To: <20240622160502.GA3058325@frogsfrogsfrogs>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 22 Jun 2024 09:08:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiDjORhZtww-_584JFSC3esGAeZZ7eLWdbaaEOUfwqSkQ@mail.gmail.com>
Message-ID: <CAHk-=wiDjORhZtww-_584JFSC3esGAeZZ7eLWdbaaEOUfwqSkQ@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: bug fix for 6.10
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 22 Jun 2024 at 09:05, Darrick J. Wong <djwong@kernel.org> wrote:
>
> EVERYONE: ignore this email please.

Too late, but I have re-done the xfs merge.

               Linus
