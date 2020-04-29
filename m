Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E79C83000
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE38D214AF
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:00:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SoXy6j7s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgD3AAu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 20:00:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48674 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbgD3AAu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 20:00:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03TNxQiF124761;
        Thu, 30 Apr 2020 00:00:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=08/vUSSJ+rQ0muWhYwsOxJk9xgk5EWluD1tb9YdoeXI=;
 b=SoXy6j7s0b7xITFFpL8vh3vrugj71b03/6hc6LsPbk0kf0WuMbPcAlRpICR18ALoDLxR
 h77SDspQZuxd3ZqmnN9Z0k7yBLO5JpifnXBpDMEHr8O6n2Vt5BrdeGaSQV7Z5d/gojnk
 ZnqvBqEf0iJWMuOvOaoe0VNvYM4QPs5mQ0WUWn3oTLWdfvwsTg8U0J23qRIUYaULm2J6
 Qm60seO5u07OFhtyRP8kpqypWiZF3VKnbXY878u/G+DkjlReiPO2EdjkUz1rGTouO169
 Vb7MKE6QGoPuxNIiU2H+901NfzonitBubphdRNp/oGfEwvH5clPxsoaHJu+5zMPV6Xyh bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30nucg8m6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 00:00:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03TNukEr141585;
        Wed, 29 Apr 2020 23:58:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30mxpm6yjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 23:58:29 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03TNwS2j003897;
        Wed, 29 Apr 2020 23:58:28 GMT
Received: from localhost (/10.159.128.65)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 16:58:28 -0700
Date:   Wed, 29 Apr 2020 16:58:19 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: teach deferred op freezer to freeze and thaw
 inodes
Message-ID: <20200429235818.GX6742@magnolia>
References: <158752128766.2142108.8793264653760565688.stgit@magnolia>
 <158752130655.2142108.9338576917893374360.stgit@magnolia>
 <20200425190137.GA16009@infradead.org>
 <20200427113752.GE4577@bfoster>
 <20200428221747.GH6742@magnolia>
 <20200429113803.GA33986@bfoster>
 <20200429114819.GA24120@infradead.org>
 <20200429142807.GU6742@magnolia>
 <20200429145557.GA26461@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429145557.GA26461@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290177
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 07:55:57AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 29, 2020 at 07:28:07AM -0700, Darrick J. Wong wrote:
> > Hmm.  Actually now that I think harder about it, the bmap item is
> > completely incore and fields are selectively copied to the log item.
> > This means that regular IO could set bi_owner = <some inode number> and
> > bi_ip = <the incore inode>.  Recovery IO can set bi_owner but leave
> > bi_ip NULL, and then the bmap item replay can iget as needed.  Now we
> > don't need this freeze/thaw thing at all.
> 
> Yes, that sounds pretty reasonable.

OTOH I was talking to Dave and we decided to try the simpler solution of
retaining the inode reference unless someone can show that the more
complex machinery is required.

--D
