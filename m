Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD77DC3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 15:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 782B6208C2
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 15:42:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PwA1MeTQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbfH2PmG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 11:42:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47548 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfH2PmG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 11:42:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TFfMhV011760;
        Thu, 29 Aug 2019 15:42:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=CgboXgU843188XW/56l/6T9xE1JIqY001HNx21TkOJQ=;
 b=PwA1MeTQefxt3XgA7D2babuMffksOT8G7ZECfcD9eEeGc501sY5KPhE6s9q9Mz6Y8U5b
 l/x8hTGUCyzHAsCyDgjw3FeBTI0vd20w6u3UALCcrSx2mj02NsoqF4AZcAuq7UYFmVQU
 31JermGjwApxnmYjYNKA1JK9ja+OLnxj1CzXdwzxZS5is4/UGWdVuETDv0TK8W1t1hMy
 khcJ7yZLP9jkjSqOf6kb+wJnKir3caXsZqYerHukamb0wzHUr8rItnyBWnZv9+8/3hvY
 gs7rY2cvt1tmCQ9xjTOSVBexvv6lHP4j0AiOh9Xor/3Iok4i7AbHjXGaDm+rEz9T1cqy 0A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uphddg31y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 15:42:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TFbsHc136501;
        Thu, 29 Aug 2019 15:42:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2uphau0n61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 15:42:00 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TFfx2c022475;
        Thu, 29 Aug 2019 15:41:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 08:41:59 -0700
Date:   Thu, 29 Aug 2019 08:41:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix sign handling problem in xfs_bmbt_diff_two_keys
Message-ID: <20190829154158.GB5354@magnolia>
References: <20190826183803.GQ1037350@magnolia>
 <20190829072318.GA18102@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829072318.GA18102@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 12:23:18AM -0700, Christoph Hellwig wrote:
> On Mon, Aug 26, 2019 at 11:38:03AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In xfs_bmbt_diff_two_keys, we perform a signed int64_t subtraction with
> > two unsigned 64-bit quantities.  If the second quantity is actually the
> > "maximum" key (all ones) as used in _query_all, the subtraction
> > effectively becomes addition of two positive numbers and the function
> > returns incorrect results.  Fix this with explicit comparisons of the
> > unsigned values.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap_btree.c |   16 ++++++++++++++--
> >  1 file changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> > index fbb18ba5d905..3c1a805b3775 100644
> > --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> > +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> > @@ -400,8 +400,20 @@ xfs_bmbt_diff_two_keys(
> >  	union xfs_btree_key	*k1,
> >  	union xfs_btree_key	*k2)
> >  {
> > -	return (int64_t)be64_to_cpu(k1->bmbt.br_startoff) -
> > -			  be64_to_cpu(k2->bmbt.br_startoff);
> > +	uint64_t		a = be64_to_cpu(k1->bmbt.br_startoff);
> > +	uint64_t		b = be64_to_cpu(k2->bmbt.br_startoff);
> > +
> > +	/*
> > +	 * Note: This routine previously casted a and b to int64 and subtracted
> > +	 * them to generate a result.  This lead to problems if b was the
> > +	 * "maximum" key value (all ones) being signed incorrectly, hence this
> > +	 * somewhat less efficient version.
> 
> Comments documenting what was done previously are a bit of a weird
> style, as the reader generally could not care less what there was
> previously.
> 
> > +	 */
> > +	if (a > b)
> > +		return 1;
> > +	else if (b > a)
> > +		return -1;
> > +	return 0;
> 
> Looks good.  I wonder if we should have a helper for this through,
> as basically any compare function taking 64-bit values will have the
> same boilerplate.
> 
> I suggest to add a helper like:
> 
> /*
>  * Compare to signed 64-bit values and return an signed 32-bit integer
>  * value that is 1, -1 or 0 for various compare callbacks.
>  */
> static inline int cmp_s64(s64 a, s64 b)
> {
> 	if (a > b)
> 		return 1;
> 	else if (b > a)
> 		return -1;
> 	return 0;
> }

A signed s64 comparison would just break the diff_two_keys function
again.  The reason for the big dorky comment is to point out that the
signed comparison doesn't work for xfs_btree_query_all, because it does:

	union xfs_btree_key		low_key;
	union xfs_btree_key		high_key;

	memset(&cur->bc_rec, 0, sizeof(cur->bc_rec));
	memset(&low_key, 0, sizeof(low_key));
	memset(&high_key, 0xFF, sizeof(high_key));

	return xfs_btree_simple_query_range(cur, &low_key, &high_key, fn, priv);

The query range function compares each record's key against high_key to
decide if it's time to stop.  Since br_startoff is set to all 1s, if you
force a unsigned 64-bit comparison then you'll correctly iterate all the
records because all records in the bmbt will have:

	br_startoff < 18446744073709551615ULL

and it'll iterate until there are no more bmbt records.  If you do a
signed 64-bit comparison, however, it'll gate its comparison on this:

	br_startoff < -1LL

which is always false, so _query_range exits without iterating
anything.

> and then the above just comes:
> 
> 	return cmp_s64(be64_to_cpu(k1->bmbt.br_startoff),
> 		       be64_to_cpu(k2->bmbt.br_startof));
> 
> and we can probably clean up various other places inside (and outside,
> but we can leave that for others) as well.  I'll cook up a patch if
> you feel this is not worth your time.

I wouldn't mind you cooking up a patch (I think I'm going to be busy
for a few hours digging through all of Dave's patches) but the helper
needs to be cmp_u64.  Though ... I also think the logic in the patched
bmbt diff_two_keys is easy enough to follow along.

(Personally I find the subtraction logic harder to follow, though it
generates less asm code on x64...)

--D
