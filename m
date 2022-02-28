Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42E5C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 20:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiB1UkB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 15:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiB1UkA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 15:40:00 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1FBFC9;
        Mon, 28 Feb 2022 12:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646080760; x=1677616760;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FyfdXQ0oJJy5xP7LYIM4Hoj9gpwoF/eamju/2GvJ4YU=;
  b=aiE9s3bSiSwJjl0Vs9/9+37OCrHclvjrXSya7InxGWTy2s9MVCeuJm0Z
   So4RtH/7zNvCNZeHTA6ebGXZHza7isMt9Jd4ED5NsSjd4yQHWfYt1m/Ge
   Nkkxx+p3bltCaoHucKV+Gku+8L+rFPXsXOdBp9br2Bm0MqSfrg/hvCTLP
   otUV9trJd7pHlI56BKe2ia8x10riHbSyGEZ9aZkZPfvrAcIEn+FloP8ap
   i1+4S+38gTkddT6iJXqawypCHLR6cKgCOUJbdShrbHGFrPVFM7xiEHL8a
   m6nFOPsgKKu+ee4dNR3Slw27WSiuKo+ZmiHEkMUQuio+57Ukws2EJUCBW
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="252715548"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="252715548"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 12:39:20 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="510236616"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.76])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 12:39:17 -0800
Date:   Mon, 28 Feb 2022 20:39:11 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Kyle Sanderson <kyle.leet@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dave Chinner <david@fromorbit.com>, qat-linux@intel.com,
        Linux-Kernal <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Intel QAT on A2SDi-8C-HLN4F causes massive data corruption with
 dm-crypt + xfs
Message-ID: <Yh0y75aegqS4jIP7@silpixa00400314>
References: <CACsaVZ+mt3CfdXV0_yJh7d50tRcGcRZ12j3n6-hoX2cz3+njsg@mail.gmail.com>
 <20220219210354.GF59715@dread.disaster.area>
 <CACsaVZ+LZUebtsGuiKhNV_No8fNLTv5kJywFKOigieB1cZcKUw@mail.gmail.com>
 <YhN76/ONC9qgIKQc@silpixa00400314>
 <CACsaVZJFane88cXxG_E1VkcMcJm8YVN+GDqQ2+tRYNpCf+m8zA@mail.gmail.com>
 <CAHk-=whVT2GcwiJM8m-XzgJj8CjytTHi_pmgmOnSpzvGWzZM1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whVT2GcwiJM8m-XzgJj8CjytTHi_pmgmOnSpzvGWzZM1A@mail.gmail.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 28, 2022 at 11:25:49AM -0800, Linus Torvalds wrote:
> On Mon, Feb 28, 2022 at 12:18 AM Kyle Sanderson <kyle.leet@gmail.com> wrote:
> >
> > Makes sense - this kernel driver has been destroying users for many
> > years. I'm disappointed that this critical bricking failure isn't
> > searchable for others.
> 
> It does sound like we should just disable that driver entirely until
> it is fixed.
> 
> Or at least the configuration that can cause problems, if there is
> some particular sub-case.
The dm-crypt + QAT use-case is already disabled since kernel 5.10 due to
a different issue.
Is it an option to port those patches to stable till I provide a fix for
the driver? I drafted already few alternatives for the fix and I am aiming
for a final set by end of week.

Thanks,

-- 
Giovanni
