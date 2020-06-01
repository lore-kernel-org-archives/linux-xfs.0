Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA58C433DF
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 23:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3659D2073B
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 23:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgFAXgH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 19:36:07 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:46344 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725802AbgFAXgH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 19:36:07 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id A82581A8731;
        Tue,  2 Jun 2020 09:36:03 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jftyH-0001FP-25; Tue, 02 Jun 2020 09:35:57 +1000
Date:   Tue, 2 Jun 2020 09:35:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Bypass sb alignment checks when custom values
 are used
Message-ID: <20200601233557.GD2040@dread.disaster.area>
References: <20200601140153.200864-1-cmaiolino@redhat.com>
 <20200601140153.200864-3-cmaiolino@redhat.com>
 <20200601212115.GC2040@dread.disaster.area>
 <3065de17-4ae7-392b-7dfe-9b9b91db9743@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3065de17-4ae7-392b-7dfe-9b9b91db9743@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=7-415B0cAAAA:8
        a=4k9HJD4jua90apFi1gEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 01, 2020 at 05:06:36PM -0500, Eric Sandeen wrote:
> On 6/1/20 4:21 PM, Dave Chinner wrote:
> > The user was not responsible for this mess (combination of missing
> > validation in XFS code and bad storage firmware providing garbage)
> > so we should not put them on the hook for fixing it. We can do it
> > easily and without needing user intervention and so that's what we
> > should do.
> 
> FWIW, I have a working xfs_repair that fixes bad geometry as well,
> I ... guess that's probably still useful?

Yes, repair should definitely be proactive on this.

> It was doing similar things to what you suggested, though I wasn't
> rounding swidth up, I was setting it equal to sunit.  *shrug* rounding
> up is maybe better; the problematic devices usually have width < unit
> so rounding up will be the same as setting equal  :)

Yup, that's exactly why I suggested rounding up :)

> phase1()
> 
> +       /*
> +        * Now see if there's a problem with the stripe width; if it's bad,
> +        * we just set it equal to the stripe unit as a harmless alternative.
> +        */
> +        if (xfs_sb_version_hasdalign(sb)) {
> +                if ((sb->sb_unit && !sb->sb_width) ||
> +                    (sb->sb_width && sb->sb_unit && sb->sb_width % sb->sb_unit)) {
> +                       sb->sb_width = sb->sb_unit;
> +                       primary_sb_modified = 1;
> +                       geometry_modified = 1;
> +                       do_warn(
> +_("superblock has a bad stripe width, resetting to %d\n"),
> +                               sb->sb_width);
> +               }
> +       }
> 
> I also had to more or less ignore bad swidths throughout repair (and in
> xfs_validate_sb_common IIRC) to be able to get this far.  If repair thinks
> a superblock is bad, it goes looking for otheres to replace it and if the
> bad geometry came from the device, they are all equally "bad..."

Yeah. Which leads me to ask: should the kernel be updating the
secondary superblocks when it finds bad geometry in the primary, or
overwrites the geometry with user supplied info?

(I have a vague recollection of being asked something about this on
IRC and me muttering something about CXFS only trashing the primary
superblock...)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
