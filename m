Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A8AEC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 05:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B349622247
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 05:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgJOFcj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 01:32:39 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:49075 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbgJOFcj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 01:32:39 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CFD753AAE69;
        Thu, 15 Oct 2020 16:32:35 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSvsQ-000gQq-Tn; Thu, 15 Oct 2020 16:32:34 +1100
Date:   Thu, 15 Oct 2020 16:32:34 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/5] mkfs: Configuration file defined options
Message-ID: <20201015053234.GE7391@dread.disaster.area>
References: <20201015032925.1574739-1-david@fromorbit.com>
 <20201015051300.GM9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015051300.GM9832@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=7-415B0cAAAA:8
        a=NBDHUJgFdIeY7vQMsYAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 14, 2020 at 10:13:00PM -0700, Darrick J. Wong wrote:
> On Thu, Oct 15, 2020 at 02:29:20PM +1100, Dave Chinner wrote:
> > Version 2:
> > 
> > - "-c file=xxx" > "-c options=xxx"
> > - split out constification into new patch
> > - removed debug output
> > - fixed some comments
> > - added man page stuff
> > 
> > Hi Folks,
> > 
> > Because needing config files for mkfs came up yet again in
> > discussion, here is a simple implementation of INI format config
> > files. These config files behave identically to options specified on
> > the command line - the do not change defaults, they do not override
> > CLI options, they are not overridden by cli options.
> > 
> > Example:
> > 
> > $ echo -e "[metadata]\ncrc = 0" > foo
> > $ mkfs/mkfs.xfs -N -c options=foo -d file=1,size=100m blah
> > Parameters parsed from config file foo successfully
> > meta-data=blah                   isize=256    agcount=4, agsize=6400 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=0        finobt=0, sparse=0, rmapbt=0
> >          =                       reflink=0
> > data     =                       bsize=4096   blocks=25600, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > log      =internal log           bsize=4096   blocks=853, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > $
> > 
> > And there's a V4 filesystem as specified by the option defined
> > in the config file. If we do:
> > 
> > $ mkfs/mkfs.xfs -N -c options=foo -m crc=1 -d file=1,size=100m blah
> > -m crc option respecified
> > Usage: mkfs.xfs
> > .....
> > $
> > 
> > You can see it errors out because the CRC option was specified in
> > both the config file and on the CLI.
> > 
> > There's lots of stuff we can do to make the conflict and respec
> > error messages better, but that doesn't change the basic
> > functionality of config file based mkfs options. To allow for future
> > changes to the way we want to apply config files, I created a
> > full option subtype for config files. That means we can add another
> > option to say "apply config file as default values rather than as
> > options" if we decide that is functionality that we want to support.
> > 
> > However, policy decisions like that are completely separate to the
> > mechanism, so these patches don't try to address desires to ship
> > "tuned" configs, system wide option files, shipping distro specific
> > defaults in config files, etc. This is purely a mechanism to allow
> > users to specify options via files instead of on the CLI.  No more,
> > no less.
> > 
> > This has only been given a basic smoke testing right now (see above!
> > :).  I need to get Darrick's tests from the previous round of config
> 
> This was in the v1 series; have you gotten Darrick's fstests to do more
> substantial testing? ;)

I got as far as asking you "where did you get your INI format
specification from?" because the tests assume stuff that I don't
think is valid about whitespace and comment structure in the format.
And then I disappeared down a rathole of "there is no one true
specification for INI files" and then something else came up....

I have not got back to culling the whitespace craziness from those
tests yet. The only format I'm considering supporting is what the
library itself actually supports, and that means random whitespace
in names, values and section headers will be a bad configuration
file format error.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
