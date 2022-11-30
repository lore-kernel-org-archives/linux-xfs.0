Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78259C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Nov 2022 10:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbiK3KH2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Nov 2022 05:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbiK3KH0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2022 05:07:26 -0500
Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com [195.245.231.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BE031EE2
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 02:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1669802844; i=@fujitsu.com;
        bh=Am5PEkTOGtJBIB8Dv0V3fP6IZIYifEumFdXDwS6ATpw=;
        h=Message-ID:Date:MIME-Version:Subject:To:References:From:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=Nw8dnP38P/zRS8DEq66VshV5VCZZ912Suil/FLyHKNcmK7Sk1B3YXuE87LOzj2sNr
         pY/ioAMeKC437ZC1x11ljQocTiGtsIeWmYnZvYa4lHWisAeiVg7mGW4EK1JJsDhHmS
         1iI4nAbba1ksIHUgdLfhD8aLnrTQAD+bskXD2HnkeG7KLCWh5LHflzSFsspPNSsYqn
         xr/ypLqCsGS/djwPX/Zd89hlwQKpvybsUHTMJN1LBoH1PbY5sF8VVWguG2B1As5uCv
         EA/J7oj8FwmJ16nF49qAL3kx7kC2e3d1Jn39Wwk56D9noizuYuLk/9T3Lt4xo2BMkh
         6vKpssxfzH5SA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRWlGSWpSXmKPExsViZ8ORpBut3Z5
  ssPajscWWY/cYLS4/4bPY9WcHuwOzx6lFEh6bVnWyeXzeJBfAHMWamZeUX5HAmrFre17BZfaK
  k2uamBsYV7N1MXJxCAlsZJToO/2dHcJZwiRxa98bZghnG6PE1mNTmLoYOTl4BewkTk55yg5is
  wioSpxreMAKEReUODnzCQuILSqQJHF1w12wuLCAr8TxgyeBbA4OEYE4iQVXVUDCQgLJEvO6W9
  hAbDYBR4l5szaC2ZwCGhKf785jBrGZBSwkFr85yA5hy0tsfzsHLC4hoCjRtuQfO4RdITFrVhs
  ThK0mcfXcJuYJjIKzkFw0C8moWUhGLWBkXsVoVpxaVJZapGtoqpdUlJmeUZKbmJmjl1ilm6iX
  Wqpbnlpcomukl1herJdaXKxXXJmbnJOil5dasokRGPQpxQqXdjC+WfZH7xCjJAeTkijvUvX2Z
  CG+pPyUyozE4oz4otKc1OJDjDIcHEoSvKs1gXKCRanpqRVpmTnACIRJS3DwKInwLgZp5S0uSM
  wtzkyHSJ1iVJQS59XVAkoIgCQySvPg2mBRf4lRVkqYl5GBgUGIpyC1KDezBFX+FaM4B6OSMC8
  /yHiezLwSuOmvgBYzAS2OFGsDWVySiJCSamCqOy4nfKrx1M2w8gmcOc4bpQ9skvysZOLZEr00
  d3/7Pe7SQkGxTLcnF17PfXRB2vnosTV+IuYt/itFeuTeiktl54c2XjskKFGe1Nu8dpNO6wn1X
  bn6a24YTTG7+39FYYmg4ppVrdub2AV+2Z19EjX95BaJZIPHOp9TLEuPZb86odti2i95c2PLJI
  UnB0pezvptuYGVJ2FHWenU14nripKkNi9XU3Hi9b5iwlib4vFG979Z++GAjNX6GysY7l2R8pq
  8wOFOVwsDe+n3vqA1To6nHprwxl8yiVDUs8tN1X/CXbdY6YXSHPvdYlX9LgtsSt+Uz3/U4x19
  JdiH8e3kzT9dTjvrf2X+GJGhHd26VYmlOCPRUIu5qDgRAHyUCGt1AwAA
X-Env-Sender: yangx.jy@fujitsu.com
X-Msg-Ref: server-9.tower-548.messagelabs.com!1669802843!2994!1
X-Originating-IP: [62.60.8.98]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.101.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 22938 invoked from network); 30 Nov 2022 10:07:23 -0000
Received: from unknown (HELO n03ukasimr03.n03.fujitsu.local) (62.60.8.98)
  by server-9.tower-548.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 30 Nov 2022 10:07:23 -0000
Received: from n03ukasimr03.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTP id 881881B0;
        Wed, 30 Nov 2022 10:07:23 +0000 (GMT)
Received: from R01UKEXCASM126.r01.fujitsu.local (R01UKEXCASM126 [10.183.43.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTPS id 7CCDD1AC;
        Wed, 30 Nov 2022 10:07:23 +0000 (GMT)
Received: from [10.167.215.54] (10.167.215.54) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Wed, 30 Nov 2022 10:07:21 +0000
Message-ID: <480d7699-5971-9125-0669-a4e77b641c5b@fujitsu.com>
Date:   Wed, 30 Nov 2022 18:07:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH] xfs/179: modify test to trigger refcount update bugs
To:     "Darrick J. Wong" <djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
        <david@fromorbit.com>
References: <166975928548.3768925.15141817742859398250.stgit@magnolia>
 <Y4aCb+y2ej1TBE/R@magnolia>
From:   =?UTF-8?B?WWFuZywgWGlhby/mnagg5pmT?= <yangx.jy@fujitsu.com>
In-Reply-To: <Y4aCb+y2ej1TBE/R@magnolia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.215.54]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022/11/30 6:06, Darrick J. Wong wrote:
> From: Darrick J. Wong<djwong@kernel.org>
> 
> Upon enabling fsdax + reflink for XFS, this test began to report
> refcount metadata corruptions after being run.  Specifically, xfs_repair
> noticed single-block refcount records that could be combined but had not
> been.
> 
> The root cause of this is improper MAXREFCOUNT edge case handling in
> xfs_refcount_merge_extents.  When we're trying to find candidates for a
> record merge, we compute the refcount of the merged record, but without
> accounting for the fact that once a record hits rc_refcount ==
> MAXREFCOUNT, it is pinned that way forever.
> 
> Adjust this test to use a sub-filesize write for one of the COW writes,
> because this is how we force the extent merge code to run.
Hi Darrick,

Cool, it is reliable to reproduce the same issue in non-DAX mode.
Reviewed-by: Xiao Yang <yangx.jy@fujitsu.com>
Tested-by: Xiao Yang <yangx.jy@fujitsu.com>

Best Regards,
Xiao Yang
