Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FD91C8FA2
	for <linux-xfs@vger.kernel.org>; Thu, 10 Oct 2024 07:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728546647; cv=none; b=VZOYIKtwTu7KqVvuN+Y3zYYvFIivV047D0N/KU/kM5ULpWbb0BIr2CFedTYSSL5eoBSCscXZGxbsPvnp3uH8J34+/AAZfG5OOlbzJyU5DqHrc212KNNtC8XRxmGQpXbbLs9m6fyMvU9u6Z/wocDhMMV6RySAGkWSibvddPxRrkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728546647; c=relaxed/simple;
	bh=h98qP67ENFBhQ8PzFpiz15au4EHuD/oL34SEByQ/3Ec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H974DCiI6+cS0l/rYIje8l7uwqkTfK9h3nzvtJ7fkoeaHujpIWXDYqLnofyXWs5eICWr4S+RyNoFSixaNHgfExzd2FuhRnx0h0XtyG1FpxpV0dDtpUHUN2DpRdlsr4uyZHRotUc6vB8T+kIIL+ZDlHNRutzlkVStUA5p3hUdPz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hk/u2SM/; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hk/u2SM/"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-20bc506347dso4675625ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 10 Oct 2024 00:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728546646; x=1729151446; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jvmR8o1Zd7WNMFxg04YvM6ScNptO0BgRV3DizZHFUZ8=;
        b=hk/u2SM/YDsezExANsrKkV3hBj0heJa4zSiqIw7jCyxetWa2mRAa21kLUt11DG9/HM
         oPUCH7aHEMhD9I0TvFVxJjvg3CkvKlL02perOW8HNAJFTh5z6FXofgyxjiYshGDysyeL
         Zk5SKauVeT00sdQZ1YZwwjAg64kqRM8u4Y2HtsfcGSlSuXDc03doDkbbNxsZE/JJolfB
         46FgAXw++i3aeUNusaRrClVFk2az+BhAC2eSq3qKzlGk1WLWVCJ9m3ee1iLkze/3FF2W
         Uy7az8mw/TPBB1m3lfOPoIvMSdN9bZxjPlgv0Kb2G9eZTEozIYePwsY3UNDR6C/1PyTu
         vYPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728546646; x=1729151446;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jvmR8o1Zd7WNMFxg04YvM6ScNptO0BgRV3DizZHFUZ8=;
        b=xJQZPyYv9SsEJEfOiwliz6znLmsi75AC9ZtroqyXrAFMcQQ1nvb6jBOnX63ZlnXI2i
         H2YvUupcFCzKKC8aZ9jQrc5z1avqta4b9xrNTL6E4FhHdnO0KA6J7KNEoLOftRp1vb3Z
         Ceh0jWc8Fe3xTt3Mt9F585pi8KzPNoSrYna/CsSMUWEU1/UY2Ge1sVtzjnyWzluDAcQU
         N8VWARJ32aWQfiZaPss3uXVsswNIuzS2tvpUFirZ7+7SR05VeQSAPYMKa++tYPAQRX3G
         SBKjYOwNyOVLEmLQQZq0J4hfhBKm6pIlodSMEAdZ36Z/7Y3JykUYtQzTkuVUfhVe+4pP
         epig==
X-Forwarded-Encrypted: i=1; AJvYcCWGiyNs+aAP97/J3CNqwpSFx0IT0hYcCXqzT0PUjea4opOG+G6mhvPtKcDGLcZ91jgnVkBj1425oCo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnuQllR19kkt6K8alZ1Gr6LdVbfEwmoTOqn/PtvwdrBMGcrhZP
	q1ygmumpt5f1Z2pmWjtm38tROHwGEDvJi1vFKKryv9EopZiHchOlXSHTtkCQGAvMp7LsqSTuHlk
	zr2UnKtLxtHdA9sTVOqEfdrULob2QNdd87fNz
X-Google-Smtp-Source: AGHT+IG4NUyfVCXyCU8Jz4aqTBl4CgLaNqotRYOmed8iiKV8Huh04xpDq0iTWoUYrpHsJPdMC8FpAz5yJ6lXTTaMXU4=
X-Received: by 2002:a17:903:1c7:b0:20c:5c37:e2e3 with SMTP id
 d9443c01a7336-20c6378011dmr65091635ad.42.1728546645201; Thu, 10 Oct 2024
 00:50:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6705c39b.050a0220.22840d.000a.GAE@google.com> <Zwd4vxcqoGi6Resh@infradead.org>
In-Reply-To: <Zwd4vxcqoGi6Resh@infradead.org>
From: Marco Elver <elver@google.com>
Date: Thu, 10 Oct 2024 09:50:06 +0200
Message-ID: <CANpmjNMV+KfJqwTgV9vZ_JSwfZfdt7oBeGUmv3+fAttxXvRXhg@mail.gmail.com>
Subject: Re: [syzbot] [xfs?] KFENCE: memory corruption in xfs_idata_realloc
To: Christoph Hellwig <hch@infradead.org>
Cc: syzbot <syzbot+8a8170685a482c92e86a@syzkaller.appspotmail.com>, 
	chandan.babu@oracle.com, djwong@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Vlastimil Babka <vbabka@suse.cz>, Feng Tang <feng.tang@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 10 Oct 2024 at 08:48, Christoph Hellwig <hch@infradead.org> wrote:
>
> [adding the kfence maintainers]
>
> On Tue, Oct 08, 2024 at 04:43:23PM -0700, syzbot wrote:
> > dashboard link: https://syzkaller.appspot.com/bug?extid=8a8170685a482c92e86a
>
> [...]
>
> > XFS (loop2): Quotacheck: Done.
> > ==================================================================
> > BUG: KFENCE: memory corruption in krealloc_noprof+0x160/0x2e0
> >
> > Corrupted memory at 0xffff88823bedafeb [ 0x03 0x00 0xd8 0x62 0x75 0x73 0x01 0x00 0x00 0x11 0x4c 0x00 0x00 0x00 0x00 0x00 ] (in kfence-#108):
> >  krealloc_noprof+0x160/0x2e0
> >  xfs_idata_realloc+0x116/0x1b0 fs/xfs/libxfs/xfs_inode_fork.c:523
>
> I've tried to make sense of this report and failed.
>
> Documentation/dev-tools/kfence.rst explains these messages as:
>
> KFENCE also uses pattern-based redzones on the other side of an object's guard
> page, to detect out-of-bounds writes on the unprotected side of the object.
> These are reported on frees::
>
> But doesn't explain what "the other side of an object's guard page" is.

Every kfence object has a guard page right next to where it's allocated:

  [ GUARD | OBJECT + "wasted space" ]

or

  [ "wasted space" + OBJECT | GUARD ]

The GUARD is randomly on the left or right. If an OOB access straddles
into the GUARD, we get a page fault. For objects smaller than
page-size, there'll be some "wasted space" on the object page, which
is on "the other side" vs. where the guard page is. If a OOB write or
other random memory corruption doesn't hit the GUARD, but the "wasted
space" portion next to an object that would be detected as "Corrupted
memory" on free because the redzone pattern was likely stomped on.

> Either way this is in the common krealloc code, which is a bit special
> as it uses ksize to figure out what the actual underlying allocation
> size of an object is to make use of that.  Without understanding the
> actual error I wonder if that's something kfence can't cope with?

krealloc + KFENCE broke in next-20241003:
https://lore.kernel.org/all/CANpmjNM5XjwwSc8WrDE9=FGmSScftYrbsvC+db+82GaMPiQqvQ@mail.gmail.com/T/#u
It's been removed from -next since then.

It's safe to ignore.

#syz dup: KFENCE: memory corruption in add_sysfs_param
