Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A3B1E6311
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 18:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734114578; cv=none; b=VxnMjGGpw7cEhfC6Tgmre7WR6NG10p+FwYFg8ZRgAkT0Yf8MaPrfSwfkU4AIkeBRwYPKa1mb+6xZ5TDu6Q6SBsN9dapIZ5dYQGR9E0Wl9ptlM3rESSJ/yl7WyQ64uy+BGlxB6qHkE12328tohvJQDdhuFaLVjXL3psVUjlTiJuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734114578; c=relaxed/simple;
	bh=4KOF3m/0Bifz2VW6wubAqEPGAc3udgNEZgwPcPXV75Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qQ8vpCF7xzD/CoWE2oCAfBPhMGaxBG5EWstoDAz6fZxgKWddnPNVI6P5WWWyAm2AVIgvZJ2zk0BavgWunDvj0ydnpibCZ/vkwy4AXl45wXr1qm0DrDCnInBsALNKbrii8RXKAPbD4bdPEh16MnqSzVgLTCkQeCzWZFYd2NDqu6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eM5tshOP; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eM5tshOP"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5d3e9f60bf4so3303797a12.3
        for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 10:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1734114575; x=1734719375; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w7Akq1IU9NnCGzLIfyVXCrqpo+VZhfqVeJTjA4MfOBY=;
        b=eM5tshOPn5eCwwDY9qgjc3KqJQu1C9TCfklewoCZC8uJZkhKHzui9jQpKJlcOMxUtn
         1r1yQ999Zl7zFZThis65LXzYhVxBR8mJLyac14FDbsKlOKZyRr/GPD9CIjujvgV4j9Bz
         h3QBDZlvCW0NMjR8ws5v5qP9B9beu45UWVGcY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734114575; x=1734719375;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w7Akq1IU9NnCGzLIfyVXCrqpo+VZhfqVeJTjA4MfOBY=;
        b=UVTzoHxeJgDTuypg7fo5/qx0RpdsfTmPYayrBEhNzsnfuuWvNYdn0EPRlTHumcxlFU
         l3hkJPcUH+FN1+4dVv63s/BDHKKA72F//qX3VSJbBqNVzSwmM4ZipCby9GpmsSokLQ/P
         INQrcOEgX/X7hiy9xhYPp1VWb6RS3ebykUldFjFeoobuA0oAttggfgr1ZvFG3vSOvYiX
         i0SOmmIXvl4Tpc66rP8DPRk2bqWPPD6ZG+zcU83LKVkTQoluZ0nN8Rx4hdUjEL7dMpMC
         mQO46CFUM3xa0+EnNCY2B6zcer2JOMyiQWLfqUpjd3CDVP7bFO23V2zGna7h1vl/NjwK
         OXlA==
X-Forwarded-Encrypted: i=1; AJvYcCVkyDBgWzZMHt7CfL12EnjoFFuYvW5tK9dW6ylEbKMAUYNLEyrTFrmz9DnzNPvZj9NWQOeGXwDBQtE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeuVqwBZBZGM4wbK4jxU6xiwIuuJlp3JmvrQmQJOpCf+rHj9yf
	v4TclpeuEZquUyKdmN3IrfEFbSeC26AGh7Xg78kq1xDjaZy/b9IKquhvzglNQJ5GKUO/NG14N5u
	wX8g=
X-Gm-Gg: ASbGncsFDwj5eCQDMOyjAtYEIkmsFyAk46tuX/mdvnb2FWFmTtC1HFwGoHYwyuC4Kkr
	LfL28+qMn1mQKPKUAO2f+rLigftev+PL9+RhjQbU3/ae5CsluvBHPy70PKD1JqLNwRnar2iWYlh
	+hfAYBPKfJdrc8L+QcTkj07qEqZiPUXWA6C3isX90tUqxT1PbQA6rrn0yxuH6L0W8uUVBtwy+5w
	B/ITivbKEqyS8vQFlH6QkOKC0Phj1E5ykoPm4jQ572NTqnxquCL8qJbQerhST2BRn9NS5d7aK6o
	e1IgrgcwwLD0nXw/sZhOUCCmBfx/Ktc=
X-Google-Smtp-Source: AGHT+IF6bIhtPxuYbbuiZ8nihp2CEo6uU0OMNlnha9DaLtjVE2Bcb3YzWidGbLwQeZSsmNYExmMSQA==
X-Received: by 2002:a17:906:328d:b0:aa6:6e41:ea55 with SMTP id a640c23a62f3a-aab778be635mr371005766b.7.1734114574640;
        Fri, 13 Dec 2024 10:29:34 -0800 (PST)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aab96005f17sm1934166b.17.2024.12.13.10.29.33
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2024 10:29:33 -0800 (PST)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aa69077b93fso306406166b.0
        for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 10:29:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUJ/Fm0FDBjlfoMkizqY19hPnRQr7bWlO5y/GI1z76WEYlTZwR7TE5hhwvYpMhUGWAY2/Pt/WXlSDs=@vger.kernel.org
X-Received: by 2002:a17:907:94cc:b0:aa6:9624:78fd with SMTP id
 a640c23a62f3a-aab77e9e625mr381597766b.48.1734114573422; Fri, 13 Dec 2024
 10:29:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cf5d4x5hfxbsca5c5g5o5r7k225ul3v67liy365gp5wagq2yzv@6v427uwmp5vz>
In-Reply-To: <cf5d4x5hfxbsca5c5g5o5r7k225ul3v67liy365gp5wagq2yzv@6v427uwmp5vz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Dec 2024 10:29:17 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg8d0nx9o+W8z6e0NAUKP9=GJCT_5XoyRi-Bqa=GPt45w@mail.gmail.com>
Message-ID: <CAHk-=wg8d0nx9o+W8z6e0NAUKP9=GJCT_5XoyRi-Bqa=GPt45w@mail.gmail.com>
Subject: Re: [GIT PULL] XFS fixes for 6.13-rc3
To: Carlos Maiolino <cem@kernel.org>
Cc: hch@lst.de, djwong@kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 13 Dec 2024 at 07:57, Carlos Maiolino <cem@kernel.org> wrote:
>
>   git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.13-rc3

What key is this signed with? Not the usual one at kernel.org.

              Linus
