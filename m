Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC617C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 04:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99211208A9
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 04:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgIQEFz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 00:05:55 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:23399 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725886AbgIQEFy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 00:05:54 -0400
X-IronPort-AV: E=Sophos;i="5.76,434,1592841600"; 
   d="scan'208";a="99337470"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 17 Sep 2020 12:05:26 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id E4F5F48990C1;
        Thu, 17 Sep 2020 12:05:25 +0800 (CST)
Received: from [10.167.220.69] (10.167.220.69) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 17 Sep 2020 12:05:23 +0800
Message-ID: <5F62E083.2040806@cn.fujitsu.com>
Date:   Thu, 17 Sep 2020 12:05:23 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.2; zh-CN; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To:     Christoph Hellwig <hch@infradead.org>
CC:     <fstests@vger.kernel.org>, <darrick.wong@oracle.com>,
        <david@fromorbit.com>, <ira.weiny@intel.com>,
        <linux-xfs@vger.kernel.org>, <guan@eryu.me>
Subject: Re: [PATCH v2 1/2] common/rc: Check 'tPnE' flags on a directory instead
 of a regilar file
References: <20200914051400.32057-1-yangx.jy@cn.fujitsu.com> <20200914072611.GB29046@infradead.org>
In-Reply-To: <20200914072611.GB29046@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.220.69]
X-ClientProxiedBy: G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) To
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206)
X-yoursite-MailScanner-ID: E4F5F48990C1.A8CF0
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2020/9/14 15:26, Christoph Hellwig wrote:
> On Mon, Sep 14, 2020 at 01:13:59PM +0800, Xiao Yang wrote:
>> 'tPnE' flags are only valid for a directory so check them on a directory.
>>
>> Signed-off-by: Xiao Yang<yangx.jy@cn.fujitsu.com>
> The change looks good, but I wonder if we should split the chattr
> tests into
>
> _require_chattr_file_flag
>
> and
>
> _require_chattr_dir_flag
>
> to make the whole thing a little less convoluted..
Hi Christoph,

Sorry for the late reply.

It seems hard to factor out _require_chattr_file_flag() and 
_require_chattr_dir_flag()
because we need to get attribute after running chattr command and then check
attribute after parsing all stderr of chattr command.
Could you provide me some detailed guide? Thanks a lot :-)

Best Regards,
Xiao Yang
>
>
> .
>



