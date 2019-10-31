Return-Path: <SRS0=K+Ru=YY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82EAC47E49
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Oct 2019 04:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8763620862
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Oct 2019 04:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfJaEzA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Oct 2019 00:55:00 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:27908 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725816AbfJaEzA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Oct 2019 00:55:00 -0400
X-IronPort-AV: E=Sophos;i="5.68,250,1569254400"; 
   d="scan'208";a="77722261"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 31 Oct 2019 12:54:57 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 7B345486A852;
        Thu, 31 Oct 2019 12:46:58 +0800 (CST)
Received: from [10.167.225.140] (10.167.225.140) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Thu, 31 Oct 2019 12:55:08 +0800
Subject: Re: [RFC PATCH v2 0/7] xfs: reflink & dedupe for fsdax (read/write
 path).
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
CC:     <linux-xfs@vger.kernel.org>, <linux-nvdimm@lists.01.org>,
        <darrick.wong@oracle.com>, <hch@infradead.org>,
        <david@fromorbit.com>, <linux-kernel@vger.kernel.org>,
        <gujx@cn.fujitsu.com>, <qi.fuli@fujitsu.com>,
        <caoj.fnst@cn.fujitsu.com>
References: <20191030041358.14450-1-ruansy.fnst@cn.fujitsu.com>
 <20191030114818.emvmgfgqadiqintw@fiona>
From:   Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Message-ID: <2737c6f6-5cca-2b92-edff-fb9227ccc6d1@cn.fujitsu.com>
Date:   Thu, 31 Oct 2019 12:54:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20191030114818.emvmgfgqadiqintw@fiona>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.225.140]
X-yoursite-MailScanner-ID: 7B345486A852.A9538
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/30/19 7:48 PM, Goldwyn Rodrigues wrote:
> On 12:13 30/10, Shiyang Ruan wrote:
>> This patchset aims to take care of this issue to make reflink and dedupe
>> work correctly (actually in read/write path, there still has some problems,
>> such as the page->mapping and page->index issue, in mmap path) in XFS under
>> fsdax mode.
> 
> Have you managed to solve the problem of multi-mapped pages? I don't
> think we can include this until we solve that problem. This is the
> problem I faced when I was doing the btrfs dax support.

That problem still exists, didn't be solved in this patchset.  But I am 
also looking into it.  As you know, it's a bit difficult.

Since the iomap for cow is merged in for-next tree, I think it's time to 
update this in order to get some comments.

> 
> Suppose there is an extent shared with multiple files. You map data for
> both files. Which inode should page->mapping->host (precisely
> page->mapping) point to? As Dave pointed out, this needs to be fixed at
> the mm level, and will not only benefit dax with CoW but other
> areas such as overlayfs and possibly containers.

Yes, I will try to figure out a solution.
> 

-- 
Thanks,
Shiyang Ruan.


