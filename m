Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7788C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50740206C9
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:27:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bcIGZGBB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgIQD1l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 23:27:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48804 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgIQD1k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 23:27:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3PM2v116517;
        Thu, 17 Sep 2020 03:27:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=BUHeygEK1VkDNbEWvd8OctttQpDmsqi5MOtneHVg2wA=;
 b=bcIGZGBBJP0jH+GVun1NwEZJmzlPIXEKfKskGMSyotQkJXsAoxpobJTcHGvh1pdrrcL0
 zXZHSGFc6sV5RIUfbKazhy7iqgSGYSiTqmc4THjXFmBpYbd8snWQfNQ2p1E3KD2jl9gd
 Jt9z2Uu95hBaG2UWuobc+8b4+wW3VrmuyXnN7nTYwkBngXdwpdlDTnWTj7JzfpbFXFeM
 LHOY0o9phtD79jeg9g8WPOCx+v9ulUq23qVCzCBVZ/Ai1of8cTYFkeW1jru2lb9nGRHf
 BDe+0YWpUToqp6momGJAlz86Yx2MCsJ88E9Zp0G3zZxVxCG1ojNXt8E0L7NbjzIcckgM bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33j91dr5ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 03:27:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3PV4g080022;
        Thu, 17 Sep 2020 03:27:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33h88a22wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 03:27:32 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08H3RWYG030995;
        Thu, 17 Sep 2020 03:27:32 GMT
Received: from localhost (/10.159.158.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 03:27:31 +0000
Date:   Wed, 16 Sep 2020 20:27:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 03/24] generic/607: don't break on filesystems that don't
 support FSGETXATTR on dirs
Message-ID: <20200917032730.GQ7955@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013419510.2923511.4577521065964693699.stgit@magnolia>
 <5F62BEAD.3090602@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5F62BEAD.3090602@cn.fujitsu.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=1 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 09:41:01AM +0800, Xiao Yang wrote:
> On 2020/9/15 9:43, Darrick J. Wong wrote:
> > From: Darrick J. Wong<darrick.wong@oracle.com>
> > 
> > This test requires that the filesystem support calling FSGETXATTR on
> > regular files and directories to make sure the FS_XFLAG_DAX flag works.
> > The _require_xfs_io_command tests a regular file but doesn't check
> > directories, so generic/607 should do that itself.  Also fix some typos.
> > 
> > Signed-off-by: Darrick J. Wong<darrick.wong@oracle.com>
> > ---
> >   common/rc         |   10 ++++++++--
> >   tests/generic/607 |    5 +++++
> >   2 files changed, 13 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/common/rc b/common/rc
> > index aa5a7409..f78b1cfc 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -2162,6 +2162,12 @@ _require_xfs_io_command()
> >   	local testfile=$TEST_DIR/$$.xfs_io
> >   	local testio
> >   	case $command in
> > +	"lsattr")
> > +		# Test xfs_io lsattr support and filesystem FS_IOC_FSSETXATTR
> > +		# support.
> > +		testio=`$XFS_IO_PROG -F -f -c "lsattr $param" $testfile 2>&1`
> > +		param_checked="$param"
> > +		;;
> >   	"chattr")
> >   		if [ -z "$param" ]; then
> >   			param=s
> > @@ -3205,7 +3211,7 @@ _check_s_dax()
> >   	if [ $exp_s_dax -eq 0 ]; then
> >   		(( attributes&  0x2000 ))&&  echo "$target has unexpected S_DAX flag"
> >   	else
> > -		(( attributes&  0x2000 )) || echo "$target doen't have expected S_DAX flag"
> > +		(( attributes&  0x2000 )) || echo "$target doesn't have expected S_DAX flag"
> >   	fi
> >   }
> > 
> > @@ -3217,7 +3223,7 @@ _check_xflag()
> >   	if [ $exp_xflag -eq 0 ]; then
> >   		_test_inode_flag dax $target&&  echo "$target has unexpected FS_XFLAG_DAX flag"
> >   	else
> > -		_test_inode_flag dax $target || echo "$target doen't have expected FS_XFLAG_DAX flag"
> > +		_test_inode_flag dax $target || echo "$target doesn't have expected FS_XFLAG_DAX flag"
> >   	fi
> >   }
> > 
> > diff --git a/tests/generic/607 b/tests/generic/607
> > index b15085ea..14d2c05f 100755
> > --- a/tests/generic/607
> > +++ b/tests/generic/607
> > @@ -38,6 +38,11 @@ _require_scratch
> >   _require_dax_iflag
> >   _require_xfs_io_command "lsattr" "-v"
> > 
> > +# Make sure we can call FSGETXATTR on a directory...
> > +output="$($XFS_IO_PROG -c "lsattr -v" $TEST_DIR 2>&1)"
> > +echo "$output" | grep -q "Inappropriate ioctl for device"&&  \
> > +	_notrun "$FSTYP: FSGETXATTR not supported on directories."
> Hi Darrick,
> 
> Could you tell me which kernel version gets the issue? :-)

ext4.

--D

> Best Regards,
> Xiao Yang
> > +
> >   # If a/ is +x, check that a's new children
> >   # inherit +x from a/.
> >   test_xflag_inheritance1()
> > 
> > 
> > 
> > .
> > 
> 
> 
> 
