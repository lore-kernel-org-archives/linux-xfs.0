Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from c.mx.filmlight.ltd.uk ([54.76.112.217]:35009 "EHLO
        c.mx.filmlight.ltd.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389428AbfEXPUL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 May 2019 11:20:11 -0400
Subject: Re: [RFC][PATCH] kernel.h: Add generic roundup_64() macro
References: <20190523100013.52a8d2a6@gandalf.local.home>
 <CAHk-=wg5HqJ2Kfgpub+tCWQ2_FiFwEW9H1Rm+an-BLGaGvDDXw@mail.gmail.com>
 <20190523112740.7167aba4@gandalf.local.home>
From: Roger Willcocks <roger@filmlight.ltd.uk>
Message-ID: <e4e875f0-2aa5-89f4-f462-78bedb9c5cde@filmlight.ltd.uk>
Date: Fri, 24 May 2019 16:11:14 +0100
MIME-Version: 1.0
In-Reply-To: <20190523112740.7167aba4@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Steven Rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: roger@filmlight.ltd.uk, LKML <linux-kernel@vger.kernel.org>, Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, dri-devel <dri-devel@lists.freedesktop.org>, nouveau@lists.freedesktop.org, linux-rdma <linux-rdma@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>


On 23/05/2019 16:27, Steven Rostedt wrote:
>
> I haven't yet tested this, but what about something like the following:
>
> ...perhaps forget about the constant check, and just force
> the power of two check:
>
> 							\
> 	if (!(__y & (__y >> 1))) {			\
> 		__x =3D round_up(x, y);			\
> 	} else {					\

You probably want

 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!(__y &=
 (__y - 1))

--

Roger
