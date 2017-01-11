Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47632 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752955AbdAKIFv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 03:05:51 -0500
Date: Wed, 11 Jan 2017 00:05:44 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Reading about CoW architecture / Performance Limits
Message-ID: <20170111080544.GB5883@birch.djwong.org>
References: <BC894F29-47E7-47A3-93FB-3E4EEE1DCDD5@flyingcircus.io>
 <20170110074524.GI14038@birch.djwong.org>
 <C97BB12C-3C30-493B-BE9A-9E8C7CB5D1A4@flyingcircus.io>
 <9713E613-6953-4AD3-89B1-C0EF639E771C@flyingcircus.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9713E613-6953-4AD3-89B1-C0EF639E771C@flyingcircus.io>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christian Theune <ct@flyingcircus.io>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 10, 2017 at 12:08:39PM +0100, Christian Theune wrote:
> Hi,
> 
> > On 10 Jan 2017, at 11:54, Christian Theune <ct@flyingcircus.io> wrote:
> > 
> > Hi,
> > 
> >> On 10 Jan 2017, at 08:45, Darrick J. Wong <darrick.wong@oracle.com <mailto:darrick.wong@oracle.com>> wrote:
> >> 
> > 
> >> You might try reading the huge comment blocks in fs/xfs/xfs_reflink.c.
> > 
> > Great, thanks! I admit not having looked there myself as I didn’t expect it. Lesson learned!
> 
> having read the code I think I understood three things:
> 
> 1. As you said, fragmentation may become an issue if the block
> allocation doesn’t manage to keep things together. This depends on the
> actual traffic patterns. (And probably free space?) I guess for long
> running environments regular/continuous reorganization would make
> sense?

It could, but keep in mind that xfs_fsr will break reflinks.

> 2. There is no data structure that introduces an additional
> “generational” penalty for CoW upon CoW upon CoW … ?

Nothing in reflink itself should do that.  The (also experimental)
reverse mapping feature will slowly consume space storing all the
backrefs, though there isn't any special overhead for shared stuff.
Reverse mappings are (at the moment) only useful for online metadata
reconstruction.

> 3. There appears to be code that allows retroactively creating CoW for
> two files that existed separately before. Is that (planned to be)
> exposed to userland?

No plans for that at the moment.  There used to be a debugging knob, but
it was ripped out before upstreaming the code.

--D

> 
> Cheers,
> Christian
> 
> --
> Christian Theune · ct@flyingcircus.io · +49 345 219401 0
> Flying Circus Internet Operations GmbH · http://flyingcircus.io
> Forsterstraße 29 · 06112 Halle (Saale) · Deutschland
> HR Stendal HRB 21169 · Geschäftsführer: Christian. Theune, Christian. Zagrodnick
> 


