Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B77FC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 05:36:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C6EF2224A
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 05:36:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mCj9x0mQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgJOFgs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 01:36:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60936 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbgJOFgs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 01:36:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09F5ZltB125263;
        Thu, 15 Oct 2020 05:36:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=EistG35kTg3g7cNTs1zY8FHNCiHPfSEGmm2kDJ3k46o=;
 b=mCj9x0mQfKOHj/jcoWd5o83V6M8tlKiOTzM9I4ZtE4KjOhLvlh2FkYnO8tdhsBRz51dS
 AdXg1QEUbbtEMf090AZqHsxP0qUltq9wp8eHb4zOyF/qHw/tXlyZ2tdf8fZGJ0Ft/zjE
 k2nAkYkGQq9P9MNDGLPoqOZiVx9+xfIGjFqnDqDoJCDs9tthOleITfvFLnJCCEcO+/LW
 VqftgpyYC0DPh7KA3q9cUZ3EL+15BmCc0ezb/N92GgBc/sBQIM6xocLr7OCDwJWvWmVd
 hvwTVyQSSHl6sRKUXJiL8M1JMoJbS94ggmZlEwayfybqXoPUcOxYUGL1k1g9BmMmKsLO dA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3434wkturb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 05:36:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09F5ZKaV031320;
        Thu, 15 Oct 2020 05:36:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 343pv1b8wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 05:36:44 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09F5ahvp001222;
        Thu, 15 Oct 2020 05:36:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Oct 2020 22:36:43 -0700
Date:   Wed, 14 Oct 2020 22:36:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] mkfs: document config files in mkfs.xfs(8)
Message-ID: <20201015053642.GP9832@magnolia>
References: <20201015032925.1574739-1-david@fromorbit.com>
 <20201015032925.1574739-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015032925.1574739-6-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9774 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=5 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9774 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=5 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150039
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 02:29:25PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> So people know it exists.

Yay documentation!

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  man/man8/mkfs.xfs.8 | 113 +++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 106 insertions(+), 7 deletions(-)
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 0a7858748457..f70d91d994fa 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -122,8 +122,46 @@ If the size of the block or sector is not specified, the default sizes
>  Many feature options allow an optional argument of 0 or 1, to explicitly
>  disable or enable the functionality.
>  .SH OPTIONS
> +Options may be specified either on the command line or in a configuration file.
> +Not all command line options can be specified in configuration files; only the
> +command line options followed by a
> +.B [section]
> +label can be used in a configuration file.
> +.PP
> +Options that can be used in configuration files are grouped into related
> +sections containing multiple options.
> +Both the command line and configuration file formats use the same section and

"The command line options and configuration files use the same option
sections and grouping."?

> +option grouping.
> +Configuration file section names are described command line options in the list

/me stumbles over "are described command line options in the list".

"Configuration file section names are listed in the command line option
sections below."?

> +below.
> +Option names and values are the same for both command line
> +and configuration file specification.
> +.PP
> +Options specified are the combined set of command line parameters and
> +configuration file parameters.
> +Duplicated options will result in a respecification error, regardless of the
> +location they were specified at.
> +.TP
> +.BI \-c " configuration_file_option"
> +This option specifies the files that mkfs configuration will be obtained from.
> +The valid
> +.I configuration_file_option
> +is:
> +.RS 1.2i
>  .TP
> +.BI options= name
> +The configuration options will be sourced from the file specified by the
> +.I name
> +option string.
> +This option can be use either an absolute or relative path to the configuration
> +file to be read.
> +.RE
> +.PP
> +.PD 0
>  .BI \-b " block_size_options"
> +.TP
> +.BI [block]

We might want to call this out explicitly as the name of the section in
the config file.

--D

> +.PD
>  This option specifies the fundamental block size of the filesystem.
>  The valid
>  .I block_size_option
> @@ -141,8 +179,12 @@ Although
>  will accept any of these values and create a valid filesystem,
>  XFS on Linux can only mount filesystems with pagesize or smaller blocks.
>  .RE
> -.TP
> +.PP
> +.PD 0
>  .BI \-m " global_metadata_options"
> +.TP
> +.BI [metadata]
> +.PD
>  These options specify metadata format options that either apply to the entire
>  filesystem or aren't easily characterised by a specific functionality group. The
>  valid
> @@ -243,8 +285,12 @@ reflink-enabled XFS filesystems.  To use filesystem DAX with XFS, specify the
>  .B \-m reflink=0
>  option to mkfs.xfs to disable the reflink feature.
>  .RE
> -.TP
> +.PP
> +.PD 0
>  .BI \-d " data_section_options"
> +.TP
> +.BI [data]
> +.PD
>  These options specify the location, size, and other parameters of the
>  data section of the filesystem. The valid
>  .I data_section_options
> @@ -416,8 +462,12 @@ By default,
>  .B mkfs.xfs
>  will not write to the device if it suspects that there is a filesystem
>  or partition table on the device already.
> -.TP
> +.PP
> +.PD 0
>  .BI \-i " inode_options"
> +.TP
> +.BI [inode]
> +.PD
>  This option specifies the inode size of the filesystem, and other
>  inode allocation parameters.
>  The XFS inode contains a fixed-size part and a variable-size part.
> @@ -537,8 +587,12 @@ accommodate a chunk of 64 inodes. Without this feature enabled, inode
>  allocations can fail with out of space errors under severe fragmented
>  free space conditions.
>  .RE
> -.TP
> +.PP
> +.PD 0
>  .BI \-l " log_section_options"
> +.TP
> +.BI [log]
> +.PD
>  These options specify the location, size, and other parameters of the
>  log section of the filesystem. The valid
>  .I log_section_options
> @@ -651,8 +705,12 @@ is 1 (on) so you must specify
>  if you want to disable this feature for older kernels which don't support
>  it.
>  .RE
> -.TP
> +.PP
> +.PD 0
>  .BI \-n " naming_options"
> +.TP
> +.BI [naming]
> +.PD
>  These options specify the version and size parameters for the naming
>  (directory) area of the filesystem. The valid
>  .I naming_options
> @@ -858,8 +916,12 @@ to be constructed;
>  the
>  .B \-q
>  flag suppresses this.
> -.TP
> +.PP
> +.PD 0
>  .BI \-r " realtime_section_options"
> +.TP
> +.BI [realtime]
> +.PD
>  These options specify the location, size, and other parameters of the
>  real-time section of the filesystem. The valid
>  .I realtime_section_options
> @@ -893,8 +955,12 @@ or logical volume containing the section.
>  This option disables stripe size detection, enforcing a realtime device with no
>  stripe geometry.
>  .RE
> -.TP
> +.PP
> +.PD 0
>  .BI \-s " sector_size_options"
> +.TP
> +.BI [sector]
> +.PD
>  This option specifies the fundamental sector size of the filesystem.
>  The valid
>  .I sector_size_option
> @@ -933,6 +999,39 @@ Do not attempt to discard blocks at mkfs time.
>  .TP
>  .B \-V
>  Prints the version number and exits.
> +.SH Configuration File Format
> +The configuration file uses a basic INI format to specify sections and options
> +within a section.
> +Section and option names are case sensitive.
> +Section names must not contain whitespace.
> +Options are name-value pairs, ended by the first whitespace in the line.
> +Option names cannot contain whitespace.
> +Full line comments can be added by starting a line with a # symbol.
> +If values contain whitespace, then it must be quoted.
> +.PP
> +The following example configuration file sets the block size to 4096 bytes,
> +turns on reverse mapping btrees and sets the inode size to 2048 bytes.
> +.PP
> +.PD 0
> +# Example mkfs.xfs configuration file
> +.HP
> +.HP
> +[block]
> +.HP
> +size=4k
> +.HP
> +.HP
> +[metadata]
> +.HP
> +rmapbt=1
> +.HP
> +.HP
> +[inode]
> +.HP
> +size=2048
> +.HP
> +.PD
> +.PP
>  .SH SEE ALSO
>  .BR xfs (5),
>  .BR mkfs (8),
> -- 
> 2.28.0
> 
