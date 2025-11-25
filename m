Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A5A2248B0
	for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 13:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764076889; cv=none; b=jjnMguys4cF+O5u+uR9oJCW3h5pAfvWQw8/OCYDtCHItZpKXkDBcwA4Pnxd5YdtToYn/AN0GBcryGqZHUZZy3AKRX6dWGFnJjOP4/aC7pofcf6fS1B4RdzibkXeRIIpy7IedgrwQnDXMCtts1iRDaOb3Edth+Z6GzVjZJYnu08c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764076889; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TRJSPE3S7oclXCW4n6o924tBovR1+D/3ofcf24294/ycPyCX55yOUKrkc7QMNqoWmBTuPGjfRC8Pwcrh3QU9eOgW//DPbVPW9SpPTknIoyr7SLtcuafWbFSwvGA44HZyKo1PqkQ7qiKDRFCzndoYhPgBCQQN1kZ2rQqzQaLzh/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S+srcaVn; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S+srcaVn"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-640aaa89697so7669104a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 05:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764076886; x=1764681686; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=S+srcaVnwTxEdnt0DzwKVDmyzP6pEIuKZQ6KOQhhkFH55Kf3bIyTii4YGzezHnioU1
         BBYkyEt/Q3kpB1JK8DiFDywmJcmjQi195XAudmtDcJJk3/LP+N05sDr29iajWcEfyspV
         ptVKgZGgloWprMleh/CxAuuHEzJ8Y27OX/vai2k9oJSWWM5Q9P3MjO7J7pdcQQ5/y7yF
         GGNGC4rlVIgqYnpeHKVvw/vBKePkVKfBusJmBUTdghkiVwKK9ZI6p3QTyAS5f7vqJgNI
         zC6XBusssXX52DpdndBIPEmPFZDu3VD3UyZem9oLxxR09sUkNGA8vo83e9BuQa0vLBPj
         ISnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764076886; x=1764681686;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=Awg8JBnWAIgOmWZkyS/HIqv5nBN2EVFUUZMTKxQBiaX/Ie/UusOArqgQJec+MbsTBA
         u99q2CyBQJJsHLe81zRWil9qtY/ySashGisHTKc5qmSrb57iLUy95LAeqJHCTTRX2i22
         In1IsXa2tryul28OEayx/aCcVz4M8guAMp+5Qw8P4ebwUkIss9RCThvnUJLjfNf6dy5s
         AezKNXxQ8kWogbYDERqE6JlNA78YtE1ZVU5bjxQjme+9QLKxgg8tdc4g1XKttXYiJ9Wg
         wKv5XKqkVVSQZY/bTgfcvYP/MJCLfbd/pcfHP+EvU7Z90sYHCpI/3332r3LNbq/+g5ij
         +ClQ==
X-Forwarded-Encrypted: i=1; AJvYcCXToS6V1GIuCezgukFp0dIjkQt2YqzOlPpKLPgeoIZ8ErnPhftEg+SrULzhUMJ38ZaxkbUeul8Hel0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJcmJ78rJUwuH7APQYGulvDddIF1oD7jfzHQ9h7xrTA1fK4Ymh
	DmEOEbKX8ozcfy+D99FtDOgdfzUhCB29N/ia/uqlvrY2jEhnGDHSO5la4nRcgE1LAoEDp7rMd56
	kjEhTudQP3KLzN5ycjN2yoKC83nKxNQ==
X-Gm-Gg: ASbGncsZDsEX1pYO0NRBIvXefl6Afe4T0KrVQcoUXMl/Vl7fMCUdWWJy3U8fBHrj3xu
	ylmuHoE47Fj5HMiFB76qZJOLl8sy7/nRuqst7SMnaPFYX4v4wjVCE1clOFHrZ7TSu3pX0nyk3nt
	Xx8ectaLqOKo/xBgFgJkQFKNPU4g12jRmTbGeqj4jyrpICwUj7jHVLVxLbeL70IhGXQtjNbUTOG
	Hh/pA3ks0CGmxXUkPUsGqfKdeULJjZIY8pPl7IzH1Cg75EXhnRISBakzVxXRxjRT2F0jWMbYh3y
	ywP7wHKcqXPlwxCCUSciF8DB6RRDODWdgzOetLRxQsR8LfqV4zpjqCG09Q==
X-Google-Smtp-Source: AGHT+IFdAjUbTCRihlcnMQbRe3kaTpxY0zS2TJvPnabL+VI06FANQqQrLV6dY7bbefHQ9hiFBD+KK4yE+DNgNHPMVMo=
X-Received: by 2002:a05:6402:280c:b0:640:96fe:c7bb with SMTP id
 4fb4d7f45d1cf-6455469c726mr15216782a12.28.1764076885654; Tue, 25 Nov 2025
 05:21:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
In-Reply-To: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 25 Nov 2025 18:50:46 +0530
X-Gm-Features: AWmQ_bmI0Nc-U-7V1vG_PnxUMzavwAZMXSjJQCtXVqm1t0YM1hU1mPKj8-N19OU
Message-ID: <CACzX3Avd95DD0g1ec5y3Rqhs6fpo0dqcKBScUr17AOHcw_2JhA@mail.gmail.com>
Subject: Re: [PATCH V3 0/6] block: ignore __blkdev_issue_discard() ret value
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	song@kernel.org, yukuai@fnnas.com, hch@lst.de, sagi@grimberg.me, 
	kch@nvidia.com, jaegeuk@kernel.org, chao@kernel.org, cem@kernel.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-xfs@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
