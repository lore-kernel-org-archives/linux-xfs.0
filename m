Return-Path: <SRS0=iJk4=43=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1A6C10DCE
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 22:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C33921927
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 22:46:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uFk7tgCw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgCJWqK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 18:46:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39410 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgCJWqK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 18:46:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02AMgWqa165342;
        Tue, 10 Mar 2020 22:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=f7fSzNpJx3JFd+0bSa9wbUZKoCulYGSN57Mz/UMeuVY=;
 b=uFk7tgCwloUQRfAsVGsndhUS1ajo9KRfDOMywDvQUg2eHsMzg0iQsSxb91vqyjvBWdX2
 dMKNt1KdZve9wuO4AHIN3GlWv521iEI+7YDOyHMqlVSP1aqlKLKll2X9pSvpY450Km59
 tzQ628vaFD0RZxr7Q3E8/KLKN5WcNt7/WBV78CVM1UzYmA7xZ5jnaWj+a9ZbCq3BZxUz
 SWPDDeGuY24LGQVSMPaR1SlZLh5lUNmVSNCcHvbp/+jFrPp6uO4v667NDode8rQE4Fmq
 8vmGy54u3y7ZiiP/ltBHnY5r9kqY8UspYCOBQMV9KcwTqXIClzg8Tco/6pcV8Z6oh6pj oQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ym31ugduv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 22:46:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02AMgV21115122;
        Tue, 10 Mar 2020 22:46:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yp8nw9kmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 22:46:00 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02AMjwcR019568;
        Tue, 10 Mar 2020 22:45:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 15:45:57 -0700
Date:   Tue, 10 Mar 2020 15:45:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: remove the unused return value from
 xfs_log_unmount_write
Message-ID: <20200310224556.GC8045@magnolia>
References: <20200306143137.236478-1-hch@lst.de>
 <20200306143137.236478-2-hch@lst.de>
 <20200306160917.GD2773@bfoster>
 <20200309080252.GA31481@lst.de>
 <20200310222856.GR10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310222856.GR10776@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003100134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003100134
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 09:28:56AM +1100, Dave Chinner wrote:
> On Mon, Mar 09, 2020 at 09:02:52AM +0100, Christoph Hellwig wrote:
> > On Fri, Mar 06, 2020 at 11:09:17AM -0500, Brian Foster wrote:
> > > On Fri, Mar 06, 2020 at 07:31:31AM -0700, Christoph Hellwig wrote:
> > > > Remove the ignored return value from xfs_log_unmount_write, and also
> > > > remove a rather pointless assert on the return value from xfs_log_force.
> > > > 
> > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > ---
> > > 
> > > I guess there's going to be obvious conflicts with Dave's series and
> > > some of these changes. I'm just going to ignore that and you guys can
> > > figure it out. :)
> > 
> > I'm glad to rebase this on top of the parts of his series that I think
> > make sense.  Just wanted to send this out for now to show what I have
> > in mind in this area.
> 
> FWIW, I'm typing limited at the moment because of a finger injury.
> 
> I was planning to rebase mine on the first 6 patches of this series
> (i.e. all but the IOERROR removal patch) a couple of days ago, but
> I'm really slow at getting stuff done at the moment. So if Darrick
> is happy with this patchset, don't let my cleanup hold it up.

Ahh, I'd held back to see what would develop. :)

I'll have a look then.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
