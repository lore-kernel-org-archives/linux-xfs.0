Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56930C4321E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Nov 2022 09:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbiK3JYl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Nov 2022 04:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiK3JYj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2022 04:24:39 -0500
Received: from mail1.bemta32.messagelabs.com (mail1.bemta32.messagelabs.com [195.245.230.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDD719009
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 01:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1669800276; i=@fujitsu.com;
        bh=SYiq0PhvYdw2tB1i52z9cMx95OLPTC7aZkNJQ0RA+Ow=;
        h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=PNGUCFBZu0ZMYsqNStpLz2fxb7A4IkbyM8it/iz3345th6XDu3abSGRReh9x6I+es
         1emENe2D4IcQta5lcsx2lOB2k8hMLVP/7KTXxUs2SsFsrv0C7YqR0C1F0pAMFHbZ1C
         dLGUSHKRqpGzh8PXT8CqtUVxi4VmkLmup030v3/CImf7ItNDcbkSkatKtVnCphf5D8
         GzRT3FDuOp1b+693mno35ZcFmdUIUurMWb1pCh5AMA/YIXpJ7RVMHKfBE7Ll74D2nO
         oKqVTIEs4htoE8cqy2S/kVZjxSO7PCM6JhL0C2INFOYejp1S+IEE5EDwvs+R1Ydg+6
         Rc4O1ybtFILww==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRWlGSWpSXmKPExsViZ8OxWTdYsT3
  Z4PV5EYstx+4xWlx+wmex688Odgdmj1OLJDw2repk8/i8SS6AOYo1My8pvyKBNePe/XvsBU3M
  Fbs/P2ZvYDzK1MXIxSEksJFRomXXdWYIZwmTxK8ljewQzjZGicl9uxi7GDk5eAXsJNqengezW
  QRUJf50v2WHiAtKnJz5hAXEFhVIkri64S4riC0s4CKx6fF1JhBbREBT4si3a0A2BwezgJnE7T
  91EPMbGSX+brwENpNNwFFi3qyNbCA2p4CbxNoF98BmMgtYSCx+c5AdwpaX2P52DjOILSGgKNG
  25B87hF0hMWtWGxOErSZx9dwm5gmMQrOQnDcLyahZSEYtYGRexWhWnFpUllqka2iil1SUmZ5R
  kpuYmaOXWKWbqJdaqlueWlyia6iXWF6sl1pcrFdcmZuck6KXl1qyiREYESnFbKt2MP5a9kfvE
  KMkB5OSKG+FVHuyEF9SfkplRmJxRnxRaU5q8SFGGQ4OJQnev7JAOcGi1PTUirTMHGB0wqQlOH
  iURHh3g7TyFhck5hZnpkOkTjEqSonznpEHSgiAJDJK8+DaYAnhEqOslDAvIwMDgxBPQWpRbmY
  JqvwrRnEORiVh3v8gU3gy80rgpr8CWswEtDhSrA1kcUkiQkqqgclB9cXUe08SXsl8q7KWzVyx
  Y3FLq6pPz5877xZG/WKyOBW4hu9k7K/vEp+9Mk/cMNwpNW+Hl6vH688XtabI91Zsk0+5sOhlS
  nyb5ez2X/sEL2X55b75lPV3TkP2zlwxjt4Nb9eGtuzdpaAhkvL03AP5d1afhS7z2p/QvNa6xo
  l3xjfLw89Z/HiOV2xMyuH3fre4cPoZ/+ft97d6hSy5dMNU8P36vVLM36+47K84Vx15V+c5D0u
  EmO13fQbZW977Diw0m24891PPItncFN97bVGF2773/ynbcqKiZcsinovbDvgvW+nBdTxJ4nm5
  rcTbp9d+XH98akeJUXVyn6bqipStluy11h8Vf25xrt7p0aOpxFKckWioxVxUnAgA7ZqeS4MDA
  AA=
X-Env-Sender: yangx.jy@fujitsu.com
X-Msg-Ref: server-18.tower-591.messagelabs.com!1669800275!341177!1
X-Originating-IP: [62.60.8.179]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.101.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 19941 invoked from network); 30 Nov 2022 09:24:35 -0000
Received: from unknown (HELO n03ukasimr04.n03.fujitsu.local) (62.60.8.179)
  by server-18.tower-591.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 30 Nov 2022 09:24:35 -0000
Received: from n03ukasimr04.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr04.n03.fujitsu.local (Postfix) with ESMTP id EC8A4154;
        Wed, 30 Nov 2022 09:24:34 +0000 (GMT)
Received: from R01UKEXCASM126.r01.fujitsu.local (R01UKEXCASM126 [10.183.43.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr04.n03.fujitsu.local (Postfix) with ESMTPS id DFDD5150;
        Wed, 30 Nov 2022 09:24:34 +0000 (GMT)
Received: from [10.167.215.54] (10.167.215.54) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Wed, 30 Nov 2022 09:24:32 +0000
Message-ID: <ef7acfc3-ec95-b4f4-65d6-3ad61e5cc40f@fujitsu.com>
Date:   Wed, 30 Nov 2022 17:24:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/2] xfs: hoist refcount record merge predicates
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     <linux-xfs@vger.kernel.org>, <david@fromorbit.com>
References: <166975928548.3768925.15141817742859398250.stgit@magnolia>
 <166975929118.3768925.9568770405264708473.stgit@magnolia>
From:   =?UTF-8?B?WWFuZywgWGlhby/mnagg5pmT?= <yangx.jy@fujitsu.com>
In-Reply-To: <166975929118.3768925.9568770405264708473.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.215.54]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022/11/30 6:01, Darrick J. Wong wrote:
> From: Darrick J. Wong<djwong@kernel.org>
> 
> Hoist these multiline conditionals into separate static inline helpers
> to improve readability and set the stage for corruption fixes that will
> be introduced in the next patch.
Hi Darrick,

It's a good refactoring. LGTM.
Reviewed-by: Xiao Yang <yangx.jy@fujitsu.com>

Best Regards,
Xiao Yang
