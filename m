Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6243C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C8D9207BC
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgHZWJ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 18:09:26 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:55615 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726783AbgHZWJX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 18:09:23 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id A646E10944F;
        Thu, 27 Aug 2020 08:09:19 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kB3ba-0003rh-VF; Thu, 27 Aug 2020 08:09:18 +1000
Date:   Thu, 27 Aug 2020 08:09:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] mkfs: add initial ini format config file parsing
 support
Message-ID: <20200826220918.GY12131@dread.disaster.area>
References: <20200826015634.3974785-1-david@fromorbit.com>
 <20200826015634.3974785-3-david@fromorbit.com>
 <9a66f54e-c4ec-4a3f-5238-89a262bd45a1@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a66f54e-c4ec-4a3f-5238-89a262bd45a1@sandeen.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=KcmsTjQD c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=Pd-8PnVNHlXT2v9x9aYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 04:56:34PM -0500, Eric Sandeen wrote:
> On 8/25/20 8:56 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add the framework that will allow the config file to be supplied on
> > the CLI and passed to the library that will parse it. This does not
> > yet do any option parsing from the config file.
> 
> so we have "-c $SUBOPT=file"
> 
> From what I read in the cover letter, and from checking in IRC it seems
> like you envision the ability to also specify defaults from a config file
> in the future; to that end it might be better to name this $SUBOPT
> "options=" instead of "file=" as the latter is very generic.
> 
> Then in the future, we could have one or both of :
> 
> -c defaults=file1 -c options=file2
> 
> i.e. configure the defaults, then configure the options

Yup, makes sense. Will change.

> I guess this is just RFC but you want probably to drop the "Ini debug:"
> printf eventually.

Yeah, I've already removed that so I can run fstests....

> This will need a man page update, of course.

Eventually, yes :P

> I think it should explain where "file" will be looked for; I assume it
> is either a full path, or a relative path to the current directory.

It will work with either, just like all the other "file" parameters
passed to mkfs....

> (In the future it would be nice to have mkfs.xfs search somewhere
> under /etc for these files as well, but I'm not bikeshedding!)

Nope, I'm not doing that. Go away. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
