Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74068C4727C
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 20:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B6AE2076A
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 20:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729063AbgI2UJZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 16:09:25 -0400
Received: from mga12.intel.com ([192.55.52.136]:11358 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728362AbgI2UJY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Sep 2020 16:09:24 -0400
IronPort-SDR: I6o5N5ZB5XeGju4hGb47jWEq6D4LgYlTRSt5gLMWp2X5dkKyGKaMVt16WxK5zZtljToYJmCgmZ
 +rPOKesTzbDw==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="141683851"
X-IronPort-AV: E=Sophos;i="5.77,319,1596524400"; 
   d="scan'208";a="141683851"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 13:09:23 -0700
IronPort-SDR: k6lbaEZ6Kq6Tr+55Ah3ph5fY75+ANMKj7k+/gRlGnkvYZBURkyULKf0K716ivLNtoUxR08T4/v
 25TNVXctKViA==
X-IronPort-AV: E=Sophos;i="5.77,319,1596524400"; 
   d="scan'208";a="493255431"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 13:09:22 -0700
Date:   Tue, 29 Sep 2020 13:09:22 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc:     linux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] man/statx: Add STATX_ATTR_DAX
Message-ID: <20200929200922.GC706602@iweiny-DESK2.sc.intel.com>
References: <20200505002016.1085071-1-ira.weiny@intel.com>
 <20200928164200.GA459459@iweiny-DESK2.sc.intel.com>
 <ddf4dd69-6bf8-8ca7-cdd7-a949884d997f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddf4dd69-6bf8-8ca7-cdd7-a949884d997f@gmail.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 29, 2020 at 10:38:46AM +0200, Michael Kerrisk (man-pages) wrote:
> Hello Ira,
> 
> On 9/28/20 6:42 PM, Ira Weiny wrote:
> > On Mon, May 04, 2020 at 05:20:16PM -0700, 'Ira Weiny' wrote:
> >> From: Ira Weiny <ira.weiny@intel.com>
> >>
> >> Linux 5.8 is slated to have STATX_ATTR_DAX support.
> >>
> >> https://lore.kernel.org/lkml/20200428002142.404144-4-ira.weiny@intel.com/
> >> https://lore.kernel.org/lkml/20200504161352.GA13783@magnolia/
> >>
> >> Add the text to the statx man page.
> >>
> >> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > 
> > Have I sent this to the wrong list?  Or perhaps I have missed a reply.
> 
> No, it's just me being a bit slow, I'm sorry. Thank you for pining.

NP

> 
> > I don't see this applied to the man-pages project.[1]  But perhaps I am looking
> > at the wrong place?
> 
> Your patch is applied now, and pushed to kernel .org. Thanks!

Sweet!  Thank you!
Ira

> 
> Cheers,
> 
> Michael
> 
