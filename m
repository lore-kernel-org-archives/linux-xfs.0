Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Aug 2006 04:37:10 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7RBalDW010882
	for <linux-xfs@OSS.SGI.com>; Sun, 27 Aug 2006 04:36:59 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.62 #1)
	id 1GHIvu-0003sQ-8r
	for <linux-xfs@OSS.SGI.com>; Sun, 27 Aug 2006 12:36:06 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17649.33701.520393.118416@base.ty.sabi.co.UK>
Date: Sun, 27 Aug 2006 12:36:05 +0100
Subject: Re: libxfs_initbuf can't memalign 4096 bytes: Cannot allocate memory
In-Reply-To: <20060827072810.GA4098@apartia.fr>
References: <20060827072810.GA4098@apartia.fr>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

>>> On Sun, 27 Aug 2006 09:28:10 +0200, Louis-David Mitterrand
>>> <vindex+lists-xfs@apartia.org> said:

[ ... ]

> xfs_repair: libxfs_initbuf can't memalign 4096 bytes: Cannot allocate memory

Most probably this is not a bug. The system probably does not
have enough memory. "Cannot allocate memory" is probably what
is happening. This has been discussed many times previously...

   http://OSS.SGI.com/archives/linux-xfs/2005-08/msg00045.html

[ ... ]
