Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81112C83000
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 23:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F2CB206A1
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 23:48:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KOm9/sx5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgD1XsH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 19:48:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38282 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbgD1XsG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 19:48:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SNTaY8130573;
        Tue, 28 Apr 2020 23:48:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=VwE1PQ9xN35hee3mMO2esy00ifFPLWA5vjlAJSEIM20=;
 b=KOm9/sx5+I9vuAx9EPT08FeU05kcSJWe/eq8qAQEh/y1MyJ+3nd7bXxylMXAxyLs944z
 arPvxsTQbe+7YdsZW+oiqyhTCxuyKzhyHvdo3SGwyiIDAY5gZE+G7IqiiG86OjcS+HOR
 5T2sQIcBzg34h4LXfb5m3Q6McOWL/1z9TJmwDmJ7BM2jPo82jUjk4M2vebHQUXl2YbLb
 4NBWo0sel0//VDcp9is2Aep0F9apsSg6yMCjal5dCfxb/EJ4j+chEacsLQ63yIRB15Rf
 iRzjweA8Pb8VO7E/C3T96BujlKWjAnJ1nqSmk4DP249ao9X03b/RZshEIHVRA11ssbol Gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30nucg2x1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 23:48:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SNc9do140486;
        Tue, 28 Apr 2020 23:46:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30mxrtqg46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 23:46:00 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03SNjxkO013717;
        Tue, 28 Apr 2020 23:45:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 16:45:59 -0700
Date:   Tue, 28 Apr 2020 16:45:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/19] xfs: refactor EFI log item recovery dispatch
Message-ID: <20200428234557.GR6742@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752123303.2140829.7801078756588477964.stgit@magnolia>
 <20200425182801.GE16698@infradead.org>
 <20200428224132.GP6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428224132.GP6742@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=2
 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=2 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 28, 2020 at 03:41:32PM -0700, Darrick J. Wong wrote:
> On Sat, Apr 25, 2020 at 11:28:01AM -0700, Christoph Hellwig wrote:
> > On Tue, Apr 21, 2020 at 07:07:13PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Move the extent free intent and intent-done log recovery code into the
> > > per-item source code files and use dispatch functions to call them.  We
> > > do these one at a time because there's a lot of code to move.  No
> > > functional changes.
> > 
> > What is the reason for splitting xlog_recover_item_type vs
> > xlog_recover_intent_type?  To me it would seem more logical to have
> > one operation vector, with some ops only set for intents.
> 
> Partly because I started by refactoring only the intent items, and then
> decided to prepend a series to do everything; and partly to be stingy
> with bytes. :P
> 
> That said, I like your suggestion of every XFS_LI_* code gets its own
> xlog_recover_item_type so I'll go do that.

Aha, now I remember why those two are separate types -- the
process_intent and cancel_intent functions operate on the xfs_log_item
that gets created from the xlog_recover_item that we pulled out of the
log, whereas the other functions are called directly on the
xlog_recovery_item.  There's no direct link between the log item and the
recovery log item, nor is there a good way to link through their
dispatch functions.

The recover_intent and recover_done functions can certainly become
commit_pass2 functions of various xlog_recover_item_type structures, but
that doesn't totally eliminate the need for xlog_recover_intent_type.

--D

> --D
