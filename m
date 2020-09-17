Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67192C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:58:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17D1F20872
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:58:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vQTCi/TS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgIQD6c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 23:58:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41578 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIQD6a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 23:58:30 -0400
X-Greylist: delayed 1848 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 23:58:29 EDT
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3rdbd018557;
        Thu, 17 Sep 2020 03:58:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=xGJ0Gw9EIIuDd2XwFxfA1gZbfQntM6aWY+QCKO/mcR0=;
 b=vQTCi/TSvlS84PVrJOG6TeF74B71bvR6bgLJ8V5BKkngY0j5EDQJCHEfFJwIcqiLz51P
 Z9m4yNmVqow8MZ2YXg64YKKowkuYYRhh0uRUi6yVV3RSFbc4Zx6oCMCyupiIIKZ5b8qN
 1LL0nIiSYbdvt77MSDJo7fEeiHpbar3QPRXXrfaKZpyO6/oFH9CPo6Iv6CgSuiZL84j6
 ezK766132C+1D37yg2jnPV260eEK7GhkuOaCAMmlJfAsgf9CZogrDCEzgApalkoyP1yK
 ceif8CvjT33BBGOSjKDux6HpJErW0+3IFEY2fpSwQzWER4I/Qbv8oY79qaCuTlM8y0Fi NA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 33gnrr6mbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 03:58:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3ttYL062330;
        Thu, 17 Sep 2020 03:56:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33hm341twn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 03:56:22 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08H3uLJk025601;
        Thu, 17 Sep 2020 03:56:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 03:56:21 +0000
Date:   Wed, 16 Sep 2020 20:56:20 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 03/24] generic/607: don't break on filesystems that don't
 support FSGETXATTR on dirs
Message-ID: <20200917035620.GR7955@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013419510.2923511.4577521065964693699.stgit@magnolia>
 <5F62BEAD.3090602@cn.fujitsu.com>
 <20200917032730.GQ7955@magnolia>
 <5F62DB4E.9040506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5F62DB4E.9040506@cn.fujitsu.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=1
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170026
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 11:43:10AM +0800, Xiao Yang wrote:
> 于 2020/9/17 11:27, Darrick J. Wong 写道:
> > On Thu, Sep 17, 2020 at 09:41:01AM +0800, Xiao Yang wrote:
> > > On 2020/9/15 9:43, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong<darrick.wong@oracle.com>
> > > > 
> > > > This test requires that the filesystem support calling FSGETXATTR on
> > > > regular files and directories to make sure the FS_XFLAG_DAX flag works.
> > > > The _require_xfs_io_command tests a regular file but doesn't check
> > > > directories, so generic/607 should do that itself.  Also fix some typos.
> > > > 
> > > > Signed-off-by: Darrick J. Wong<darrick.wong@oracle.com>
> > > > ---
> > > >    common/rc         |   10 ++++++++--
> > > >    tests/generic/607 |    5 +++++
> > > >    2 files changed, 13 insertions(+), 2 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/common/rc b/common/rc
> > > > index aa5a7409..f78b1cfc 100644
> > > > --- a/common/rc
> > > > +++ b/common/rc
> > > > @@ -2162,6 +2162,12 @@ _require_xfs_io_command()
> > > >    	local testfile=$TEST_DIR/$$.xfs_io
> > > >    	local testio
> > > >    	case $command in
> > > > +	"lsattr")
> > > > +		# Test xfs_io lsattr support and filesystem FS_IOC_FSSETXATTR
> > > > +		# support.
> > > > +		testio=`$XFS_IO_PROG -F -f -c "lsattr $param" $testfile 2>&1`
> > > > +		param_checked="$param"
> > > > +		;;
> > > >    	"chattr")
> > > >    		if [ -z "$param" ]; then
> > > >    			param=s
> > > > @@ -3205,7 +3211,7 @@ _check_s_dax()
> > > >    	if [ $exp_s_dax -eq 0 ]; then
> > > >    		(( attributes&   0x2000 ))&&   echo "$target has unexpected S_DAX flag"
> > > >    	else
> > > > -		(( attributes&   0x2000 )) || echo "$target doen't have expected S_DAX flag"
> > > > +		(( attributes&   0x2000 )) || echo "$target doesn't have expected S_DAX flag"
> > > >    	fi
> > > >    }
> > > > 
> > > > @@ -3217,7 +3223,7 @@ _check_xflag()
> > > >    	if [ $exp_xflag -eq 0 ]; then
> > > >    		_test_inode_flag dax $target&&   echo "$target has unexpected FS_XFLAG_DAX flag"
> > > >    	else
> > > > -		_test_inode_flag dax $target || echo "$target doen't have expected FS_XFLAG_DAX flag"
> > > > +		_test_inode_flag dax $target || echo "$target doesn't have expected FS_XFLAG_DAX flag"
> > > >    	fi
> > > >    }
> > > > 
> > > > diff --git a/tests/generic/607 b/tests/generic/607
> > > > index b15085ea..14d2c05f 100755
> > > > --- a/tests/generic/607
> > > > +++ b/tests/generic/607
> > > > @@ -38,6 +38,11 @@ _require_scratch
> > > >    _require_dax_iflag
> > > >    _require_xfs_io_command "lsattr" "-v"
> > > > 
> > > > +# Make sure we can call FSGETXATTR on a directory...
> > > > +output="$($XFS_IO_PROG -c "lsattr -v" $TEST_DIR 2>&1)"
> > > > +echo "$output" | grep -q "Inappropriate ioctl for device"&&   \
> > > > +	_notrun "$FSTYP: FSGETXATTR not supported on directories."
> > > Hi Darrick,
> > > 
> > > Could you tell me which kernel version gets the issue? :-)
> > ext4.
> Hi Darrick,
> 
> I didn't get the issue by v5.7.0 xfs_io on v5.8.0 kernel:
> ----------------------------------------------------------------------------------
> # blkid /dev/pmem0
> /dev/pmem0: UUID="181f4d76-bc21-45b7-a6d2-e486f6cc479b" TYPE="ext4"
> # df -h | grep pmem0
> /dev/pmem0 2.0G 28K 1.8G 1% /mnt/xfstests/test
> # strace -e ioctl xfs_io -c "lsattr -v" /mnt/xfstests/test
> ioctl(3, FS_IOC_FSGETXATTR, 0x7ffdc7061d10) = 0
> [] /mnt/xfstests/test
> ----------------------------------------------------------------------------------
> Do I miss something?

Oops, sorry, I was reading the wrong VM report.  It's overlayfs (atop
xfs though I don't think that matters) that doesn't support FSGETXATTR
on directories.

--D

> Thanks,
> Xiao Yang
> > --D
> > 
> > > Best Regards,
> > > Xiao Yang
> > > > +
> > > >    # If a/ is +x, check that a's new children
> > > >    # inherit +x from a/.
> > > >    test_xflag_inheritance1()
> > > > 
> > > > 
> > > > 
> > > > .
> > > > 
> > > 
> > > 
> > 
> > .
> > 
> 
> 
> 
