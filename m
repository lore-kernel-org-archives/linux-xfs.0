Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5DBCC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 17:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53F01214D8
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 17:46:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FLQ+Vyrr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgIQRpu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 13:45:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:32818 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbgIQRpn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 13:45:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HHecab076012;
        Thu, 17 Sep 2020 17:45:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=YUHeO5giUwKREHkYFkFvVeQxmE3zhNJyPmXrCPMPDB8=;
 b=FLQ+VyrrjMwf/nrzyFsTyn1titb81xI2pJ/P46Uw4tt6ONT2s2oTHmerLeQ5ESNv4Yn+
 HHjezYux7dfolIERvwonx6WRJ9QqdPn1Ww7q/QZ5yYw6rYhcimxJSeJm/1raWuRz4jC+
 mxAM4Wi+skEb4eOa9EbRQLPSpExjgOlxnaBszfbIf5HKCY6DQX5yhaoAPedhC0i4WpqO
 vI2L9jfCZFDrJey6FD8TWq55FAhoSRzbsfJ0FPdmjtpf8zh88DrP8NOfqOo6zDXh4PB3
 eHiD8WZR279tELay5LRIc6aRwVXmcW6mVGDyIi8ZbHT4M2ENWYFLYZYN+6JF47rJRxYP HA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33j91dvfdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 17:45:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HHeLQH145884;
        Thu, 17 Sep 2020 17:45:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33khpndhey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 17:45:27 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08HHjPDu026314;
        Thu, 17 Sep 2020 17:45:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 17:45:25 +0000
Date:   Thu, 17 Sep 2020 10:45:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/2] xfs: log new intent items created as part of
 finishing recovered intent items
Message-ID: <20200917174524.GJ7955@magnolia>
References: <160031332353.3624373.16349101558356065522.stgit@magnolia>
 <160031332982.3624373.6230830770363563010.stgit@magnolia>
 <20200917090742.GC13366@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917090742.GC13366@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170131
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 10:07:42AM +0100, Christoph Hellwig wrote:
> On Wed, Sep 16, 2020 at 08:28:49PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > During a code inspection, I found a serious bug in the log intent item
> > recovery code when an intent item cannot complete all the work and
> > decides to requeue itself to get that done.  When this happens, the
> > item recovery creates a new incore deferred op representing the
> > remaining work and attaches it to the transaction that it allocated.  At
> > the end of _item_recover, it moves the entire chain of deferred ops to
> > the dummy parent_tp that xlog_recover_process_intents passed to it, but
> > fail to log a new intent item for the remaining work before committing
> > the transaction for the single unit of work.
> > 
> > xlog_finish_defer_ops logs those new intent items once recovery has
> > finished dealing with the intent items that it recovered, but this isn't
> > sufficient.  If the log is forced to disk after a recovered log item
> > decides to requeue itself and the system goes down before we call
> > xlog_finish_defer_ops, the second log recovery will never see the new
> > intent item and therefore has no idea that there was more work to do.
> > It will finish recovery leaving the filesystem in a corrupted state.
> > 
> > The same logic applies to /any/ deferred ops added during intent item
> > recovery, not just the one handling the remaining work.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> I wonder how we could come up with a reliable reproducer for this,
> though..

Yeah, I've never actually seen this trip in practice.  I suppose we
could add an error injection point to force the log and bail out midway
through recovery, but that won't help much on unfixed kernels.

--D
