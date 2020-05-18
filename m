Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 858B3C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 02:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D14D20787
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 02:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgERC6f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 May 2020 22:58:35 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:47140 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726720AbgERC6e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 May 2020 22:58:34 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 117987EB310
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 12:58:31 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jaVz2-0001zo-Jb
        for linux-xfs@vger.kernel.org; Mon, 18 May 2020 12:58:28 +1000
Date:   Mon, 18 May 2020 12:58:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [XFS SUMMIT] Version 3 log format
Message-ID: <20200518025828.GO2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=ARj7ySXj6l8VWHdNb-MA:9 a=stGwddlUQRkr0Jn5:21 a=CbGt1OgiBvixnX_t:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Topic:	Version 3 log format

Scope:	Performance
	Removing sector size limits
	Large stripe unit log write alignment

Proposal:

The current v2 log format is an extension of the v1 format which was
limited to 32kB in size. The size limitation was due to the way that
the log format requires every basic block to be stamped with the LSN
associated with the iclog that is being written.

This requirement stems from the fact that log recovery needed this
LSN stamp to determine where the head and tail of the log lies, and
whether the iclog was written completely. The implementation
requires storing the data written to the first 32 bits of each
sector of iclog data into a special array in the log header, and
replacing the data with the cycle number of the current iclog write.
When the log is replayed, before the iclog is read the data is
extracted from the iclog headers anre written back over the cycle
numbers so the transaction information is returned to it's original
state before decoding occurs.

For V2 logs, a set of extension headers were created, allowing
another 7 basic blocks full of encoded data, which allows us to remap an
extra 7 32kB segments of iclog data into the iclog header. This is
where the 256kB iclog size limit comes from - it's 8 * 32kB
segments.

As the iclogs get larger, this whole encoding scheme because more
CPU expensive, and it largely limits what we can do with expanding
iclogs. It also doesn't take into account how things have changed
since v2 logs were first designed.

That is, we didn't have delayed logging. That meant iclogbuf IO was
the limiting factor to commit rates, not CPU overhead. We now do
commits that total up to 32MB of data, and we do that by cycling
through it iclogbuf at a time. As a result, CIL pushes are largely
IO bound waiting for iclogbufs to complete IO. Larger iclogbufs here
would make a substantial difference to performance when the CIL
is full, resulting in less blocking and fewer cache flushes when
writing iclogbufs.

The question is this: do we still need this cycle stamping in every
single sector? If we don't need it, then a new format is much
simpler than if we need basic block stamping.

From the perspective of determining if a iclog write was complete,
we don't trust the cycle number entirely in log recovery anymore.
Once we have the log head and the log tail, we do a CRC validation
walk of the log to validate it. Hence we don't really need cycle
data in the log data to validate writes were complete - the CRC will
fail if a iclogbuf write is torn.

So that comes back to finding the head and tail of the log. This is
done by doing a binary search of the log based reading basic blocks
and checking the cycle number in the basic block that was read. We
really don't need to do this search via single sector IO; what we
really want to find is the iclog header at the head and the tail of
the log.

To do this, we could do a binary search based on the maximum
supported iclogbuf size and scan the buffers that are read for
iclog header magic numbers. There may be more than one in a buffer,
(e.g. head and tail in the same region) but that is an in-memory
search rather than individual single sector IO. Once we've found an
iclog header, We can read the LSN out of the header, and that tells
us the cycle number of that commit. Hence we can do the binary
search to find the head and tail of the log without needing have the
cycle number stamped into every sector.

IOWs, I don't see a reason we need to maintain the per-basic-block
cycle stamp in the log format. Hence by removing it from the format
we get rid of the need for the encoding tables, and we remove the
limitation on log write size that we currently have.  Essentially we
move entirely to a "validation by CRC" model for detecting
torn/incomplete log writes, and that greatly reduces the complexity
of log writing code.

It also allows us to use arbitrarily large log writes instead of
fixed sizes, opening up further avenues for optimisation of both
journal IO patterns and how we format items into the bios for
dispatch. We already have log vector buffers that we hand off to the
CIL checkpoint for async processing; it is not a huge stretch to
consider mapping them directly into bios and using bio chaining to
submit them rather than copying them into iclogbufs for submission
(i.e. single copy logging rather than the double copy we do now).
And for DAX hardware, we can directly map the journal....

But before we get to that, we really need a new log format that
allows us to get away from the limitations of the existing "fixed
size with encoding" log format.

Discussion:
	- does it work?
	- implications of a major incompat log format change
	- implications of larger "inflight" window in the journal
	  to match the "inflight" window the CIL has.
	- other problems?
	- other potential optimisations a format change allows?
	- what else might we add to a log format change to solve
	  other recovery issues?

-- 
Dave Chinner
david@fromorbit.com
