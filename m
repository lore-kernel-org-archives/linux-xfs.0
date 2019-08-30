Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82AD4C3A5A3
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 06:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A1E821670
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 06:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfH3GDx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 02:03:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4000 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726334AbfH3GDw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 02:03:52 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7U61j60055556
        for <linux-xfs@vger.kernel.org>; Fri, 30 Aug 2019 02:03:51 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2umpb5715e-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 30 Aug 2019 02:03:51 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Fri, 30 Aug 2019 07:03:48 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 30 Aug 2019 07:03:45 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7U63ifp52822090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 06:03:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD7375204F;
        Fri, 30 Aug 2019 06:03:44 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.124.35.181])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A9BB152051;
        Fri, 30 Aug 2019 06:03:43 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        hch@infradead.org
Subject: Re: [RFC] xfs: Flush iclog containing XLOG_COMMIT_TRANS before waiting for log space
Date:   Fri, 30 Aug 2019 11:35:28 +0530
Organization: IBM
In-Reply-To: <20190830021329.GB1119@dread.disaster.area>
References: <20190821110448.30161-1-chandanrlinux@gmail.com> <20190830003441.GY1119@dread.disaster.area> <20190830021329.GB1119@dread.disaster.area>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 19083006-4275-0000-0000-0000035EF739
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19083006-4276-0000-0000-000038713052
Message-Id: <2825614.hYjRE6fU7Y@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-30_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=937 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908300064
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday, August 30, 2019 7:43 AM Dave Chinner wrote: 
> On Fri, Aug 30, 2019 at 10:34:41AM +1000, Dave Chinner wrote:
> > On Fri, Aug 30, 2019 at 09:08:17AM +1000, Dave Chinner wrote:
> > > On Thu, Aug 29, 2019 at 10:51:59AM +0530, Chandan Rajendra wrote:
> > > > 	 786576: kworker/4:1H-kb  1825 [004]   217.041079:                       xfs:xfs_log_assign_tail_lsn: dev 7:1 new tail lsn 2/19333, old lsn 2/19330, last sync 3/18501
> > > 
> > > 200ms later the tail has moved, and last_sync_lsn is now 3/18501.
> > > i.e. the iclog writes have made it to disk, and the items have been
> > > moved into the AIL. I don't know where that came from, but I'm
> > > assuming it's an IO completion based on it being run from a
> > > kworker context that doesn't have an "xfs-" name prefix(*).
> > > 
> > > As the tail has moved, this should have woken the anything sleeping
> > > on the log tail in xlog_grant_head_wait() via a call to
> > > xfs_log_space_wake(). The first waiter should wake, see that there
> > > still isn't room in the log (only 3 sectors were freed in the log,
> > > we need at least 60). That woken process should then run
> > > xlog_grant_push_ail() again and go back to sleep.
> > 
> > Actually, it doesn't get woken because xlog_grant_head_wake() checks
> > how much space is available before waking waiters, and there clearly
> > isn't enough here. So that's one likely vector. Can you try this
> > patch?
> 
> And this one on top to address the situation the previous patch
> doesn't....
> 

Dave, with the 3 patches added (i.e. synchronous transactions during log
recovery and the two patches posted now), the deadlock is not recreated.

Tested-by: Chandan Rajendra <chandanrlinux@gmail.com>

-- 
chandan



