Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56530 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753099AbeBEQoP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Feb 2018 11:44:15 -0500
Date: Mon, 5 Feb 2018 08:44:12 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs_scrub: call for testing
Message-ID: <20180205164412.GF4849@magnolia>
References: <e0ada9ef-aafb-5179-2729-447d67bd6265@sandeen.net>
 <20180205161049.7e22aa09@harpe.intellique.com>
 <61166e99-1195-1192-d229-f7e01f1d52da@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <61166e99-1195-1192-d229-f7e01f1d52da@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Emmanuel Florac <eflorac@intellique.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Feb 05, 2018 at 09:49:41AM -0600, Eric Sandeen wrote:
> On 2/5/18 9:10 AM, Emmanuel Florac wrote:
> > Le Fri, 2 Feb 2018 15:36:33 -0600
> > Eric Sandeen <sandeen@sandeen.net> écrivait:
> > 
> >> I'd really value feedback on scrub as it stand at this point -
> >> Is the documentation clear?  Is the output correct?  Do the
> >> tool's arguments make sense?  Does it segfault?  Does it
> >> find real errors?  Does it crash your kernel? Does it
> >> eat your data?
> > 
> > Wouldn't it be better to remove the parts about repairing the
> > filesystem in the documentation? The man page states that it *can't*
> > repair the filesystem, but nonetheless explains under which
> > circumstances it *won't* be able to repair (in some theoretical future
> > version with repair capabilities, I suppose). Ditto with the -n and -y
> > option, I suppose they're both basically noop at the moment? That's
> > quite unclear what it actually does.
> 
> I'll take another look at the manpage.  The userspace tool today /can/
> do some degree of optimization or repair if the kernel supports it,
> so I was reluctant to suggest removing all such language.

Yes.  If check doesn't find any errors and we're in preen or repair mode
then we can trim the free space.  They're not completely no-op...

> So, "-n" is not a no-op, it's a check-only ("scrub") pass vs. the default
> no-argument action of "optimizing," or the extra -y action which would repair.
> If that's not all clear, I'd appreciate suggestions to clean it up.

-n	Only check filesystem metadata.  Do not repair or optimize
	anything.

-y	Check filesystem metadata and try to repair errors.  If the
	errors cannot be fixed online, the filesystem must be taken
	offline and repaired with xfs_repair(8).

> > Regarding FITRIM for flash storage, I think most people refers to it as
> > "TRIM", not the ioctl name FITRIM. Using "TRIM" would probably be more
> > understandable IMO.
> 
> Fair point, thanks.
> 
> > Because I'm such a funny boy, I just wanted to see what happens when
> > running xfs_scrub on an unsupported kernel. On both a 4.14.x and a
> > 3.18.x it seems about right:
> > 
> > root@bareos16:~# ./xfs_scrub /mnt/raid/
> > EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
> > Error: /mnt/raid: Kernel metadata scrubbing facility is not available.
> > Info: /mnt/raid: Scrub aborted after phase 1.
> > /mnt/raid: 2 errors found.
> 
> Yup.  TBH I'm not a fan of listing "your kernel can't scrub" as
> "errors found."  I think we should find a way around that.

What do you mean by that?

--D

> 
> > I don't have any system running 4.15 to test its effects, but I'll do
> > as soon as possible.
> 
> Cool, thanks.
> 
> -Eric
> 



