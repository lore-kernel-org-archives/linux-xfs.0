Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9472BC3A5A6
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 02:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FA702196E
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 02:50:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YHE3OHsq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392115AbfITCuZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 22:50:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51230 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388700AbfITCuZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Sep 2019 22:50:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8K2na8C042229;
        Fri, 20 Sep 2019 02:50:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=zTP7HntL0cLYxneaO6w7bSX+tUOsryV53661/88JidQ=;
 b=YHE3OHsqN52bUms4G6yYt6f/gDtzRwxajUvaXANVHrxpH1Z3km1TxBHFwLC3eahfnXri
 CayOfuWQXbQ+0JpN2TKP8I6DLUIoismlkAIMsfSrE3yO4gM6mzbWMtrIeBzQrt/1Wznb
 hXrJiLJdw+xPMp9+8hDYEcSzr8DWOWGSKohO8+vmaJ3lif4rWv+9uC4wtgimGYBy+fOz
 lZSdqHbfQqFCdzOSmERPUbie3Fr0RIX+AzWnes0njdIOr7KoWxWDIlMpJB0cfIm6tZ98
 hFAOZjzcuUJPVasgJQyRVVG0mpIX24M6fJqjOrKp+6jbE+Jg+H0AVkbvTO1tjNaBf7V2 Iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v3vb4qk3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 02:50:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8K2o6jO107432;
        Fri, 20 Sep 2019 02:50:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2v3vb77fns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 02:50:06 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8K2ma1r028097;
        Fri, 20 Sep 2019 02:48:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Sep 2019 19:48:36 -0700
Date:   Thu, 19 Sep 2019 19:48:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Cc:     Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] common/xfs: wipe the XFS superblock of each AGs
Message-ID: <20190920024836.GO2229799@magnolia>
References: <20190919150024.8346-1-zlang@redhat.com>
 <66503981-2ff3-f28b-fd06-9d6360c930fe@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66503981-2ff3-f28b-fd06-9d6360c930fe@cn.fujitsu.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9385 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909200030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9385 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909200031
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 20, 2019 at 09:52:11AM +0800, Yang Xu wrote:
> 
> 
> on 2019/09/19 23:00, Zorro Lang wrote:
> > xfs/030 always fails after d0e484ac699f ("check: wipe scratch devices
> > between tests") get merged.
> > 
> > Due to xfs/030 does a sized(100m) mkfs. Before we merge above commit,
> > mkfs.xfs detects an old primary superblock, it will write zeroes to
> > all superblocks before formatting the new filesystem. But this won't
> > be done if we wipe the first superblock(by merging above commit).
> > 
> > That means if we make a (smaller) sized xfs after wipefs, those *old*
> > superblocks which created by last time mkfs.xfs will be left on disk.
> > Then when we do xfs_repair, if xfs_repair can't find the first SB, it
> > will go to find those *old* SB at first. When it finds them,
> > everyting goes wrong.
> > 
> > So I try to get XFS AG geometry(by default) and then try to erase all
> > superblocks. Thanks Darrick J. Wong helped to analyze this issue.
> Feel free to add Reported-by.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> >   common/rc  |  4 ++++
> >   common/xfs | 23 +++++++++++++++++++++++
> >   2 files changed, 27 insertions(+)
> > 
> > diff --git a/common/rc b/common/rc
> > index 66c7fd4d..fe13f659 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -4048,6 +4048,10 @@ _try_wipe_scratch_devs()
> >   	for dev in $SCRATCH_DEV_POOL $SCRATCH_DEV $SCRATCH_LOGDEV $SCRATCH_RTDEV; do
> >   		test -b $dev && $WIPEFS_PROG -a $dev
> >   	done
> > +
> > +	if [ "$FSTYP" = "xfs" ];then
> > +		try_wipe_scratch_xfs
> I think we should add a simple comment for why we add it.
> 
> ps:_scratch_mkfs_xfs also can make case pass. We can use it and add comment.
> the  try_wipe_scratch_xfs method and the _scratch_mkfs_xfs method are all
> acceptable for me.

Yes, I suppose formatting and then wiping per below would also achieve
our means, but it would come at the extra cost of zeroing the log.  I'm
not too eager to increase xfstest runtime even more.

Hmmm, I wonder if xfs_db could just grow a 'wipe all superblocks'
command....

--D

> > +	fi
> >   }
> >   # Only run this on xfs if xfs_scrub is available and has the unicode checker
> > diff --git a/common/xfs b/common/xfs
> > index 1bce3c18..34516f82 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -884,3 +884,26 @@ _xfs_mount_agcount()
> >   {
> >   	$XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
> >   }
> > +
> > +# wipe the superblock of each XFS AGs
> > +try_wipe_scratch_xfs()
> > +{
> > +	local tmp=`mktemp -u`
> > +
> > +	_scratch_mkfs_xfs -N 2>/dev/null | perl -ne '
> > +		if (/^meta-data=.*\s+agcount=(\d+), agsize=(\d+) blks/) {
> > +			print STDOUT "agcount=$1\nagsize=$2\n";
> > +		}
> > +		if (/^data\s+=\s+bsize=(\d+)\s/) {
> > +			print STDOUT "dbsize=$1\n";
> > +		}' > $tmp.mkfs
> > +
> > +	. $tmp.mkfs
> > +	if [ -n "$agcount" -a -n "$agsize" -a -n "$dbsize" ];then
> > +		for ((i = 0; i < agcount; i++)); do
> > +			$XFS_IO_PROG -c "pwrite $((i * dbsize * agsize)) $dbsize" \
> > +				$SCRATCH_DEV >/dev/null;
> > +		done
> > +       fi
> > +       rm -f $tmp.mkfs
> > +}
> > 
> 
> 
