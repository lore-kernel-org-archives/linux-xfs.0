Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Aug 2008 05:00:41 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7PC0as0010517
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 05:00:37 -0700
Received: from mail2.shareable.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B24121A4086F
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 05:01:59 -0700 (PDT)
Received: from mail2.shareable.org (mail2.shareable.org [80.68.89.115]) by cuda.sgi.com with ESMTP id ZFumiwm7MYYbUxtw for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 05:01:59 -0700 (PDT)
Date: Mon, 25 Aug 2008 13:01:47 +0100
From: Jamie Lokier <jamie@shareable.org>
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous snapshotting file system)
Message-ID: <20080825120146.GC20960@shareable.org>
References: <20080821051508.GB5706@disturbed> <200808211933.34565.nickpiggin@yahoo.com.au> <20080821170854.GJ5706@disturbed> <200808221229.11069.nickpiggin@yahoo.com.au> <20080825015922.GP5706@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825015922.GP5706@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <nickpiggin@yahoo.com.au>, gus3 <musicman529@yahoo.com>, Szabolcs Szakacsits <szaka@ntfs-3g.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Dave Chinner wrote:
> To keep on top of this, we keep adding new variations and types and
> expect the filesystems to make best use of them (without
> documentation) to optimise for certain situations. Example - the
> new(ish) BIO_META tag that only CFQ understands. I can change the
> way XFS issues bios to use this tag to make CFQ behave the same way
> it used to w.r.t. metadata I/O from XFS, but then the deadline and
> AS will probably regress because they don't understand that tag and
> still need the old optimisations that just got removed. Ditto for
> prioritised bio dispatch - CFQ supports it but none of the others
> do.


There's nothing wrong with adding BIO_META (for example) and other
hints in _principle_.  You should be able to ignore it with no adverse
effects.  If its not used by a filesystem (and there's nothing else
competing to use the same disk), I would hope to see the same
performance as other kernels which don't have it.

If the elevators are being changed in such a way that old filesystem
code which doesn't use new hint bits is running significantly slower,
surely that's blatant elevator regression, and that's where the bugs
should be reported and fixed?

-- Jamie
