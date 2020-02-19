Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF95C5ACC4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 22:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5120B24670
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 22:01:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pvHTGM5z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgBSWBX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 17:01:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33598 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgBSWBW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 17:01:22 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01JM107i040771;
        Wed, 19 Feb 2020 22:01:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=0kuFK854nQQye3G1yeMWluWNHU6Ca0QKGKTvXcx1+Mk=;
 b=pvHTGM5zeEpKMASBIFayCNMfUTVItpj4r0wpdFLFydZ0Z2H+GBA2gz6oztzPZARS9xZI
 PwstxDVx36O0Fs42d6wHoDkU49gZQ4gd4gdVOESF5ZFoM8NaemOvRkou8LMhjorFXzs6
 4Q/NnEALsGD7AJaPCljwjR9IyYFJbmvfG/g7yq33ZyCgxrm9cBLRiWEulhORsDRNnMPS
 fHpRSTPahVo1Z1nFhRuaJv+Yuw70852SEIhZmwWNsFG3yFjsNiW+LzhnMlL2cYN9qdwl
 shqrh8RmNxr/qi0r5PK+PmDbG2TxFIjufD/A8FyX5S7IV2lqgTkC03mjV1SDrw/9zpft Lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2y8udd64p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 22:01:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01JLvmQJ195005;
        Wed, 19 Feb 2020 22:01:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2y8ud23f5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 22:01:06 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01JM15E2017457;
        Wed, 19 Feb 2020 22:01:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 14:01:05 -0800
Date:   Wed, 19 Feb 2020 14:01:04 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Richard Wareing <rwareing@fb.com>, linux-xfs@vger.kernel.org,
        Anthony Iliopoulos <ailiopoulos@suse.de>,
        Yong Sun <YoSun@suse.com>
Subject: Re: Modern uses of CONFIG_XFS_RT
Message-ID: <20200219220104.GE9504@magnolia>
References: <20200219135715.GZ30113@42.do-not-panic.com>
 <20200219143227.aavgzkbuazttpwky@andromeda>
 <20200219143824.GR11244@42.do-not-panic.com>
 <20200219170945.GN9506@magnolia>
 <20200219175502.GS11244@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219175502.GS11244@42.do-not-panic.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:55:02PM +0000, Luis Chamberlain wrote:
> On Wed, Feb 19, 2020 at 09:09:45AM -0800, Darrick J. Wong wrote:
> > On Wed, Feb 19, 2020 at 02:38:24PM +0000, Luis Chamberlain wrote:
> > > On Wed, Feb 19, 2020 at 03:32:27PM +0100, Carlos Maiolino wrote:
> > > > On Wed, Feb 19, 2020 at 01:57:15PM +0000, Luis Chamberlain wrote:
> > > > > I hear some folks still use CONFIG_XFS_RT, I was curious what was the
> > > > > actual modern typical use case for it. I thought this was somewhat
> > > > > realted to DAX use but upon a quick code inspection I see direct
> > > > > realtionship.
> > > > 
> > > > Hm, not sure if there is any other use other than it's original purpose of
> > > > reducing latency jitters. Also XFS_RT dates way back from the day DAX was even a
> > > > thing. But anyway, I don't have much experience using XFS_RT by myself, and I
> > > > probably raised more questions than answers to yours :P
> > > 
> > > What about another question, this would certainly drive the users out of
> > > the corners: can we remove it upstream?
> > 
> > My DVR and TV still use it to record video data.
> 
> Is anyone productizing on that though?
> 
> I was curious since most distros are disabling CONFIG_XFS_RT so I was
> curious who was actually testing this stuff or caring about it.

Most != All.  We enabled it here, for development of future products.

> > I've also been pushing the realtime volume for persistent memory devices
> > because you can guarantee that all the expensive pmem gets used for data
> > storage, that the extents will always be perfectly aligned to large page
> > sizes, and that fs metadata will never defeat that alignment guarantee.
> 
> For those that *are* using XFS in production with realtime volume with dax...
> I wonder whatcha doing about all these tests on fstests which we don't
> have a proper way to know if the test succeeded / failed [0] when an
> external logdev is used, this then applies to regular external log dev
> users as well [1].

Huh?  How did we jump from realtime devices to external log files?

> Which makes me also wonder then, what are the typical big users of the
> regular external log device?
> 
> Reviewing a way to address this on fstests has been on my TODO for
> a while, but it begs the question of how much do we really care first.
> And that's what I was really trying to figure out.
> 
> Can / should we phase out external logdev / realtime dev? Who really is
> caring about this code these days?

Not many, I guess. :/

There seem to be a lot more tests these days that use dmflakey on the
data device to simulate a temporary disk failure... but those aren't
going to work for external log devices because they seem to assume that
what we call the data device is also the log device.

--D

> [0] https://github.com/mcgrof/oscheck/blob/master/expunges/linux-next-xfs/xfs/unassigned/xfs_realtimedev.txt
> [1] https://github.com/mcgrof/oscheck/blob/master/expunges/linux-next-xfs/xfs/unassigned/xfs_logdev.txt
> 
>   Luis
