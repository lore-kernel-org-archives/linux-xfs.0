Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5316EC5ACD6
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 08:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AB492076D
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 08:00:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WfgQS24p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgCRIAz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 04:00:55 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37190 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgCRIAz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 04:00:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CWvXuaghVn1dUCz35V/UhjSUfrMhfalwlIvVr6VM85c=; b=WfgQS24pChqjePPa3juG9sCWQ1
        FDDGF3S2zoPlT38S8fZzwqfn5HyVNgWdQgvqP7Xl3ZhIyCRIv8Ejh2cTbAqd5C9435oy5bIQEBmbG
        uqL4aAvxxJHMGqRumo8fy5y9WX4F+1OcpiXHErEGG2TaMj4x8ugeFl/bMGD4mOZGk1Ipj8ThykWzy
        OnENgegMtiA9uKX50jOQ5FGpud127dVs3FTumzh9r1IffKfOzlA1mwg/JXMfgwEEN9sHdUR+zvSwE
        YLpsjxZoR1JnsST473osh+xCkcaits9st9206KgReUM3+Y3VgndJgLIi4sSyOfOT5OhP4Fe3vPAnm
        TgDA36tg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jETdG-0003ri-38; Wed, 18 Mar 2020 08:00:54 +0000
Date:   Wed, 18 Mar 2020 01:00:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Ober, Frank" <frank.ober@intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dimitri <dimitri.kravtchuk@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Barczak, Mariusz" <mariusz.barczak@intel.com>,
        "Barajas, Felipe" <felipe.barajas@intel.com>
Subject: Re: write atomicity with xfs ... current status?
Message-ID: <20200318080054.GA9969@infradead.org>
References: <MW3PR11MB46974637E20D2ED949A7A47E8BF90@MW3PR11MB4697.namprd11.prod.outlook.com>
 <20200316215913.GV256767@magnolia>
 <20200316233240.GR10776@dread.disaster.area>
 <MW3PR11MB4697D889E18319F7231F49BD8BF60@MW3PR11MB4697.namprd11.prod.outlook.com>
 <20200318022719.GV10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318022719.GV10776@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 18, 2020 at 01:27:19PM +1100, Dave Chinner wrote:
> What is this "atomic block size" going to be, and how is it going to
> be advertised to the block layer and filesystems?

Enterprise SSDs typically support a few k.  That being said without
a scatter/gather Write command that isn't very useful except for
a few DB log case.  That is why the file system implemented
atomic semantics that have been my primary interest are a lot more
interesting.

The NVMe SSDs advertise this size in a really convolulted way, because
the limits can be globl, per-namespace and also have nasty offsets.

Take a look at Section 6.4 of the NVMe 1.4 spec:

https://nvmexpress.org/wp-content/uploads/NVM-Express-1_4-2019.06.10-Ratified.pdf

This is how I wired it up for my POC Linux series:

http://git.infradead.org/users/hch/xfs.git/commitdiff/66079e128d7fa452f45f8a4ffce1597157098dbe
http://git.infradead.org/users/hch/xfs.git/commitdiff/70dc57ff030bf3ce0f37678002ef36b5ab5ed42e
http://git.infradead.org/users/hch/xfs.git/commitdiff/b2f1a09c47b4404ef0d18aad576f4b2ca086a3e0
