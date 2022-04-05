Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA13AC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Apr 2022 05:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiDEFi7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 01:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiDEFi6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Apr 2022 01:38:58 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 531221CB20
        for <linux-xfs@vger.kernel.org>; Mon,  4 Apr 2022 22:37:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 852AD10E56CD;
        Tue,  5 Apr 2022 15:36:59 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nbbsA-00DweP-D1; Tue, 05 Apr 2022 15:36:58 +1000
Date:   Tue, 5 Apr 2022 15:36:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     sandeen@redhat.com
Cc:     xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH V2] mkfs: increase the minimum log size to 64MB when
 possible
Message-ID: <20220405053658.GW1544202@dread.disaster.area>
References: <a8bc42f2-98db-2f16-2879-9ed62415ba01@redhat.com>
 <ac764fd9-ddd9-3b44-02bc-c91c390881c5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac764fd9-ddd9-3b44-02bc-c91c390881c5@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=624bd57b
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=rOGq21PWSZxxjIaaS48A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 04, 2022 at 06:31:03PM -0500, Eric Sandeen wrote:
> For starters I know the lack of if / else if in the co is a little
> ugly but smashing into 80cols was uglier...
> 
> Here are the changes in log size for various filesystem geometries
> (differing block sizes and filesystem sizes, with and without stripe
> geometry to increase AG count). "--" means mkfs failed.
> 
> Blocksize: 4096
> 	|	orig		|	new
> size	|	log	striped	|	log	striped
> -------------------------------------------------------
> 128m	|	5m	m	|	5m	m
> 256m	|	5m	18m	|	5m	18m
> 511m	|	5m	18m	|	5m	18m
> 512m	|	5m	18m	|	64m	18m
> 513m	|	5m	18m	|	64m	64m
> 1024m	|	10m	18m	|	64m	64m
> 2047m	|	10m	18m	|	64m	64m
> 2048m	|	10m	18m	|	64m	64m
> 2049m	|	10m	18m	|	64m	64m
> 4g	|	10m	20m	|	64m	64m
> 8g	|	10m	20m	|	64m	64m
> 15g	|	10m	20m	|	64m	64m
> 16g	|	10m	20m	|	64m	64m
> 17g	|	10m	20m	|	64m	64m
> 32g	|	16m	20m	|	64m	64m
> 64g	|	32m	32m	|	64m	64m
> 256g	|	128m	128m	|	128m	128m
> 512g	|	256m	256m	|	256m	256m
> 1t	|	512m	512m	|	512m	512m
> 2t	|	1024m	1024m	|	1024m	1024m
> 4t	|	2038m	2038m	|	2038m	2038m
> 8t	|	2038m	2038m	|	2038m	2038m
> 
> Blocksize: 1024
> 	|	orig		|	new
> size	|	log	striped	|	log	striped
> ------------------------------------------------------------------------------
> 128m	|	3m	15m	|	3m	15m
> 256m	|	3m	15m	|	3m	15m
> 511m	|	3m	15m	|	3m	15m
> 512m	|	3m	15m	|	64m	15m
> 513m	|	3m	15m	|	64m	64m
> 1024m	|	10m	15m	|	64m	64m
> 2047m	|	10m	16m	|	64m	64m
> 2048m	|	10m	16m	|	64m	64m
> 2049m	|	10m	16m	|	64m	64m
> 4g	|	10m	16m	|	64m	64m
> 8g	|	10m	16m	|	64m	64m
> 15g	|	10m	16m	|	64m	64m
> 16g	|	10m	16m	|	64m	64m
> 17g	|	10m	16m	|	64m	64m
> 32g	|	16m	16m	|	64m	64m
> 64g	|	32m	32m	|	64m	64m
> 256g	|	128m	128m	|	128m	128m
> 512g	|	256m	256m	|	256m	256m
> 1t	|	512m	512m	|	512m	512m
> 2t	|	1024m	1024m	|	1024m	1024m
> 4t	|	1024m	1024m	|	1024m	1024m
> 8t	|	1024m	1024m	|	1024m	1024m
> 
> Blocksize: 65536
> 	|	orig		|	new
> size	|	log	striped	|	log	striped
> ------------------------------------------------------------------------------
> 128m	|	--	--	|	--	--
> 256m	|	32m	--	|	32m	--
> 511m	|	32m	32m	|	32m	32m
> 512m	|	32m	32m	|	64m	32m
> 513m	|	32m	32m	|	64m	63m
> 1024m	|	32m	32m	|	64m	64m
> 2047m	|	56m	45m	|	64m	64m
> 2048m	|	56m	45m	|	64m	64m
> 2049m	|	56m	45m	|	64m	64m
> 4g	|	56m	69m	|	64m	69m
> 8g	|	56m	69m	|	64m	69m
> 15g	|	56m	69m	|	64m	69m
> 16g	|	56m	69m	|	64m	69m
> 17g	|	56m	69m	|	64m	69m
> 32g	|	56m	69m	|	64m	69m
> 64g	|	56m	69m	|	64m	69m
> 256g	|	128m	128m	|	128m	128m
> 512g	|	256m	256m	|	256m	256m
> 1t	|	512m	512m	|	512m	512m
> 2t	|	1024m	1024m	|	1024m	1024m
> 4t	|	2038m	2038m	|	2038m	2038m
> 8t	|	2038m	2038m	|	2038m	2038m

Those new sizes look good to me.

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
