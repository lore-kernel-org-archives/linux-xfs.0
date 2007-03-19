Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 Mar 2007 18:06:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2J15w6p024237
	for <xfs@oss.sgi.com>; Sun, 18 Mar 2007 18:06:00 -0700
Date: Mon, 19 Mar 2007 12:05:54 +1100
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: HAVE_FORMAT32 never enabled in mainline
Message-ID: <3B879A0369DABD1EDF88296F@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <45FC650F.70208@sandeen.net>
References: <20070317154028.GA18997@lst.de> <45FC650F.70208@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>
Cc: tes@melbourne.sgi.com, xfs@oss.sgi.com

Hi Eric,

--On 17 March 2007 5:00:47 PM -0500 Eric Sandeen <sandeen@sandeen.net> wrote:

> Christoph Hellwig wrote:
>> Looks like the code for dealing with x86/amd64 logs is never actually
>> enable in mainline because nothing defines HAVE_FORMAT32.
>
> Actually since it's all #ifndef (note the n) everything under the #ifndefs -is- enabled (since
> it's never defined), so I think it's all functional....

Yep (sorry, just missed your email).

> structures under the #ifndefs are used
> outside the #ifndefs, so the #ifndefs can probably just be removed...?

Would need to sort out the userspace header sharing situation first as
mentioned in the hch email.

Cheers,
Tim.
