Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EFD7C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 15:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37AAE20714
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 15:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390107AbgJLPqc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 11:46:32 -0400
Received: from sandeen.net ([63.231.237.45]:32948 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389679AbgJLPqc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Oct 2020 11:46:32 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id BE67B11662;
        Mon, 12 Oct 2020 10:45:23 -0500 (CDT)
Subject: Re: [PATCH V2] generic: test reflinked file corruption after short
 COW
To:     Eryu Guan <guan@eryu.me>, Eric Sandeen <sandeen@redhat.com>
Cc:     fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
References: <b63354c6-795d-78e2-4002-83c08a373171@redhat.com>
 <72427003-febc-cc31-743d-41e25b314874@redhat.com>
 <20201011050122.GU3853@desktop>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d676e096-c80f-cb57-99f8-d022281925aa@sandeen.net>
Date:   Mon, 12 Oct 2020 10:46:31 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201011050122.GU3853@desktop>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/11/20 12:01 AM, Eryu Guan wrote:
>> +# Make all files w/ 1m hints; create original 2m file
>> +$XFS_IO_PROG -c "extsize 1048576" $DIR | _filter_xfs_io
>> +$XFS_IO_PROG -c "cowextsize 1048576" $DIR | _filter_xfs_io
> This only works on xfs, and prints extra message on btrfs like
> 
> +foreign file active, extsize command is for XFS filesystems only                                     
> +foreign file active, cowextsize command is for XFS filesystems only
> 
> So I discard outputs of above xfs_io commands.
> 
> Thanks,
> Eryu
> 

Oh, sorry about that.  Thanks for fixing.
