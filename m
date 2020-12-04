Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1F7C4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 21:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 460A922BE8
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 21:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbgLDVhU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 16:37:20 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33600 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727906AbgLDVhT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 16:37:19 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4LZ7gI108461;
        Fri, 4 Dec 2020 21:36:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=w2kOfQd6yP23oo1ZSaBAU4YKlvuyWwKPdHy+PuJrnww=;
 b=K/RpR/+wO8WOBtoKoCrfnf+h2WcRdbiD5fdouX3yJTj4lhuHaE1csek4nSWEHnXcYMsu
 QqQOnW/oS5p6IgoTxjMtk2fgPxtT9TZuCcPMW1MjUjf+yB8cXc08bXV7xQLK9TJxqKTm
 CGpViQNUZ+1NBU1qwavP+EFt7QB8i6TgGlIFI+Av3XGD1r7fjbc+z4SWxurKuwPX9EFr
 8L9qDYHXSWu32OmCTeo+HBlrbYNmslUsPWBvnvjXQmogAUbL11z+LhMZmFOLFXvqtwEw
 rVvYyLUcdNjCOvTG9TZH7SCXJpAehvk5qDydzvhaV1lyHVwgDwN2QdI10RZqPGjf1/lb Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 353c2bd9wt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 21:36:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4LaHjJ120727;
        Fri, 4 Dec 2020 21:36:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3540f3urxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 21:36:35 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B4LaXw3003782;
        Fri, 4 Dec 2020 21:36:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Dec 2020 13:36:33 -0800
Date:   Fri, 4 Dec 2020 13:36:32 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: define a new "needrepair" feature
Message-ID: <20201204213632.GG629293@magnolia>
References: <160679383892.447856.12907477074923729733.stgit@magnolia>
 <160679385127.447856.3129099457617444604.stgit@magnolia>
 <20201201161812.GD1205666@bfoster>
 <2a5ce5a2-9df4-5c19-13d3-f0a16d8030ba@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a5ce5a2-9df4-5c19-13d3-f0a16d8030ba@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=1 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040122
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 04, 2020 at 02:07:49PM -0600, Eric Sandeen wrote:
> On 12/1/20 10:18 AM, Brian Foster wrote:
> > On Mon, Nov 30, 2020 at 07:37:31PM -0800, Darrick J. Wong wrote:
> >> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>
> >> Define an incompat feature flag to indicate that the filesystem needs to
> >> be repaired.  While libxfs will recognize this feature, the kernel will
> >> refuse to mount if the feature flag is set, and only xfs_repair will be
> >> able to clear the flag.  The goal here is to force the admin to run
> >> xfs_repair to completion after upgrading the filesystem, or if we
> >> otherwise detect anomalies.
> >>
> >> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >> ---
> > IIUC, we're using an incompat bit to intentionally ensure the filesystem
> > cannot mount, even on kernels that predate this particular "needs
> > repair" feature. The only difference is that an older kernel would
> > complain about an unknown feature and return a different error code.
> > Right?
> > 
> > That seems reasonable, but out of curiousity is there a need/reason for
> > using an incompat bit over an ro_compat bit?
> 
> I'm a fan of a straight-up incompat, because we don't really know what
> format changes in the future might require this flag to be set; nothing
> guarantees that future changes will be ro-compat-safe, right?

Correct.  In the case of the inobtcount upgrade, we know that the
inobt/finobt blockcounts in the AGI are zero (and thus wrong) right
after the upgrade.  If we made it a rocompat bit then we'd allow ro
mounts but we'd also have to be careful to prohibit a ro->rw remount,
at which point the admin gets a Big Surprise.

Why not just make the admin repair the system right then and there?
I mean, xfs_admin is already going to run repair anyway, so in practice
there shouldn't be that many people trying to push an "upgraded but
needs repair" fs at the kernel anyway.

--D

> -Eric
