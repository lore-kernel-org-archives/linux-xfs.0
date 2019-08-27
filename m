Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9056FC3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 18:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6664F2189D
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 18:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566931633;
	bh=vnSw26vmza9tai31s0shDTzonK8nFj+I5IpeOSR9cPs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=F3NFL+0XFnudexIQjUOnmDN4ObY/9wAXUH1TyhW6/DqUl+/yAPG2roB7o26FT20dx
	 OOl8rQXCBZfWFPTNQy+/gti4nHIqysPWDAxiPSVW89KCwt+SuOYX7BnVbBzmznu1gD
	 gyZ+ngbrJgPZntNh3MceUyrWIIazvGobzXIlfJFA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbfH0SrM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 14:47:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730267AbfH0SrM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Aug 2019 14:47:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07D6420828;
        Tue, 27 Aug 2019 18:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566931631;
        bh=vnSw26vmza9tai31s0shDTzonK8nFj+I5IpeOSR9cPs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YFMRi73OilY3DgQHbLybMuAP5cW01HbXtboEiYHiIEl+TDmWaRIcMkf7zJw71RMgc
         C3SC4B0CERhMeGyfP5LHfEOxK0gLUHuA+Vawuqseqz+XO59BhI8JUnaChTbe1eDAkW
         kOUBuvxm4d5RmPQDxZAptE1isY7XwJZBPWy/EK80=
Date:   Tue, 27 Aug 2019 20:47:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eryu Guan <guaneryu@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Security Officers <security@kernel.org>,
        Debian Security Team <team@security.debian.org>,
        benjamin.moody@gmail.com, Ben Hutchings <benh@debian.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH v2] generic: test for failure to unlock inode after chgrp
 fails with EDQUOT
Message-ID: <20190827184709.GB2987@kroah.com>
References: <20190827041816.GB1037528@magnolia>
 <alpine.DEB.2.21.1908270811030.1939@nanos.tec.linutronix.de>
 <20190827150451.GY1037350@magnolia>
 <alpine.DEB.2.21.1908271707400.1939@nanos.tec.linutronix.de>
 <20190827152648.GB534@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827152648.GB534@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 27, 2019 at 05:26:48PM +0200, Greg KH wrote:
> On Tue, Aug 27, 2019 at 05:19:27PM +0200, Thomas Gleixner wrote:
> > Darrick,
> > 
> > On Tue, 27 Aug 2019, Darrick J. Wong wrote:
> > 
> > > On Tue, Aug 27, 2019 at 08:13:19AM +0200, Thomas Gleixner wrote:
> > > > On Mon, 26 Aug 2019, Darrick J. Wong wrote:
> > > > > +++ b/tests/generic/719
> > > > > @@ -0,0 +1,59 @@
> > > > > +#! /bin/bash
> > > > > +# SPDX-License-Identifier: GPL-2.0-or-newer
> > > > 
> > > > Please run scripts/spdxcheck.py on that file and consult the licensing
> > > > documentation.
> > > 
> > > -or-later, sorry.
> > > 
> > > So .... now that everyone who wanted these SPDX identifiers have spread
> > > "GPL-2.0+" around the kernel and related projects (xfsprogs, xfstests)
> > > just in time for SPDX 3.0 to deprecate the "+" syntax, what are we
> > > supposed to do?  Another treewide change to fiddle with SPDX syntax?
> > > Can we just put:
> > > 
> > > Valid-License-Identifier: GPL-2.0+
> > > Valid-License-Identifier: GPL-2.0-or-later
> > > 
> > > in the LICENSES/GPL-2.0 file like the kernel does?
> > 
> > The kernel is not going to change that because we have started with this
> > before the s/+/-or-later/ happened. Tools need to read both.
> >  
> > > Is that even going to stay that way?  I thought I heard that Greg was
> > > working on phasing out the "2.0+" tags since SPDX deprecated that?
> > 
> > For new stuff we should use -or-later methinks.
> 
> For new stuff, if you wish to be "kind" to some community members, we
> should use "-or-later" and "-only".  But as you say, both are fine.
> 
> And no, I am NOT working on phasing out any SPDX tags for the older
> stuff.  Personally, I like the older ones.
> 
> > Yeah, we should add a MAINTAINERS entry for LICENSES. Greg and myself are
> > going to be volunteered I fear.
> 
> Yeah, I figured it was only a matter of time.  Let me go create an entry
> given that we already have git tree for it in linux-next for a while
> now...

Now submitted:
	https://lore.kernel.org/lkml/20190827172519.GA28849@kroah.com/T/#u

