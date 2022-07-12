Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF582C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jul 2022 04:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiGLE5Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 00:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiGLE5Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 00:57:24 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050387D7B4;
        Mon, 11 Jul 2022 21:57:22 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 38CBF68AA6; Tue, 12 Jul 2022 06:57:19 +0200 (CEST)
Date:   Tue, 12 Jul 2022 06:57:19 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Andreas =?iso-8859-1?Q?Gr=FCnbacher?= 
        <andreas.gruenbacher@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        cluster-devel <cluster-devel@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 2/4] gfs2: remove ->writepage
Message-ID: <20220712045719.GA4705@lst.de>
References: <20220711041459.1062583-1-hch@lst.de> <20220711041459.1062583-3-hch@lst.de> <CAHpGcMLFwN4toB2KD0EvPAgx3zchpGNfzUWfsJ-8dxmnOieCsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHpGcMLFwN4toB2KD0EvPAgx3zchpGNfzUWfsJ-8dxmnOieCsQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 12, 2022 at 01:22:48AM +0200, Andreas Grünbacher wrote:
> It should be possible to remove the .writepage operation in
> gfs2_jdata_aops as well, but I must be overlooking something because
> that actually breaks things.

We'll need to wire up ->migratepage for it first to not lose any memory
migration functinality.  But yes, the plan is to eventually kill off
->writepage.  If I can get you to look into gfs2_jdata_aops,
gfs2_meta_aops and gfs2_rgrp_aops, that would be awesome.
