Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from act-MTAout2.csiro.au ([150.229.7.38]:5734 "EHLO
        act-MTAout2.csiro.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388278AbeGXFwG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jul 2018 01:52:06 -0400
Date: Tue, 24 Jul 2018 14:37:34 +1000
From: Vincent McIntyre <vincent.mcintyre@csiro.au>
Subject: Re: xfsprogs-dev failing to build
Message-ID: <20180724043734.GI27624@mayhem.atnf.CSIRO.AU>
References: <20180724040944.GH27624@mayhem.atnf.CSIRO.AU>
 <20180724042738.GS4813@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180724042738.GS4813@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 23, 2018 at 09:27:38PM -0700, Darrick J. Wong wrote:
> On Tue, Jul 24, 2018 at 02:09:44PM +1000, Vincent McIntyre wrote:
> > Hi
> > 
> > I am trying to build the latest xfsprogs on an older system,
> > details below. The configure script is failing on what appears
> > to be an unexpanded m4 macro,
> > 
> >   PKG_CHECK_MODULES(libicu, icu-i18n, have_libicu=yes, have_libicu=no)
> 
> Hmmm, I thought that pkg.m4 would be pulled in via aclocal
> automatically, but I could be wrong. :/
> 
> What version of pkg-config (or I guess pkgconf?) is on the system?
> 

It was not actually installed, and that was the problem.
The tree builds ok now, and xfs_repair -n works ok.

A bit odd pkg-config was not installed, I had installed the
'build-essential' metapackage but I guess it didn't pull in.

> > I'm not quite sure how to work around this or if it is a bug.
> > Any advice would be appreciated.
> 
> Definitely some sort of bug...

I think the only fix needed is for the xfs.org faq page

- apt-get install libtool automake gettext libblkid-dev uuid-dev
+ apt-get install libtool automake gettext libblkid-dev uuid-dev pkg-config

Possibly libicu-dev should be added to the list also.

Thanks for the fast response.
Cheers
Vince
