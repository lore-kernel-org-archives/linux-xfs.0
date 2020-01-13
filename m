Return-Path: <SRS0=9ni0=3C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 313C8C33CA9
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 17:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 030012075B
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 17:01:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fuOFpwVu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgAMRBX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 12:01:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41786 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727331AbgAMRBX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 12:01:23 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00DGxOae119475;
        Mon, 13 Jan 2020 17:01:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=DR889jPsFTs5Jr3fa1YEDAjY55QrZd7wjshESpRdDPs=;
 b=fuOFpwVuQzAwaqRnvdXY/tHcLriQEkWQQc66qU4Mtv4DgpjDkQNR+tgiM9/yK98YT4Uz
 BFruSBji174BlngGy6aRlNIAKsoAWtZWDtY2gWZUh3MXkdvqDntaQZ5uWpo/Mtmws6Iv
 xzKdMHPPNePGQR4Bk43t+LUGsLUSZq1fL5XG1LUEAGI8UP2CuRY3KBblgHMcRQMoRVna
 6r+mRYztufqLEQRBfpLG1tz8eoT0GYPHMsoqjafDjIYfMWfKUsefy+9rcwyNcdKSDpCY
 E0vgXyzjv47tlaREZ67Rc8dTMy2smhYvIRdNb5ttlZ7cnD22JV+SENWLXUMjXq2F4aXJ 0Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xf74s0a5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 17:01:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00DGxQkS103176;
        Mon, 13 Jan 2020 17:01:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xfrgj1rud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 17:01:10 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00DH15lW031176;
        Mon, 13 Jan 2020 17:01:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jan 2020 09:01:05 -0800
Date:   Mon, 13 Jan 2020 09:01:05 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: Fix xfs_dir2_sf_entry_t size check
Message-ID: <20200113170105.GF8247@magnolia>
References: <20200109141459.21808-1-vincenzo.frascino@arm.com>
 <c43539f2-aa9b-4afa-985c-c438099732ff@sandeen.net>
 <1a540ee4-6597-c79e-1bce-6592cb2f3eae@arm.com>
 <20200109165048.GB8247@magnolia>
 <435bcb71-9126-b1f1-3803-4977754b36ff@arm.com>
 <CAK8P3a0eY6Vm5PNdzR8Min9MrwAqH8vnMZ3C+pxTQhiFVNPyWA@mail.gmail.com>
 <20200113135800.GA8635@lst.de>
 <CAK8P3a0MZdDhY1DmdxjCSMXFqyu0G1ijsQdo7fmN9Ebxgr9cNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0MZdDhY1DmdxjCSMXFqyu0G1ijsQdo7fmN9Ebxgr9cNw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001130142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001130142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 13, 2020 at 03:06:50PM +0100, Arnd Bergmann wrote:
> On Mon, Jan 13, 2020 at 2:58 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > On Mon, Jan 13, 2020 at 02:55:15PM +0100, Arnd Bergmann wrote:
> > > With ARM OABI (which you get when EABI is disabled), structures are padded
> > > to multiples of 32 bits. See commits 8353a649f577 ("xfs: kill
> > > xfs_dir2_sf_off_t")
> > > and aa2dd0ad4d6d ("xfs: remove __arch_pack"). Those could be partially
> > > reverted to fix it again, but it doesn't seem worth it as there is
> > > probably nobody
> > > running XFS on OABI machines (actually with the build failure we can
> > > be fairly sure there isn't ;-).
> >
> > Or just try adding a __packed to the xfs_dir2_sf_entry definition?
> 
> Yes, that should be correct on all architectures, and I just noticed
> that this is what we already have on xfs_dir2_sf_hdr_t directly
> above it for the same reason.

Yeah, that sounds like a reasonable way forward, short of cleaning out
all the array[0] cr^Hode... ;)

To the original submitter: can you add __packed to the structure
definition and (assuming it passes oabi compilation) send that to the
list, please?

--D

> 
>        Arnd
