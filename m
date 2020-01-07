Return-Path: <SRS0=eQYP=24=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999FFC282DD
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 18:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71C2F20848
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 18:16:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VaYONphR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgAGSQq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 13:16:46 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35582 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728430AbgAGSQp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 13:16:45 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007IEFY4181854;
        Tue, 7 Jan 2020 18:16:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=VbFozqPz1Ni4r6WQYrlEExCVTtwHzP0/vUt3SiGSswE=;
 b=VaYONphRAP0fotWd/fOnG1B8z4750kpMyCjiKRfLJPk0y9YZhTDmXvAhxZV0iM3HpiRh
 5Fw1IJRq1HFa3yjN+VBHHNabIS67G26GinoAQcmZ3HKHlIDhFFr6FXd2SqEqNdsp5/S0
 unDOhBEmjdOKhsdjW+l74ySc/1BQYOgLJaCgPN5aGHjnxPSj/rSMINTyx6SCNPGCxo/o
 IWL4p4zTFX+30S6KX02uQVAh40Yr0+vRuX0pt6AtR7trQvIi5mzGw+4ais23u2JL77Rv
 dOuhU76fT7tfOj+msJ7TpFQw4DgRKS7K8sGwnBJZOTq6J0LlaeMHrxGgaUbVVjjWQQuS DA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xakbqq6b8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 18:16:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007IEBIc170778;
        Tue, 7 Jan 2020 18:16:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xcjvdpwfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 18:16:23 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 007IGGM1028225;
        Tue, 7 Jan 2020 18:16:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 10:16:16 -0800
Date:   Tue, 7 Jan 2020 10:16:14 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] xfs: disallow broken ioctls without
 compat-32-bit-time
Message-ID: <20200107181614.GA917713@magnolia>
References: <20191218163954.296726-1-arnd@arndb.de>
 <20191218163954.296726-2-arnd@arndb.de>
 <20191224084514.GC1739@infradead.org>
 <CAK8P3a2ANKoV1DhJMUuAr0qKW7HgRvz9LM2yLkSVWP9Rn-LUhA@mail.gmail.com>
 <20200102180749.GA1508633@magnolia>
 <20200107141634.GC10628@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107141634.GC10628@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001070144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001070144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 07, 2020 at 06:16:34AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 02, 2020 at 10:07:49AM -0800, Darrick J. Wong wrote:
> > > Sorry I missed that comment earlier. I've had a fresh look now, but
> > > I think we still need to deprecate XFS_IOC_SWAPEXT and add a
> > > v5 version of it, since the comparison will fail as soon as the range
> > > of the inode timestamps is extended beyond 2038, otherwise the
> > > comparison will always be false, or require comparing the truncated
> > > time values which would add yet another representation.
> > 
> > I prefer we replace the old SWAPEXT with a new version to get rid of
> > struct xfs_bstat.  Though a SWAPEXT_V5 probably only needs to contain
> > the *stat fields that swapext actually needs to check that the file
> > hasn't been changed, which would be ino/gen/btime/ctime.
> > 
> > (Maybe I'd add an offset/length too...)
> 
> And most importantly we need to lift it to the VFS instead of all the
> crazy fs specific interfaces at the moment.

Yeah.  Fixing that (and maybe adding an ioctl to set the FS UUID online)
were on my list for 5.6 but clearly I have to defer everything until 5.7
because we've just run out of time.

Uh... I started looking into unifying the ext4 and xfs defrag ioctl, but
gagged when I realized that the ext4 ioctl also handles the data copy
inside the kernel.  I think that's the sort of behavior we should /not/
allow into the new ioctl, though that also means that the required
changes for ext4/e4defrag will be non-trivial.

The btrfs defrag ioctl also contains thresholding information and
optional knobs to enable compression, which makes me wonder if we should
focus narrowly on swapext being "swap these extents but only if the
source file hasn't changed" and not necessarily defrag?

...in which case I wonder, can people (ab)use this interface for atomic
file updates?  Create an O_TMPFILE, reflink the source file into the
temp file, make your updates to the tempfile, and then swapext the
donor's file data back into the source file, but only if the source file
hasn't changed?

--D
