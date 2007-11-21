Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 07:22:00 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lALFLkfX008158
	for <xfs@oss.sgi.com>; Wed, 21 Nov 2007 07:21:48 -0800
Date: Wed, 21 Nov 2007 15:21:53 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Turn off XBF_READ_AHEAD in io completion
Message-ID: <20071121152153.GE8454@infradead.org>
References: <47296FF7.8080607@sgi.com> <20071101100012.GA20065@infradead.org> <4733B1CA.9030109@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4733B1CA.9030109@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Nov 09, 2007 at 12:03:06PM +1100, Lachlan McIlroy wrote:
> Okay, I've done that (new patch attached).  It's certainly not as
> clean as the last patch.

Yes, it doesn't really look like an improvement.  I'd go with your previous
patch and see if we can find a better way to sort out the buffer flags mess
later.
