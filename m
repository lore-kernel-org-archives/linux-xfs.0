Return-Path: <SRS0=Jrso=6Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C58DC47255
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 16:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54D4A20708
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 16:46:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nFpOJxkO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgEKQqa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 May 2020 12:46:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58146 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729120AbgEKQqa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 May 2020 12:46:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04BGgxh5056405;
        Mon, 11 May 2020 16:46:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=CHy4BE8QPe35m0qPEKv7wR4dV8ykCygKiScMCuWPozM=;
 b=nFpOJxkOI9kWFJgzKfanPd4LP8i1DmSViFc4txMVPetjm0cnHLcizgaSOMP9TQ03nof8
 X9VGB1z2Kw49I/vC78hc8RiHDslMkfPH94XhZ0jFJfjZT5iY5qZlE8rDJowJz6rJIsmr
 fuZF/fqQAe37QpDHsL14WVO2KqAMC4d2nqoYsMZmCZoBKGYoifuxB2h9QDHCQFbdg6Dz
 Xme3R9eT82ZoLp6ArArH92kD5bg8gQE3zoDkCL6Z/guyOaflbGqmpC1QezoIXu/LWB+4
 XNfFQwJFg22HvSbslfmiPN6Iw/prK7l//7dhvxDGvM6JkknM/5lEbMgkUGneQisbqRw3 9A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30x3gse8es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 May 2020 16:46:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04BGbrKr073942;
        Mon, 11 May 2020 16:44:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30x6ewcpcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 May 2020 16:44:25 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04BGiMhD003644;
        Mon, 11 May 2020 16:44:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 May 2020 09:44:22 -0700
Date:   Mon, 11 May 2020 09:44:21 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/16] xfs_repair: fix missing dir buffer corruption
 checks
Message-ID: <20200511164421.GA6714@magnolia>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904179840.982941.17275782452712518850.stgit@magnolia>
 <20200509170850.GA12777@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509170850.GA12777@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=875 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005110131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=905
 malwarescore=0 adultscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1015 bulkscore=0 phishscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005110131
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 10:08:50AM -0700, Christoph Hellwig wrote:
> On Sat, May 09, 2020 at 09:29:58AM -0700, Darrick J. Wong wrote:
> > @@ -140,11 +140,24 @@ _("can't read %s block %u for inode %" PRIu64 "\n"),
> >  		if (whichfork == XFS_DATA_FORK &&
> >  		    (nodehdr.magic == XFS_DIR2_LEAFN_MAGIC ||
> >  		    nodehdr.magic == XFS_DIR3_LEAFN_MAGIC)) {
> > +			int bad = 0;
> > +
> >  			if (i != -1) {
> >  				do_warn(
> >  _("found non-root LEAFN node in inode %" PRIu64 " bno = %u\n"),
> >  					da_cursor->ino, bno);
> > +				bad++;
> >  			}
> > +
> > +			/* corrupt leafn node; rebuild the dir. */
> > +			if (!bad &&
> > +			    (bp->b_error == -EFSBADCRC ||
> > +			     bp->b_error == -EFSCORRUPTED)) {
> > +				do_warn(
> > +_("corrupt %s LEAFN block %u for inode %" PRIu64 "\n"),
> > +					FORKNAME(whichfork), bno, da_cursor->ino);
> > +			}
> > +
> 
> So this doesn't really change any return value, but just the error
> message.  But looking at this code I wonder why we don't check
> b_error first thing after reading the buffer, as checking the magic
> for a corrupt buffer seems a little pointless.

<shrug> In the first hunk I was merely following what we did for DA_NODE
blocks (check magic, then check for corruption errors) but I guess I
could just pull that up in the file.  I'll have a look and see what
happens if I do that.

--D
