Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D3BFCA9EB9
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 03:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB31120862
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 03:58:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r2LPFFgR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfJ2D6o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 23:58:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43258 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfJ2D6o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 23:58:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9T3t1nK183128;
        Tue, 29 Oct 2019 03:58:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=UYBvEhM01dE1PYclUWFQKX+8PyG3BmJmPceX/miPf/s=;
 b=r2LPFFgROn9tRxaWqsZeO/cMq4s0NIFAo5JA4V2m3KH469EA33fMzN6hSlNrCbNrPyAC
 PIW65a6LbpnbkNfJNXB0aQA+zSVxnOyx4iN6/kr2VWNT5SmQLIduyskik7JtzEv30vug
 k3/5fr+4/XZnOt7yps04g25+vcd5Mkaf0MhkDsbSw+JTCn12AktusuLqBLjJ+TCoCKWh
 gyLdFEQDRI8lSFX2kh+S7rOF1v+2uBF2eMX67L5cOuP3GFcwXcKj0W5cyojfeuQ9EPwy
 hLBwyYgJkbPPaka7aQaoDCqoZ9pE1nvUPU6aIpzMqMDwAfhLQw12XNIHvFXL2XK5cRp6 5Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vve3q61uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 03:58:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9T3mZmZ141765;
        Tue, 29 Oct 2019 03:58:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vwam06hkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 03:58:38 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9T3wWex022059;
        Tue, 29 Oct 2019 03:58:32 GMT
Received: from localhost (/10.159.156.71)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 20:58:32 -0700
Date:   Mon, 28 Oct 2019 20:58:31 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: softlockup with CONFIG_XFS_ONLINE_SCRUB enabled
Message-ID: <20191029035831.GE15221@magnolia>
References: <20191025102404.GA12255@lst.de>
 <20191027183232.GA15221@magnolia>
 <20191028073003.GA20274@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028073003.GA20274@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290041
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 28, 2019 at 08:30:03AM +0100, Christoph Hellwig wrote:
> On Sun, Oct 27, 2019 at 11:32:32AM -0700, Darrick J. Wong wrote:
> > On Fri, Oct 25, 2019 at 12:24:04PM +0200, Christoph Hellwig wrote:
> > > Hi Darrick,
> > > 
> > > the current xfs tree seems to easily cause sotlockups in generic/175
> > > (and a few other tests, but not as reproducible) for me.  This is on
> > > 20GB 4k block size images on a VM with 4 CPUs and 4G of RAM.
> > 
> > Hrm.  I haven't seen that before... what's your kernel config?
> > This looks like some kind of lockup in slub debugging...?
> > 
> > Also, is this a new thing?  Or something that used to happen with low
> > frequency but has slowly increased to the point that it's annoying?
> > 
> > (Or something else?)
> 
> Seems to happen with 5.3 as well.  I only recently turned
> CONFIG_XFS_ONLINE_SCRUB back on in my usual test config, that is what
> made it show up..
> 
> .config attached.

Aha, you have preempt disabled and slub debugging on by default, which
(on the million-extent files produced by generic/175) mean that scrub
takes long enough to trip the soft lockup watchdog while checking the
bmap.  The test eventually finishes, but the obvious(ly stupid) bandaid
of calling touch_softlockup_watchdog merely plunged the VM into
"rcu_sched self-detected stall on CPU" messages and as it's late I'll
set it aside until tomorrow.

IOWs I think I know what's going on but don't yet know how to fix it. :/

--D
