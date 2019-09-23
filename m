Return-Path: <SRS0=UWJz=XS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A3A2C04EBF
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 15:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13B08207FD
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 15:12:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c/5niShX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731678AbfIWPM5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Sep 2019 11:12:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44518 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfIWPM5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Sep 2019 11:12:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8NF991P157733;
        Mon, 23 Sep 2019 15:12:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=VnVlZnroDnp9QFMV/KCJI5K68Wl/29910b6ZIPf9ylg=;
 b=c/5niShXfQh0cX9g6njfufiv7qNHG3LG4r6v5xx2ZmD9AgLmJOYKrHiHl+nfF7XZfDl9
 IiwCKtxWgYnoFA5DB58TrYYBLi7uQomEg16uPndidk75F45aUiAoe674sYo5t0eBg5e7
 1T+zqHluKKj7xwK7NJGETSM2DLLuwP4lAXtivCoQSzeqiHzeTfhCOB+G41fkNcnpNVop
 jWKxYrzQNHti00OFOivbLfUYgvoICSvE3X1JXWDziT4aOjRcEZDs7i01RnZOrR3kU2ub
 MBSOfHPQGZppsnU0PBnrBOdgCx0dStL0TF3rjJj4s1mm5qdS+DLSrHoRUR1CF0Xbhuu0 hA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v5b9tfmt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 15:12:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8NFA6ii091370;
        Mon, 23 Sep 2019 15:12:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2v6yvphwhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 15:12:43 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8NFCgwk008709;
        Mon, 23 Sep 2019 15:12:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Sep 2019 08:12:41 -0700
Date:   Mon, 23 Sep 2019 08:12:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] common/xfs: wipe the XFS superblock of each AGs
Message-ID: <20190923151239.GS2229799@magnolia>
References: <20190920062327.14747-1-zlang@redhat.com>
 <20190920153443.GR2229799@magnolia>
 <20190922112512.GP7239@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190922112512.GP7239@dhcp-12-102.nay.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909230144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909230144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 22, 2019 at 07:25:12PM +0800, Zorro Lang wrote:
> On Fri, Sep 20, 2019 at 08:34:43AM -0700, Darrick J. Wong wrote:
> > On Fri, Sep 20, 2019 at 02:23:27PM +0800, Zorro Lang wrote:
> > > xfs/030 always fails after d0e484ac699f ("check: wipe scratch devices
> > > between tests") get merged.
> > > 
> > > Due to xfs/030 does a sized(100m) mkfs. Before we merge above commit,
> > > mkfs.xfs detects an old primary superblock, it will write zeroes to
> > > all superblocks before formatting the new filesystem. But this won't
> > > be done if we wipe the first superblock(by merging above commit).
> > > 
> > > That means if we make a (smaller) sized xfs after wipefs, those *old*
> > > superblocks which created by last time mkfs.xfs will be left on disk.
> > > Then when we do xfs_repair, if xfs_repair can't find the first SB, it
> > > will go to find those *old* SB at first. When it finds them,
> > > everyting goes wrong.
> > > 
> > > So I try to get XFS AG geometry(by default) and then try to erase all
> > > superblocks. Thanks Darrick J. Wong helped to analyze this issue.
> > > 
> > > Reported-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
> > > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > > ---
> > > 
> > > Hi,
> > > 
> > > V2 did below changes:
> > > 1) Use xfs_db to detect the real xfs geometry
> > > 2) Do a $FSTYP specified wipe before trying to wipefs all scratch devices
> > > 
> > > Thanks,
> > > Zorro
> > > 
> > >  common/rc  |  8 ++++++++
> > >  common/xfs | 20 ++++++++++++++++++++
> > >  2 files changed, 28 insertions(+)
> > > 
> > > diff --git a/common/rc b/common/rc
> > > index 66c7fd4d..56329747 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > > @@ -4045,6 +4045,14 @@ _try_wipe_scratch_devs()
> > >  {
> > >  	test -x "$WIPEFS_PROG" || return 0
> > >  
> > > +	# Do specified filesystem wipe at first
> > > +	case "$FSTYP" in
> > > +	"xfs")
> > > +		_try_wipe_scratch_xfs
> > > +		;;
> > > +	esac
> > > +
> > > +	# Then do wipefs on all scratch devices
> > >  	for dev in $SCRATCH_DEV_POOL $SCRATCH_DEV $SCRATCH_LOGDEV $SCRATCH_RTDEV; do
> > >  		test -b $dev && $WIPEFS_PROG -a $dev
> > >  	done
> > > diff --git a/common/xfs b/common/xfs
> > > index 1bce3c18..082a1744 100644
> > > --- a/common/xfs
> > > +++ b/common/xfs
> > > @@ -884,3 +884,23 @@ _xfs_mount_agcount()
> > >  {
> > >  	$XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
> > >  }
> > > +
> > > +# Wipe the superblock of each XFS AGs
> > > +_try_wipe_scratch_xfs()
> > > +{
> > > +	local num='^[0-9]+$'
> > > +	local agcount
> > > +	local agsize
> > > +	local dbsize
> > > +
> > > +	agcount=`_scratch_xfs_get_sb_field agcount 2>/dev/null`
> > > +	agsize=`_scratch_xfs_get_sb_field agblocks 2>/dev/null`
> > > +	dbsize=`_scratch_xfs_get_sb_field blocksize 2>/dev/null`
> > > +
> > > +	if [[ $agcount =~ $num && $agsize =~ $num && $dbsize =~ $num ]];then
> > > +		for ((i = 0; i < agcount; i++)); do
> > > +			$XFS_IO_PROG -c "pwrite $((i * dbsize * agsize)) $dbsize" \
> > > +				$SCRATCH_DEV >/dev/null;
> > > +		done
> > > +	fi
> > 
> > What happened to the loop that simulates a _scratch_mkfs_xfs run (to get
> > the AG geometry) and then zaps that too?  You need both zeroing loops to
> > make sure xfs/030 doesn't trip over old superblocks, right?
> 
> Hi,
> 
> Sorry I'm not sure what you mean. Do you mean I'd better to do two zeroing
> loops, one is as above, the other is for default mkfs.xfs geometry as
> below[1]?

Yes.

--D

> Thanks,
> Zorro
> 
> [1]
>   local tmp=`mktemp -u`
>   _scratch_mkfs_xfs -N 2>/dev/null | perl -ne '
>     if (/^meta-data=.*\s+agcount=(\d+), agsize=(\d+) blks/) {
>       print STDOUT "agcount=$1\nagsize=$2\n";
>     }
>     if (/^data\s+=\s+bsize=(\d+)\s/) {
>       print STDOUT "dbsize=$1\n";
>     }' > $tmp.mkfs
> 
>   . $tmp.mkfs
>   if [ -n "$agcount" -a -n "$agsize" -a -n "$dbsize" ];then
>     for ((i = 0; i < agcount; i++)); do
>       $XFS_IO_PROG -c "pwrite $((i * dbsize * agsize)) $dbsize" \
>          $SCRATCH_DEV >/dev/null;
>     done
>   fi
>   rm -f $tmp.mkfs
> 
> 
> 
> > 
> > --D
> > 
> > > +}
> > > -- 
> > > 2.20.1
> > > 
