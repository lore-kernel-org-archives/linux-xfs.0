Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F317C433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 15:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB33B22453
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 15:02:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ce/68yJH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgGNPCB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 11:02:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38678 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgGNPCB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 11:02:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EEatka141050;
        Tue, 14 Jul 2020 15:01:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=q7TW4TvqP3kC9uLJLPTBBLJ0KFjheA/3Mrn8X68L2cI=;
 b=ce/68yJHZvFECLuXimbcv2Cr8xCMWrpp8Lr/J6yWaBIR5JJQqyqAjd1KMFJKbFtxZBqS
 qEmFriU83koD0j+LTdLguqjtuLO/ByOFFmDOTvBy0aVa/WYh5R2Um0KrHjCkum3PwtyD
 gv8iMHR2bN6zJGll6U6EXi4/WKOO8FsGas/yuttqKPvU02jj2VmM8oxL01bv3ZfqAQSZ
 M1oYCKPd6SFKv88LuunysqcgKSJwfWCF/m4h2clzYcDhswKTPlM5dHgKd1/5T6dsqb07
 aio3v9iZXCqgGKj1Hc+0UcxbJXEdqSIoD0ILm420SjwxMPPSHEHvnj3IzN2UIWYBlPFH mQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3275cm5vy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 15:01:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EEba69036507;
        Tue, 14 Jul 2020 15:01:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 327q0pdjac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 15:01:50 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06EF1nDO008046;
        Tue, 14 Jul 2020 15:01:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 08:01:49 -0700
Date:   Tue, 14 Jul 2020 08:01:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_io: Document '-q' option for pread/pwrite command
Message-ID: <20200714150148.GA7606@magnolia>
References: <20200714055327.1396-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714055327.1396-1-yangx.jy@cn.fujitsu.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140113
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 14, 2020 at 01:53:26PM +0800, Xiao Yang wrote:
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>

I did not know we had a 'q' flag...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  io/pread.c        |  3 ++-
>  io/pwrite.c       |  3 ++-
>  man/man8/xfs_io.8 | 10 ++++++++--
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/io/pread.c b/io/pread.c
> index 971dbbc9..458a78b8 100644
> --- a/io/pread.c
> +++ b/io/pread.c
> @@ -30,6 +30,7 @@ pread_help(void)
>  " The reads are performed in sequential blocks starting at offset, with the\n"
>  " blocksize tunable using the -b option (default blocksize is 4096 bytes),\n"
>  " unless a different pattern is requested.\n"
> +" -q   -- quiet mode, do not write anything to standard output.\n"
>  " -B   -- read backwards through the range from offset (backwards N bytes)\n"
>  " -F   -- read forwards through the range of bytes from offset (default)\n"
>  " -v   -- be verbose, dump out buffers (used when reading forwards)\n"
> @@ -506,7 +507,7 @@ pread_init(void)
>  	pread_cmd.argmin = 2;
>  	pread_cmd.argmax = -1;
>  	pread_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> -	pread_cmd.args = _("[-b bs] [-v] [-i N] [-FBR [-Z N]] off len");
> +	pread_cmd.args = _("[-b bs] [-qv] [-i N] [-FBR [-Z N]] off len");
>  	pread_cmd.oneline = _("reads a number of bytes at a specified offset");
>  	pread_cmd.help = pread_help;
>  
> diff --git a/io/pwrite.c b/io/pwrite.c
> index 995f6ece..467bfa9f 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -27,6 +27,7 @@ pwrite_help(void)
>  " The writes are performed in sequential blocks starting at offset, with the\n"
>  " blocksize tunable using the -b option (default blocksize is 4096 bytes),\n"
>  " unless a different write pattern is requested.\n"
> +" -q   -- quiet mode, do not write anything to standard output.\n"
>  " -S   -- use an alternate seed number for filling the write buffer\n"
>  " -i   -- input file, source of data to write (used when writing forward)\n"
>  " -d   -- open the input file for direct IO\n"
> @@ -483,7 +484,7 @@ pwrite_init(void)
>  	pwrite_cmd.argmax = -1;
>  	pwrite_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
>  	pwrite_cmd.args =
> -_("[-i infile [-dDwNOW] [-s skip]] [-b bs] [-S seed] [-FBR [-Z N]] [-V N] off len");
> +_("[-i infile [-qdDwNOW] [-s skip]] [-b bs] [-S seed] [-FBR [-Z N]] [-V N] off len");
>  	pwrite_cmd.oneline =
>  		_("writes a number of bytes at a specified offset");
>  	pwrite_cmd.help = pwrite_help;
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index b9dcc312..d3eb3e7e 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -200,7 +200,7 @@ option will set the file permissions to read-write (0644). This allows xfs_io to
>  set up mismatches between the file permissions and the open file descriptor
>  read/write mode to exercise permission checks inside various syscalls.
>  .TP
> -.BI "pread [ \-b " bsize " ] [ \-v ] [ \-FBR [ \-Z " seed " ] ] [ \-V " vectors " ] " "offset length"
> +.BI "pread [ \-b " bsize " ] [ \-qv ] [ \-FBR [ \-Z " seed " ] ] [ \-V " vectors " ] " "offset length"
>  Reads a range of bytes in a specified blocksize from the given
>  .IR offset .
>  .RS 1.0i
> @@ -211,6 +211,9 @@ can be used to set the blocksize into which the
>  .BR read (2)
>  requests will be split. The default blocksize is 4096 bytes.
>  .TP
> +.B \-q
> +quiet mode, do not write anything to standard output.
> +.TP
>  .B \-v
>  dump the contents of the buffer after reading,
>  by default only the count of bytes actually read is dumped.
> @@ -241,7 +244,7 @@ See the
>  .B pread
>  command.
>  .TP
> -.BI "pwrite [ \-i " file " ] [ \-dDwNOW ] [ \-s " skip " ] [ \-b " size " ] [ \-S " seed " ] [ \-FBR [ \-Z " zeed " ] ] [ \-V " vectors " ] " "offset length"
> +.BI "pwrite [ \-i " file " ] [ \-qdDwNOW ] [ \-s " skip " ] [ \-b " size " ] [ \-S " seed " ] [ \-FBR [ \-Z " zeed " ] ] [ \-V " vectors " ] " "offset length"
>  Writes a range of bytes in a specified blocksize from the given
>  .IR offset .
>  The bytes written can be either a set pattern or read in from another
> @@ -254,6 +257,9 @@ allows an input
>  .I file
>  to be specified as the source of the data to be written.
>  .TP
> +.B \-q
> +quiet mode, do not write anything to standard output.
> +.TP
>  .B \-d
>  causes direct I/O, rather than the usual buffered
>  I/O, to be used when reading the input file.
> -- 
> 2.21.0
> 
> 
> 
