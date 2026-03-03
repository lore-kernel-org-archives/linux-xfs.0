Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64C047DD7A
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 14:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772549776; cv=pass; b=mWgCQH+pwJqjLXHFsXQkf5T/B23BrGSy+LziaT7irA0XUBTaunzlPbqb0Q33hsZ7IFKKU58+0qGXL17Vg/vG1NvHPFqVxiJwiokXxqn+9WFdwIKG/+QUsGSuikdXIEpY+Upp7Nip/FOBLTTAbTGCjvqAWTEiEmXVrhIj4A8EQys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772549776; c=relaxed/simple;
	bh=5QoujqJkWgms6jqzEiHsaG7e0wdOWQp96Pzu/VCA4rA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bLrYfdWSDJkDgnxcLdmO2GU+ZcUnAsNILwEsXhqlBtYJUZy4St31sqvDQCTUyFN6AFvPzXcYl4PaF/QD1wGK2EYVg9CkABCMQbYd2FF1wUfqrea7bVjBX5UT+icVtgGWa1LurWV9YEnL2/Jh6IuxD1kzgE+uOKkei/xJK+yWYHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PfIHgG9h; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PfIHgG9h"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-65c4152313fso8290230a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 03 Mar 2026 06:56:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772549773; cv=none;
        d=google.com; s=arc-20240605;
        b=Si4rqYeszYB85UNWB52GLhoBFaMvwivrMLIxgfxSnXHcuF4vnkP8i3QLkKXrLPe/G+
         RKFtdVlC3jq1wL+1fG0KZBiCgmCSh7aUmR9hIAhoFgXHb4XmTxboGNEoPAClDnk6gqbB
         lGvuZd0mP2Krb3iF7Pu2NZvkzChb69tpHCJjvRY3dCIIZh4vhWgxTzoBPimkXVfJ8G+8
         m4NBxMDHhOkU9BAMW2zDrZ72+7pvOnvfPoJV2FSpt/pfSVhvdnL4m96giF2DBsBDGtea
         o1s/opP0HlQCJmtzgrXHu8kSDPIZP9puRk86WYCZCOKgt/PYS0gv+0GHa9nTzOR8+iLs
         1eZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=udta42pxnBlFqxC1s4Qd1kLUvohusAt+5rXvzlylPvw=;
        fh=I+xXzA4yy4jTajbAO3mxVSSQawdQ5qciFrRtrQG3MBA=;
        b=iE5gYUjTuNblhjnGkAOyGvGTZX3CHns26X+g93qo8gQ13IYJgSQOuHSCuP9uqkKEwy
         TNobNNbHNEUK4QMO/XJkfpZkqKHI9qvaYhT6kwhOb0bm1bEC+ycB16PB5OVtj5wyg6zZ
         UDk96mfhmFbP8sy5qNMB9rJ7aG5GX4NUSr2Mc1e+IEDemlThNzjz6LzIY1nkGAJx35ri
         E40lW0aNnwwM1n+CV8ChCEnZfoz+twxIdzTDKk7HijMpJIJ68u89ZPqcDPNi4IzNgQaN
         gdK/izcAR0KIMmJwZsQoPaXf1GTkmiNrUKrATkD7WFk4huJDr/8WFoxK9Puq1yz4QEpD
         wDrA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772549773; x=1773154573; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=udta42pxnBlFqxC1s4Qd1kLUvohusAt+5rXvzlylPvw=;
        b=PfIHgG9hoaNHWSQc9BC3S25gqfPqDUvt5S6PuctIb6fwWpXcbC7JFsQIBhee0CCvFL
         11Y01HQsEbDWxuT9+61Fw2SuVkFUQTk0TBU8OSIkw00HdDpYAZC25w+EB3hlKuveJtxj
         17S6P13N06cDDc+E+mLu5QFZtFhYxr1vf9ujvT1Jhpu3kQZOwHYsg7RieyLxBtuX8KL2
         hDySVqTDbUPZPgS/NEB/TLAFkfUK89KjOZ9MhoBFg6ZIu2LzuGjOdBP01Q6QyROE95He
         42d3vIfntBkJEAikpwSLJlhwE+IWgWgG0cPIJzc3qDMmTZOEDi7OYAAtdUwHZnW9voks
         W5Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772549773; x=1773154573;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=udta42pxnBlFqxC1s4Qd1kLUvohusAt+5rXvzlylPvw=;
        b=XxX/k9OGXsm8ALWsYj1f8D61qUsaXTD/0gGhnEBiFoSWfv9Duzp4n3W9c59/NxG8XO
         vZc3arvaTYQTKIrF108DEKsZVwAHA6URr+gJGYspv2z3/yqbq/sc/6KQ9cMYFugWKZZO
         XxOPW+81dObIL4m85DZ2oklAC7n9LKN7DEw4jmdOSOf1eNMxpXPsPVfB6u1q7ONeQh9L
         cIlvOFunNXLfuHzD/InRnJiXwMZ0guecuGbLfqHzgncZciXSTKj8aoH53Ya+UXO77ORc
         f7PIwZXvfUiOLw+hVALFOQA2ByvCBjTwKtdlenY90dEmD2x1hIwqJ2o+fsCv91syvva6
         riug==
X-Forwarded-Encrypted: i=1; AJvYcCVn7RQYJXOeALlCavVlLrnmGgtq9qltaP2xtaK8+gL7+HSQbMDIUQfv4KuuxmQki60GBJtme/yV5SE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5AXUvGlPH1A7C+IAFw3NuAR7aMEXkyV/CCs97mZt5METX0crO
	1S3J3jDH4t4yhbEANAJ+eFer4UYjioY5J3tge8zhVnDkdSmoX/OJdRaxICkk5vwh8RgB7Hjp2pN
	ivxL9C3GbtQF2D7hIWMaTvNPQ16ArGvw=
X-Gm-Gg: ATEYQzx5GA2trJiFb9HB1bMtXYddOzfi9QqkAHg4lJoTfDyd8jvIbKcOSQKGxXy503n
	EgJCug6E76WAJgxfgDBrCJUu3Cg4fkn+6YH58p8KJJf2TjIGpQYSGit/VLzAWeRQGNQ7d/tYJj8
	95ktED064Q0cOLSWm7zC4BFqUfHpTnv+2uIWG456MSVdZcCYE7QB/XtXodgmJTjZrpLvhrIeMNJ
	A1iy0LvlsaIXm1+qgZ9p+zpetJa29GrtfoFUJincGWaBRZqFAiOHNsrqGxdLo+0J1UUbVQGa23S
	2yfsBeCJ/8kFNx/CJOMkW2i8dojJLh3pKAsF40afTw==
X-Received: by 2002:a17:907:1c90:b0:b93:892a:e82b with SMTP id
 a640c23a62f3a-b93892ae9f8mr888062766b.51.1772549772848; Tue, 03 Mar 2026
 06:56:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <177249785452.483405.17984642662799629787.stgit@frogsfrogsfrogs>
 <177249785472.483405.1160086113668716052.stgit@frogsfrogsfrogs>
 <CAOQ4uxgmYNWCs18+WU9-7QDkhp0f_xX6nvKiyDhS8gZzfUXXXA@mail.gmail.com> <aab1Z7J-m97VfFvS@infradead.org>
In-Reply-To: <aab1Z7J-m97VfFvS@infradead.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 3 Mar 2026 15:56:01 +0100
X-Gm-Features: AaiRm50Dm2AD3hFSZjiomm2u0pnUT4PvlIZrYEt7j6TT094HiewpP9Ly0nyguXc
Message-ID: <CAOQ4uxiruBkn=454AoxQuatK3CUve95Jkn=wBzU9hDkWWbFGPA@mail.gmail.com>
Subject: Re: [PATCH 1/1] generic: test fsnotify filesystem error reporting
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com, linux-fsdevel@vger.kernel.org, 
	hch@lst.de, gabriel@krisman.be, jack@suse.cz, fstests@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 3, 2026 at 3:51=E2=80=AFPM Christoph Hellwig <hch@infradead.org=
> wrote:
>
> On Tue, Mar 03, 2026 at 10:21:04AM +0100, Amir Goldstein wrote:
> > On Tue, Mar 3, 2026 at 1:40=E2=80=AFAM Darrick J. Wong <djwong@kernel.o=
rg> wrote:
> > >
> > > From: Darrick J. Wong <djwong@kernel.org>
> > >
> > > Test the fsnotify filesystem error reporting.
> >
> > For the record, I feel that I need to say to all the people whom we pus=
hed back
> > on fanotify tests in fstests until there was a good enough reason to do=
 so,
> > that this seems like a good reason to do so ;)
>
> Who pushed backed on that?  Because IMHO hiding stuff in ltp is a sure
> way it doesn't get exercisesd regularly?
>

Jan and myself pushed back on adding generic fanotify tests to fstest
because we already have most fanotify tests in LTP.

LTP is run by many testers on many boxes and many release
kernels and we are happy with this project to host tests for the
subsystem that we maintain.

Thanks,
Amir.
