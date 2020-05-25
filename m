Return-Path: <SRS0=1/fZ=7H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC4FC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 May 2020 06:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 787172071A
	for <linux-xfs@archiver.kernel.org>; Mon, 25 May 2020 06:08:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q1Zop2oN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgEYGIQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 May 2020 02:08:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33926 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgEYGIP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 May 2020 02:08:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04P621EH062217;
        Mon, 25 May 2020 06:08:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=BAKZis/ST/EocxNsZQqpJJMMmheS0IxSkj0K1u/zdqk=;
 b=q1Zop2oN3mFPgegVoopJ9GxyiQF8/VJOhPLn+/wWI5UQ3JzlEpkYBhVuNNfqbldz/RIi
 jc5Pg8XzaMUNM3QdhIPSuEEzQIynzt+gmhMSTP3yyoVsR3Xc8d9WCc6zaS6s9c2+X6ze
 VYfgS1nh/C6IbMz/ZXwVBHyeTgiYpF0TapxA4Go+jylwuq3Oh0UwKXTU6lJQMTkjQcRl
 xQTuQYobjNmf8m7zJbWxHRGGeboFYdsESf2zS3QJq0Ar9weZebSrZh5JwAFZlFQHfteO
 mQ9DakIcCvMGU7BiZbdKiOOuhhK+QvMWUsE+WTBeL4Z+pLPqEPtsEsExvqgwskAtu4CM Kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 316uskm514-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 25 May 2020 06:08:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04P63RsR141347;
        Mon, 25 May 2020 06:08:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 317dkq1d9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 May 2020 06:08:12 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04P686YP012375;
        Mon, 25 May 2020 06:08:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 24 May 2020 23:08:06 -0700
Date:   Sun, 24 May 2020 23:08:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Emmanuel Florac <eflorac@intellique.com>, linux-xfs@vger.kernel.org
Subject: Re: [XFS SUMMIT] Deprecating V4 on-disk format
Message-ID: <20200525060804.GC252930@magnolia>
References: <20200513023618.GA2040@dread.disaster.area>
 <20200519062338.GH17627@magnolia>
 <20200520011430.GS2040@dread.disaster.area>
 <20200520151510.11837539@harpe.intellique.com>
 <20200525032354.GV2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200525032354.GV2040@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9631 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=1 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005250050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9631 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 lowpriorityscore=0
 suspectscore=1 spamscore=0 priorityscore=1501 clxscore=1011
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 cotscore=-2147483648 adultscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005250050
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 25, 2020 at 01:23:54PM +1000, Dave Chinner wrote:
> On Wed, May 20, 2020 at 03:15:10PM +0200, Emmanuel Florac wrote:
> > Le Wed, 20 May 2020 11:14:30 +1000
> > Dave Chinner <david@fromorbit.com> écrivait:
> > 
> > > Well, there's a difference between what a distro that heavily
> > > patches the upstream kernel is willing to support and what upstream
> > > supports. And, realistically, v4 is going to be around for at least
> > > one more major distro release, which means the distro support time
> > > window is still going to be in the order of 15 years.
> > 
> > IIRC, RedHat/CentOS v.7.x shipped with a v5-capable mkfs.xfs, but
> > defaulted to v4. That means that unless you were extremely cautious
> > (like I am :) 99% of RH/COs v7 will be running v4 volumes for the
> > coming years. How many years, would you ask?
> 
> Largely irrelevant to the question at hand, as support is dependent
> on the distro lifecycle here. Essentially whatever is in RHEL7 is
> supported by RH until the end of it's life.
> 
> In RHEL8, we default to v5 filesystems, but fully support v4. That
> will be the case for the rest of it's life. Unless the user
> specifically asks for it, no new v4 filesystems are being created on
> current RHEL releases.
> 
> If we were to deprecate v4 now, then it will be marked as deprecated
> in the next major RHEL release. That means it's still fully
> supported in that release for it's entire life, but it will be
> removed in the next major release after that. So we are still
> talking about at least 15+ years of enterprise distro support for
> the format, even if upstream drops it sooner...

We probably ought to do it sooner than later though, particularly if we
think/care about 5.9 turning into an LTS.

> > As for the lifecycle of a filesystem, I just ended support on a 40 TB
> > archival server I set up back in 2007. I still have a number of
> > supported systems from the years 2008-2010, and about a hundred from
> > 2010-2013. That's how reliable XFS is, unfortunately :)
> 
> Yup, 10-15 years is pretty much the expected max life of storage
> systems before the hardware really needs to be retired. We made v5
> the default 5 years ago, so give it another 10 years (the sort of
> timeframe we are talking about here) and just about
> everything will be running v5 and that's when v4 can likely be
> dropped.
> 
> The other thing to consider is that we need to drop v4 before we get
> to y2038 support issues as the format will never support dates
> beyond that. Essentially, we need to have the deprecation discussion
> and take action in the near future so that people have stopped using
> it before y2038 comes along and v4 filesystems break everything.
> 
> Not enough people think long term when it comes to computers - it
> should be more obvious now why I brought this up for discussion...

Ok then, who would like to help me get the y2038 timestamp patches
reviewed for ~5.9? :D

(Anyone; not necessarily Dave)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
