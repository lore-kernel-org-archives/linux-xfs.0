Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87285C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 18:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6606922582
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 18:07:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f2Oq4Y8E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgGNSHr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 14:07:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47374 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgGNSHr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 14:07:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EHqsrS064854;
        Tue, 14 Jul 2020 18:07:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=M61vqUsmnSE/NsL1/SgcaK8+wCFJS2ZF6Y3TeeqL5Ws=;
 b=f2Oq4Y8Egn+PHB1eT0X6etERfQIQC2AB060qbWqZud1wlMVzw5s9SpbXkDS9qzga+N3k
 73Tq1GXlDhAwiDJR0kYtcgj2yC/mm9Sdq4PrcpcEbZ8jmGl7PznBQQWPMNfiFBHYeY6c
 TReqwapqp1ine7My80JVUZ9aeVjT0s/kBbbpkEsMnDeSUnlxa08CMQJwIPwyviml4/wZ
 EAH/e0jfWHKQIxk81K1XbpgvSdcgoeX5dopY6VsgouX+yJdfTsdF+SQgoqfh98lW3u30
 6PUI4LohnvZ+SY1TnRzPjFj4xZpxKIhIk+ZJGn0ajHG+lCRxAU+BLQZCIUow2i0tztd7 PQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32762neujv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 18:07:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EHqdlW024147;
        Tue, 14 Jul 2020 18:07:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 327qby63pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 18:07:43 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06EI7hql014984;
        Tue, 14 Jul 2020 18:07:43 GMT
Received: from localhost (/10.159.135.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 11:07:42 -0700
Date:   Tue, 14 Jul 2020 11:07:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/26] xfs: move the ondisk dquot flags to their own
 namespace
Message-ID: <20200714180741.GC7606@magnolia>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
 <159469033930.2914673.6332873477280477365.stgit@magnolia>
 <20200714080530.GL19883@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714080530.GL19883@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 mlxlogscore=875 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=896 lowpriorityscore=0
 bulkscore=0 suspectscore=1 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 14, 2020 at 09:05:30AM +0100, Christoph Hellwig wrote:
> > +/*
> > + * flags for q_flags field in the dquot.
> > + */
> > +#define XFS_DQFLAG_DIRTY	0x0008		/* dquot is dirty */
> > +#define XFS_DQFLAG_FREEING	0x0010		/* dquot is being torn down */
> 
> I think it might make sense to start with the first available flag
> here.

Done.

--D
