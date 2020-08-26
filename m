Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCF3DC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 15:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B196C2078A
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 15:44:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aX5U9db+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgHZPoI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 11:44:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52026 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgHZPoD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 11:44:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QFZIga078535;
        Wed, 26 Aug 2020 15:43:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=7IZJK6URUQHd8OVfAliA1LM97byCBE+AfVpKWgBle2c=;
 b=aX5U9db+/3TTdJTJ48VAd0Gqo22nHL3FJibF+1aTCWwd6XTfHZ+hnML8wjs5AxQx0jxA
 QSmL+xLdOQoHnsTa0tgG35VDYgnvIVapdbINQf0y3d5OORcAXVWJ4gpSlwBGGr9BS7AI
 51zgP0ez3aOX2p0mdx9lxK8fGZiRFk4nj5IqHIFA6t7H47DM7N3eK/AOlIwObSdc+e/G
 M15SE1oxNp/DYvYO7o/xPD9KElYCnvfNAPGTBeWvn/5jIi/rOsVufFQTWukOW9T+d7un
 i8pUinFZRK1GRfJ93gR4fOrWCdVCznggTDLng4TjNUN7sQKxGNoruazSCMadxEw/Tkv0 Dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 333w6tyt9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Aug 2020 15:43:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QFUefs125645;
        Wed, 26 Aug 2020 15:43:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 333ru09suu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Aug 2020 15:43:57 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07QFhumi029766;
        Wed, 26 Aug 2020 15:43:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 08:43:56 -0700
Date:   Wed, 26 Aug 2020 08:43:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix boundary test in xfs_attr_shortform_verify
Message-ID: <20200826154355.GO6096@magnolia>
References: <63722af5-2d8d-2455-17ee-988defd3126f@redhat.com>
 <20200825224144.GS12131@dread.disaster.area>
 <2210dced-9196-b42e-9205-4b9da3832553@sandeen.net>
 <20200826151300.GM6096@magnolia>
 <d3066453-6cc6-020e-426e-96d7d1a24164@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3066453-6cc6-020e-426e-96d7d1a24164@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008260116
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 10:39:26AM -0500, Eric Sandeen wrote:
> On 8/26/20 10:13 AM, Darrick J. Wong wrote:
> 
> ...
> 
> > TBH I think this ought to be fixed by changing the declaration of
> > xfs_attr_sf_entry.nameval to "uint8_t nameval[]" and using more modern
> > fugly macros like struct_sizeof() to calculate the entry sizes without
> > us all having to remember to subtract one from the struct size.
> 
> Fair, but I think that in the interest of time we should fix it up with a -1
> which is consistent with the other bits of attr code first, then this can all
> be cleaned up by making it a [] not [1], dropping the magical -1, turning
> the macros into functions ala dir2, etc.
> 
> Sound ok?

Yes.  sorry, I thought I was suggesting that we start with the quick -1
fix and move on to fixing the struct, but ENOCOFFEE and LPC sessions
start too early... :(

--d

> >> No.  I should do that, good point.  Now I do wonder if
> >>
> >>                 /*
> >>                  * Check that the variable-length part of the structure is
> >>                  * within the data buffer.  The next entry starts after the
> >>                  * name component, so nextentry is an acceptable test.
> >>                  */
> >>                 next_sfep = XFS_ATTR_SF_NEXTENTRY(sfep);
> >>                 if ((char *)next_sfep > endp)
> >>                         return __this_address;
> >>
> >> should be >= but I'll have to unravel all the macros to see.  In that case
> >> though the missing "=" makes it too lenient not too strict, at least.
> > 
> > *endp points to the first byte after the end of the buffer, because it
> > is defined as (*sfp + size).  The end of the last *sfep in the sf attr
> > struct is supposed to coincide with the end of the buffer, so changing
> > this to >= is not correct.
> 
> Let me think on that a little more ;)
> 
> -Eric
