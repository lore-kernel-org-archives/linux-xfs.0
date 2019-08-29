Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9202C3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 16:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAB562166E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 16:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfH2QMr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 12:12:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:46688 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727118AbfH2QMr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Aug 2019 12:12:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1C4AEADDC;
        Thu, 29 Aug 2019 16:12:46 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id B72B91E3BEA; Thu, 29 Aug 2019 18:12:45 +0200 (CEST)
Date:   Thu, 29 Aug 2019 18:12:45 +0200
From:   Jan Kara <jack@suse.cz>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org
Subject: Re: Deadlock during generic/530 test
Message-ID: <20190829161245.GA14731@quack2.suse.cz>
References: <20190829133156.GA11187@quack2.suse.cz>
 <20190829155445.GE5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829155445.GE5354@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu 29-08-19 08:54:45, Darrick J. Wong wrote:
> On Thu, Aug 29, 2019 at 03:31:56PM +0200, Jan Kara wrote:
> > Hello,
> > 
> > When running fstests, I've hit a deadlock with generic/530 test with
> > 5.3-rc6 based kernel (commit 9e8312f5e160 in particular) in my test VM.
> > Full dmesg is attached. BTW mount is the only task in D state. In
> > particular all xfs kernel processes are happily sitting in interruptible
> > sleep.
> 
> Hm, is this possibly the same as:
> 
> https://lore.kernel.org/linux-xfs/20190821110448.30161-1-chandanrlinux@gmail.com/
> 
> (Something about needing to nudge the log along when dumping unlinked
> inodes during log recovery?)

Yeah. Looks like that. Thanks for the pointer.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
