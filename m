Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE4CC56202
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 01:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C0A2206FA
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 01:35:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Sq1krQ3c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgKXBfl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Nov 2020 20:35:41 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51654 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgKXBfk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Nov 2020 20:35:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO0FGLb058692;
        Tue, 24 Nov 2020 00:24:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=s/wLH0QqtDoPPbmRzkc8eTBYqRq4wxY1UzHtffjSwz8=;
 b=Sq1krQ3cSED5pLy6pWV46kwif7nc42STNNJzHlAK01thgK2XP2imWSN2tpJ9wUfHps31
 iVctBZkM/dyIo7vBIr+w31EMghj4zBbcnW7E2WcvUwoSxr1V/NRuyc/CYhguv9rjpNdV
 23mV0hXgQ5LiTqWHiUjoowiGkXzwdmDAWtHO0ey0PMeGpGFJ7fm2RLvYHmNqnRGPmN5s
 L5DtA4UqMziKbEyA6IqxMG5LzKIPPvnum76gXTFXvDvZeBKITmv0KEDyChseTqSLUBA+
 iGGqPZm+HXtQof4SQBP+Zyuz+gid6CezsSH9ijBl9ui2djF9kKvuHq0nG13thg9nfrBo +g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 34xtaqkhwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 00:24:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO0Fu7r185600;
        Tue, 24 Nov 2020 00:24:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34ycnrp1ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 00:24:35 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AO0OZG8032448;
        Tue, 24 Nov 2020 00:24:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 16:24:34 -0800
Date:   Mon, 23 Nov 2020 16:24:33 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] libxfs-apply: don't add duplicate headers
Message-ID: <20201124002433.GA31219@magnolia>
References: <160503138275.1201232.927488386999483691.stgit@magnolia>
 <160503144025.1201232.11112616423278752638.stgit@magnolia>
 <8adce075-983b-2b3f-eb3c-10eb72bccf0c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8adce075-983b-2b3f-eb3c-10eb72bccf0c@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=2
 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 suspectscore=2 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 23, 2020 at 02:30:58PM -0600, Eric Sandeen wrote:
> On 11/10/20 12:04 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we're backporting patches from libxfs, don't add a S-o-b header if
> > there's already one in the patch being ported.
> 
> I guess the goal here is to not add 2 identical sign offs in a row.
> 
> But when I do the libxfs-application, I do feel like it should add
> my SOB as sort of a chain of custody record before I commit it to a
> new tree/project, no?
> 
> So could this be modified to simply not add 2 identical SOBs in a row?
> 
> Maybe we can just run "uniq" on the $_hdr.new file?

Not sure how uniq gets us to "not add 2 identical signoffs in a row" but
changing the last line of add_header to:

tail -n 1 "$hdrfile" | grep -q "^${hdr}$" || echo "$hdr" >> "$hdrfile"

would do it.

--D

> Thanks,
> -Eric
> 
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tools/libxfs-apply |   14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/tools/libxfs-apply b/tools/libxfs-apply
> > index 3258272d6189..35cdb9c3449b 100755
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
> > +	grep -q "^${hdr}$" "$hdrfile" || echo "$hdr" >> "$hdrfile"
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
