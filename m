Return-Path: <SRS0=rRn/=BB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C13C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 03:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E130F207DD
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 03:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731960AbgGVDqi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 23:46:38 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:38476 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731857AbgGVDqi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 23:46:38 -0400
X-IronPort-AV: E=Sophos;i="5.75,381,1589212800"; 
   d="scan'208";a="96724259"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 22 Jul 2020 11:46:36 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id D56AF4CE4BD8;
        Wed, 22 Jul 2020 11:46:31 +0800 (CST)
Received: from [10.167.220.69] (10.167.220.69) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Wed, 22 Jul 2020 11:46:30 +0800
Message-ID: <5F17B696.30002@cn.fujitsu.com>
Date:   Wed, 22 Jul 2020 11:46:30 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.2; zh-CN; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To:     Eric Sandeen <sandeen@sandeen.net>
CC:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_io: Document '-q' option for pread/pwrite command
References: <20200714055327.1396-1-yangx.jy@cn.fujitsu.com> <20200714150148.GA7606@magnolia> <ab89861d-0d85-e803-d545-18bd11342ab0@sandeen.net>
In-Reply-To: <ab89861d-0d85-e803-d545-18bd11342ab0@sandeen.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.220.69]
X-ClientProxiedBy: G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) To
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206)
X-yoursite-MailScanner-ID: D56AF4CE4BD8.ADE92
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2020/7/15 2:08, Eric Sandeen wrote:
> On 7/14/20 8:01 AM, Darrick J. Wong wrote:
>> On Tue, Jul 14, 2020 at 01:53:26PM +0800, Xiao Yang wrote:
>>> Signed-off-by: Xiao Yang<yangx.jy@cn.fujitsu.com>
>> I did not know we had a 'q' flag...
>>
>> Reviewed-by: Darrick J. Wong<darrick.wong@oracle.com>
> It was added>= 15 years ago and never documented, so that's
> not surprising.  :P
>
> Reviewed-by: Eric Sandeen<sandeen@redhat.com>
>
> Care to fix up sendfile as well?
Hi Eric,

Sure, I can doc '-q' for sendfile command.
BTW: sorry for missing this comment. :-(

Thanks,
Xiao Yang
> Thanks,
> -Eric
>
>
> .
>



