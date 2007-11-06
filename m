Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Nov 2007 11:04:07 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA6J43b7029852
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2007 11:04:04 -0800
Message-ID: <4730BAA5.1080406@sandeen.net>
Date: Tue, 06 Nov 2007 13:04:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: TAKE 972756 - Implement fallocate.
References: <20071102024314.9BF3458C38F7@chook.melbourne.sgi.com>	 <cc7060690711051042h5c39c540mf60f95e2f67c7bd7@mail.gmail.com>	 <20071106001223.GY66820511@sgi.com> <cc7060690711060927n1ea8a489n9f02029a11b73b00@mail.gmail.com>
In-Reply-To: <cc7060690711060927n1ea8a489n9f02029a11b73b00@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

Bhagi rathi wrote:
> File is of size 1k.  A 4k block is allocated as file-system block size is
> 4k.
>  Preallocation happened from 1k to 256k. Now, it looks to me that we have
> un-written extents from 4k to 256k. There is no guarantee that data from 1k
> to 4k is all zero'es. Fallocate is updating size.  Hence on subsequent read,
> we can get garbage from 1k to 4k and all zero'es from 4k to 256k

You've tested this and found it to be true?

-Eric

> Is the expectation here is application should take the responsibility of
> zero'ing
> data?  I still need to through fallocate requirements.
