Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BC3192B7A;
	Mon, 28 Oct 2024 10:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730112169; cv=none; b=tc/j7j6qyh/ojYGg8gz5gd5SUDSlvPRFmp+X7vEf489zqM3ZUGWIk2KoxB9z+apFcD1cccWdOZxr7PbFvdaLcGa5mmTrjZYEwCE5sI/PTlg61LSHB4vlHiw/ULhKMon/RL3xdmLBTlTvvDTEhjTuEUuLCTgTpEgq4nCcE96tqX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730112169; c=relaxed/simple;
	bh=PJtkT24Z/TTon2g/ozKDLIhO9vz+L3zrXxrTJsClTpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLXZnYLTGy7l+lD3t3lDWiE08S9SMmGzXAewrBTrCB1/SkjpdGUuEoZDi5ksu2lq1LJz8gfakF5ZcfzCnqysN3WamOF0kYVbjTKftMXleJngzpFjAxXVkcSbqNxWpvrYjvlpiuDB2pP5qgJzo8ypOustxV2dw+0pb17Aq7d8DCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z2SEh0Mr; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z2SEh0Mr"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-71806621d42so2369114a34.3;
        Mon, 28 Oct 2024 03:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730112167; x=1730716967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oOmFAfCnDJXvI8RF8TapIJvUf9gtYEA5J0bX0oM9YcA=;
        b=Z2SEh0Mr0l8mRTpxLCuZnsFAlSfC4n6lyIMfRHLI2jQeJb8QnAUV1hM/q5GCIQDIGQ
         uvxc3cJjtZxeqaCW9igwdXo5oZj2PICyrgq1/g//+Zg15wQ6CVPeDenQ9epezO/5HURd
         T4EgKvKJhF7fCHJTcyQsRJaI5ulVYdyzgF8uuAskiqB5I6GJTz8A04d7z7Nz7RWjerFR
         vu+XMsxN8SnPsXC5o+0LVnsl+jByR5rvBen3UuF0YF9yxYvdu/XGG4q+If5nJQwvNS3Y
         GwIr59Zd9Xa8fhF7MJXDGGLzzGABgHqUPgWp17FvhP23PJ6Jy361ZEFF8q5unslaNbkN
         HovA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730112167; x=1730716967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oOmFAfCnDJXvI8RF8TapIJvUf9gtYEA5J0bX0oM9YcA=;
        b=o95NBmmZbk3yPaJhzJayrEaTLiYlV+m1vhoIh1pEXJsbyqjMklYJN2p8pDADNizPfy
         p9Me1IP+dshbr8WlOZBS6TYGGNVyZAs4THqt4DFLZ4TB5XAccJHrL/AF3RLdmJm97ehp
         RmcZwtAg6XRWWSAMiVOQOJVJ8QMGdxfon8Idt9AqjpnZAiERew8/84RKuRu0yMlN27bA
         9WDknJtlHjXP/t/uXXsGKn9QbH0BL/hjGW2enJn4AGa8ZqjaXn9cNG4uNC9I5rAiaEuc
         qjWc3xSZm3MnZ6elzP22SJcv84EsIpO/Nu3QsfOlkdvm0xk3dSWfFNJWl3n7nLwkCPkB
         QU6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVRQxAcSNENMEXp2e39GnzuMTIEcDv8WZ0fhXeaUFN6/W2/PhbxQLa17/IQpfqUe4o7dyt+yerH0/0XHCk=@vger.kernel.org, AJvYcCXtiOdJl8xVajgXKuz+lbyDMX0R/2SE9yRkIlkg3zII5EnYxE33hrmjZxDhfiCEcdZ1Xr28Mj3gh9O4@vger.kernel.org
X-Gm-Message-State: AOJu0YxdPmK7UgOmruE5djKFC6nWSbgLizo2ew5GTeu3eOIHZYRRQjOJ
	Dp3lP54kPXKHD9+4RXRj6M2c55MD7Su/Xu6Z+EpEsjnyLDon+AXF
X-Google-Smtp-Source: AGHT+IHuYND158uLrfePBzGMCJRxhcuOVOFc3RZKnszbWTqowu40j35MBXivAfLMiEsDRSYX7hagXQ==
X-Received: by 2002:a05:6830:378a:b0:718:4198:f7ea with SMTP id 46e09a7af769-71868287219mr7017933a34.23.1730112167078;
        Mon, 28 Oct 2024 03:42:47 -0700 (PDT)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7edc867995csm5443807a12.22.2024.10.28.03.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 03:42:46 -0700 (PDT)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: alexjlzheng@gmail.com
Cc: alexjlzheng@tencent.com,
	cem@kernel.org,
	chandanbabu@kernel.org,
	dchinner@redhat.com,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	zhangjiachen.jaycee@bytedance.com
Subject: Re: [PATCH] xfs: fix the judgment of whether the file already has extents
Date: Mon, 28 Oct 2024 18:42:42 +0800
Message-ID: <20241028104242.1114200-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
In-Reply-To: <20241028103332.1108203-1-alexjlzheng@tencent.com>
References: <20241028103332.1108203-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 28 Oct 2024 18:33:32 +0800, alexjlzheng@tencent.com wrote:
> On Mon, 28 Oct 2024 02:41:01 -0700, hch@infradead.org wrote:
> > On Sun, Oct 27, 2024 at 02:01:16AM +0800, alexjlzheng@gmail.com wrote:
> > > From: Jinliang Zheng <alexjlzheng@tencent.com>
> > > 
> > > When we call create(), lseek() and write() sequentially, offset != 0
> > > cannot be used as a judgment condition for whether the file already
> > > has extents.
> > > 
> > > This patch uses prev.br_startoff instead of offset != 0.
> >
> > This changed the predicate from "are we at offset 0" to "are there
> > any allocations before that".  That's a pretty big semantic change.
> > Maybe a good one, maybe not.  Can you explain what workload it helps
> > you with?
> 
> 
> Thanks for your reply.
> 
> I noticed this because I was confused when reading the code here. The code
> comment here says:
> 
> /*
>  * If there are already extents in the file, try an exact EOF block
>  * allocation to extend the file as a contiguous extent. If that fails,
>  * or it's the first allocation in a file, just try for a stripe aligned
>  * allocation.
>  */
> 
> But as you said, the semantics of the current code is "are we at offset 0",
> not "are there any allocations before that".

By the way, we only get here if got is or after EOF, so "are there any allocations
before that" means "are there already extents in the file".

Thank you, again. :)
Jinliang Zheng

> 
> Therefore, I think it is better to use "prev.br_startoff != NULLFILEOFF"
> instead of the current "offset != 0", at least its semantics are more
> consistent with the intention in the code comment and reduce confusion.
> 
> But if the semantics here have indeed changed to the point where it is
> inconsistent with the code comment, my suggestion is to update the code
> comment here.
> 
> Thank you. :)
> Jinliang Zheng
