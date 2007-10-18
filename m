Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Oct 2007 12:11:36 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9IJBT7s004911
	for <xfs@OSS.SGI.com>; Thu, 18 Oct 2007 12:11:32 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.66 #1)
	id 1Iia01-0006hB-MZ
	for <xfs@OSS.SGI.com>; Thu, 18 Oct 2007 19:21:37 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18199.42033.260371.275119@base.ty.sabi.co.UK>
Date: Thu, 18 Oct 2007 19:21:37 +0100
Subject: Re: {WHAT?} Slow seek in kernels >= 2.6.18
In-Reply-To: <4717156C.3030308@firma.seznam.cz>
References: <4717156C.3030308@firma.seznam.cz>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <xfs@oss.sgi.com>

>>> On Thu, 18 Oct 2007 10:12:28 +0200, Anton A Vorobev
>>> <anton.vorobev@firma.seznam.cz> said:

anton.vorobev> Hi!  A question. We've got an application that
anton.vorobev> runs about 30-40 minutes. After kernel upgrade
anton.vorobev> from 2.6.17 branch, it runs about 3 hours. [
anton.vorobev> ... ]

I'd check the elevator and its parameters more than XFS.
