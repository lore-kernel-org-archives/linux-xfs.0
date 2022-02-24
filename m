Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA01AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 20:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiBXU7d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 15:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234420AbiBXU7d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 15:59:33 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 751522399EC
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 12:59:02 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6E42B53210F;
        Fri, 25 Feb 2022 07:59:00 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nNLCV-00G04S-A7; Fri, 25 Feb 2022 07:58:59 +1100
Date:   Fri, 25 Feb 2022 07:58:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Emmanuel Florac <eflorac@intellique.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: experience with very large filesystems
Message-ID: <20220224205859.GO59715@dread.disaster.area>
References: <20220223163513.43f1f054@harpe.intellique.com>
 <20220223211006.GL59715@dread.disaster.area>
 <20220224130953.4906c7e3@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220224130953.4906c7e3@harpe.intellique.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6217f195
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=8nJEP1OIZ-IA:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=8-xpJkjEXkBUN_AqSlsA:9 a=wPNLvfGTeEIA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 24, 2022 at 01:09:53PM +0100, Emmanuel Florac wrote:
> Le Thu, 24 Feb 2022 08:10:06 +1100
> Dave Chinner <david@fromorbit.com> écrivait:
> 
> > From the storage side, you really want to expand the storage with
> > chunks that have the same geometry (stripe unit and stripe width)
> > so that it doesn't screw up the alignment of the filesystem to the
> > new storage.
> 
> That part should be easy, I plan to use the same type of hardware anyway
> (12 TB Ultrastar disks).
>  
> > And that's where the difficultly may lie. If the existing storage
> > volume the filesystem sits on doesn't end exactly on a stripe width
> > boundary, you're going to have to offset the start of the new
> > storage volumes part way into the first stripe width in the volumes
> > to ensure that when the filesystem expands, then end of the first
> > stripe width in the new volume is exactly where the filesystem
> > expects it to be.
> 
> That should be somewhat more manageable given that I've setup
> everything as an LVM volume. I may use partitions on the new devices to
> precisely align the PVs before expanding the LV. 

You can use the PV/LV header size options to align the contents of
the LV.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
