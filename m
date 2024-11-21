Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8B4230986;
	Thu, 21 Nov 2024 07:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732173464; cv=none; b=taIWoQjzFWVCc1f1AxdGXdHDHHgHG3aVjjilk1FKz1TQeEy+zX4EL8AK3nLrOjUdJoA2hqS3A7O7vbb3TGqP6xhiW7uPCpbklJ+Q55n00MX6grNWMBYrWJW9yTKmS4uOhitHKB/SCkW+whn6chiSCrVBHkQWcRZoK7FI41SEaRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732173464; c=relaxed/simple;
	bh=2N8FrdIFlf5Axb5OQYHDkS+Vjtnc6Esv4DvBsTmfKSQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hH4dQPR4QJyp+CV8dRP0YaTvYPGWJxMnnDL6sEAxUkJS5dU3oxKDsdeLFrmZLT1xlCRXqFN2jXHhXrT17lJtN01SLgMu7ehIbKgLJGIcbULAI19fCMFQXY7CvnwCmKDShS93Fi+GdozddVXsZoba1H68HfT0MfDkZxdgfUMfjCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jgJEhy/N; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jgJEhy/N"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-460ad0440ddso3487191cf.3;
        Wed, 20 Nov 2024 23:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732173461; x=1732778261; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wcRCVij+jy1yzybGIl/QjepmiE3gRZ552VqPD/9QysU=;
        b=jgJEhy/NT9/rpqGeaM5XU4E2J8BrOACHmzyQuGkCRE3LP1P/44xfO9C66D9abiHKDK
         UoUC4IqW9yus6ALVDgZjI6JaBhVVWPRtaxYWbHVHNwBcCK7vy2vmYXTaUxCrtBoV23Rl
         Riu4FtdPmxF8oWDjpC1vj7VxguY/pd0ldRrMcaHEdyIuo1EG2yAA7tQ0UwzNBNdc2iZJ
         vbOCEimWgapbxGkuGclaQcnAcvTfBlApj749z1JVb0lYrlGVYXfxWGxzdqCD5twLOhmV
         LfzTWRoFlejoLHyQXZkzJby87+H+KlVLKMW0nBhdzfEX7/9J+vRZdl8OiS1q/Jk8BAZ8
         02Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732173461; x=1732778261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wcRCVij+jy1yzybGIl/QjepmiE3gRZ552VqPD/9QysU=;
        b=a0Rui/E10aZC+Nmd8fZCQkLENoI+YY0DE0XiLU+b8wija16SmtIb8LgQRRubGGfWsO
         Bx1WvLV6diLM65eqIR8eBjDipltYGKpwjuq7Zs+PCcTlDXCyY/0XAUbm1oyiQKh6Zr1V
         KjZf0I2CyHYqlK/A02eudtp0SW4oafJT3EyKg294s4I3zlCU7yXqc3WfpkEh30mxV1Wo
         BDTAPuQBJkNUlxuoZdvtW1IKa0Z6cgDLqIVWItqrfp1LVO4DHlXGpmGmBzGjvn8/qG31
         j6MGVrIvRQVDJ9oeSSnWPe+3aSyVvBGp9p5HgW65q+sqWk87//cK8fORzpgT9zQedNIC
         YjpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJogNT+aNzvqFMUyNGJZnk2g6yF6nuCcdIz1EuHZo4SFJaAPsiUAt98trlaSfuHAQhOwUnATBOVb3msSY=@vger.kernel.org, AJvYcCWPDJA0fX4FbPTfC8Jy+Hnoo7/SfY4pVQu2pmUwHLdpGeIl5kqVxNHAjf+znwMfj/7x++x0BtTKWJyg@vger.kernel.org
X-Gm-Message-State: AOJu0YyxGyWJ2eABnuqJc8qOnUzFWJBdkHl7VTjRjUxDp9rC/P+aVMTw
	aaSnT8sEuYgUgFPnQFci6IYT1bjbJcexDXCbIZsz3ZM1XINZ62opYccdrnvmetGug1dBBt1H0q1
	s/EsCSPhiS3sotTCQL+2os1fBUDo=
X-Gm-Gg: ASbGncvVWj0ijT03CL8ZczIUPJp7jhbCzw++LahetejqUWSAqI8yBGzd0UUPmUuu5YA
	B2iAr6mAsczzwEQmiA03x0+CfMbCFnKtwuG+ykEF1tQk6X+MjwIYeDaJgSqE=
X-Google-Smtp-Source: AGHT+IHX1nuY98ydbt+1WK+bi4CS1S3L5AXrldWDKn7ID7lfYu+4teRDO08ye48dfIWFIw3wir83jj7NX4iLrNiKOc4=
X-Received: by 2002:a05:622a:424b:b0:460:e8d3:7bc6 with SMTP id
 d75a77b69052e-46479d2ce53mr66398261cf.46.1732173460963; Wed, 20 Nov 2024
 23:17:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241104014439.3786609-1-zhangshida@kylinos.cn>
 <ZyhAOEkrjZzOQ4kJ@dread.disaster.area> <CANubcdVbimowVMdoH+Tzk6AZuU7miwf4PrvTv2Dh0R+eSuJ1CQ@mail.gmail.com>
 <Zyi683yYTcnKz+Y7@dread.disaster.area> <CANubcdX3zJ_uVk3rJM5t0ivzCgWacSj6ZHX+pDvzf3XOeonFQw@mail.gmail.com>
 <ZzFmOzld1P9ReIiA@dread.disaster.area> <CANubcdXv8rmRGERFDQUELes3W2s_LdvfCSrOuWK8ge=cdEhFYA@mail.gmail.com>
 <Zz5ogh1-52n35lZk@dread.disaster.area>
In-Reply-To: <Zz5ogh1-52n35lZk@dread.disaster.area>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Thu, 21 Nov 2024 15:17:04 +0800
Message-ID: <CANubcdX2q+HqZTw8v1Eqi560X841fzOFX=BzgVdEi=KwP7eijw@mail.gmail.com>
Subject: Re: [PATCH 0/5] *** Introduce new space allocation algorithm ***
To: Dave Chinner <david@fromorbit.com>
Cc: djwong@kernel.org, dchinner@redhat.com, leo.lilong@huawei.com, 
	wozizhi@huawei.com, osandov@fb.com, xiang@kernel.org, 
	zhangjiachen.jaycee@bytedance.com, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dave Chinner <david@fromorbit.com> =E4=BA=8E2024=E5=B9=B411=E6=9C=8821=E6=
=97=A5=E5=91=A8=E5=9B=9B 06:53=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sun, Nov 17, 2024 at 09:34:53AM +0800, Stephen Zhang wrote:
> > Dave Chinner <david@fromorbit.com> =E4=BA=8E2024=E5=B9=B411=E6=9C=8811=
=E6=97=A5=E5=91=A8=E4=B8=80 10:04=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > On Fri, Nov 08, 2024 at 09:34:17AM +0800, Stephen Zhang wrote:
> > > > Dave Chinner <david@fromorbit.com> =E4=BA=8E2024=E5=B9=B411=E6=9C=
=884=E6=97=A5=E5=91=A8=E4=B8=80 20:15=E5=86=99=E9=81=93=EF=BC=9A
> > > > > On Mon, Nov 04, 2024 at 05:25:38PM +0800, Stephen Zhang wrote:
> > > > > > Dave Chinner <david@fromorbit.com> =E4=BA=8E2024=E5=B9=B411=E6=
=9C=884=E6=97=A5=E5=91=A8=E4=B8=80 11:32=E5=86=99=E9=81=93=EF=BC=9A
> > > > > > > On Mon, Nov 04, 2024 at 09:44:34AM +0800, zhangshida wrote:
> > >
> > > [snip unnecessary stereotyping, accusations and repeated information]
> > >
> > > > > AFAICT, this "reserve AG space for inodes" behaviour that you are
> > > > > trying to acheive is effectively what the inode32 allocator alrea=
dy
> > > > > implements. By forcing inode allocation into the AGs below 1TB an=
d
> > > > > preventing data from being allocated in those AGs until allocatio=
n
> > > > > in all the AGs above start failing, it effectively provides the s=
ame
> > > > > functionality but without the constraints of a global first fit
> > > > > allocation policy.
> > > > >
> > > > > We can do this with any AG by setting it up to prefer metadata,
> > > > > but given we already have the inode32 allocator we can run some
> > > > > tests to see if setting the metadata-preferred flag makes the
> > > > > existing allocation policies do what is needed.
> > > > >
> > > > > That is, mkfs a new 2TB filesystem with the same 344AG geometry a=
s
> > > > > above, mount it with -o inode32 and run the workload that fragmen=
ts
> > > > > all the free space. What we should see is that AGs in the upper T=
B
> > > > > of the filesystem should fill almost to full before any significa=
nt
> > > > > amount of allocation occurs in the AGs in the first TB of space.
> > >
> > > Have you performed this experiment yet?
> > >
> > > I did not ask it idly, and I certainly did not ask it with the intent
> > > that we might implement inode32 with AFs. It is fundamentally
> > > impossible to implement inode32 with the proposed AF feature.
> > >
> > > The inode32 policy -requires- top down data fill so that AG 0 is the
> > > *last to fill* with user data. The AF first-fit proposal guarantees
> > > bottom up fill where AG 0 is the *first to fill* with user data.
> > >
> > > For example:
> > >
> > > > So for the inode32 logarithm:
> > > > 1. I need to specify a preferred ag, like ag 0:
> > > > |----------------------------
> > > > | ag 0 | ag 1 | ag 2 | ag 3 |
> > > > +----------------------------
> > > > 2. Someday space will be used up to 100%, Then we have to growfs to=
 ag 7:
> > > > +------+------+------+------+------+------+------+------+
> > > > | full | full | full | full | ag 4 | ag 5 | ag 6 | ag 7 |
> > > > +------+------+------+------+------+------+------+------+
> > > > 3. specify another ag for inodes again.
> > > > 4. repeat 1-3.
> > >
> > > Lets's assume that AGs are 512GB each and so AGs 0 and 1 fill the
> > > entire lower 1TB of the filesystem. Hence if we get to all AGs full
> > > the entire inode32 inode allocation space is full.
> > >
> > > Even if we grow the filesystem at this point, we still *cannot*
> > > allocate more inodes in the inode32 space. That space (AGs 0-1) is
> > > full even after the growfs.  Hence we will still give ENOSPC, and
> > > that is -correct behaviour- because the inode32 policy requires this
> > > behaviour.
> > >
> > > IOWs, growfs and changing the AF bounds cannot fix ENOSPC on inode32
> > > when the inode space is exhausted. Only physically moving data out
> > > of the lower AGs can fix that problem...
> > >
> > > > for the AF logarithm:
> > > >     mount -o af1=3D1 $dev $mnt
> > > > and we are done.
> > > > |<-----+ af 0 +----->|<af 1>|
> > > > |----------------------------
> > > > | ag 0 | ag 1 | ag 2 | ag 3 |
> > > > +----------------------------
> > > > because the af is a relative number to ag_count, so when growfs, it=
 will
> > > > become:
> > > > |<-----+ af 0 +--------------------------------->|<af 1>|
> > > > +------+------+------+------+------+------+------+------+
> > > > | full | full | full | full | ag 4 | ag 5 | ag 6 | ag 7 |
> > > > +------+------+------+------+------+------+------+------+
> > > > So just set it once, and run forever.
> > >
> > > That is actually the general solution to the original problem being
> > > reported. I realised this about half way through reading your
> > > original proposal. This is why I pointed out inode32 and the
> > > preferred metadata mechanism in the AG allocator policies.
> > >
> > > That is, a general solution should only require the highest AG
> > > to be marked as metadata preferred. Then -all- data allocation will
> > > then skip over the highest AG until there is no space left in any of
> > > the lower AGs. This behaviour will be enforced by the existing AG
> > > iteration allocation algorithms without any change being needed.
> > >
> > > Then when we grow the fs, we set the new highest AG to be metadata
> > > preferred, and that space will now be reserved for inodes until all
> > > other space is consumed.
> > >
> > > Do you now understand why I asked you to test whether the inode32
> > > mount option kept the data out of the lower AGs until the higher AGs
> > > were completely filled? It's because I wanted confirmation that the
> > > metadata preferred flag would do what we need to implement a
> > > general solution for the problematic workload.
> > >
> >
> > Hi, I have tested the inode32 mount option. To my suprise, the inode32
> > or the metadata preferred structure (will be referred to as inode32 for=
 the
> > rest reply) doesn't implement the desired behavior as the AF rule[1] do=
es:
> >         Lower AFs/AGs will do anything they can for allocation before g=
oing
> > to HIGHER/RESERVED AFs/AGS. [1]
>
> This isn't important or relevant to the experiment I asked you to
> perform and report the results of.
>
> I asked you to observe and report the filesystem fill pattern in
> your environment when metadata preferred AGs are enabled. It isn't
> important whether inode32 exactly solves your problem, what I want
> to know is whether the underlying mechanism has sufficient control
> to provide a general solution that is always enabled.
>
> This is foundational engineering process: check your hypothesis work
> as you expect before building more stuff on top of them. i.e.
> perform experiments to confirm your ideas will work before doing
> anything else.
>
> If you answer a request for an experiment to be run with "theory
> tells me it won't work" then you haven't understood why you were
> asked to run an experiment in the first place.
>

If I understand your reply correctly, then maybe my expression is the
problem. What I replied before is:
1. I have tested the inode32 option with the metadata preferred AGs
enabled(Yeah, I do check if the AG is set with
XFS_AGSTATE_PREFERS_METADATA). And with the alternating-
punching pattern, I observed that the preferred AG will still get fragmente=
d
quickly, but the AF will not.
(That's what I meant in the first sentence of my previous reply...)
2. Then I tried to explain why it doesn't work in theory.

Sorry for any misunderstanding because of my unclear reply.

Cheers,
Shida

> If you can't run requested experiments or don't understand why an
> expert might be asking for that experiment to be run, then say so.
> I can explain in more detail, but I don't like to waste time on
> ideas that I can't confirm have a solid basis in reality...
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
