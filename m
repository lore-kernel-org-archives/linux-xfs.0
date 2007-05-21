Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 May 2007 22:10:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4L5APfB013870
	for <xfs@oss.sgi.com>; Sun, 20 May 2007 22:10:27 -0700
Date: Mon, 21 May 2007 15:14:34 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: [xfs-masters] 2.6.22-rc2 built on ppc
Message-ID: <F35CBABFFBB23DB22ECDAF70@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20070521042542.GA11798@tuatara.stupidest.org>
References: <20070520111408.GF3253@aragorn.home.lxtec.de>
 <9BA71D7C90D3CBF30ABEF4AF@timothy-shimmins-power-mac-g5.local>
 <20070521042542.GA11798@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: riesebie@lxtec.de, xfs@oss.sgi.com



--On 20 May 2007 9:25:42 PM -0700 Chris Wedgwood <cw@f00f.org> wrote:

> On Mon, May 21, 2007 at 01:25:06PM +1000, Timothy Shimmin wrote:
>
>> However, we can init it on definition to shut the warning up.
>
> Please don't.  It's not a bug, doing an unneeded init just to silence
> gcc (gcc could be smarter in some cases) has the potential to hide
> real bugs later on.

:)
Yeah, I was discussing with this with someone earlier today.
He suggested that it was better to init it (to say NULLRTBLOCK)
because it was more likely to find a problem (if we change/add code
later on incorrectly)
than if we leave it to be unitialised with a random value.

--Tim
