Return-Path: <SRS0=3qtu=37=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B15C352A3
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 15:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8A1F2086A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 15:10:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mmxEsZpQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgBKPKZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 10:10:25 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40186 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbgBKPKZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Feb 2020 10:10:25 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01BF2S4c048851;
        Tue, 11 Feb 2020 15:10:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=FWE5czf2Hy/QclAQhrDVvBUt59yW+X3AnC5rOn0o1dw=;
 b=mmxEsZpQFY3qphyIRTLrV5DfdSRMqKzhVHIUFqtRo9le3Wmf2oSrRrWaWP7Z3m5n5XUo
 mDg4KVwZOT95w8HmKn3cHlmaA6zXb0R2LecMZP0xQAyrVjgaYomM32sRptD+aWil95Sx
 XP9qCNv2Y0CLAI8RIgZSsDFNAZxZiR32G1mpHJF9tUpQ3MT8x3wj9aXxqKO3OEKOCEX+
 fESb6+yzjsgs1hYByYz5naWi0zcaN7GrFM3layFHfIPMJvKrQgqFV8/I2KSv6IXk2BT0
 OhNqM/vCZ+FI8/LWE7jN6xIX0DDiTDfozwK1LhOytpFJ7JVmSApW6lvyuKlPjOElGNf2 EQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2y2k883y38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 11 Feb 2020 15:10:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01BF6GDd124124;
        Tue, 11 Feb 2020 15:10:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2y26hv3gmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Feb 2020 15:10:16 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01BFACLf026402;
        Tue, 11 Feb 2020 15:10:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Feb 2020 07:10:12 -0800
Date:   Tue, 11 Feb 2020 07:10:10 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Vincent Fazio <vfazio@xes-inc.com>,
        Brian Foster <bfoster@redhat.com>,
        Aaron Sierra <asierra@xes-inc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fallback to readonly during recovery
Message-ID: <20200211151010.GK6870@magnolia>
References: <20200210211037.1930-1-vfazio@xes-inc.com>
 <99259ceb-2d0d-1054-4335-017f1854ba14@sandeen.net>
 <829353330.403167.1581373892759.JavaMail.zimbra@xes-inc.com>
 <400031d2-dbcb-a0de-338d-9a11f97c795c@sandeen.net>
 <20200211125504.GA2951@bfoster>
 <e8169b53-252b-b133-7bc5-ee5dc206c402@xes-inc.com>
 <4f55ae5e-c5cc-6c13-6ed4-ac6c770cd55f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4f55ae5e-c5cc-6c13-6ed4-ac6c770cd55f@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=965 phishscore=0
 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002110112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 impostorscore=0 clxscore=1011 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002110112
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 11, 2020 at 08:29:59AM -0600, Eric Sandeen wrote:
> On 2/11/20 8:04 AM, Vincent Fazio wrote:
> > All,
> 
> ...
> 
> > As mentioned in the commit message, the SSDs we work with are ATA devices and there is no such mechanism in the ATA spec to report to the block layer that the device is RO. What we run into is this:
> > 
> > xfs_log_mount
> >     xfs_log_recover
> >         xfs_find_tail
> >             xfs_clear_stale_blocks
> >                 xlog_write_log_records
> >                     xlog_bwrite
> > 
> > the xlog_bwrite fails and triggers the call to xfs_force_shutdown.

If your device doesn't accept write requests then mark it read only.

--D

> > In this specific scenario, we know the log is clean as
> > XFS_MOUNT_WAS_CLEAN is set in the log flags, however the stale
> > blocks cannot be removed due to the device being write-protected.
> > the call to xfs_clear_stale_blocks cannot be obviated because, as
> > mentioned before, ATA devices do not have a mechanism to report that
> > they're read-only.
> 
> Ok, at least now we see where the writes are coming from.  A device that
> is /marked/ readonly won't get into xfs_clear_stale_blocks.  I'm not sure
> if we could just skip the xfs_clear_stale_blocks call if XFS_MOUNT_WAS_CLEAN
> is set, or if head == tail and no recovery is needed.  If so, then maybe
> rearranging the call to xfs_clear_stale_blocks could help.  I'll let people
> who know more log details than I do chime in on that though.
> 
> -Eric
