Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B096FC63777
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Nov 2020 17:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C8362073C
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Nov 2020 17:16:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WRzvzloa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgK3RQI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 12:16:08 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54624 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgK3RQI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Nov 2020 12:16:08 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUH8stR139421;
        Mon, 30 Nov 2020 17:15:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=PXfd9viFsd3D4oXozCXqQkuRYHZs/V8io1nobL6bcw0=;
 b=WRzvzloaX8hFyTsnArdrU6MYCsPhn83/UrPP8NkbHGWxNVFFphcSxUgjaDM/fGYoaJM1
 xm3B1zgNGJIPY1A2xSjOVp0kFCTVVfrZdwxyaBlN43grmLMpdBD0UvjfzFVi57GczRdr
 tIlrQGWMBFrs5RgC8p9s3/6DAUy3t870JKR+6HkZQFtu2HAEVmNNlC0PzLKhFSy/ygRH
 78yy9WSoUJmauD/+qOaBPlhutAFDVNA1EjSkVI90Hk25eBbU39VNfn8qnC4YvrpB2Xla
 DRcVEplSulXqTj+5y+7OYerlotq5jzkYUymBs9ivSiXEaVskQnmLGNd/BJ//RDwl0PVK eA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 353c2apc6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 17:15:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUHACPj120887;
        Mon, 30 Nov 2020 17:13:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3540aqw3td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 17:13:25 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AUHDOZm020109;
        Mon, 30 Nov 2020 17:13:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 17:13:23 +0000
Date:   Mon, 30 Nov 2020 09:13:23 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] libxfs-apply: don't add duplicate headers
Message-ID: <20201130171323.GA143049@magnolia>
References: <160633667604.634603.7657982642827987317.stgit@magnolia>
 <160633668210.634603.16132006317248436755.stgit@magnolia>
 <4bc2eb57-a5e8-59e5-9c69-0d8767df4796@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bc2eb57-a5e8-59e5-9c69-0d8767df4796@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=2
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300111
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 25, 2020 at 03:12:39PM -0600, Eric Sandeen wrote:
> On 11/25/20 2:38 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we're backporting patches from libxfs, don't add a S-o-b header if
> > there's already one at the end of the headers of the patch being ported.
> > 
> > That way, we avoid things like:
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> But it will still not add my additional SOB if I merge something across to
> userspace that starts out with:
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> And I always felt like the committer should be adding their SOB to the end of
> the chain when they move code from one place to another, especially if any
> tweaks got made along the way.
> 
> IOWs I see the rationale for removing duplicate /sequential/ SOBs, but not
> for removing duplicate SOBs in general.
> 
> Am I thinking about that wrong?

add_header is different from last time -- whereas before it would search
the entire $hdrfile for $hdr and add $hdr if it didn't find a match, now
it only looks at the last line of $hdrfile for a match.

For your example above, it would not add another "SOB: Darrick" because
there's already one at the bottom of the headers; but it would add
another "SOB: Eric" because this commit acquired other tags after your
first signoff.

--D

> > ---
> >  tools/libxfs-apply |   14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/tools/libxfs-apply b/tools/libxfs-apply
> > index 3258272d6189..9271db380198 100755
> > --- a/tools/libxfs-apply
> > +++ b/tools/libxfs-apply
> > @@ -193,6 +193,14 @@ filter_xfsprogs_patch()
> >  	rm -f $_libxfs_files
> >  }
> >  
> > +add_header()
> > +{
> > +	local hdr="$1"
> > +	local hdrfile="$2"
> > +
> > +	tail -n 1 "$hdrfile" | grep -q "^${hdr}$" || echo "$hdr" >> "$hdrfile"
> > +}
> > +
> >  fixup_header_format()
> >  {
> >  	local _source=$1
> > @@ -280,13 +288,13 @@ fixup_header_format()
> >  	sed -i '${/^[[:space:]]*$/d;}' $_hdr.new
> >  
> >  	# Add Signed-off-by: header if specified
> > -	if [ ! -z ${SIGNED_OFF_BY+x} ]; then 
> > -		echo "Signed-off-by: $SIGNED_OFF_BY" >> $_hdr.new
> > +	if [ ! -z ${SIGNED_OFF_BY+x} ]; then
> > +		add_header "Signed-off-by: $SIGNED_OFF_BY" $_hdr.new
> >  	else	# get it from git config if present
> >  		SOB_NAME=`git config --get user.name`
> >  		SOB_EMAIL=`git config --get user.email`
> >  		if [ ! -z ${SOB_NAME+x} ]; then
> > -			echo "Signed-off-by: $SOB_NAME <$SOB_EMAIL>" >> $_hdr.new
> > +			add_header "Signed-off-by: $SOB_NAME <$SOB_EMAIL>" $_hdr.new
> >  		fi
> >  	fi
> >  
> > 
