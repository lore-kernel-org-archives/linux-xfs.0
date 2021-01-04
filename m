Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73120C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 19:34:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3908C21919
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 19:34:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbhADTe3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 14:34:29 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51094 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbhADTe3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 14:34:29 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104JPLjP132185;
        Mon, 4 Jan 2021 19:33:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=OC9ZKwZlBqqXKy4s1FTTtfns0YEdBFdfj/ftzGDK5p0=;
 b=wouS3dL5eg6lYpeY/lbbMFkTHPbu1Av5Q4VCOTxEgfe4Hc2e6oe4rEVxIzsskqAjIPff
 +p/6tluFs26wVO9qCONeC7FtqvpbzQUvL562+ocMtVRwdKkZ3FXzVbrWUcdeHwh5xDqW
 IrlzzMPNyWoe5BM8VVm0Dxt+ui6aaSR2N6jWKMCL8LTfc1+OqX0u9S+ptENULv0PV4x5
 gwlfJYb011/CAbd4xZS8dOir1zpwBUmL43Z/bSQ3qcEDAvsNqN7+lEAlNCQ/ZwQqaa5F
 6ZDEj2262Mxk+ZwDH62QKwNGcZSWJDspzUkCzvVL7RfG/TFmUY4Ec5NiQ8NrfZf9CYhw Hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35tebanyb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 04 Jan 2021 19:33:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104JQKo2006714;
        Mon, 4 Jan 2021 19:31:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 35v2axm7fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Jan 2021 19:31:45 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 104JVhJM000556;
        Mon, 4 Jan 2021 19:31:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Jan 2021 19:31:43 +0000
Date:   Mon, 4 Jan 2021 11:31:42 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: make inobtcount visible
Message-ID: <20210104193142.GN6918@magnolia>
References: <20210104113006.328274-1-zlang@redhat.com>
 <3c682608-3ba8-83bb-8d16-49c798e7258c@sandeen.net>
 <3194df4e-267f-8fb1-c183-ead1d4080c85@sandeen.net>
 <20210104185754.GI14354@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104185754.GI14354@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101040123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101040123
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 05, 2021 at 02:57:54AM +0800, Zorro Lang wrote:
> On Mon, Jan 04, 2021 at 10:29:21AM -0600, Eric Sandeen wrote:
> > 
> > 
> > On 1/4/21 9:28 AM, Eric Sandeen wrote:
> > > On 1/4/21 5:30 AM, Zorro Lang wrote:
> > >> When set inobtcount=1/0, we can't see it from xfs geometry report.
> > >> So make it visible.
> > >>
> > >> Signed-off-by: Zorro Lang <zlang@redhat.com>
> > > Hi Zorro - thanks for spotting this.
> > > 
> > > I think the libxfs changes need to hit the kernel first, then we can
> > > pull it in and fix up the report_geom function.  Nothing calls
> > > xfs_fs_geometry directly in userspace, FWIW.
> > 
> > Hah, of course I forgot about libxfs_fs_geometry. o_O
> > 
> > In any case, I think this should hit the kernel first, want to send
> > that patch if it's not already on the list?
> 
> I can give it a try, if Darrick haven't had one in his developing list :)

Why do we need to expose INOBTCNT/inobtcount via the geometry ioctl?
It doesn't expose any user-visible functionality.

--D

> Thanks,
> Zorro
> 
> > 
> > -Eric
> > 
> > > Thanks,
> > > -Eric
> > > 
> > 
> 
