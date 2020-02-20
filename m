Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A153C5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 02:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D07E821D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 02:04:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Iv90TMVn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgBTCEK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 21:04:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56762 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727280AbgBTCEK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 21:04:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K23wAQ030191;
        Thu, 20 Feb 2020 02:03:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=KfD3ubTvRToUwigqxHUFxZOJZZMGtVbdMJIiX32ndHk=;
 b=Iv90TMVnV04L45b8Zig9NbyLZm+cZ7Zfs59SF/vF++pd8oAQLEiucs2qucDRZqJG7Mha
 KjQDeyTlXo8aoXxmkLbexcawvzkYnR3YPjZQPkGFA4nRP8STXP+NOFqJWS9/fDTZslen
 K6ib1iDcnhBCrGiz5VCpUcoZByhMR1AGSE2kiCOy0GDaUR83QsE5brZpk+6ZRelOXn2p
 MIuelc+EE9jE0x3wMozu6dVYy7Pk457kmY+o9lNULE4EaqSmup+ghRfBBWqQXiLoMGuZ
 lyw4ExOgO+i7bNic1sPKUDw59PxMgn3s3/mfCjNHxVnNMzV5eIcBU2mrtzQHa91laSmN qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2y8udkeuxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 02:03:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K21mD3042342;
        Thu, 20 Feb 2020 02:03:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2y8ud4qrxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 02:03:57 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01K23uOo006155;
        Thu, 20 Feb 2020 02:03:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 18:03:55 -0800
Date:   Wed, 19 Feb 2020 18:03:54 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Richard Wareing <rwareing@fb.com>, linux-xfs@vger.kernel.org,
        Anthony Iliopoulos <ailiopoulos@suse.de>,
        Yong Sun <YoSun@suse.com>
Subject: Re: Modern uses of CONFIG_XFS_RT
Message-ID: <20200220020354.GR9506@magnolia>
References: <20200219135715.GZ30113@42.do-not-panic.com>
 <20200219143227.aavgzkbuazttpwky@andromeda>
 <20200219143824.GR11244@42.do-not-panic.com>
 <20200219170945.GN9506@magnolia>
 <20200219175502.GS11244@42.do-not-panic.com>
 <20200219220104.GE9504@magnolia>
 <20200220001729.GT11244@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220001729.GT11244@42.do-not-panic.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 12:17:29AM +0000, Luis Chamberlain wrote:
> On Wed, Feb 19, 2020 at 02:01:04PM -0800, Darrick J. Wong wrote:
> > On Wed, Feb 19, 2020 at 05:55:02PM +0000, Luis Chamberlain wrote:
> > > On Wed, Feb 19, 2020 at 09:09:45AM -0800, Darrick J. Wong wrote:
> > > > On Wed, Feb 19, 2020 at 02:38:24PM +0000, Luis Chamberlain wrote:
> > > > > On Wed, Feb 19, 2020 at 03:32:27PM +0100, Carlos Maiolino wrote:
> > > > > > On Wed, Feb 19, 2020 at 01:57:15PM +0000, Luis Chamberlain wrote:
> > > > > > > I hear some folks still use CONFIG_XFS_RT, I was curious what was the
> > > > > > > actual modern typical use case for it. I thought this was somewhat
> > > > > > > realted to DAX use but upon a quick code inspection I see direct
> > > > > > > realtionship.
> > > > > > 
> > > > > > Hm, not sure if there is any other use other than it's original purpose of
> > > > > > reducing latency jitters. Also XFS_RT dates way back from the day DAX was even a
> > > > > > thing. But anyway, I don't have much experience using XFS_RT by myself, and I
> > > > > > probably raised more questions than answers to yours :P
> > > > > 
> > > > > What about another question, this would certainly drive the users out of
> > > > > the corners: can we remove it upstream?
> > > > 
> > > > My DVR and TV still use it to record video data.
> > > 
> > > Is anyone productizing on that though?
> > > 
> > > I was curious since most distros are disabling CONFIG_XFS_RT so I was
> > > curious who was actually testing this stuff or caring about it.
> > 
> > Most != All.  We enabled it here, for development of future products.
> 
> Ah great to know, thanks!
> 
> > > > I've also been pushing the realtime volume for persistent memory devices
> > > > because you can guarantee that all the expensive pmem gets used for data
> > > > storage, that the extents will always be perfectly aligned to large page
> > > > sizes, and that fs metadata will never defeat that alignment guarantee.
> > > 
> > > For those that *are* using XFS in production with realtime volume with dax...
> > > I wonder whatcha doing about all these tests on fstests which we don't
> > > have a proper way to know if the test succeeded / failed [0] when an
> > > external logdev is used, this then applies to regular external log dev
> > > users as well [1].
> > 
> > Huh?  How did we jump from realtime devices to external log files?
> 
> They share the same problem with fstests when using an alternative log
> device, which I pointed out on [0] and [1].
> 
> [0] https://github.com/mcgrof/oscheck/blob/master/expunges/linux-next-xfs/xfs/unassigned/xfs_realtimedev.txt
> [1] https://github.com/mcgrof/oscheck/blob/master/expunges/linux-next-xfs/xfs/unassigned/xfs_logdev.txt
> 
> > > Which makes me also wonder then, what are the typical big users of the
> > > regular external log device?
> > > 
> > > Reviewing a way to address this on fstests has been on my TODO for
> > > a while, but it begs the question of how much do we really care first.
> > > And that's what I was really trying to figure out.
> > > 
> > > Can / should we phase out external logdev / realtime dev? Who really is
> > > caring about this code these days?
> > 
> > Not many, I guess. :/
> > 
> > There seem to be a lot more tests these days that use dmflakey on the
> > data device to simulate a temporary disk failure... but those aren't
> > going to work for external log devices because they seem to assume that
> > what we call the data device is also the log device.
> 
> That goes to show that the fstests assumption on a shared data/log device was
> not only a thing of the past, its still present, and unless we address
> soon, the gap will only get bigger.
> 
> OK thanks for the feedback. The situation in terms of testing rtdev or
> external logs seems actually worse than I expected given the outlook for
> the future and no one seeming to really care too much right now. If the
> dax folks didn't care, then the code will likely just bit rot even more.
> Is it too nutty for us to consider removing it as a future goal?

Yes.  You just jumped from "I haven't had time to triage these failing
tests" straight to ripping out code.  Analyze the failures, fix the
tests that weren't designed flexibly enough to handle, and we'll discuss
the ones that aren't easily changed.

--D

>   Luis
