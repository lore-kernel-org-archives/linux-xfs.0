Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60022 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751624AbeBEWkF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Feb 2018 17:40:05 -0500
Date: Mon, 5 Feb 2018 14:39:59 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs_scrub: call for testing
Message-ID: <20180205223959.GJ4849@magnolia>
References: <e0ada9ef-aafb-5179-2729-447d67bd6265@sandeen.net>
 <20180205161049.7e22aa09@harpe.intellique.com>
 <61166e99-1195-1192-d229-f7e01f1d52da@sandeen.net>
 <20180205180807.261e822f@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180205180807.261e822f@harpe.intellique.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Feb 05, 2018 at 06:08:07PM +0100, Emmanuel Florac wrote:
> Le Mon, 5 Feb 2018 09:49:41 -0600
> Eric Sandeen <sandeen@sandeen.net> écrivait:
> 
> > > 
> > > Wouldn't it be better to remove the parts about repairing the
> > > filesystem in the documentation? The man page states that it *can't*
> > > repair the filesystem, but nonetheless explains under which
> > > circumstances it *won't* be able to repair (in some theoretical
> > > future version with repair capabilities, I suppose). Ditto with the
> > > -n and -y option, I suppose they're both basically noop at the
> > > moment? That's quite unclear what it actually does.  
> > 
> > I'll take another look at the manpage.  The userspace tool today /can/
> > do some degree of optimization or repair if the kernel supports it,
> > so I was reluctant to suggest removing all such language.
> > 
> > So, "-n" is not a no-op, it's a check-only ("scrub") pass vs. the
> > default no-argument action of "optimizing," or the extra -y action
> > which would repair. If that's not all clear, I'd appreciate
> > suggestions to clean it up.
> > 
> 
> Now I'm wondering: is the default option of "optimizing" really
> useful? Wouldn't it be better to simply have a check-only (-n) version,
> and a full-fledged version when given no argument? 
> Or maybe do a simple optimisation, optionally,  when given the '-y' (or
> some other flag) option? 
> 
> I say that after having a look at man pages from some comparable
> utilities, namely xfs_repair, btrfs_scrub and "zpool scrub", who all
> default to "full operation" without options.

I don't care /that/ much about what 'zpool scrub' does, but I do see
your point that from the admin's perspective either we fix everything or
we don't, so there's no need for a -y and we can do what repair does (-n
means dry run, lack of -n means fix it).

--D

> 
> -- 
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |	<eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------


