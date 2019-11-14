Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72375C43215
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 00:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FEDB20643
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 00:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfKNAoY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 19:44:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:34916 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbfKNAoY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Nov 2019 19:44:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Nov 2019 16:44:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,302,1569308400"; 
   d="scan'208";a="229942902"
Received: from shao2-debian.sh.intel.com (HELO [10.239.13.6]) ([10.239.13.6])
  by fmsmga004.fm.intel.com with ESMTP; 13 Nov 2019 16:44:20 -0800
Subject: Re: [LTP] [xfs] 73e5fff98b: kmsg.dev/zero:Can't_open_blockdev
To:     Jan Stancek <jstancek@redhat.com>, Ian Kent <raven@themaw.net>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
        lkp@lists.01.org, ltp@lists.linux.it,
        DavidHowells <dhowells@redhat.com>,
        AlViro <viro@ZenIV.linux.org.uk>
References: <20191111010022.GH29418@shao2-debian>
 <3fb8b1b04dd7808b45caf5262ee629c09c71e0b6.camel@themaw.net>
 <1108442397.11662343.1573560143066.JavaMail.zimbra@redhat.com>
 <20191112120818.GA8858@lst.de>
 <5f758be455bb8f761d028ea078b3e2a618dfd4b1.camel@themaw.net>
 <e38bc7a8505571bbb750fc0198ec85c892ac7b3a.camel@themaw.net>
 <975334005.11814790.1573625805426.JavaMail.zimbra@redhat.com>
From:   Rong Chen <rong.a.chen@intel.com>
Message-ID: <d0db75cc-440d-6de8-f6d2-ddf399a3bdb7@intel.com>
Date:   Thu, 14 Nov 2019 08:44:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <975334005.11814790.1573625805426.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/13/19 2:16 PM, Jan Stancek wrote:
>
> ----- Original Message -----
>>>>> # mount -t xfs /dev/zero /mnt/xfs
>>> Assuming that is what is being done ...
>> Arrrh, of course, a difference between get_tree_bdev() and
>> mount_bdev() is that get_tree_bdev() prints this message when
>> blkdev_get_by_path() fails whereas mount_bdev() doesn't.
>>
>> Both however do return an error in this case so the behaviour
>> is the same.
>>
>> So I'm calling this not a problem with the subject patch.
>>
>> What needs to be done to resolve this in ltp I don't know?
> I think that's question for kernel test robot, which has this extra
> check built on top. ltp itself doesn't treat this extra message as FAIL.
>
> Jan
>

Hi all,

Thanks for your help, kernel test robot bisected automatically for new 
error:

    kern  :err   : [  135.993912] /dev/zero: Can't open blockdev

Please ignore the report if it's not a problem.

Best Regards,
Rong Chen
