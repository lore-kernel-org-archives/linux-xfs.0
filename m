Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A859620B800
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757944127; cv=none; b=bs+miqc2FnF32adKFz+0K7BiQJdwPD6cRqbuEhTSYChRV9yPB958WJ358f8PKOXHloldBAbm0+44oQStrbu+U4mHqksU3BtOAEsZk03yvLcoJFqrE3rsIVBlQf66v6i91pE/LPNzzTvdH7eryz349lF5bIeXOEoeWV9hUMCNxNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757944127; c=relaxed/simple;
	bh=ZQub+XOP6AHhSCrQS8OLhNc41tiEetqbLr9I34JJKfI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EN7l4UT8DA9x8t3p06J5487QTjH+5FH2dgtIx8UeB979AvthYmEXsBAb81yEdVk1uxIatnDKOhrQJS6jtA/zSfEDYidqCuPL9zxIgJWt6P8is7sycSHZco9pgomrgXmNufrCQmBWe52knU/KHWCtG6lmjl5sSfLBrV3SBXvjFp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RRLhTpsL; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RRLhTpsL"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-62f1987d4b2so3351888a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 06:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757944123; x=1758548923; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQub+XOP6AHhSCrQS8OLhNc41tiEetqbLr9I34JJKfI=;
        b=RRLhTpsLrx9Sr8YLwKoknx0bVMfaEylTK9/uhnWhAZR+SnL8QQM+oLvYNDbdTQO5Il
         hQY8dAvJPoriAxgvLuv9PFAd2cwiG8wJxTuSRZDTWYIjZ26LGRnr3JIrwUhKt8xkZ+gY
         JVkUfUKtTYS/nYS6FJOFoEUj5MnfJpMjIpDHlTYNm2w6/1gNslccuYLUsX+ACHVQUMqT
         Jm6bp4OxaI5b9zjx2xIDpW9LFKVSBi4ba5L1B8R8oxF7s6ZLZ6SnsI0kiwVq3TijNUo+
         eU6tC5nCkXIM1Qn5or2Cg2GlMtyAoydwJSetKbZwkCXzzVlqAYs2u4DG+29TT6ZMin2X
         8vug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757944123; x=1758548923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQub+XOP6AHhSCrQS8OLhNc41tiEetqbLr9I34JJKfI=;
        b=sxr6lL8XRYGpNiqvNUJNEo+hNs5+Tck0aJligNJb7WEQWz4NShrfuoE2a+TdujhBQB
         Rv/Mkqda1zE1ujCYhlwI4ppCMsr0jXwqJ+vOhS3FXcT3bboF+50Q0/oiJpZqaW2B046q
         j4+5JHLN6Ylv8u5Li2svLowlTowiibYG+4WCLwMSoudQuvkUtp+ob766teKtm03c8bD5
         rPcSdrZiAiO6HGOC6twzGzGJArqLRbT0XeS33UQD+XqRfwX6FVoBzoxEw0+nIWYU8HT/
         N5Or0zvUr4YZEqMU7xlezj5FJMLKGPqENDnWh14a9hzzhWvlxrM5kenU8eNK9vGsY5bQ
         sDhw==
X-Forwarded-Encrypted: i=1; AJvYcCXX9ScOexL6fxFBLGhjJQ2I8ejh+RGnY1Lc3JAworwmTcQATvT9HW677E8ZFiFpN4xwbQWfdNORCEw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+GqCMTtz4XEwDxF/+Towd6cYb4KH04Qx9oLZSxdxLeSORwbZq
	cuMRqqVlm5XyZ2l1IbFl80M6w+df2p6CjYD+gv74Xq4DEgiVmOTVWW8mZj78gig3FId6fzikV9E
	4ocojTAGCg6GVwhU+4xQ87g7rhP20L2s=
X-Gm-Gg: ASbGncu9+xwu4zMdMENh/H1lfyVMMVZqKSKz1q0aTqWECjVuyzp1pC89GJmiOJqZsnD
	0EgSX9tx3T42wZ1qDtx8JSyHBlPDf4JOb2JUj/81Lbrcbe/RGQlv6PRCK9/pwpVX8Cdnu2PqaNn
	5p/jy1O4XLg2/xrejev1z/5/vgFEPq8MKQhC+Be7H0WqWYKqhXXcrG7wqc0+mZUjmeJxmqFjJZM
	KQCCI1rvHSu8lNDi5lOhSb4IakMJfQ9tQyCShjPy3FJ0RWYxw==
X-Google-Smtp-Source: AGHT+IHKOjA1HGcuEvHra72Dd+b7paytkVEuO8cRpT6BW/OBg2GvOxuDt2DlAqGkxcef1Fdd4odGq3BTUr41/Ykmo58=
X-Received: by 2002:a05:6402:4556:b0:62a:53ad:c5f6 with SMTP id
 4fb4d7f45d1cf-62ed80d0d53mr10005029a12.7.1757944122921; Mon, 15 Sep 2025
 06:48:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250911045557.1552002-1-mjguzik@gmail.com> <20250911045557.1552002-3-mjguzik@gmail.com>
 <20250915-erstflug-kassieren-37e5b3f5b998@brauner> <CAGudoHG7uPDFH9K9sjnEZxZ_DtXC-ZqSkwzCJUmw1yKAzEA+dQ@mail.gmail.com>
 <20250915-tricksen-militant-406d4cb8ebda@brauner>
In-Reply-To: <20250915-tricksen-militant-406d4cb8ebda@brauner>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Mon, 15 Sep 2025 15:48:29 +0200
X-Gm-Features: AS18NWBzKunwGtJz0IldCwMc_KnnKbN39RwVHQ4hFOW8fT-nO1xKAbfCWtkbTJc
Message-ID: <CAGudoHETnk1NJe_7TAsweokKia2xtKH0bLn-V7+hcE1voiqrhw@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] fs: hide ->i_state handling behind accessors
To: Christian Brauner <brauner@kernel.org>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, josef@toxicpanda.com, kernel-team@fb.com, 
	amir73il@gmail.com, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, ocfs2-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2025 at 3:41=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Mon, Sep 15, 2025 at 03:27:16PM +0200, Mateusz Guzik wrote:
> > On Mon, Sep 15, 2025 at 2:41=E2=80=AFPM Christian Brauner <brauner@kern=
el.org> wrote:
> > >
> > > On Thu, Sep 11, 2025 at 06:55:55AM +0200, Mateusz Guzik wrote:
> > > > Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> > > > ---
> > >
> > > I would do:
> > >
> > > inode_state()
> > > inode_state_raw()
> > >
> > > Similar to
> > >
> > > rcu_derefence()
> > > rcu_dereference_raw()
> > >
> >
> > I don't follow how to fit this in here.
> >
> > Here is the complete list:
> > inode_state_read
> > inode_state_read_unstable
> >
> > first is a plain read + lockdep assert, second is a READ_ONCE
> >
> > inode_state_add
> > inode_state_add_unchecked
> > inode_state_del
> > inode_state_del_unchecked
> > inode_state_set_unchecked
> >
> > Routine with _unchecked forego asserts, otherwise the op checks lockdep=
.
> >
> > I guess _unchecked could be _raw, but I don't see how to fit this into
> > the read thing.
>
> _raw() is adapted from rcu which is why I'm very familiar with what it
> means: rcu_dereference() performs checks and rcu_dereference_raw()
> doesn't. It's just a naming convention that we already have and are
> accustomed to.
>
> >
> > Can you just spell out the names you want for all of these?
>
> just use _raw() imho
>

For these no problem:
inode_state_add
inode_state_add_raw
inode_state_del
inode_state_del_raw
inode_state_set_raw

But for the read side:
inode_state_read
inode_state_read_unstable

The _unstable thing makes sure to prevent surprise re-reads
specifically because the lock is not expected to be held.
Giving it the _raw suffix would suggest it is plain inode_state_read
without lockdep, which is imo misleading.

But I'm not going to die on this hill.
