Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F506C433E2
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 02:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49B792072A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 02:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgICC6P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 22:58:15 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:49901 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726528AbgICC6P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 22:58:15 -0400
X-IronPort-AV: E=Sophos;i="5.76,384,1592841600"; 
   d="scan'208";a="98858575"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 03 Sep 2020 10:58:13 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id 9FBA848990E1;
        Thu,  3 Sep 2020 10:58:09 +0800 (CST)
Received: from [10.167.220.69] (10.167.220.69) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 3 Sep 2020 10:58:08 +0800
Message-ID: <5F505BBF.5070907@cn.fujitsu.com>
Date:   Thu, 3 Sep 2020 10:58:07 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.2; zh-CN; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Ira Weiny <ira.weiny@intel.com>
CC:     <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: Add check for unsupported xflags
References: <20200831172250.GT6107@magnolia> <5F4DE4C1.6010403@cn.fujitsu.com> <20200901163551.GW6107@magnolia> <5F4F0647.5060305@cn.fujitsu.com> <20200902030946.GL6096@magnolia> <5F4F12E2.3080200@cn.fujitsu.com> <20200902041039.GM6096@magnolia> <5F4F2964.8050809@cn.fujitsu.com> <20200902170326.GP6096@magnolia> <20200902173828.GR878166@iweiny-DESK2.sc.intel.com> <20200902174527.GV6096@magnolia>
In-Reply-To: <20200902174527.GV6096@magnolia>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.220.69]
X-ClientProxiedBy: G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) To
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206)
X-yoursite-MailScanner-ID: 9FBA848990E1.AB79A
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2020/9/3 1:45, Darrick J. Wong wrote:
> On Wed, Sep 02, 2020 at 10:38:28AM -0700, Ira Weiny wrote:
>> On Wed, Sep 02, 2020 at 10:03:26AM -0700, Darrick J. Wong wrote:
>>> On Wed, Sep 02, 2020 at 01:11:00PM +0800, Xiao Yang wrote:
>>>> Hi Darrick,
>>>>
>>>> It is reasonable for your concern to add a check in VFS, but checking all
>>>> defined xflags is too rough in VFS if one filesystem only supports few
>>>> xflags. :-)
>>> I was advocating for two levels of flags checks: one in the VFS for
>>> undefined flags, and a second check in each filesystem for whichever
>>> flag it wants to recognize.  I was not implying that the VFS checks
>>> would be sufficient on their own.
>>>
>> I've not really followed this thread completely but wouldn't this proposed
>> check in the VFS layer be redundant because the set of flags the filesystem
>> accepts should always be a strict subset of the VFS flags?
Hi,

I also think this check in the VFS is redundant. :-)

> Yes.  It's 100% CYA.  I wouldn't be that bent out of shape if the vfs
> part never happens, but as we already have a vfs argument checker
> function in addition to the per-fs validation I don't see why we would
> leave a gap... ;)

After looking at vfs_ioc_fssetxattr_check(), why do we need to move the 
check of extent
size hint to vfs?  It seems a xfs-specific flag, right?
btw:
It is fine to move DAX and project id to vfs because they are supported 
by more than one
filesystem(e.g. ext4 and xfs).

Best Regards,
Xiao Yang
> --D
>
>> Ira
>
> .
>



