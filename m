Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Aug 2006 03:44:44 -0700 (PDT)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.186])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k74AiMDW003405
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 03:44:23 -0700
Received: by nf-out-0910.google.com with SMTP id k26so611891nfc
        for <xfs@oss.sgi.com>; Fri, 04 Aug 2006 03:43:56 -0700 (PDT)
Message-ID: <9a8748490608040343p472591b8n9856f4afd78c9dfa@mail.gmail.com>
Date: Fri, 4 Aug 2006 12:43:54 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: 2.6.18-rc3-git3 - XFS - BUG: unable to handle kernel NULL pointer dereference at virtual address 00000078
In-Reply-To: <20060804200549.A2414667@wobbly.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490608040122l69ff139dtaae27e8981022dae@mail.gmail.com>
	 <20060804200549.A2414667@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On 04/08/06, Nathan Scott <nathans@sgi.com> wrote:
> On Fri, Aug 04, 2006 at 10:22:21AM +0200, Jesper Juhl wrote:
> > I just hit a BUG that looks XFS related.
> >
> > The machine is running 2.6.18-rc3-git3
> >
> > (more info below the BUG messages)
> >
>
> Thanks for reporting, Jesper - is it reproducible?

I don't know. I only tried that kernel once and when it broke on me
went back to the previous 2.6.11 kernel it was running before.


>  Could you try this
> patch for me?

Sure.
The machine is semi-production, so there are limits to how much and
when I can test on it.
roughly wednesday and thursday each week I should be able to run
experimental kernels on it, the rest of the week the box needs to be
stable.

>  We had a couple of other reports of this, but the earlier
> reporters have vanished ... could you let me know if this helps?
>

What I'll do is apply that patch to the 2.6.18-rc3-git3 kernel that
BUG'ed on me, then wednesday next week I'll boot the machine with the
patched kernel and it should be able to run for ~24hrs, then I can
report back to you if it crashed or not.

Or is there some other way you'd rather have me do it (subject to the
constraint that I can only do experiments one and a half to two days a
week) ?


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
