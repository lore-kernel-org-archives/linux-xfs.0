Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C174C3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 15:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1076F2469D
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 15:17:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A5kSCtXp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgB1PRR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 10:17:17 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36506 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgB1PRR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 10:17:17 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SF9WxB012141;
        Fri, 28 Feb 2020 15:17:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=/1BhB/mFVi+Ilab5UD3ockzEOGo5oyWsE0BE46RTHzg=;
 b=A5kSCtXptv32qsZXeD2xFA/CONE+VKcAiLCQM//9DIzrG/Tcl7HiK3BtxwuglxUKhB9U
 ljct5ASbfd3EAogmV/uIv3UXLxbvLWpNy9eN7HC2jmrXRw76ZC6qElSk/5PloMfjCD5l
 F/o2QVddsDh2AjpjX8S9koenY9zQwvoT7xodHkZZJAwIQgq3BojTQED8OiEGyM1K8/yi
 37ez2BZsuyeuKKpSH2cUujgIcsIL3Mc1RJihya7icdl1Pecb2RL7F8T1Nv2QGqWnYF2M
 KhMed38yz+i1LpJSo6P45LbY92YhHFT/kWd3t4FrfEtXcoh+bK3reI5UdusSxV+Nwixe BQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ydcsnuj4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 15:17:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SFEQA3042039;
        Fri, 28 Feb 2020 15:17:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ydj4r1sf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 15:17:13 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01SFHCBl003721;
        Fri, 28 Feb 2020 15:17:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 07:17:11 -0800
Date:   Fri, 28 Feb 2020 07:17:11 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] fstests: fix up filters & expected output for latest
 xfs_repair
Message-ID: <20200228151711.GU8045@magnolia>
References: <ea796af5-4f7e-e882-c918-b6ff9f10f91f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea796af5-4f7e-e882-c918-b6ff9f10f91f@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 08:50:49PM -0800, Eric Sandeen wrote:
> A handful of minor changes went into xfs_repair output in the
> last push, so add a few more filters and change the resulting
> expected output.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Rrrgh, guess who also had this patch lurking in his xfstests tree for so
long that he forgot it was there...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> I confirmed that xfs/030, xfs/033, and xfs/178 pass on both
> current for-next, as well as v5.4.0
> 
> diff --git a/common/repair b/common/repair
> index 5a9097f4..6668dd51 100644
> --- a/common/repair
> +++ b/common/repair
> @@ -29,7 +29,13 @@ _filter_repair()
>  # for sb
>  /- agno = / && next;	# remove each AG line (variable number)
>  s/(pointer to) (\d+)/\1 INO/;
> -s/(sb root inode value) (\d+)( \(NULLFSINO\))?/\1 INO/;
> +# Changed inode output in 5.5.0
> +s/sb root inode value /sb root inode /;
> +s/realtime bitmap inode value /realtime bitmap inode /;
> +s/realtime summary inode value /realtime summary inode /;
> +s/ino pointer to /inode pointer to /;
> +#
> +s/(sb root inode) (\d+)( \(NULLFSINO\))?/\1 INO/;
>  s/(realtime bitmap inode) (\d+)( \(NULLFSINO\))?/\1 INO/;
>  s/(realtime summary inode) (\d+)( \(NULLFSINO\))?/\1 INO/;
>  s/(inconsistent with calculated value) (\d+)/\1 INO/;
> @@ -74,6 +80,8 @@ s/(inode chunk) (\d+)\/(\d+)/AGNO\/INO/;
>  # sunit/swidth reset messages
>  s/^(Note - .*) were copied.*/\1 fields have been reset./;
>  s/^(Please) reset (with .*) if necessary/\1 set \2/;
> +# remove new unlinked inode test
> +/^bad next_unlinked/ && next;
>  # And make them generic so we dont depend on geometry
>  s/(stripe unit) \(.*\) (and width) \(.*\)/\1 (SU) \2 (SW)/;
>  # corrupt sb messages
> diff --git a/tests/xfs/030.out b/tests/xfs/030.out
> index 2b556eec..4a7c4b8b 100644
> --- a/tests/xfs/030.out
> +++ b/tests/xfs/030.out
> @@ -14,12 +14,12 @@ attempting to find secondary superblock...
>  found candidate secondary superblock...
>  verified secondary superblock...
>  writing modified primary superblock
> -sb root inode value INO inconsistent with calculated value INO
> +sb root inode INO inconsistent with calculated value INO
>  resetting superblock root inode pointer to INO
>  sb realtime bitmap inode INO inconsistent with calculated value INO
> -resetting superblock realtime bitmap ino pointer to INO
> +resetting superblock realtime bitmap inode pointer to INO
>  sb realtime summary inode INO inconsistent with calculated value INO
> -resetting superblock realtime summary ino pointer to INO
> +resetting superblock realtime summary inode pointer to INO
>  Phase 2 - using <TYPEOF> log
>          - zero log...
>          - scan filesystem freespace and inode maps...
> @@ -131,12 +131,12 @@ attempting to find secondary superblock...
>  found candidate secondary superblock...
>  verified secondary superblock...
>  writing modified primary superblock
> -sb root inode value INO inconsistent with calculated value INO
> +sb root inode INO inconsistent with calculated value INO
>  resetting superblock root inode pointer to INO
>  sb realtime bitmap inode INO inconsistent with calculated value INO
> -resetting superblock realtime bitmap ino pointer to INO
> +resetting superblock realtime bitmap inode pointer to INO
>  sb realtime summary inode INO inconsistent with calculated value INO
> -resetting superblock realtime summary ino pointer to INO
> +resetting superblock realtime summary inode pointer to INO
>  Phase 2 - using <TYPEOF> log
>          - zero log...
>          - scan filesystem freespace and inode maps...
> diff --git a/tests/xfs/178.out b/tests/xfs/178.out
> index 8e0fc8e1..0bebe553 100644
> --- a/tests/xfs/178.out
> +++ b/tests/xfs/178.out
> @@ -12,12 +12,12 @@ attempting to find secondary superblock...
>  found candidate secondary superblock...
>  verified secondary superblock...
>  writing modified primary superblock
> -sb root inode value INO inconsistent with calculated value INO
> +sb root inode INO inconsistent with calculated value INO
>  resetting superblock root inode pointer to INO
>  sb realtime bitmap inode INO inconsistent with calculated value INO
> -resetting superblock realtime bitmap ino pointer to INO
> +resetting superblock realtime bitmap inode pointer to INO
>  sb realtime summary inode INO inconsistent with calculated value INO
> -resetting superblock realtime summary ino pointer to INO
> +resetting superblock realtime summary inode pointer to INO
>  Phase 2 - using <TYPEOF> log
>          - zero log...
>          - scan filesystem freespace and inode maps...
> @@ -48,12 +48,12 @@ attempting to find secondary superblock...
>  found candidate secondary superblock...
>  verified secondary superblock...
>  writing modified primary superblock
> -sb root inode value INO inconsistent with calculated value INO
> +sb root inode INO inconsistent with calculated value INO
>  resetting superblock root inode pointer to INO
>  sb realtime bitmap inode INO inconsistent with calculated value INO
> -resetting superblock realtime bitmap ino pointer to INO
> +resetting superblock realtime bitmap inode pointer to INO
>  sb realtime summary inode INO inconsistent with calculated value INO
> -resetting superblock realtime summary ino pointer to INO
> +resetting superblock realtime summary inode pointer to INO
>  Phase 2 - using <TYPEOF> log
>          - zero log...
>          - scan filesystem freespace and inode maps...
> 
