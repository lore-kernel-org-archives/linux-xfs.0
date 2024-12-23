Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFDE1A8F6E;
	Mon, 23 Dec 2024 11:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734954955; cv=none; b=BP07gFAnmdTcoIJs+zdN29zOTQsRkigLk7T3TB2M65Uh0InXCFdpHUmaN4MrYQz4u7TvycHMRhuyJPQ7cHtnnzlE7rGSc3fWT27Gmdo3EFKaSAYfns0qSdQBbTzrdKvEHJODM51jfgpOFeR4C6ifP/S7l/TX1WNCAQWFLf+y9Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734954955; c=relaxed/simple;
	bh=Qf6w1EE7qTO6RP31qvjoa2UACxC2YFj5hFAl/zm61hY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DqqZgxCS1P9YD+7gCCLOCfJqHUvqNvqunrU9pzY/4//wHUC/GXm4+dXYEZn1ARWDDrwWC/p6hzX5JFZ/IlTq1xz19e5jBoJI8nYEEjwGBfm5TweRGfFZVEAqaTqR+YjyDskOaWsqK6MSyUmsRfV/payuuDguNUaqm4PG1ZH2/Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SLEe/DMe; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SLEe/DMe"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6d92e457230so40986746d6.1;
        Mon, 23 Dec 2024 03:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734954952; x=1735559752; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yh1cy/wRC7b39JaZfiJhB6xPXvP60nFjZDtMdtjelOI=;
        b=SLEe/DMe9q3pFak7SbP5lK07Q5pkIHf4LKEq01l3+Sk1frbBpO0+Ozz5daTRHX5k1G
         RwoxVQ22xrMu3YxdCsmpr5ubUqGRfO1m8/rp/huSo2U6h6KKTKtFxi9w7rFLJkdrRKR6
         pqmOu0BasFwm8V8aJluowZbuIKRiXLdqHxWXF7TcDBH397U380aGKv7vp+Bgqi+qliT0
         hWmOCuDKss9oIlHX3lTHCmGh4kLcW0AizwMpedc10I0mc4BFXJYXRmuiVEhfdC4yExaU
         I/B3QXFvlu6H2WQJFKnQPL6SGiWP+WZCifWTyDuOqaO2jmfB29VVPeLworeWScJoASde
         BE8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734954952; x=1735559752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yh1cy/wRC7b39JaZfiJhB6xPXvP60nFjZDtMdtjelOI=;
        b=U+chj4xnRK/1mi+jAAi/Z3fVngo/iod8z8kITv+x5pv7QRtQFYiJAg1pMYuz9023Nf
         YpbvjJfkdM0zYyIRjzRKJBdYg7U+SWWLay1SMmrJtkh+nC0NMsT0rgAMq6P0Z2WXpEge
         1UDXcc4VkPne5VkCUjm6P+u1t19sip29jLQT8YVDjz+2AZe8Uz359mld/kYh0rijo+1t
         r599hQdjWUPeTfh87op//MLv68DweXGf8zE745LtSOdpGbTU8tjgOII29CUr+ZbcgjO2
         PhifWbFHWNhaCij7mqcEE/qnLZ6SFyZOXVPt432HWBfMMuZGCdurYVnBPknl3wKzF2t8
         DmWg==
X-Forwarded-Encrypted: i=1; AJvYcCUk1ONhuid9LXF+WJPKSx+qLchjRxo+m9CGnjO/hKGUh3+ifAVt8JRLEyfaAyuyyDhG7t3Gs30Rwp70@vger.kernel.org, AJvYcCWnYNP+WNpfESaH9GKLRkXCyhljgrEMo3xCGtucQXr0ox6lCr40SUIu7+DSyeLW5+9Qj2fE/4BM65DWXrw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfrEr+kQugWVz+PM1ufYRWPwnl1YbALShGgTOlvzXi3aLS8s4D
	b/s3noQlDPbo2xVXz/C+8JK0sH2eMlTkWBYtrp8mlJMopO77IoUaFUwMWI2Sz7EVlcDlQt/zT1E
	0KtxaPL+lUxyREOnSunlcyqLcVr8BPGbhleDzew==
X-Gm-Gg: ASbGncufacNYeQsyM0wI82LAu4qxayk+0nZMM/3/XueV7mg+B27g263pfsXmQPP/khO
	eHdwxHSkiOGP90MFBM4Lw557zCJkgNqsag+E99Ks=
X-Google-Smtp-Source: AGHT+IGXELnX+S4Nn14Ey7GNcfI/7nbDoBDh1cupEATZtZwYNjk0hwMNt+RnsPKL4Nz2MzJSfLv7WW2jB4HoZzNTdaQ=
X-Received: by 2002:a05:6214:27eb:b0:6d8:f612:e27d with SMTP id
 6a1803df08f44-6dd2339ff38mr204223226d6.32.1734954952509; Mon, 23 Dec 2024
 03:55:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241223093722.78570-1-laoar.shao@gmail.com>
In-Reply-To: <20241223093722.78570-1-laoar.shao@gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 23 Dec 2024 19:55:16 +0800
Message-ID: <CALOAHbBtCJqCQq=P4eHA10TxHrnwgbfL1dJN5ZtnL9ow1wXEKw@mail.gmail.com>
Subject: Re: [PATCH] hung_task: fix missing hung task detection for kthread in
 TASK_WAKEKILL state
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 23, 2024 at 5:37=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> =
wrote:
>
> We recently encountered an XFS deadlock issue, which is a known problem
> resolved in the upstream kernel [0]. During the analysis of this issue, I
> observed that a kernel thread in the TASK_WAKEKILL state could not be
> detected as a hung task by the hung_task detector. The details are as
> follows:
>
> Using the following command, I identified nine tasks stuck in the D state=
:
>
> $ ps -eLo state,comm,tid,wchan  | grep ^D
> D java            4177339 xfs_buf_lock
> D kworker/93:3+xf 3025535 xfs_buf_lock
> D kworker/87:0+xf 3426612 xfs_extent_busy_flush
> D kworker/85:0+xf 3479378 xfs_buf_lock
> D kworker/91:1+xf 3584478 xfs_buf_lock
> D kworker/80:3+xf 3655680 xfs_buf_lock
> D kworker/89:0+xf 3671691 xfs_buf_lock
> D kworker/84:1+xf 3708397 xfs_buf_lock
> D kworker/81:1+xf 4005763 xfs_buf_lock
>
> However, the hung_task detector only reported eight of these tasks:
>
> [3108840.650652] INFO: task java:4177339 blocked for more than 247779 sec=
onds.
> [3108840.654197] INFO: task kworker/93:3:3025535 blocked for more than 24=
8427 seconds.
> [3108840.657711] INFO: task kworker/85:0:3479378 blocked for more than 24=
7836 seconds.
> [3108840.661483] INFO: task kworker/91:1:3584478 blocked for more than 24=
9638 seconds.
> [3108840.664871] INFO: task kworker/80:3:3655680 blocked for more than 24=
9638 seconds.
> [3108840.668495] INFO: task kworker/89:0:3671691 blocked for more than 24=
9047 seconds.
> [3108840.672418] INFO: task kworker/84:1:3708397 blocked for more than 24=
7836 seconds.
> [3108840.676175] INFO: task kworker/81:1:4005763 blocked for more than 24=
7836 seconds.
>
> Task 3426612, although in the D state, was not reported as a hung task.
>
> I confirmed that task 3426612 remained in the D (disk sleep) state and
> experienced no context switches over a long period:
>
> $ cat /proc/3426612/status | grep -E "State:|ctxt_switches:";   \
>   sleep 60; echo "----"; \
>   cat /proc/3426612/status | grep -E "State:|ctxt_switches:"
> State:  D (disk sleep)
> voluntary_ctxt_switches:        7516
> nonvoluntary_ctxt_switches:     0
> ----
> State:  D (disk sleep)
> voluntary_ctxt_switches:        7516
> nonvoluntary_ctxt_switches:     0
>
> The system's hung_task detector settings were configured as follows:
>
>   kernel.hung_task_timeout_secs =3D 28
>   kernel.hung_task_warnings =3D -1
>
> The issue lies in the handling of task state in the XFS code. Specificall=
y,
> the thread in question (3426612) was set to the TASK_KILLABLE state in
> xfs_extent_busy_flush():
>
>   xfs_extent_busy_flush
>     prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
>
> When a task is in the TASK_WAKEKILL state (a subset of TASK_KILLABLE), th=
e
> hung_task detector ignores it, as it assumes such tasks can be terminated=
.
> However, in this case, the kernel thread cannot be killed, meaning it
> effectively becomes a hung task.
>
> To address this issue, the hung_task detector should report the kthreads =
in
> the TASK_WAKEKILL state.
>
> Link: https://lore.kernel.org/linux-xfs/20230620002021.1038067-5-david@fr=
omorbit.com/ [0]
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Dave Chinner <david@fromorbit.com>
> ---
>  kernel/hung_task.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/hung_task.c b/kernel/hung_task.c
> index c18717189f32..ed63fd84ce2e 100644
> --- a/kernel/hung_task.c
> +++ b/kernel/hung_task.c
> @@ -220,8 +220,9 @@ static void check_hung_uninterruptible_tasks(unsigned=
 long timeout)
>                  */
>                 state =3D READ_ONCE(t->__state);
>                 if ((state & TASK_UNINTERRUPTIBLE) &&
> +                   (t->flags & PF_KTHREAD ||
>                     !(state & TASK_WAKEKILL) &&
> -                   !(state & TASK_NOLOAD))
> +                   !(state & TASK_NOLOAD)))
>                         check_hung_task(t, timeout);
>         }
>   unlock:
> --
> 2.43.5
>

Please disregard this. There may be multiple hung tasks in the TASK_IDLE st=
ate.
I will send a new one.

--
Regards
Yafang
