Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3DD198A38
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 23:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731368407; cv=none; b=IdK2v7bJ+LQdHn2mc1/Ig/qQWSZtfDs8RplLoDgmg5sff0DSnEjsahjTg/XyK4w+R8O+gvkXtjt7w+HXvEMkPomwh6gvsqTQCwtPX4EBUh6BKhnsUmz6De+giT2myKHMUVnDJ+ZYU6R9JMgj9Pnx1r68IUeJLau2DJsdns1F3Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731368407; c=relaxed/simple;
	bh=5iMzA2h0qeiCLS/UE7L1mkZIgcrO/N5kJ3Okms4mkXw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eOWZeOpv+etq11oao19HqIq58DeCVnWsZOToK41kIf80uT5u20otSn82DeOsdIUnk+bKrGqUPm21XXOp5wW8KDE/22i6wtOLI5UONEKaehKEvTvIlQNrHi6hUxyDPfkyKE95E8Ds/CVYI3KceKY5STATbP4bk/IBEwE0cJgOXBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LajbJBzi; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LajbJBzi"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a9e8522c10bso783808866b.1
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 15:40:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1731368404; x=1731973204; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MfrZKwA8Q666Z7hBV0+zRbjc85gr+W93j+HNejLY+JI=;
        b=LajbJBziZbjhdyFhHv2zEie5HlJQnOlKZUqHm7NDR9PuRFQYcPSl1gsrWlrDM54lHL
         bKkV54j/2yyGA5oioGiUe2gP9ONZdN97OzKI9JhXl2OBjH3VtLFu33v2Eszo3XyEAn4R
         Yw/BuZILJrq7ot9i6g+9CG9gea4tdG9+Dc0hg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731368404; x=1731973204;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MfrZKwA8Q666Z7hBV0+zRbjc85gr+W93j+HNejLY+JI=;
        b=F4RZ351UcC05IMDGdJdW18BxFd3MFADoHyczSXGIryxi2N7xLppObaOz+YvbmTTz1V
         a/erob0dl0DDAoPiRDEaQd4liKzM+Lbnax5qX29t58LtHwvIcFf+9TUeSYTcQED9QMCB
         +NL6Icr1xnHBr1JqdIQwsfOSHAXdsQ164pVRxX8W+AXkkVIPDwSLvPbTDmc2vqf8HW0c
         M2FB5IQWJAsonHluUupnC3QifKkAYnRLpbxxi8k8jVC1vw4kMDlJlx+5MU0kfce0Yqzu
         hC+v7STtC/uy1+MOJW0bHlfjOJHAnWY8hMQkg8ZRZI7o2l1ejihujuudE1Ep5Yb6j12x
         y9Lw==
X-Forwarded-Encrypted: i=1; AJvYcCVhzMOz2EHaDj4SWdvACr5A+EEd9drpetZ6Grs2UuehRTNhgm4McHDPWaaLHjQ4B+PN5j7ZHhIk5IE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyS69nMbcITPtHKM1GnFWszeL8iD1bScOsbYkexlOX2gk61JAZg
	rzXwEw/i3eeysVVC7LzrJNaj09kwt2dzL4lhK8niGWvVgoh1JlBsTH3eSA8nknVXAuee0y3eV2K
	FYsU=
X-Google-Smtp-Source: AGHT+IH16L9Jbj9ldvU+9qYM4mypEXLUCTze57YNTBgESv/IIA/jfZCeg0JP79ADYcCJzL6YBTbSCA==
X-Received: by 2002:a17:907:1c90:b0:a9e:eee8:4947 with SMTP id a640c23a62f3a-a9eefeb300bmr1477268766b.9.1731368403743;
        Mon, 11 Nov 2024 15:40:03 -0800 (PST)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0a4b82csm654826366b.67.2024.11.11.15.40.01
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2024 15:40:02 -0800 (PST)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a99ebb390a5so1119109766b.1
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 15:40:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUcyvxAR44Lu4Q640kvPfmATUEWAJCXePSVSshY0nprBLu8X7jljB0psiO2cxzTvWEPfDxncuXctPY=@vger.kernel.org
X-Received: by 2002:a17:906:ee8c:b0:a93:a664:a23f with SMTP id
 a640c23a62f3a-a9eefe3f3famr1355377966b.5.1731368401330; Mon, 11 Nov 2024
 15:40:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731355931.git.josef@toxicpanda.com> <b509ec78c045d67d4d7e31976eba4b708b238b66.1731355931.git.josef@toxicpanda.com>
 <CAHk-=wh4BEjbfaO93hiZs3YXoNmV=YkWT4=OOhuxM3vD2S-1iA@mail.gmail.com>
 <CAEzrpqdtSAoS+p4i0EzWFr0Nrpw1Q2hphatV7Sk4VM49=L3kGw@mail.gmail.com> <CAHk-=wj8L=mtcRTi=NECHMGfZQgXOp_uix1YVh04fEmrKaMnXA@mail.gmail.com>
In-Reply-To: <CAHk-=wj8L=mtcRTi=NECHMGfZQgXOp_uix1YVh04fEmrKaMnXA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Nov 2024 15:39:45 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh9hc8sSNYwurp5cm2ub52yHYGfXC8=BfhuR3XgFr0vEA@mail.gmail.com>
Message-ID: <CAHk-=wh9hc8sSNYwurp5cm2ub52yHYGfXC8=BfhuR3XgFr0vEA@mail.gmail.com>
Subject: Re: [PATCH v6 06/17] fsnotify: generate pre-content permission event
 on open
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, 
	amir73il@gmail.com, brauner@kernel.org, linux-xfs@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 11 Nov 2024 at 15:22, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> See why I'm shouting? You're doing insane things, and you're doing
> them for all the cases that DO NOT MATTER. You're doing all of this
> for the common case that doesn't want to see that kind of mindless
> overhead.

Side note: I think as filesystem people, you guys are taught to think
"IO is expensive, as long as you can avoid IO, things go fast".

And that's largely true at a filesystem level.

But on the VFS level, the common case is actually "everything is
cached in memory, we're never calling down to the filesystem at all".

And then IO isn't the issue.

So on a VFS level, to a very close approximation, the only thing that
matters is cache misses and mispredicted branches.

(Indirect calls have always had some overhead, and Spectre made it
much worse, so arguably indirect calls have become the third thing
that matters).

So in the VFS layer, we have ridiculous tricks like

        if (unlikely(!(inode->i_opflags & IOP_FASTPERM))) {
                if (likely(inode->i_op->permission))
                        return inode->i_op->permission(idmap, inode, mask);

                /* This gets set once for the inode lifetime */
                spin_lock(&inode->i_lock);
                inode->i_opflags |= IOP_FASTPERM;
                spin_unlock(&inode->i_lock);
        }
        return generic_permission(idmap, inode, mask);

in do_inode_permission, because it turns out that the IOP_FASTPERM
flag means that we literally don't even need to dereference
inode->i_op->permission (nasty chain of D$ accesses), and we can
*only* look at accesses off the 'inode' pointer.

Is this an extreme example? Yes. But the whole i_opflags kind of thing
does end up mattering, exactly because it keeps the D$ footprint
smaller.

                  Linus
