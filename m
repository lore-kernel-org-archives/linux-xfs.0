Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAACBC38A02
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 22:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiJ1W6K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 18:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJ1W6K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 18:58:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9DC1F525B
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 15:58:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C45A9CE2E54
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 22:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2B3C433C1;
        Fri, 28 Oct 2022 22:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666997885;
        bh=W/DQem/C6JybBusrS8imOal/rC27FzVuMDHgMj0K2lY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H01aytbMY7z4npLlB1zcexWkh5825kVV8UuUPvhoOeaa/O4g36t7GTh2XHCfDOG6b
         kSHWmMtYLeLMj/bb/bkTs7xecnTZuiVM44IxhQ5iKZJhvYLaRac3eQXcTxaSWGe5Qw
         m9SvN3GFtTPLbpaoN/RWOj7z0eCtn1W+T5sQs1M0iQ11bel7e8TqSYTAPIlIQuqK9I
         6X605PpNBJyVFYAxvaDJrKpoyneyZ3IuXLu5NwvNLvgCyBpoJJl9ISCRmeq1TktT7n
         9sAvQy5U2vjqadlUIKN8OUjeskCNuPZiuQtvVJmNwboNotMmNPyt8Oiig9W6CR6mvc
         9PINxBCXiVknw==
Date:   Fri, 28 Oct 2022 15:58:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Neutron Sharc <neutronsharc@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Fwd: does xfs support aio_fsync?
Message-ID: <Y1xefLbvx96dNUqq@magnolia>
References: <CAB-bdyRWCJLDde4izM_H-Bh9wPg-Enas+D4VvTROWEpVy0ZgZg@mail.gmail.com>
 <CAB-bdyTJjM7ju-ku6w1Tib06r70FbZ8r0y8mfBaKu4XQDuMeUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB-bdyTJjM7ju-ku6w1Tib06r70FbZ8r0y8mfBaKu4XQDuMeUw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 28, 2022 at 03:11:15PM -0700, Neutron Sharc wrote:
> Hello all,
> I have a workload that benefits the most if I can issue async fsync
> after many async writes are completed. I was under the impression that
> xfs/ext4 both support async fsync so I can use libaio to submit fsync.
> When I tested with io_submit(fsync),  it always returned EINVAL.  So I
> browsed the linux source (both kernel 3.10,  4.14)  and I found
> xfs/xfs_file.c doesn't implement "aio_fsync", nor does ext4/file.c.
> 
> I found an old post which said aio_fsync was already included in xfs
> (https://www.spinics.net/lists/xfs/msg28408.html)
> 
> What xfs or kernel version should I use to get aio_fsync working?  Thanks all.

$ git blame -L 1606,+2 fs/aio.c
a3c0d439e4d92 (Christoph Hellwig 2018-03-27 19:18:57 +0200 1606) static void aio_fsync_work(struct work_struct *work)
a3c0d439e4d92 (Christoph Hellwig 2018-03-27 19:18:57 +0200 1607) {

...some time around the 4.19 LTS?

--D

> 
> 
> Shawn
