Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F120C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Mar 2022 23:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240020AbiCaXTR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 19:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238692AbiCaXTR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Mar 2022 19:19:17 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1F2924D994
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 16:17:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8AFC4534289;
        Fri,  1 Apr 2022 10:17:25 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1na42d-00CGYl-Qh; Fri, 01 Apr 2022 10:17:23 +1100
Date:   Fri, 1 Apr 2022 10:17:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 215783] New: kernel NULL pointer dereference and general
 protection fault in fs/xfs/xfs_buf_item_recover.c:
 xlog_recover_do_reg_buffer() when mount a corrupted image
Message-ID: <20220331231723.GI1544202@dread.disaster.area>
References: <bug-215783-201763@https.bugzilla.kernel.org/>
 <20220331213539.GH1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331213539.GH1544202@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62463686
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=ruCHeXO0QZa-cquT8uIA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 01, 2022 at 08:35:39AM +1100, Dave Chinner wrote:
> On Thu, Mar 31, 2022 at 08:07:08PM +0000, bugzilla-daemon@kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=215783
> > - Overview 
> > kernel NULL pointer dereference and general protection fault in
> > fs/xfs/xfs_buf_item_recover.c:xlog_recover_do_reg_buffer() when mount a
> > corrupted image, sometimes cause kernel hang
> > 
> > - Reproduce 
> > tested on kernel 5.17.1, 5.15.32
> > 
> > $ mkdir mnt
> > $ unzip tmp7.zip
> > $ ./mount.sh xfs 7  ##NULL pointer derefence
> > or
> > $ sudo mount -t xfs tmp7.img mnt ##general protection fault
> > 
> > - Kernel dump
> 
> You've now raised 4 bugs that all look very similar and are quite
> possibly all caused by the same corruption vector.
> Please do some triage on the failure to identify the
> source of the corruption that trigger this failure.

Ok, the log has been intentionally corrupted in a way that does not
happen in the real world. i.e.  The iclog header at the tail of the
log has had the CRC zeroed, so CRC checking for media bit corruption
has been intentionally bypassed by the tool that corrupted the log.

The first item is a superblock buffer item, which contains 2
regions; a buf log item and a 384 byte long region containing the
logged superblock data.

However, the buf log item has been screwed with to say that it has 8
regions rather than 2, and so when recovery goes to recovery the
third region that doesn't exist, it falls off the end of the
allocated transaction buffer.

We only ever write iclogs with CRCs in them (except for mkfs when it
writes an unmount record to intialise the log), so bit corruptions
like this will get caught before we even started log recovery in
production systems.

We've got enough issues with actual log recovery bugs that we don't
need to be overloaded by being forced to play whack-a-mole with
malicious corruptions that *will not happen in the real world*
because "security!".

Looking at the crash locations for the other bugs, they are all
going to be the same thing - you've corrupted the vector index in
the log item and so they all fall off the end of the buffer because
the index no longer matches the actual contents of the log item.

vvvv THIS vvvv

> If you are going to run some scripted tool to randomly corrupt the
> filesystem to find failures, then you have an ethical and moral
> responsibility to do some of the work to narrow down and identify
> the cause of the failure, not just throw them at someone to do all
> the work.

^^^^ THIS ^^^^^

Please confirm your other reports have the same root cause and close
them if they are. If not, please point us to the unique corruption
in the log that causes the failure.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
