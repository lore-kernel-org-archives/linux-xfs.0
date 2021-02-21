Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D703C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 21:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15F4164EBE
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 21:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhBUViN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 21 Feb 2021 16:38:13 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:49482 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230356AbhBUViM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Feb 2021 16:38:12 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 77C9778AB24;
        Mon, 22 Feb 2021 08:37:28 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lDwPv-00Fh8z-Ga; Mon, 22 Feb 2021 08:37:27 +1100
Date:   Mon, 22 Feb 2021 08:37:27 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        linux-xfs@vger.kernel.org
Subject: Re: NACK Re: [PATCH 2/4] debian: Enable CET on amd64
Message-ID: <20210221213727.GN4662@dread.disaster.area>
References: <20210220121610.3982-1-bastiangermann@fishpost.de>
 <20210220121610.3982-3-bastiangermann@fishpost.de>
 <20210221035943.GJ4662@dread.disaster.area>
 <CADWks+Y93MB=fO42K4oQ2kKt=82bz9m=KDVHWeZmqxLV40-PdA@mail.gmail.com>
 <20210221042809.GM4662@dread.disaster.area>
 <CADWks+Yf_Vg7fTPH_BoXEmxUoo_XnyCLj4oeBme5fRTqoy+o4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADWks+Yf_Vg7fTPH_BoXEmxUoo_XnyCLj4oeBme5fRTqoy+o4g@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=7-415B0cAAAA:8
        a=TJDqitv73KFGkjakVWAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 21, 2021 at 04:32:46AM +0000, Dimitri John Ledkov wrote:
> On Sun, Feb 21, 2021 at 4:28 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Sun, Feb 21, 2021 at 04:02:55AM +0000, Dimitri John Ledkov wrote:
> > > The patch in question is specific to Ubuntu and was not submitted by
> > > me to neither Debian or Upstream.
> > >
> > > Indeed, this is very distro specific, because of all the other things
> > > that we turn on by default in our toolchain, dpkg build flags, and all
> > > other packages.
> > >
> > > This patch if taken at face value, will not enable CET. And will make
> > > the package start failing to build from source, when using older
> > > toolchains that don't support said flag.
> >
> > Yes, that is exactly what I said when pointing out how to *support
> > this properly* so it doesn't break builds in environments that do
> > not support such functionality.
> >
> > Having it as a configure option allows the configure script to -test
> > whether the toolchain supports it- and then either fail (enable=yes)
> > or not use it (enable=probe) and continue the build without it.
> >
> > > It should not go upstream nor into debian.
> >
> > There is no reason it cannot be implemented as a build option in the
> > upstream package. Then you can get rid of all your nasty hacks and
> > simply add --enable-cf-protections to your distro's configure
> > options.
> >
> > And other distros that also support all this functionality can use
> > it to. Please play nice with others and do things the right way
> > instead of making silly claims about how "nobody else can use this"
> > when it's clear that they can if they also tick all the necessary
> > boxes.
> 
> debian will probably will not want --enable-cf-protections as a
> configure option, and will enable CET via dpkg-buildflags as a
> hardening option, which will then be turned on by default for relevant
> architectures and series as of when debian kernel starts to support
> it.
> 
> as that way, debian will be able to affect that change across the whole distro.

Except now you've got the problem that dpkg-buildflags is not used
by various packages such as xfsprogs, so the flags it sets up,
even with overrides like DEB_BUILD_MAINT_OPTIONS are completely
ignored by the debian package build because debian/rules is not set
up to source the buildflags at all.

e.g. if you run 'make Q= deb' you won't see any of the compiler or
linker options emitted by dpkg-buildflags being used during the
debian package build. You will, OTOH, see it emit stuff like LTO
options because those get turned on via configure.

> once CET is actually merged into kernel, I do not expect configure
> options or debian/rules changes to enable CET. At most `export
> DEB_BUILD_MAINT_OPTIONS=hardening` should be enough in debian/rules.

The default dpkg-buildflags output already includes "hardening"
options, and as I said above, they aren't actually included in the
build rules. Hence what you suggest just won't work like you think
it should.

Again, if you want build option stuff to work correctly, don't rely
on distro specific magic to turn stuff on because it just doesn't
work for everyone. Use configure options to enable, probe and detect
support and enable the feature in the build, then upstream and other
distros can actually build with it and test it outside the magical
unicorn distro build environment you are running in...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
