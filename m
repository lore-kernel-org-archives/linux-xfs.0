Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A177EC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 04:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 576BC20715
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 04:00:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zCcej8tI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgEREAT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 00:00:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33476 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgEREAT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 00:00:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04I3wPZg020575;
        Mon, 18 May 2020 04:00:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=flD2Ezailf+lavAMPV1B9H05O4WyEqCVSNNbuKQI6mw=;
 b=zCcej8tINQUAlnuVveSzUAWjlKENFcXqkzK7MhcfmJgIw2wmwadNuFcWEx4MlyrYks5J
 BtqQ8DhruKzAEWIvxhtHGvlVJCKL82Qpw7jrtKvKk+3MZmDBvDqI7qS9F14YM4YGz9cz
 eBka3yeq6cfMoPXeeEVGPSN9OLOMR/HQ2HCvGYHZc/R0UO3V30rJxQvMbxqIt/NA1hIQ
 nsccw3dAnu6Ti6eI9z2A6z7KLsUDUtLxWXQz7olT34/ynWvNo2GnKl6iJr5x6r+wsutR
 7WT/SPHfnlYdgKfaQAuZ7GkgKKJFtHC7X/+K3xQVuGPkFU2NXKE6JgDtgS4ASZiyIBlY kQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31284kmcyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 18 May 2020 04:00:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04I3x1CC027180;
        Mon, 18 May 2020 04:00:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 312sxph8kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 May 2020 04:00:14 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04I40D5a001212;
        Mon, 18 May 2020 04:00:13 GMT
Received: from localhost (/10.159.131.116)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 17 May 2020 21:00:13 -0700
Date:   Sun, 17 May 2020 21:00:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [XFS SUMMIT] Version 3 log format
Message-ID: <20200518040010.GA17627@magnolia>
References: <20200518025828.GO2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518025828.GO2040@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9624 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005180035
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9624 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005180035
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 12:58:28PM +1000, Dave Chinner wrote:
> 
> Topic:	Version 3 log format
> 
> Scope:	Performance
> 	Removing sector size limits
> 	Large stripe unit log write alignment
> 
> Proposal:
> 
> The current v2 log format is an extension of the v1 format which was
> limited to 32kB in size. The size limitation was due to the way that
> the log format requires every basic block to be stamped with the LSN
> associated with the iclog that is being written.
> 
> This requirement stems from the fact that log recovery needed this
> LSN stamp to determine where the head and tail of the log lies, and
> whether the iclog was written completely. The implementation
> requires storing the data written to the first 32 bits of each
> sector of iclog data into a special array in the log header, and
> replacing the data with the cycle number of the current iclog write.
> When the log is replayed, before the iclog is read the data is
> extracted from the iclog headers anre written back over the cycle
> numbers so the transaction information is returned to it's original
> state before decoding occurs.
> 
> For V2 logs, a set of extension headers were created, allowing
> another 7 basic blocks full of encoded data, which allows us to remap an
> extra 7 32kB segments of iclog data into the iclog header. This is
> where the 256kB iclog size limit comes from - it's 8 * 32kB
> segments.
> 
> As the iclogs get larger, this whole encoding scheme because more
> CPU expensive, and it largely limits what we can do with expanding
> iclogs. It also doesn't take into account how things have changed
> since v2 logs were first designed.
> 
> That is, we didn't have delayed logging. That meant iclogbuf IO was
> the limiting factor to commit rates, not CPU overhead. We now do
> commits that total up to 32MB of data, and we do that by cycling
> through it iclogbuf at a time. As a result, CIL pushes are largely
> IO bound waiting for iclogbufs to complete IO. Larger iclogbufs here
> would make a substantial difference to performance when the CIL
> is full, resulting in less blocking and fewer cache flushes when
> writing iclogbufs.
> 
> The question is this: do we still need this cycle stamping in every
> single sector? If we don't need it, then a new format is much
> simpler than if we need basic block stamping.
> 
> From the perspective of determining if a iclog write was complete,
> we don't trust the cycle number entirely in log recovery anymore.
> Once we have the log head and the log tail, we do a CRC validation
> walk of the log to validate it. Hence we don't really need cycle
> data in the log data to validate writes were complete - the CRC will
> fail if a iclogbuf write is torn.
> 
> So that comes back to finding the head and tail of the log. This is
> done by doing a binary search of the log based reading basic blocks
> and checking the cycle number in the basic block that was read. We
> really don't need to do this search via single sector IO; what we
> really want to find is the iclog header at the head and the tail of
> the log.
> 
> To do this, we could do a binary search based on the maximum
> supported iclogbuf size and scan the buffers that are read for
> iclog header magic numbers. There may be more than one in a buffer,
> (e.g. head and tail in the same region) but that is an in-memory
> search rather than individual single sector IO. Once we've found an
> iclog header, We can read the LSN out of the header, and that tells
> us the cycle number of that commit. Hence we can do the binary
> search to find the head and tail of the log without needing have the
> cycle number stamped into every sector.
> 
> IOWs, I don't see a reason we need to maintain the per-basic-block
> cycle stamp in the log format. Hence by removing it from the format
> we get rid of the need for the encoding tables, and we remove the
> limitation on log write size that we currently have.  Essentially we
> move entirely to a "validation by CRC" model for detecting
> torn/incomplete log writes, and that greatly reduces the complexity
> of log writing code.
> 
> It also allows us to use arbitrarily large log writes instead of
> fixed sizes, opening up further avenues for optimisation of both
> journal IO patterns and how we format items into the bios for
> dispatch. We already have log vector buffers that we hand off to the
> CIL checkpoint for async processing; it is not a huge stretch to
> consider mapping them directly into bios and using bio chaining to
> submit them rather than copying them into iclogbufs for submission
> (i.e. single copy logging rather than the double copy we do now).
> And for DAX hardware, we can directly map the journal....
> 
> But before we get to that, we really need a new log format that
> allows us to get away from the limitations of the existing "fixed
> size with encoding" log format.
> 
> Discussion:
> 	- does it work?
> 	- implications of a major incompat log format change
> 	- implications of larger "inflight" window in the journal
> 	  to match the "inflight" window the CIL has.

Giant flood of log items overwhelming the floppy disk(s) underlying the
fs? :P

> 	- other problems?
> 	- other potential optimisations a format change allows?

Will have to ponder this in the morning.

> 	- what else might we add to a log format change to solve
> 	  other recovery issues?

Make sure log recovery can be done on any platform?

--D

> 
> -- 
> Dave Chinner
> david@fromorbit.com
