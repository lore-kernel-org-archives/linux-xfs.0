Return-Path: <SRS0=dEjd=3X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C76C3524D
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 17:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 710F72051A
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 17:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgBCRoZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 12:44:25 -0500
Received: from verein.lst.de ([213.95.11.211]:57165 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728310AbgBCRoZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Feb 2020 12:44:25 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 393EE68B20; Mon,  3 Feb 2020 18:44:21 +0100 (CET)
Date:   Mon, 3 Feb 2020 18:44:21 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jan Kara <jack@suse.cz>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: RFC: hold i_rwsem until aio completes
Message-ID: <20200203174421.GB20001@lst.de>
References: <20200114161225.309792-1-hch@lst.de> <20200116140004.GE8446@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116140004.GE8446@quack2.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 03:00:04PM +0100, Jan Kara wrote:
> I'd like to note that using i_dio_count has also one advantage you didn't
> mention. For AIO case, if you need to hold i_rwsem in exclusive mode,
> holding the i_rwsem just for submission part is a significant performance
> advantage (shorter lock hold times allow for higher IO parallelism). I
> guess this could be mitigated by downgrading the lock to shared mode
> once the IO is submitted. But there will be still some degradation visible
> for the cases of mixed exclusive and shared acquisitions because shared
> holders will be blocking exclusive ones for longer time.
> 
> This may be especially painful for filesystems that don't implement DIO
> overwrites with i_rwsem in shared mode...

True.  Fortunately there are patches for ext4 out to move over to that
scheme.  gfs2 will need a little more attention, but that also for other
reasons.
