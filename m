Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 567BFC83004
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 14:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32CEC206F0
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 14:21:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="odplWUBd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgD2OVH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 10:21:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55784 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbgD2OVH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 10:21:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03TEJYBS158719;
        Wed, 29 Apr 2020 14:21:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=/noxWw9LXCLqWA3bpNo9elMlN/5VdORyAss20xj+26w=;
 b=odplWUBdiEayfjEAncnijV3uBgNsDVK9YVYD8q2aiJTDhl7KDiMSEn0qfqNLrxc1KgCd
 5H3MSxzUq5LzCtO5offOk/viJYOsoF/km8GVrQuMQs1MKaYqPZmopJjW5UY1/IuHoj8W
 AfCjvuVo6SVX4dF9dh9uiLjwlF6KaIQa1DXk49UV3sOuAvJ8F6Vqmn/nHRl/QgYGW2DQ
 K8ZVGMNCKebdbraslU4Sk3C1Y10pP6+93VMEJ08fqRO3vyfBHShDEy554dUR2U/GvkUD
 BM559FQveKU7BZUduPDVDZwehBbrYbp8pYqf+wIuV2SkzJ6T21aUqC0OQ5DnC6I+wFEM Mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30p01nvjca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 14:21:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03TEI1U7062033;
        Wed, 29 Apr 2020 14:20:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30pvd14p94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 14:20:59 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03TEKvwN010526;
        Wed, 29 Apr 2020 14:20:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 07:20:57 -0700
Date:   Wed, 29 Apr 2020 07:20:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/19] xfs: refactor EFI log item recovery dispatch
Message-ID: <20200429142056.GS6742@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752123303.2140829.7801078756588477964.stgit@magnolia>
 <20200425182801.GE16698@infradead.org>
 <20200428224132.GP6742@magnolia>
 <20200428234557.GR6742@magnolia>
 <20200429070916.GA2625@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429070916.GA2625@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=2 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=2 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004290119
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 12:09:16AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 28, 2020 at 04:45:57PM -0700, Darrick J. Wong wrote:
> > On Tue, Apr 28, 2020 at 03:41:32PM -0700, Darrick J. Wong wrote:
> > > On Sat, Apr 25, 2020 at 11:28:01AM -0700, Christoph Hellwig wrote:
> > > > On Tue, Apr 21, 2020 at 07:07:13PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > 
> > > > > Move the extent free intent and intent-done log recovery code into the
> > > > > per-item source code files and use dispatch functions to call them.  We
> > > > > do these one at a time because there's a lot of code to move.  No
> > > > > functional changes.
> > > > 
> > > > What is the reason for splitting xlog_recover_item_type vs
> > > > xlog_recover_intent_type?  To me it would seem more logical to have
> > > > one operation vector, with some ops only set for intents.
> > > 
> > > Partly because I started by refactoring only the intent items, and then
> > > decided to prepend a series to do everything; and partly to be stingy
> > > with bytes. :P
> > > 
> > > That said, I like your suggestion of every XFS_LI_* code gets its own
> > > xlog_recover_item_type so I'll go do that.
> > 
> > Aha, now I remember why those two are separate types -- the
> > process_intent and cancel_intent functions operate on the xfs_log_item
> > that gets created from the xlog_recover_item that we pulled out of the
> > log, whereas the other functions are called directly on the
> > xlog_recovery_item.  There's no direct link between the log item and the
> > recovery log item, nor is there a good way to link through their
> > dispatch functions.
> 
> Maybe those should move to xfs_item_ops as they operate on a "live"
> xfs_log_item? (they'd need to grow names clearly related to recovery
> of course).  In fact except for slightly different calling convention
> ->cancel_intent already seems to be identical to ->abort_intent in
> xfs_item_ops, so that would be one off the list.

Hmm, yes, that's a better way out.  Trees, meet forest. ;)

> Btw, it seems like we should drop the ail_lock before calling
> ->process_intent as all instances do that anyway, and it would keep
> the locking a little more centralized, and it will allow killing
> one pointless wrapper in each instance.  Maybe we can also move
> the recovered flag to the generic log item flags?

Yeah, I was working on adding that to the patchset too.

--D
