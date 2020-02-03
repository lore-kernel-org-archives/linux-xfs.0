Return-Path: <SRS0=dEjd=3X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 764F9C35247
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 22:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4617420674
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 22:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgBCW7S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 17:59:18 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:56297 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726853AbgBCW7S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Feb 2020 17:59:18 -0500
Received: from dread.disaster.area (pa49-181-161-120.pa.nsw.optusnet.com.au [49.181.161.120])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BEA1E3A25A1;
        Tue,  4 Feb 2020 09:59:15 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iykgU-0006RT-HA; Tue, 04 Feb 2020 09:59:14 +1100
Date:   Tue, 4 Feb 2020 09:59:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Alan Latteri <alan@instinctualsoftware.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: su & sw for HW-RAID60
Message-ID: <20200203225914.GB20628@dread.disaster.area>
References: <2CE21042-5F18-4642-BF48-AF8416FB9199@instinctualsoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2CE21042-5F18-4642-BF48-AF8416FB9199@instinctualsoftware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=SkgQWeG3jiSQFIjTo4+liA==:117 a=SkgQWeG3jiSQFIjTo4+liA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=itKrJUk2X_LMhHrTErUA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 03, 2020 at 01:48:20PM -0800, Alan Latteri wrote:
> Hello,
> 
> In an environment with an LSI 3108 based HW-RAID60, 256k stripe size on controller, 5 spans of (10data+2parity) disks.  What is the proper su & sw to use?  Do I do sw to the underlying 10 data disks per span? The top level 5 spans or all 50 data disks with the array?   Use case is as a file server for 20-60 MB per frame image sequences.
> 
> i.e
> 
> 1) sw=256k,sw=10
> 2) sw=256k,sw=5
> 3) sw=256k,sw=50

A HW RAID6 lun in this configuration behaves (and performs) like a
single disk, so you're actually putting together a 5-disk raid-0
stripe with a stripe unit of 2560kB.

i.e. for consistent performance and allocation alignment for large
files, you want to do full RAID-6 stripe writes to each lun. Hence
you want the filesytsem aligned to the first disk in each of the
RAID-6 luns and to size allocations to full RAID6 lun width, not
random individual drives in the RAID-6 luns.

IOWs:

sw=2560k,sw=5

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
