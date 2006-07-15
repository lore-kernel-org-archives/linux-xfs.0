Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 15 Jul 2006 12:29:47 -0700 (PDT)
Received: from smtp103.sbc.mail.mud.yahoo.com (smtp103.sbc.mail.mud.yahoo.com [68.142.198.202])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6FJTMDW026817
	for <linux-xfs@oss.sgi.com>; Sat, 15 Jul 2006 12:29:26 -0700
Date: Sat, 15 Jul 2006 12:28:57 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: XFS and write barrier
Message-ID: <20060715192857.GA11034@tuatara.stupidest.org>
References: <200607151248.56603.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200607151248.56603.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com

On Sat, Jul 15, 2006 at 12:48:56PM +0200, Martin Steigerwald wrote:

> What are those intermittent IO errors? I googled but did not find a
> discussion of this change.

write barriers are enabled by default now, they have been for some
months (since the end of March)

> Does anyone have any hint as to why this may have been the case?
> Thing is that the system went down, the kernel crashed while it was
> in use.

usually in the case of a kernel crash the disks are able to ti flush
(unlike with power loss) so i wouldn't expect barriers or the lack of
them to affect things here

> I am suspecting that the kernel went down due to other instabilities
> and then XFS got corrupted by out of order writes.

yes, if writes are misordered and some are lost, then it's possible to
have a corrupt filesystem when you come back up
