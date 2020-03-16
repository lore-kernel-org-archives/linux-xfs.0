Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82041C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 22:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45FCC2071C
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 22:01:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N5clBcDU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732724AbgCPWBS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 18:01:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43888 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732652AbgCPWBS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 18:01:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GLci2b078645;
        Mon, 16 Mar 2020 22:01:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=LL3TfUCPhwkpHKdHzdut/mtgdm5pm5f91pl4s0obFG8=;
 b=N5clBcDUeH99vjFX1i/PxlTLrRf0lyxEOmgMELtKiagwl1RP9PN0dbRzDgTbXBuxp8r6
 iPHhuTnOdKzM7PDhKlPjLbc+igToAA0EHCGdrApYxGMxbCiq5vv8zOVxnEAnbUviX6tW
 Bx3t+DQn599UbAgpXSjDLmY8neDiG4Al4YX8r5Q+vBdtaPLA4Qck5o31EUDETBPzyFmZ
 H04VrdtVKcQKLi1zzVk9zcAtyhVnIAAehvXvrnbG09oDEszy8eGspcyTYVvR5DSVTzvT
 xMu+/e6hK36nXZ0TBH2HtcnaMGP/efrFXo/V8vS0nDacGY99GaNfcAmn6GFs+3HdWKMi Sg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yrq7ksg63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 22:01:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GLohL8059799;
        Mon, 16 Mar 2020 21:59:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ys8tqgvc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:59:15 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02GLxEof024402;
        Mon, 16 Mar 2020 21:59:14 GMT
Received: from localhost (/10.159.132.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 14:59:14 -0700
Date:   Mon, 16 Mar 2020 14:59:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Ober, Frank" <frank.ober@intel.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: write atomicity with xfs ... current status?
Message-ID: <20200316215913.GV256767@magnolia>
References: <MW3PR11MB46974637E20D2ED949A7A47E8BF90@MW3PR11MB4697.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MW3PR11MB46974637E20D2ED949A7A47E8BF90@MW3PR11MB4697.namprd11.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160089
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1011
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160089
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 08:59:54PM +0000, Ober, Frank wrote:
> Hi, Intel is looking into does it make sense to take an existing,
> popular filesystem and patch it for write atomicity at the sector
> count level. Meaning we would protect a configured number of sectors
> using parameters that each layer in the kernel would synchronize on.
>  We could use a parameter(s) for this that comes from the NVMe
> specification such as awun or awunpf

<gesundheit>

Oh, that was an acronym...

> that set across the (affected)
> layers to a user space program such as innodb/MySQL which would
> benefit as would other software. The MySQL target is a strong use
> case, as its InnoDB has a double write buffer that could be removed if
> write atomicity was protected at 16KiB for the file opens and with
> fsync(). 

We probably need a better elaboration of the exact usecases of atomic
writes since I haven't been to LSF in a couple of years (and probably
not this year either).  I can think of a couple of access modes off the
top of my head:

1) atomic directio write where either you stay under the hardware atomic
write limit and we use it, or...

2) software atomic writes where we use the xfs copy-on-write mechanism
to stage the new blocks and later map them back into the inode, where
"later" is either an explicit fsync or an O_SYNC write or something...

3) ...or a totally separate interface where userspace does something
along the lines of:

	write_fd = stage_writes(fd);

which creates an O_TMPFILE and reflinks all of fd's content to it

	write(write_fd...);

	err = commit_writes(write_fd, fd);

which then uses extent remapping to push all the changed blocks back to
the original file if it hasn't changed.  Bonus: other threads don't see
the new data until commit_writes() finishes, and we can introduce new
log items to make sure that once we start committing we can finish it
even if the system goes down.

> My question is why hasn't xfs write atomicity advanced further, as it
> seems in 3.x kernel time a few years ago this was tried but nothing
> committed. as documented here:
>
>                http://git.infradead.org/users/hch/vfs.git/shortlog/refs/heads/O_ATOMIC
> 
> Is xfs write atomicity still being pursued , and with what design
> objective. There is a long thread here,
> https://lwn.net/Articles/789600/ on write atomicity, but with no
> progress, lots of ideas in there but not any progress, but I am
> unclear.
> 
> Is my design idea above simply too simplistic, to try and protect a
> configured block size (sector count) through the filesystem and block
> layers, and what really is not making it attainable?

Lack of developer time, AFAICT.

--D

> Thanks for the feedback
> Frank Ober
