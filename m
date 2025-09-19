Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F2814286
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 09:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758275694; cv=none; b=nHOakzKULidB5bWysa/p6qSxw7CEU2hS/pgiUCQJpnb0Xa8wOt8QuZqjCAhVT0kyJxHskrc13gCwCjpLsT4wOPvWvywYtj62uTBHTnchQmgUq+CxcSZgUpgsg2FAtafDa3lTHUZvZQLs8mFpUsQPxK/rtVwri56DkPMq80RvTHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758275694; c=relaxed/simple;
	bh=dgtFOm38P9aI6/915v1yVDS2kMb9u/O/desqpxSnf0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ExmiJxoO2hfidz+bYphlVHmvo77D3854LN5UZ+3RlDVPYWFZj20RwEX0TDM5jH+eDadwnDmZXV/2k6TZEGOGhRJpwkGNEASFItnebhza0pxwcN/llLSPc0PcZxQ5nGXQYDQdTIJoukYP/IubwIeI08rEaRyB5NR12pjBRgRN4uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D0ww+35H; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D0ww+35H"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-62fbfeb097eso1098629a12.2
        for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 02:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758275691; x=1758880491; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D1fKK2VeIGcuA6sZx7T8OVafrUk30/MIz6Mtn0eRk4A=;
        b=D0ww+35HPYDgbX+WJHvGWzEHxGXOKMQF80wYpwCHYLX/o8mh/QwYse62u6Pl8WvlpB
         G9vy9O/fn4jSzD9BGizMNga1kdo5J1wAlD5SgH+qdhdhgQrmL1YyYGim3d0lSt1aRY9z
         g+y2DXGoGOZXWBXTf9xOn5N5j4cc/N3oFG0ah/chZJGQmGQQCMuDAEqijyjxWWZ3xDdO
         587G7hg0BJlaf6n4/aTdbz31VLrx3a6iABwmyJlhC+AfOyqQWblHEPPdMY2pFRODzSlQ
         zJYMkLZtsEZMxBDdoGdIVcNpH2sD2fzpwNjnEmDPPb9IAnMzc4tVVa7IFUogZPXR08g9
         N7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758275691; x=1758880491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D1fKK2VeIGcuA6sZx7T8OVafrUk30/MIz6Mtn0eRk4A=;
        b=ViVQo8aYO6oaej/zHQqziZKTDyyTWFeBWItcB1K1dUDK5Z8SMVc/FCo0YFpSqAWOJZ
         pqRGigVtvl63loKe0Ng2t/evcIbbIQHL0GEubtrVWhjlBUcw9ZGZzmkV7EaLqFl8F+LR
         YdE345EASJl3ZWvEtetObUzmD9TWWMsSdnb5WPYyerzFIL41f+l9dfT+lRrVokqnWFti
         LURlfbyjpwb18P28E1Z9YzQWCTBCf263kvKDtJkY1qWrndvvaWNgG/0zF3ib69k6dzGT
         694k5lHUcpJ8RsBm0jyaVQez4eZTX7jE8ncIYmvrI/uj6NW+cBsbSApUydd073ndfctw
         R/Tg==
X-Forwarded-Encrypted: i=1; AJvYcCUTwFUQt51+NLLDehIKy8wbCAHmLBWC7OOqRPHwpf1TH6sWoToVvw18VOTPYfvrLHPO4Cg8jXRedE8=@vger.kernel.org
X-Gm-Message-State: AOJu0YycfpLu7akQA1UzKzP64zk2ONXi/Pf9YXUOjSXBEY/v3+DVG69W
	cCtLQGTa3KAMPHtzf2wHZM4/ECSoOWCnR06Mt7k2TMFlabaGUxSDGMegkRfMOCNXk0SWPRe1O/N
	hQsqF762X0meAlhK84st8GrKGE3BHExQ=
X-Gm-Gg: ASbGnctdVkucu0ECeAjz2bmSWgRH74/O6Kb15fSbcHMVhOq8HEHcuom89M/2AyTCIbP
	trHshRfbiy9zFYvzW79+5k3N00JKaHUZ2C+3ZsrlpSVsQGqSrsHV8qH63yS3exH51c0vURYqhC9
	NhkcaCfwyNP2v9o0PyJZ/20HaTvtua2ioQj+Ih5IuFwcRuzGQKTPuPLFHz000sLcjBrUBVbZF5m
	wpGQxKUxHYUET6nJSdOdaVd/lwvFc2wwhORoIRLkS1hxIg=
X-Google-Smtp-Source: AGHT+IE5oiKuJw8bSM5pCB6RKkNUQyiqR7jU1bNaTBtzzRRL/3JjPFaCojPjFSXwo6+sUUPKTUkwNzO7kN2G6awGZQk=
X-Received: by 2002:a05:6402:21c6:b0:62f:50b9:2881 with SMTP id
 4fb4d7f45d1cf-62fc0a7b232mr2468458a12.19.1758275691061; Fri, 19 Sep 2025
 02:54:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798151087.382724.2707973706304359333.stgit@frogsfrogsfrogs>
 <175798151352.382724.799745519035147130.stgit@frogsfrogsfrogs>
 <CAOQ4uxibHLq7YVpjtXdrHk74rXrOLSc7sAW7s=RADc7OYN2ndA@mail.gmail.com>
 <20250918181703.GR1587915@frogsfrogsfrogs> <CAOQ4uxiH1d3fV0kgiO3-JjqGH4DKboXdtEpe=Z=gKooPgz7B8g@mail.gmail.com>
 <CAJfpegsrBN9uSmKzYbrbdbP2mKxFTGkMS_0Hx4094e4PtiAXHg@mail.gmail.com>
In-Reply-To: <CAJfpegsrBN9uSmKzYbrbdbP2mKxFTGkMS_0Hx4094e4PtiAXHg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 19 Sep 2025 11:54:39 +0200
X-Gm-Features: AS18NWA621z2KRPPWOGIYUM6iJJ0YvzsnlUffsLmeJBzhEVFirihKN7gNrA_jS0
Message-ID: <CAOQ4uxgvzrJVErnbHW5ow1t-++PE8Y3uN-Fc8Vv+Q02RgDHA=Q@mail.gmail.com>
Subject: Re: [PATCH 04/28] fuse: adapt FUSE_DEV_IOC_BACKING_{OPEN,CLOSE} to
 add new iomap devices
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Darrick J. Wong" <djwong@kernel.org>, bernd@bsbernd.com, linux-xfs@vger.kernel.org, 
	John@groves.net, linux-fsdevel@vger.kernel.org, neal@gompa.dev, 
	joannelkoong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 19, 2025 at 9:14=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Thu, 18 Sept 2025 at 20:42, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Thu, Sep 18, 2025 at 8:17=E2=80=AFPM Darrick J. Wong <djwong@kernel.=
org> wrote:
>
> > > How about restricting the backing ids to RLIMIT_NOFILE?  The @end par=
am
> > > to idr_alloc_cyclic constrains them in exactly that way.
> >
> > IDK. My impression was that Miklos didn't like having a large number
> > of unaccounted files, but it's up to him.
>
> There's no 1:1 mapping between a fuse instance and a "fuse server
> process", so the question is whose RLIMIT_NOFILE?  Accounting to the
> process that registered the fd would be good, but implementing it
> looks exceedingly complex.  Just taking RLIMIT_NOFILE value from the
> process that is doing the fd registering should work, I guess.
>
> There's still the question of unhiding these files.  Latest discussion
> ended with lets create a proper directory tree for open files in proc.
> I.e. /proc/PID/fdtree/FD/hidden/...
>

Yes, well, fuse_backing_open() says:
/* TODO: relax CAP_SYS_ADMIN once backing files are visible to lsof */
So that's the reason I was saying there is no justification to
relax this for FUSE_IOMAP as long as this issue is not resolved.

As Darrick writes, fuse4fs needs only 1 backing blockdev
and other iomap fuse fs are unlikely to need more than a few
backing blockdevs.

So maybe, similar to max_stack_depth, we require the server to
negotiate the max_backing_id at FUSE_INIT time.

We could allow any "reasonable" number without any capabilities
and regardless of RLIMIT_NOFILE or we can account max_backing_id
in advance for the user setting up the connection.

For backward compat (or for privileged servers) zero max_backing_id
means unlimited (within the int32 range) and that requires
CAP_SYS_ADMIN for fuse_backing_open() regardless of which
type of backing file it is.

WDYT?

Thanks,
Amir.
