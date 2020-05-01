Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82110C4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 18:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 554F624961
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 18:27:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PEECU9eT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbgEAS1y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 14:27:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56116 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729767AbgEAS1y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 14:27:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 041IJS3f055503;
        Fri, 1 May 2020 18:27:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=hZ0n9u0mp5PInDH9bKDcT12Jo7Qotdmw1Q++okcxn/k=;
 b=PEECU9eTE6La9nFVQcSzovK+2rEnkVclehvX/vEP2ENbSz0QbuYFwhwsc2At89g0uoDc
 jkRymMUoEODcsBIkY5lWX0RQLq53EpJvHWfrzlwor5XdSHcAYSZhEcEh9YRitJusuoLS
 KSGs2eWU3fucHkTpQuZEHap2CZBBYaVqOK4bYwGoP70QoiEGFxMk4gUf18/D35nmVljR
 iq7CGqPKtkIW+Viuow+BuwYmsmUpcqAGliFZaSpNwpVvzqUiVQRLegkW9oxL3gDFwK+v
 DryW8ap1b2Nj/WN0UuUaC8fD1hc+NTKFO6CPI9a0vSb0iqoAiiUINbivxigW7NH0O9NH Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30r7f5ugd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 18:27:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 041IGV71136162;
        Fri, 1 May 2020 18:25:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30r7f4mfkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 18:25:51 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 041IPnx6003046;
        Fri, 1 May 2020 18:25:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 May 2020 11:25:49 -0700
Date:   Fri, 1 May 2020 11:25:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Saravanan Shanmugham (sarvi)" <sarvi@cisco.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: Snapshot/Cloned workspace with changed file/directory ownership
 for all files in clone
Message-ID: <20200501182548.GZ6742@magnolia>
References: <DE682B09-7215-41EB-9D1F-25BFB41410E5@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DE682B09-7215-41EB-9D1F-25BFB41410E5@cisco.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 clxscore=1011 phishscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 05:40:45PM +0000, Saravanan Shanmugham (sarvi) wrote:
> One use case for "cloned" workspaces or "seeded" workspaces, is "prebuilt workspaces" for very large builds.
> 
> What would it take to add this capability to the xfs roadmap? This would be very usefull.
> 
> Our use case is as following
>    1. Our fully built software build workspaces can be 800GB+
>    2. We have a nightly build that builds the whole workspace 800GB, done by a generic user "buildusr"
>    3. We then snapshot that workspace with xfs snapshotting capability.

What xfs snapshotting 'capability' is that?

Or, since you've already asked this on the btrfs list, chown -R the
directory tree after you receive the fs image from the build system.

(Maybe the answer you want is shiftfs...)

--D

>    3. We want the developer, "sarvi", to be able to clone from that snapshot and be able to incremental software build and development in the cloned workspace or the seeded filesystem/workspace.
> 
> Problem: 
> All the content, files, directories in the cloned workspace are still owned by "buildusr" and not "sarvi", which causes my builds to fail with permission problems.
> Is there anything in xfs that can help. 
> For that matter any of the open source filesystems support seeding or snapshot/cloning that you might be aware of.
> 
> So far the only filesystem that seems have the capability map/change the file ownership as part of the clone operation is Netapp. 
> And unfortunately that isn’t open source and wont serve our purpose.
> 
>  
> Thanks,
> Sarvi
> Occam’s Razor Rules
> 
