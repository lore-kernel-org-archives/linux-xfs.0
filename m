Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8DE2C6379F
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Nov 2020 01:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48D9922255
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Nov 2020 01:53:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ic9cVeX6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgKTBxe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Nov 2020 20:53:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54320 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgKTBxd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Nov 2020 20:53:33 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK1iXF1184343;
        Fri, 20 Nov 2020 01:53:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=IiH2s7+bhKW47E7w0Kmtbf3G9ronEziZ9NQ8pJTou/A=;
 b=Ic9cVeX64VxT43iSdD5eZbzXTBJ2dBQEDMXnCp7Jrqk8EFmnI4kCJnrZCn+6w3OMUE0n
 Q6+R7KPeLgHpf9+7ulEDO98JWicrgstDBsW6AtRUbvL6FBCB2z5jYZxSuRcIfH9iqUzr
 WzXI8ZDhSrv0EdM3ChVVJ1O3Y08hHWVFHRROV7RISw1GrQ/qs+j1fkKtbo7tgGaCWO40
 zJhTL4IOdsK34mMuyxaiFFljqTcc/nNKMo+OkBgudh9wRjWzPesRMYgmiNhN6fDB8WQ3
 2vLQrRWG3Lt84CQXbHn+h950wa2p97Pi7F1BQf0WvDYTN1iDa7JuvisAI4D19zv7BsHL Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34t7vngghr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Nov 2020 01:53:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK1jb6u008324;
        Fri, 20 Nov 2020 01:53:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34ts0um3j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 01:53:29 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AK1rRpT015839;
        Fri, 20 Nov 2020 01:53:28 GMT
Received: from localhost (/10.159.242.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 17:53:27 -0800
Date:   Thu, 19 Nov 2020 17:53:26 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: test inobtcount upgrade
Message-ID: <20201120015326.GC3837269@magnolia>
References: <160382541643.1203756.12015378093281554469.stgit@magnolia>
 <160382542877.1203756.11339393830951325848.stgit@magnolia>
 <de3588f9-e80a-b9ba-cb03-16d538060675@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de3588f9-e80a-b9ba-cb03-16d538060675@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=1 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200011
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 18, 2020 at 10:44:40AM -0600, Eric Sandeen wrote:
> On 10/27/20 2:03 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make sure we can actually upgrade filesystems to support inobtcounts.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/xfs        |   16 ++++++++++++
> >  tests/xfs/910     |   72 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/910.out |    3 ++
> >  tests/xfs/group   |    1 +
> >  4 files changed, 92 insertions(+)
> >  create mode 100755 tests/xfs/910
> >  create mode 100644 tests/xfs/910.out
> > 
> > 
> > diff --git a/common/xfs b/common/xfs
> > index 3f5c14ba..e548a0a1 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -978,3 +978,19 @@ _require_xfs_copy()
> >  	[ "$USE_EXTERNAL" = yes ] && \
> >  		_notrun "Cannot xfs_copy with external devices"
> >  }
> > +
> > +_require_xfs_mkfs_inobtcount()
> > +{
> > +	_scratch_mkfs_xfs_supported -m inobtcount=1 >/dev/null 2>&1 \
> > +	   || _notrun "mkfs.xfs doesn't have inobtcount feature"
> > +}
> 
> I'd like to also add:
> 
> +_require_xfs_admin_upgrade()
> +{
> +	local feature="$1"
> +
> +	_require_scratch
> +	# Catch missing "-O" or missing feature handling
> +	_scratch_xfs_admin -O $feature 2>&1 | grep "illegal option\|Cannot change" \
> +		&& _notrun "xfs_admin does not support upgrading $1"
> +}

Well it occurred to me that the xfs_db version command has a help
screen that lists all of the things that it knows how to upgrade.
So, it should be easy enough to detect whether or not it makes sense to
test an upgrade path.  Thanks for the suggestion, sorry I was rambling
about this being harder a few days ago... :/

--D

> 
> and then:
> 
> ...
> 
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> > +_require_xfs_mkfs_inobtcount
> > +_require_xfs_scratch_inobtcount
> 
> +_require_xfs_admin_upgrade "inobtcount"
> 
> to be sure that the upgrade command is also supported by xfs_admin.  By the time
> we get to release, both mkfs & xfs_admin should both support it, but I'm hedging
> my bets on the upgrade path just a little,and it seems best to explicitly test
> both requirements.
> 
> that helper can be re-used on the bigtime upgrade test as well and anything else
> that requires an xfs_admin upgrade path ...
> 
> Thanks,
> -Eric
