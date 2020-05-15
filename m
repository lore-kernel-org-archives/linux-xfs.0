Return-Path: <SRS0=g8AD=65=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B74C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 21:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BCE2205CB
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 21:10:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bsxe+0jz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgEOVKS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 May 2020 17:10:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44300 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgEOVKR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 May 2020 17:10:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FL7KEi090919;
        Fri, 15 May 2020 21:10:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=aC+Cqnpzn+jxUeAe4dqVLwrXH0VkD6IP68HxcKCLzm0=;
 b=Bsxe+0jzbRgSi72L3b3Gm38CCHjkC9s54B1NIevD5If21v9Ha+4tz62+z+CmivdJz7EH
 2e5dJ8G/bViWMiuV40ZQFAAB+cNuWtAYis19piuOCTGFGiylX5Zi8PSV66etNFoItrqc
 UfrduU94Rrce44PDb9zdfu4I7XK36aIY9wayL7VJz6HBDyDeD/LnRZwwS6GS2vuzvD0x
 VhqnfqxHzl5QvcGcAdw57E8FmhYOgTapOb1+ABtdW6PFLODDo9nCHHDaTigItPQ2e1/D
 w/DoCziL08eq+X0/TRHbR9kZU0bcfczgebTYm96x4YBB4HDF7Mtoqqsanzt64PtkwHO5 Bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 311nu5nygk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 21:10:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FL8pAu134264;
        Fri, 15 May 2020 21:10:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3100ys83k5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 21:10:14 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04FLADoC019779;
        Fri, 15 May 2020 21:10:13 GMT
Received: from localhost (/10.159.241.121)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 May 2020 14:10:12 -0700
Date:   Fri, 15 May 2020 14:10:11 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] mkfs.xfs: sanity check stripe geometry from blkid
Message-ID: <20200515211011.GP6714@magnolia>
References: <a673fbd3-5038-2dc8-8135-a58c24042734@redhat.com>
 <20200515204802.GO6714@magnolia>
 <49e3d73f-1df1-e4d3-2451-db76f7084731@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49e3d73f-1df1-e4d3-2451-db76f7084731@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9622 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=1
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9622 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 suspectscore=1 spamscore=0 lowpriorityscore=0 cotscore=-2147483648
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150176
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 15, 2020 at 03:54:34PM -0500, Eric Sandeen wrote:
> On 5/15/20 3:48 PM, Darrick J. Wong wrote:
> > On Fri, May 15, 2020 at 02:14:17PM -0500, Eric Sandeen wrote:
> >> We validate commandline options for stripe unit and stripe width, and
> >> if a device returns nonsensical values via libblkid, the superbock write
> >> verifier will eventually catch it and fail (noisily and cryptically) but
> >> it seems a bit cleaner to just do a basic sanity check on the numbers
> >> as soon as we get them from blkid, and if they're bogus, ignore them from
> >> the start.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> diff --git a/libfrog/topology.c b/libfrog/topology.c
> >> index b1b470c9..38ed03b7 100644
> >> --- a/libfrog/topology.c
> >> +++ b/libfrog/topology.c
> >> @@ -213,6 +213,19 @@ static void blkid_get_topology(
> >>  	val = blkid_topology_get_optimal_io_size(tp);
> >>  	*swidth = val;
> >>  
> >> +        /*

Tabs not spaces

> >> +	 * Occasionally, firmware is broken and returns optimal < minimum,
> >> +	 * or optimal which is not a multiple of minimum.
> >> +	 * In that case just give up and set both to zero, we can't trust
> >> +	 * information from this device. Similar to xfs_validate_sb_common().
> >> +	 */
> >> +        if (*sunit) {
> >> +                if ((*sunit > *swidth) || (*swidth % *sunit != 0)) {

Why not combine these?

if (*sunit != 0 && (*sunit > *swidth || *swidth % *sunit != 0)) {

Aside from that the code looks fine I guess...

> > I feel like we're copypasting this sunit/swidth checking logic all over
> > xfsprogs 
> 
> That's because we are!
> 
> > and yet we're still losing the stripe unit validation whackamole
> > game.
> 
> Need moar hammers!
> 
> > In the end, we want to check more or less the same things for each pair
> > of stripe unit and stripe width:
> > 
> >  * integer overflows of either value
> >  * sunit and swidth alignment wrt sector size
> >  * if either sunit or swidth are zero, both should be zero
> >  * swidth must be a multiple of sunit
> > 
> > All four of these rules apply to the blkid_get_toplogy answers for the
> > data device, the log device, and the realtime device; and any mkfs CLI
> > overrides of those values.
> > 
> > IOWs, is there some way to refactor those four rules into a single
> > validation function and call that in the six(ish) places we need it?
> > Especially since you're the one who played the last round of whackamole,
> > back in May 2018. :)
> 
> So .... I would like to do that refactoring.  I'd also like to fix this
> with some expediency, TBH...
> 
> Refactoring is going to be a little more complicated, I fear, because sanity
> on "what came straight from blkid" is a little different from "what came from
> cmdline" and has slightly different checks than "how does it fit into the
> superblock we just read?"

Admittedly I wondered if "refactor all these checks" would fall apart
because each tool has its own slightly different reporting and logging
requirements.  You could make a checker function return an enum of what
it's mad about and each caller could either have a message catalogue or
just bail depending on the circumstances, but now I've probably
overengineered the corner case catching code.

> This (swidth-vs-sunit-is-borken) is common enough that I wanted to just kill
> it with fire, and um ... make it all better/cohesive at some later date.
> 
> I don't like arguing for expediency over beauty but well... here I am.

:(

--D

> -Eric
> 
> > --D
> > 
> >> +                        *sunit = 0;
> >> +                        *swidth = 0;
> >> +                }
> >> +        }
> >> +
> >>  	/*
> >>  	 * If the reported values are the same as the physical sector size
> >>  	 * do not bother to report anything.  It will only cause warnings
> >>
> > 
> 
