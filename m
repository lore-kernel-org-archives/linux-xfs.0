Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A909BC49ED7
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 04:31:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 606F72073F
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 04:31:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sYl8TFpb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391444AbfITEbf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 00:31:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46358 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390723AbfITEbf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Sep 2019 00:31:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8K4Sl8U156379;
        Fri, 20 Sep 2019 04:31:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=hC0+ZBpS+g8oq2uWhp6EEWeHgOqSMLLi5PFPBDZGwnM=;
 b=sYl8TFpbjOsjPvFOd979vmv3Jp6H+g0vV3n9431gZoEx0R6dYZaJQYrn3T0l+iZu63hn
 vTrqA6B7w6ekBNI+EKXFx6R6Jbe+QWMMarvXDU4CpcehOjE18tFlHPzcC0s/7jCnUf9Z
 Ob+olUHzx1XqP1d/liqMpKEnqVHcy5zXwzRqjlWiIWOJmUvM8GLZmPxIidkPf18hGwsC
 YLjvYQ7pfznfRtka6V9JMwxdjOfDIb8JK9fKWmiirFcSWo82OiafXZ24hrwzcfVVZIpa
 WVJAnoyJPxoZsF/jpfF4L6bFxo5IDkbjByqfEm2mEpaAztDDpTVTPdIDoqPrywPjoG2g mA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2v3vb4yyba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 04:31:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8K4OC9O100795;
        Fri, 20 Sep 2019 04:29:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2v3vb7d109-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 04:29:28 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8K4TRPP019761;
        Fri, 20 Sep 2019 04:29:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Sep 2019 21:29:27 -0700
Date:   Thu, 19 Sep 2019 21:29:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] common/xfs: wipe the XFS superblock of each AGs
Message-ID: <20190920042922.GQ2229799@magnolia>
References: <20190919150024.8346-1-zlang@redhat.com>
 <66503981-2ff3-f28b-fd06-9d6360c930fe@cn.fujitsu.com>
 <20190920024836.GO2229799@magnolia>
 <20190920043139.GO7239@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920043139.GO7239@dhcp-12-102.nay.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9385 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909200049
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9385 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909200050
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 20, 2019 at 12:31:39PM +0800, Zorro Lang wrote:
> On Thu, Sep 19, 2019 at 07:48:36PM -0700, Darrick J. Wong wrote:
> > On Fri, Sep 20, 2019 at 09:52:11AM +0800, Yang Xu wrote:
> > > 
> > > 
> > > on 2019/09/19 23:00, Zorro Lang wrote:
> > > > xfs/030 always fails after d0e484ac699f ("check: wipe scratch devices
> > > > between tests") get merged.
> > > > 
> > > > Due to xfs/030 does a sized(100m) mkfs. Before we merge above commit,
> > > > mkfs.xfs detects an old primary superblock, it will write zeroes to
> > > > all superblocks before formatting the new filesystem. But this won't
> > > > be done if we wipe the first superblock(by merging above commit).
> > > > 
> > > > That means if we make a (smaller) sized xfs after wipefs, those *old*
> > > > superblocks which created by last time mkfs.xfs will be left on disk.
> > > > Then when we do xfs_repair, if xfs_repair can't find the first SB, it
> > > > will go to find those *old* SB at first. When it finds them,
> > > > everyting goes wrong.
> > > > 
> > > > So I try to get XFS AG geometry(by default) and then try to erase all
> > > > superblocks. Thanks Darrick J. Wong helped to analyze this issue.
> > > Feel free to add Reported-by.
> > > > 
> > > > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > > > ---
> > > >   common/rc  |  4 ++++
> > > >   common/xfs | 23 +++++++++++++++++++++++
> > > >   2 files changed, 27 insertions(+)
> > > > 
> > > > diff --git a/common/rc b/common/rc
> > > > index 66c7fd4d..fe13f659 100644
> > > > --- a/common/rc
> > > > +++ b/common/rc
> > > > @@ -4048,6 +4048,10 @@ _try_wipe_scratch_devs()
> > > >   	for dev in $SCRATCH_DEV_POOL $SCRATCH_DEV $SCRATCH_LOGDEV $SCRATCH_RTDEV; do
> > > >   		test -b $dev && $WIPEFS_PROG -a $dev
> > > >   	done
> > > > +
> > > > +	if [ "$FSTYP" = "xfs" ];then
> > > > +		try_wipe_scratch_xfs
> > > I think we should add a simple comment for why we add it.
> > > 
> > > ps:_scratch_mkfs_xfs also can make case pass. We can use it and add comment.
> > > the  try_wipe_scratch_xfs method and the _scratch_mkfs_xfs method are all
> > > acceptable for me.
> > 
> > Yes, I suppose formatting and then wiping per below would also achieve
> > our means, but it would come at the extra cost of zeroing the log.  I'm
> > not too eager to increase xfstest runtime even more.
> > 
> > Hmmm, I wonder if xfs_db could just grow a 'wipe all superblocks'
> > command....
> 
> Haha, I was thinking about that too, and I tried this:
> --
> agc=`_scratch_xfs_get_sb_field agcount`
> wipe_xfs_cmd="$XFS_DB_PROG -x"
> for ((i=0; i<agc; i++)); do
> 	wipe_xfs_cmd="$wipe_xfs_cmd -c \"sb $i\" -c \"write -c magicnum 0x00000000\""
> done
> wipe_xfs_cmd="$wipe_xfs_cmd $SCRATCH_DEV"
> eval $wipe_xfs_cmd
> --
> 
> The only one problem about this, I think it's the max length of bash command:)

Yeah... I mean, the downside of all this is that a filesystme could have
thousands of AGs, though I don't imagine there are many people who set
up a 1PB array just to run xfstests ;)

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > > +	fi
> > > >   }
> > > >   # Only run this on xfs if xfs_scrub is available and has the unicode checker
> > > > diff --git a/common/xfs b/common/xfs
> > > > index 1bce3c18..34516f82 100644
> > > > --- a/common/xfs
> > > > +++ b/common/xfs
> > > > @@ -884,3 +884,26 @@ _xfs_mount_agcount()
> > > >   {
> > > >   	$XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
> > > >   }
> > > > +
> > > > +# wipe the superblock of each XFS AGs
> > > > +try_wipe_scratch_xfs()
> > > > +{
> > > > +	local tmp=`mktemp -u`
> > > > +
> > > > +	_scratch_mkfs_xfs -N 2>/dev/null | perl -ne '
> > > > +		if (/^meta-data=.*\s+agcount=(\d+), agsize=(\d+) blks/) {
> > > > +			print STDOUT "agcount=$1\nagsize=$2\n";
> > > > +		}
> > > > +		if (/^data\s+=\s+bsize=(\d+)\s/) {
> > > > +			print STDOUT "dbsize=$1\n";
> > > > +		}' > $tmp.mkfs
> > > > +
> > > > +	. $tmp.mkfs
> > > > +	if [ -n "$agcount" -a -n "$agsize" -a -n "$dbsize" ];then
> > > > +		for ((i = 0; i < agcount; i++)); do
> > > > +			$XFS_IO_PROG -c "pwrite $((i * dbsize * agsize)) $dbsize" \
> > > > +				$SCRATCH_DEV >/dev/null;
> > > > +		done
> > > > +       fi
> > > > +       rm -f $tmp.mkfs
> > > > +}
> > > > 
> > > 
> > > 
