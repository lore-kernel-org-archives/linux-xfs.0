Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 10 Oct 2008 11:06:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9AI6C9s002806
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2008 11:06:12 -0700
Date: Fri, 10 Oct 2008 11:07:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] fix barrier fail detection in XFS
In-Reply-To: <48EEF60D.4020602@sgi.com>
Message-ID: <alpine.LFD.2.00.0810101105110.3503@nehalem.linux-foundation.org>
References: <48EEF60D.4020602@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: lkml@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>, Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org, toei.rei@stargazer.at



On Fri, 10 Oct 2008, Timothy Shimmin wrote:
> 
> This is an important fix posted by Christoph Hellwig today.

Oh, btw, when doing this, please add the

	From: Christoph Hellwig <hch@lst.de>

at the top of the email (and if you re-post the one-liner summary 
description, prepend it with "Subject: ", so that when I apply it as an 
email, the "Fix barrier fail detection in XFS" doesn't end up being 
repeated twice - once from the real email subject line, and once as the 
first normal line of the email).

I did it by hand, so you don't need to re-send, but just for future 
reference, for when I don't happen to notice (and so that I don't have to 
do it myself when I _do_ notice)

		Linus
