Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 318BCC43141
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 13:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01C7720715
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 13:14:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H8kXXk4c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfKNNOo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 08:14:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49226 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbfKNNOo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 08:14:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=He7TZydBqJdm6j9sMwQxIx5OY+kOVIAf9OOyvnsEo8I=; b=H8kXXk4c0DwI4SMpC88yvWlam
        G0t6uhkTWxOyi9P4Pv/0bY/6oagZlpCILgiPEI6osgCmOuD2BWKkijjFF6YrGWUZjFr23c1hDWg3N
        D6fTelb8eVI9h5qIKkP26X4UAmcJfKMi2N6RuOJF7QzaBqwN3DoVjWxM4jkqeD7XHAnW8zc7NWANi
        nFnBKj0RnSAwMyObNRjVbHvLO7jKgfDVp0J9LtN19xmYVIcr96WDk6LQxUHL8ey4yLHDe0Q4Y8jkd
        l/bwbFVmItcuydLKrrYdWcco07I2BBOR17Tlv9upt1Y4cUgcPsLrOHAfpKHIFRjXCFcwSmVPy00xl
        OO4J1sI8g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iVExH-0006vR-Vb; Thu, 14 Nov 2019 13:14:36 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DF8F5301120;
        Thu, 14 Nov 2019 14:13:26 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 93E2829E032D8; Thu, 14 Nov 2019 14:14:34 +0100 (CET)
Date:   Thu, 14 Nov 2019 14:14:34 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: Re: single aio thread is migrated crazily by scheduler
Message-ID: <20191114131434.GQ4114@hirez.programming.kicks-ass.net>
References: <20191114113153.GB4213@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114113153.GB4213@ming.t460p>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 14, 2019 at 07:31:53PM +0800, Ming Lei wrote:
> Hi Guys,
> 
> It is found that single AIO thread is migrated crazely by scheduler, and
> the migrate period can be < 10ms. Follows the test a):

What does crazy mean? Does it cycle through the L3 mask?
