Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6126C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 17:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EA9220717
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 17:25:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LYHJo/sA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfLRRZx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 12:25:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57276 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfLRRZx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 12:25:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIHOEll016011;
        Wed, 18 Dec 2019 17:25:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=gq9P6Z8wcS5FtbEbuhVP7Ryn9ow2sGvz6tsY+t58Szg=;
 b=LYHJo/sA/eG57CfZlYIcN6l0FoMSCevOJdA7KhpnTjwEvNexV1xw+wnhSLXIhZ2HzkYw
 Tij4vxSWRTlk+oflc5FrsQVpzLQw+X0aZg1m0qEW+Ks5vw7+BR2qscvD1i9JyKtkfMVS
 XW/0KtW7Bb9WY7dn/oCXm6KbkiHeXvubeurgRDnnGviS6dd7e0tdGSALbYaL0RBC3R+w
 yZ+wWQI/aEbnMxCc+6MM4jeSt2iYhiCr9NLCqwNtJxGtFKUwEdwWHxRZdI2bwHrw8Ayt
 hqpyGKcmq3++ly9O2lba59Qy97ig4WsGkBdPyRxKlPLgYRZhJimXIvL1i9qNzpuWQwH1 Gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wvqpqf34q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 17:25:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIHOVA8007870;
        Wed, 18 Dec 2019 17:25:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wyp4xdqg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 17:25:47 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBIHPjMG014893;
        Wed, 18 Dec 2019 17:25:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 09:25:45 -0800
Date:   Wed, 18 Dec 2019 09:25:44 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] man: list xfs_io lsattr inode flag letters
Message-ID: <20191218172544.GO12765@magnolia>
References: <20191218170951.GN12765@magnolia>
 <61bbca8d-a145-3ad1-cb64-9bdd1d78f452@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61bbca8d-a145-3ad1-cb64-9bdd1d78f452@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 18, 2019 at 11:20:40AM -0600, Eric Sandeen wrote:
> On 12/18/19 11:09 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The section of the xfs_io manpage for the 'chattr' command says to refer
> > to xfsctl(3) for information on the flags.  The inode flag information
> > was moved to ioctl_xfs_fssetxattr(2) ages ago, and it never actually
> > mapped the inode flag letters to inode flag bits, so add those to the
> > xfs_io manpage.
> 
> Hm, ok.  The info is in the command's help output but I suppose it's useful
> enough to have it in the (a?) manpage, too.
> 
> OTOH this cuts & pastes quite a lot from the ioctl_xfs_fsgetxattr and I get
> nervous when we do that because it /will/ get out of sync.
> 
> I wonder if we can just say "refer to help output for flag mappings, and to
> ioctl_xfs_fsgetxattr for flag descriptions?"
> 
> Or would it suffice to just fix up the existing text:
> 
> The mapping between each
> letter and the inode flags (refer to
> .BR ioctl_xfs_fssetxattr (2)
> for the full list) is available via the
> .B help
> command.

Hmm, I guess that would work too?

Or how about add the raw mapping from letter to flag in the manpage:

"The inode flags are as follows:
o	XFS_XFLAG_OSCAR
t	XFS_XFLAG_THE
g	XFS_XFLAG_GROUCH"

? :)

/bikeshedding

--D

> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  man/man8/xfs_io.8 |  123 ++++++++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 117 insertions(+), 6 deletions(-)
> > 
> > diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> > index 2f17c64c..26523ab8 100644
> > --- a/man/man8/xfs_io.8
> > +++ b/man/man8/xfs_io.8
> > @@ -794,18 +794,129 @@ for all directory entries below the currently open file
> >  can be used to restrict the output to directories only).
> >  This is a depth first descent, it does not follow symlinks and
> >  it also does not cross mount points.
> > +
> > +The current inode flag letters are:
> > +
> > +.PD 0
> > +.RS
> > +.TP 0.5i
> > +.SM "r (XFS_XFLAG_REALTIME)"
> > +The file is a realtime file.
> > +
> > +.TP
> > +.SM "p (XFS_XFLAG_PREALLOC)"
> > +The file has preallocated space.
> > +
> > +.TP
> > +.SM "i (XFS_XFLAG_IMMUTABLE)"
> > +The file is immutable - it cannot be modified, deleted or renamed, no link can
> > +be created to this file and no data can be written to the file.
> > +Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE capability
> > +can set or clear this flag.
> > +
> > +.TP
> > +.SM "a (XFS_XFLAG_APPEND)"
> > +The file is append-only - it can only be open in append mode for writing.
> > +Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE capability
> > +can set or clear this flag.
> > +
> > +.TP
> > +.SM "s (XFS_XFLAG_SYNC)"
> > +All writes to the file are synchronous.
> > +
> > +.TP
> > +.SM "A (XFS_XFLAG_NOATIME)"
> > +When the file is accessed, its atime record is not modified.
> > +
> > +.TP
> > +.SM "d (XFS_XFLAG_NODUMP)"
> > +The file should be skipped by backup utilities.
> > +
> > +.TP
> > +.SM "t (XFS_XFLAG_RTINHERIT)"
> > +New files created in this directory will be automatically flagged as realtime.
> > +New directories created in the directory will inherit the inheritance bit.
> > +
> > +.TP
> > +.SM "P (XFS_XFLAG_PROJINHERIT)"
> > +New files and directories created in the directory will inherit the parent's
> > +project ID.
> > +New directories also inherit the project ID and project inheritance bit.
> > +
> > +.TP
> > +.SM "n (XFS_XFLAG_NOSYMLINKS)"
> > +Can only be set on a directory and disallows creation of symbolic links in the
> > +directory.
> > +
> > +.TP
> > +.SM "e (XFS_XFLAG_EXTSIZE)"
> > +Extent size hint - if a basic extent size value is set on the file then the
> > +allocator will try allocate in multiples of the set size for this file.
> > +This only applies to non-realtime files.
> > +See
> > +.BR ioctl_xfs_fsgetxattr "(2)"
> > +for more information.
> > +
> > +.TP
> > +.SM "E (XFS_XFLAG_EXTSZINHERIT)"
> > +New files and directories created in the directory will inherit the parent's
> > +basic extent size value (see above).
> > +Can only be set on a directory.
> > +
> > +.TP
> > +.SM "f (XFS_XFLAG_NODEFRAG)"
> > +The file should be skipped during a defragmentation operation.
> > +When applied to a directory, new files and directories created will
> > +inherit the no\-defrag state.
> > +
> > +.TP
> > +.SM "S (XFS_XFLAG_FILESTREAM)"
> > +Filestream allocator - allows a directory to reserve an allocation group for
> > +exclusive use by files created within that directory.
> > +Files being written in other directories will not use the same allocation group
> > +and so files within different directories will not interleave
> > +extents on disk.
> > +The reservation is only active while files are being created and written into
> > +the directory.
> > +
> > +.TP
> > +.SM "x (XFS_XFLAG_DAX)"
> > +If the filesystem lives on directly accessible persistent memory, reads and
> > +writes to this file will go straight to the persistent memory, bypassing the
> > +page cache.
> > +A file with this flag set cannot share blocks.
> > +If set on a directory, new files and directories created will inherit the
> > +persistent memory capability.
> > +
> > +.TP
> > +.SM "C (XFS_XFLAG_COWEXTSIZE)"
> > +Copy on Write Extent size hint - if a CoW extent size value is set on the file,
> > +the allocator will allocate extents for staging a copy on write operation
> > +in multiples of the set size for this file.
> > +See
> > +.BR ioctl_xfs_fsgetxattr "(2)"
> > +for more information.
> > +If the CoW extent size is set on a directory, then new file and directories
> > +created in the directory will inherit the parent's CoW extent size value.
> > +
> > +.TP
> > +.SM "X (XFS_XFLAG_HASATTR)"
> > +The file has extended attributes associated with it.
> > +This flag cannot be changed via chattr.
> > +.RE
> > +
> >  .TP
> >  .BR chattr " [ " \-R " | " \-D " ] [ " + / \-riasAdtPneEfSxC " ]"
> >  Change extended inode flags on the currently open file. The
> >  .B \-R
> >  and
> >  .B \-D
> > -options have the same meaning as above. The mapping between each
> > -letter and the inode flags (refer to
> > -.BR xfsctl (3)
> > -for the full list) is available via the
> > -.B help
> > -command.
> > +options have the same meaning as above.
> > +
> > +See the
> > +.B lsattr
> > +command above for the list of inode flag letters.
> > +
> >  .TP
> >  .BI "flink " path
> >  Link the currently open file descriptor into the filesystem namespace.
> > 
