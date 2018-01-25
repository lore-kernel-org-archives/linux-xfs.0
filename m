Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43926 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751204AbeAYWgv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jan 2018 17:36:51 -0500
Date: Thu, 25 Jan 2018 14:36:39 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 27/29] xfs_scrub: integrate services with systemd
Message-ID: <20180125223639.GQ9068@magnolia>
References: <151622651142.31925.4179778330985746435.stgit@magnolia>
 <151622668376.31925.11115543396206091025.stgit@magnolia>
 <e517aefd-5ad0-4de6-6b8f-1911da22f464@sandeen.net>
 <20180125214411.GP9068@magnolia>
 <0a9006ce-05ea-1bc8-751e-6a49aa0db32a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a9006ce-05ea-1bc8-751e-6a49aa0db32a@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Jan 25, 2018 at 04:16:52PM -0600, Eric Sandeen wrote:
> 
> 
> On 1/25/18 3:44 PM, Darrick J. Wong wrote:
> >> Ok this seems batshit crazy, no offense.  I don't blame /you/ ;)  You pointed me
> >> at  http://refspecs.linuxbase.org/LSB_2.0.1/LSB-PDA/LSB-PDA/iniscrptact.html
> >> but it says that the /initscript/ should exit with specific codes, not that
> >> the application it /calls/ should do so.
> > Yes.  At the moment, the systemd service calls xfs_scrub directly, hence
> > it interprets the return code as an initscript error code.  So in theory
> > we could create a wrapper script that does all the is_service junk, but
> > now that's another weird little script to break.  On the plus side we'd
> > contain the systemd workaround crap to some random wrapper in /usr/lib.
> > 
> > Ok, I'll think about it.
> > 
> 
> does LSB even have anything to do w/ systemd behavior or have they reinvented
> all that by now?  :(

I think systemd is mostly following LSB here, though they give us the
flexibility to screw things up.

> FWIW,
> 
> https://www.freedesktop.org/software/systemd/man/systemd.service.html
> 
> says that you can define:
> 
> SuccessExitStatus=
> 
>     Takes a list of exit status definitions that, when returned by the main service process, will be considered successful termination
> 
> does that help?

No.  The xfs_scrub_fail@ service is only invoked if the service fails,
so if we use SuccessExitStatus= to remap the scrub problem error codes
to "success" then systemd considers the service to have succeeded and
won't start the _fail service.

--D

> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
