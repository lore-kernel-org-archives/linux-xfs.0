Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33412 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728212AbfCOBBS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 21:01:18 -0400
Date: Thu, 14 Mar 2019 18:01:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/36] debian: enable parallel make
Message-ID: <20190315010113.GB4929@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259746044.31886.13633380455067163247.stgit@magnolia>
 <CAFMei7MhwDDLvZ41Op5ij7S0_h3FpK19eXZdX6=guS_nBJ361A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFMei7MhwDDLvZ41Op5ij7S0_h3FpK19eXZdX6=guS_nBJ361A@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nathan Scott <nathans@redhat.com>
Cc: "Sandeen, Eric" <sandeen@sandeen.net>, xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 15, 2019 at 11:18:32AM +1100, Nathan Scott wrote:
> On Fri, Mar 15, 2019 at 8:04 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Use parallel make to speed up dpkg builds.
> 
> Seems a little more involved than I woulda expected, but LGTM.
> 
> Reviewed-by: Nathan Scott <nathans@debian.org>
> 
> >                 for dir in include libxfs; do \
> > -                       $(MAKE) -C $$dir NODEP=1 install-headers; \
> > +                       $(MAKE) $(PMAKEFLAGS) -C $$dir NODEP=1 install-headers; \
> >                 done; \
> 
> OOC, does the $(MAKE) -C above warrant the same treatment as the earlier patch?
> (i.e. removing the -C there for less verbosity)

Hmm, that seems like it could be the case.  I'll have a look tomorrow.

--D

> cheers.
> 
> --
> Nathan
