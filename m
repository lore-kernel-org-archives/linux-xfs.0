Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389079AbfEXP07 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 May 2019 11:26:59 -0400
Date: Fri, 24 May 2019 11:26:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] kernel.h: Add generic roundup_64() macro
Message-ID: <20190524112656.5ef67c6c@gandalf.local.home>
In-Reply-To: <e4e875f0-2aa5-89f4-f462-78bedb9c5cde@filmlight.ltd.uk>
References: <20190523100013.52a8d2a6@gandalf.local.home>
        <CAHk-=wg5HqJ2Kfgpub+tCWQ2_FiFwEW9H1Rm+an-BLGaGvDDXw@mail.gmail.com>
        <20190523112740.7167aba4@gandalf.local.home>
        <e4e875f0-2aa5-89f4-f462-78bedb9c5cde@filmlight.ltd.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, dri-devel <dri-devel@lists.freedesktop.org>, nouveau@lists.freedesktop.org, linux-rdma <linux-rdma@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Fri, 24 May 2019 16:11:14 +0100
Roger Willcocks <roger@filmlight.ltd.uk> wrote:

> On 23/05/2019 16:27, Steven Rostedt wrote:
> >
> > I haven't yet tested this, but what about something like the following:
> >
> > ...perhaps forget about the constant check, and just force
> > the power of two check:
> >
> > 							\
> > 	if (!(__y & (__y >> 1))) {			\
> > 		__x = round_up(x, y);			\
> > 	} else {					\  
> 
> You probably want
> 
>             if (!(__y & (__y - 1))
> 
> --

Yes I do. I corrected it in my next email.

 http://lkml.kernel.org/r/20190523133648.591f9e78@gandalf.local.home

> #define roundup(x, y) (					\
> {							\
> 	typeof(y) __y = y;				\
> 	typeof(x) __x;					\
> 							\
> 	if (__y & (__y - 1))				\
> 		__x = round_up(x, __y);			\
> 	else						\
> 		__x = (((x) + (__y - 1)) / __y) * __y;	\
> 	__x;						\
> })


-- Steve
