Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1AE4C433E6
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 08:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B1E72084C
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 08:05:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GgzYNtwT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgIBIFB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 04:05:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49776 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbgIBIE6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 04:04:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08249YP8113675;
        Wed, 2 Sep 2020 04:12:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=FbE5LhMCpXi9EMjiXj5gIIITv8whtGVc0mnmw/4Oxoc=;
 b=GgzYNtwTP1L0P1GCLirMqxdtVKtSvyOBM/0qpX7K5e0wgw09n5HjmFMBD1nnKaq+kTuP
 NmJJFxVr98cf8DKoxXNVnHNB+oRIooqPLLwCfZjcuzSm4bKVNIgvCbASCv6LdKBRmV0V
 /iKP8yY11cedvmZBbaZvB+DX8g6sql4OSSg98/spWh2uizcwaDgMbFt4GCD0tGRf/W3J
 Bz7gM2eDUtEBfJxjxPfaWUoXV9rjb/ZVs4R2Lv00T4iI0b9ffXzj+AwuQENWuIXlxV4i
 UDPp40ZBXlyMppMN+zMvQ6nl2nFZklhJsVD/PyFFJypysKZ8Dl+8GAkfIzDZ672OFjEm Dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 337eer02j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 04:12:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08245CSX189026;
        Wed, 2 Sep 2020 04:10:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3380kpap6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 04:10:42 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0824Afqq027980;
        Wed, 2 Sep 2020 04:10:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 21:10:40 -0700
Date:   Tue, 1 Sep 2020 21:10:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     linux-xfs@vger.kernel.org, ira.weiny@intel.com
Subject: Re: [PATCH] xfs: Add check for unsupported xflags
Message-ID: <20200902041039.GM6096@magnolia>
References: <20200831133745.33276-1-yangx.jy@cn.fujitsu.com>
 <20200831172250.GT6107@magnolia>
 <5F4DE4C1.6010403@cn.fujitsu.com>
 <20200901163551.GW6107@magnolia>
 <5F4F0647.5060305@cn.fujitsu.com>
 <20200902030946.GL6096@magnolia>
 <5F4F12E2.3080200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5F4F12E2.3080200@cn.fujitsu.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=1 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020038
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 02, 2020 at 11:34:58AM +0800, Xiao Yang wrote:
> 于 2020/9/2 11:09, Darrick J. Wong 写道:
> > On Wed, Sep 02, 2020 at 10:41:11AM +0800, Xiao Yang wrote:
> > > On 2020/9/2 0:35, Darrick J. Wong wrote:
> > > > On Tue, Sep 01, 2020 at 02:05:53PM +0800, Xiao Yang wrote:
> > > > > On 2020/9/1 1:22, Darrick J. Wong wrote:
> > > > > > On Mon, Aug 31, 2020 at 09:37:45PM +0800, Xiao Yang wrote:
> > > > > > > Current ioctl(FSSETXATTR) ignores unsupported xflags silently
> > > > > > > so it it not clear for user to know unsupported xflags.
> > > > > Hi Darrick,
> > > > > 
> > > > > Sorry for a typo(s/it it/it is/).
> > > > > > > For example, use ioctl(FSSETXATTR) to set dax flag on kernel
> > > > > > > v4.4 which doesn't support dax flag:
> > > > > > > --------------------------------
> > > > > > > # xfs_io -f -c "chattr +x" testfile;echo $?
> > > > > > > 0
> > > > > > > # xfs_io -c "lsattr" testfile
> > > > > > > ----------------X testfile
> > > > > > > --------------------------------
> > > > > > > 
> > > > > > > Add check to report unsupported info as ioctl(SETXFLAGS) does.
> > > > > > > 
> > > > > > > Signed-off-by: Xiao Yang<yangx.jy@cn.fujitsu.com>
> > > > > > > ---
> > > > > > >     fs/xfs/xfs_ioctl.c      | 4 ++++
> > > > > > >     include/uapi/linux/fs.h | 8 ++++++++
> > > > > > >     2 files changed, 12 insertions(+)
> > > > > > > 
> > > > > > > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > > > > > > index 6f22a66777cd..cfe7f20c94fe 100644
> > > > > > > --- a/fs/xfs/xfs_ioctl.c
> > > > > > > +++ b/fs/xfs/xfs_ioctl.c
> > > > > > > @@ -1439,6 +1439,10 @@ xfs_ioctl_setattr(
> > > > > > > 
> > > > > > >     	trace_xfs_ioctl_setattr(ip);
> > > > > > > 
> > > > > > > +	/* Check if fsx_xflags have unsupported xflags */
> > > > > > > +	if (fa->fsx_xflags&    ~FS_XFLAG_ALL)
> > > > > > > +                return -EOPNOTSUPP;
> > > > > > Shouldn't this be in vfs_ioc_fssetxattr_check, since we're checking
> > > > > > against all the vfs defined XFLAGS?
> > > > > Right, different filesystems support different XFLAGS so I think it is hard
> > > > > to put this
> > > > > check into vfs_ioc_fssetxattr_check().  For example,
> > > > > 1) ext4 defines EXT4_SUPPORTED_FS_XFLAGS and do the check before
> > > > > vfs_ioc_fssetxattr_check():
> > > > I guess I wasn't clear enough about the xflags checks.
> > > > 
> > > > Historically, XFS never checked the flags value for set bits that don't
> > > > correspond to a known (X)FS_XFLAG_ value.  If your program passes in a
> > > > set bit that the kernel doesn't know about, the kernel does nothing
> > > > about it, and a subsequent FSGETXATTR will not have that bit set.
> > > Hi Darrick,
> > > 
> > > Yes, we have to confirm if XFS supports the specified xflag by both
> > > FSSETXATTR and
> > > FSGETXATT(instead of the single FSSETXATTR) so it is not clear and simple
> > > for user.
> > > This patch just makes ioctl(FSSETXATTR) return -EOPNOTSUPP when XFS doesn't
> > > support
> > > the specified xflag.
> > > Note: ext4/f2fs/btrfs have implemented the behavior.
> > > 
> > > BTW:
> > > With this patch, current '_require_xfs_io_command "chattr"' in xfstests can
> > > check XFS's
> > > supported xflags directly and don't need to check them by extra
> > > ioctl(FSGETXATTR).
> > > > The old ioctl (back when it was xfs only) wasn't officially documented,
> > > > so it wasn't clear whether the kernel should do that or return EINVAL.
> > > > 
> > > > Then the ioctl pair was hoisted to the VFS, a manpage was written
> > > > specifying an EINVAL return for invalid arguments, and ext4, f2fs, and
> > > > btrfs followed this.
> > > > 
> > > > FS_XFLAG_ALL is the set of all defined FS_XFLAG_* values.  Therefore,
> > > > the VFS needs to check that userspace does not try to pass in a flags
> > > > value with totally unknown bits set in it.  That's what I thought you
> > > > were trying to do with this patch.
> > > > 
> > > > Since you bring it up, however -- ext4/f2fs/btrfs support only a subset
> > > > of the (X)FS_XFLAG values, so they implement a second check to constrain
> > > > the flags values to the ones that those filesystems support.  I doubt
> > > > that the set of flags that XFS supports will stay the same as the set of
> > > > flags that the VFS header establishes, so it would be wise to implement
> > > > a second check in XFS, even if right now it provides no added benefit
> > > > over the VFS check.
> > > This patch just tries to implement the second check in XFS.
> > > 
> > > Different filesystems(ext4/f2fs/btrfs/xfs) support different xflags so the
> > > check depends
> > > on these filesystems instead of vfs.  I am not sure why we need to implement
> > > the first
> > > check?(I think the first check seems surplus)

Oops, sorry, I didn't notice this.

The reason for checking both in the VFS and in the fs driver itself is
to ensure that there's at least some checking of the syscall inputs even
if a new fs implementation neglects to check the flags.

(Or the original implementation <cough>.)

> Hi Darrick,
> 
> Do you agree this point that only implements the second check in XFS? :-)

Yes.

> > > > IOWs, I'm suggesting that you write one patch to define a FS_XFLAG_ALL
> > > > consisting of all known FS_XFLAG_* values, and a check in
> > > > vfs_ioc_fssetxattr_check that uses that to establish basic sanity of the
> > > > arguments; and a second patch to define a XFS_XFLAG_ALL consisting of
> > > > all the flags that XFS supports, and a check in xfs_ioctl_setattr that
> > > > uses XFS_XFLAG_ALL to establish that we're not passing in an XFLAG that
> > > > XFS doesn't support.
> > > How about the following patch(i.e. add a check in xfs_ioctl_setattr):
> > > -----------------------------------------------------------
> > > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > > index 84bcffa87753..8ac19f55c701 100644
> > > --- a/fs/xfs/libxfs/xfs_fs.h
> > > +++ b/fs/xfs/libxfs/xfs_fs.h
> > > @@ -92,6 +92,14 @@ struct getbmapx {
> > >   #define XFS_FMR_OWN_COW                FMR_OWNER('X', 7) /* cow staging */
> > >   #define XFS_FMR_OWN_DEFECTIVE  FMR_OWNER('X', 8) /* bad blocks */
> > > 
> > > +#define XFS_SUPPORTED_FS_XFLAGS \
> > > +       (FS_XFLAG_REALTIME | FS_XFLAG_PREALLOC | FS_XFLAG_IMMUTABLE | \
> > > +        FS_XFLAG_APPEND | FS_XFLAG_SYNC | FS_XFLAG_NOATIME |
> > > FS_XFLAG_NODUMP | \
> > > +        FS_XFLAG_RTINHERIT | FS_XFLAG_PROJINHERIT | FS_XFLAG_NOSYMLINKS | \
> > > +        FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT | FS_XFLAG_NODEFRAG | \
> > > +        FS_XFLAG_FILESTREAM | FS_XFLAG_DAX | FS_XFLAG_COWEXTSIZE | \
> > > +        FS_XFLAG_HASATTR)
> > This is an implementation detail, so you might as well put it right
> > above xfs_ioctl_setattr.
> > 
> > That and xfs_fs.h gets packaged in /usr/include so we don't want to have
> > to support that symbol for userspace programs forever.
> 
> Will put the macro above xfs_ioctl_setattr, as below:
> -------------------------------------------------------------
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6f22a66777cd..e188e81961bd 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1425,6 +1425,14 @@ xfs_ioctl_setattr_check_projid(
> return 0;
> }
> 
> +#define XFS_SUPPORTED_FS_XFLAGS \
> + (FS_XFLAG_REALTIME | FS_XFLAG_PREALLOC | FS_XFLAG_IMMUTABLE | \
> + FS_XFLAG_APPEND | FS_XFLAG_SYNC | FS_XFLAG_NOATIME | FS_XFLAG_NODUMP | \
> + FS_XFLAG_RTINHERIT | FS_XFLAG_PROJINHERIT | FS_XFLAG_NOSYMLINKS | \
> + FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT | FS_XFLAG_NODEFRAG | \
> + FS_XFLAG_FILESTREAM | FS_XFLAG_DAX | FS_XFLAG_COWEXTSIZE | \
> + FS_XFLAG_HASATTR)
> +
> STATIC int
> xfs_ioctl_setattr(
> xfs_inode_t *ip,
> @@ -1439,6 +1447,10 @@ xfs_ioctl_setattr(
> 
> trace_xfs_ioctl_setattr(ip);
> 
> + /* Check if fsx_xflags has unsupported xflags */
> + if (fa->fsx_xflags & ~XFS_SUPPORTED_FS_XFLAGS)
> + return -EOPNOTSUPP;
> +
> code = xfs_ioctl_setattr_check_projid(ip, fa);
> if (code)
> return code;
> -------------------------------------------------------------
> 
> Best Regards,
> Xiao Yang
> > --D
> > 
> > > +
> > >   /*
> > >    * Structure for XFS_IOC_FSSETDM.
> > >    * For use by backup and restore programs to set the XFS on-disk inode
> > > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > > index 6f22a66777cd..ec5feaa8dec8 100644
> > > --- a/fs/xfs/xfs_ioctl.c
> > > +++ b/fs/xfs/xfs_ioctl.c
> > > @@ -1439,6 +1439,10 @@ xfs_ioctl_setattr(
> > > 
> > >          trace_xfs_ioctl_setattr(ip);
> > > 
> > > +       /* Check if fsx_xflags have unsupported xflags */
> > > +       if (fa->fsx_xflags&  ~XFS_SUPPORTED_FS_XFLAGS)
> > > +                return -EOPNOTSUPP;
> > > +
> > >          code = xfs_ioctl_setattr_check_projid(ip, fa);
> > >          if (code)
> > >                  return code;
> > > -----------------------------------------------------------
> > > 
> > > Best Regards,
> > > Xiao Yang
> > > > --D
> > > > 
> > > > > -------------------------------------------------------------------------------
> > > > > ext4/ioctl.c:
> > > > > #define EXT4_SUPPORTED_FS_XFLAGS (FS_XFLAG_SYNC | FS_XFLAG_IMMUTABLE | \
> > > > >                                     FS_XFLAG_APPEND | FS_XFLAG_NODUMP | \
> > > > >                                     FS_XFLAG_NOATIME | FS_XFLAG_PROJINHERIT |
> > > > > \
> > > > >                                     FS_XFLAG_DAX)
> > > > > ...
> > > > >                   if (fa.fsx_xflags&   ~EXT4_SUPPORTED_FS_XFLAGS)
> > > > >                           return -EOPNOTSUPP;
> > > > > ...
> > > > > -------------------------------------------------------------------------------
> > > > > 2) btrfs adds check_xflags() and calls it before vfs_ioc_fssetxattr_check():
> > > > > -------------------------------------------------------------------------------
> > > > > btrfs/ioctl.c:
> > > > > static int check_xflags(unsigned int flags)
> > > > > {
> > > > >           if (flags&   ~(FS_XFLAG_APPEND | FS_XFLAG_IMMUTABLE |
> > > > > FS_XFLAG_NOATIME |
> > > > >                         FS_XFLAG_NODUMP | FS_XFLAG_SYNC))
> > > > >                   return -EOPNOTSUPP;
> > > > >           return 0;
> > > > > }
> > > > > ...
> > > > >           ret = check_xflags(fa.fsx_xflags);
> > > > >           if (ret)
> > > > >                   return ret;
> > > > > ...
> > > > > -------------------------------------------------------------------------------
> > > > > 
> > > > > Perhaps, I should rename FS_XFLAG_ALL to XFS_SUPPORTED_FS_XFLAGS and move
> > > > > it into libxfs/xfs_fs.h.
> > > > > 
> > > > > Best Regards,
> > > > > Xiao Yang
> > > > > > --D
> > > > > > 
> > > > > > > +
> > > > > > >     	code = xfs_ioctl_setattr_check_projid(ip, fa);
> > > > > > >     	if (code)
> > > > > > >     		return code;
> > > > > > > diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> > > > > > > index f44eb0a04afd..31b6856f6877 100644
> > > > > > > --- a/include/uapi/linux/fs.h
> > > > > > > +++ b/include/uapi/linux/fs.h
> > > > > > > @@ -142,6 +142,14 @@ struct fsxattr {
> > > > > > >     #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
> > > > > > >     #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
> > > > > > > 
> > > > > > > +#define FS_XFLAG_ALL \
> > > > > > > +	(FS_XFLAG_REALTIME | FS_XFLAG_PREALLOC | FS_XFLAG_IMMUTABLE | \
> > > > > > > +	 FS_XFLAG_APPEND | FS_XFLAG_SYNC | FS_XFLAG_NOATIME | FS_XFLAG_NODUMP | \
> > > > > > > +	 FS_XFLAG_RTINHERIT | FS_XFLAG_PROJINHERIT | FS_XFLAG_NOSYMLINKS | \
> > > > > > > +	 FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT | FS_XFLAG_NODEFRAG | \
> > > > > > > +	 FS_XFLAG_FILESTREAM | FS_XFLAG_DAX | FS_XFLAG_COWEXTSIZE | \
> > > > > > > +	 FS_XFLAG_HASATTR)
> > > > > > > +
> > > > > > >     /* the read-only stuff doesn't really belong here, but any other place is
> > > > > > >        probably as bad and I don't want to create yet another include file. */
> > > > > > > 
> > > > > > > -- 
> > > > > > > 2.25.1
> > > > > > > 
> > > > > > > 
> > > > > > > 
> > > > > > .
> > > > > > 
> > > > > 
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
