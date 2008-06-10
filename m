Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jun 2008 10:06:38 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5AH6Xbf016506
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 10:06:33 -0700
Received: from smtp-out03.alice-dsl.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 457CA17A805C
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 10:07:28 -0700 (PDT)
Received: from smtp-out03.alice-dsl.net (smtp-out03.alice-dsl.net [88.44.63.5]) by cuda.sgi.com with ESMTP id 6E01QiUtE2J8cFHM for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 10:07:28 -0700 (PDT)
Subject: Re: Probems with xfs_repair on large filesystem and 32bit OS.
From: Andi Kleen <andi@firstfloor.org>
References: <6A32BC807C106440B7E23208F280DDAF01D3F6C8A8@bcmail1.VIDMARK.LOCAL>
	<20080610115038.GD3005@sillage.bis.pasteur.fr>
	<6A32BC807C106440B7E23208F280DDAF01D3F6C8B4@bcmail1.VIDMARK.LOCAL>
	<20080610122811.GB15871@infradead.org>
Date: Tue, 10 Jun 2008 19:07:26 +0200
In-Reply-To: <20080610122811.GB15871@infradead.org> (Christoph Hellwig's message of "Tue, 10 Jun 2008 08:28:11 -0400")
Message-ID: <87tzg1p6b5.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Lance Reed <lreed@brightcove.com>, Tru Huynh <tru@pasteur.fr>, "'xfs@oss.sgi.com'" <xfs@oss.sgi.com>

Christoph Hellwig <hch@infradead.org> writes:

> On Tue, Jun 10, 2008 at 08:07:18AM -0400, Lance Reed wrote:
>> SO, I take it from what you say that that I can running any newer version of xfs progs and a 64bit host (fiber attached, easy to do this), and run xfs_repair on the 32bit XFS volumes without fear of data corruption?
>> Is this because XFS is not version specific, and xfs_repair will honor the 32bit file data structures?
>
> Yes, this is fine.  All the actual filesystem structures are endian and
> 32/64bit clean.  The log needs to be in the same endianess and had 32bit
> vs 64bit problems on x86 for a while, but it needs to be recovered
> before you run xfs_repair anyway.

Actually there used to be some bugs in old versions where 32bit couldn't 
replay 64bit logs or vice versa.  Probably all fixed in uptodate kernels.

-Andi
