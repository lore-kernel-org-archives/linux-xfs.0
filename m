Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCEDCC32792
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 16:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EB5921855
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 16:12:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dNYXczve"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfI3QMR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 12:12:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47064 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731459AbfI3QMQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 12:12:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8UG9msN024202;
        Mon, 30 Sep 2019 16:11:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=jD52WCVvEP4EGxA4wuE+aASZi4J8rTOnAzwe7NHhYD0=;
 b=dNYXczve5tgynZYgo0W/iz1yLSoTj0GvFQDbj5JFJHmJPEkV/0M9OBa+L0a542aYSnri
 QD+ig+bBIVhXWLbLu8AWJJoR42tApXJlbWCgbhgun/AZJv0LYvkSbvSRRPKqYG6ZRu6N
 m6xxQaCx6ooERTQFFz8ogtie861o+TrefWZHphcoWnAb3HX+h0JB0HR6qIKOQX3ETnMj
 iNgTxvVX3xGPjRfy4piU/KxUmMfpvDBCPifwJLOz/s88PaggwiO1M2qa/aJI/IJbAvJm
 dlf8JBS6U6Oc1bIt1MBsXUuAz0O9tXzvUt53TdJCx6hccUYmtqP7VoP0JoYII8rXumET BA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2v9xxugbyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 16:11:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8UG9iwU062363;
        Mon, 30 Sep 2019 16:11:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vbmpwgx8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 16:11:56 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8UGBqJp029363;
        Mon, 30 Sep 2019 16:11:55 GMT
Received: from localhost (/67.161.8.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 09:11:52 -0700
Date:   Mon, 30 Sep 2019 09:11:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: calculate iext tree geometry in btheight
 command
Message-ID: <20190930161151.GA13108@magnolia>
References: <156944764785.303060.15428657522073378525.stgit@magnolia>
 <156944765991.303060.7541074919992777157.stgit@magnolia>
 <20190926214102.GK16973@dread.disaster.area>
 <20190930075854.GK27886@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930075854.GK27886@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909300159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909300159
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 30, 2019 at 12:58:54AM -0700, Christoph Hellwig wrote:
> On Fri, Sep 27, 2019 at 07:41:02AM +1000, Dave Chinner wrote:
> > > +static int iext_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
> > > +{
> > > +	blocklen -= 2 * sizeof(void *);
> > > +
> > > +	return blocklen / sizeof(struct xfs_bmbt_rec);
> > > +}
> > 
> > This isn't correct for the iext nodes. They hold 16 key/ptr pairs,
> > not 15.
> > 
> > I suspect you should be lifting the iext btree format definitions
> > like this one:
> 
> Is the command supposed to deal with the on-disk or in-memory nodes?
> The ones your quote are the in-memory btrees, but the file seems
> (the way I read it, the documentation seems to be lacking) with the
> on-disk btrees.

It started as a command for calculating ondisk btree geometry but then
we were discussing the iext tree geometry on irc so I extended it to
handle that too.

(Ugh, where /did/ the documentation go...)

--D
