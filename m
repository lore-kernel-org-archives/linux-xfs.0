Return-Path: <SRS0=IeGX=YO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99F99CA9EAF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 20:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E3992089C
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 20:14:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ArJGTJC+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730155AbfJUUOm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 16:14:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48476 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730065AbfJUUOm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 16:14:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LKEeJd156515;
        Mon, 21 Oct 2019 20:14:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Av/jvwguh1hW7VtaOV2yL6KW1cmvrlEq/fCaCYapz2I=;
 b=ArJGTJC+HBeK8K3CsYKKF4say+lAGq0riKgyJewHoD29ixDS4cbSbRmbUnle3+KimaNS
 PxfB3bcvV3SYoYMis+Qx+psuMS//w2gFLuteesul9DtMjt6B2cDYXNjxw4wpPWrMrdDz
 5EsD71xv3yIZOch+6jVtIerKc3OCOr58P9KgLqxoUl0BTv6ko7JswohU6dY14eJ10aYp
 uiO5Xkzx7fkR9ByDnEVPACGRR94lSsV47JYwaZp71Wqyi8l1XYBnfAnxomE+JOZlc92O
 ymY7GhQRvsWOtuVrX0PwLLpMt8sIZ7d+OvCsaJmFAVPNJ7lvTpPEAl6qB/YwIiv9N3VK 3g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vqu4qj06u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 20:14:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LKETmm008479;
        Mon, 21 Oct 2019 20:14:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vrcmnw6gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 20:14:33 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9LKDj3p002930;
        Mon, 21 Oct 2019 20:13:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Oct 2019 13:13:45 -0700
Date:   Mon, 21 Oct 2019 13:13:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] libfrog: clean up platform_nproc
Message-ID: <20191021201344.GF913374@magnolia>
References: <156944736739.300131.5717633994765951730.stgit@magnolia>
 <156944742224.300131.10235357474710122535.stgit@magnolia>
 <dfa0af2b-1f72-40e4-6877-4296e51c7fd9@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfa0af2b-1f72-40e4-6877-4296e51c7fd9@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=9 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910210194
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=9 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910210194
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 21, 2019 at 02:31:52PM -0500, Eric Sandeen wrote:
> On 9/25/19 4:37 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The platform_nproc function should check for error returns and obviously
> > garbage values and deal with them appropriately.  Fix the header
> > declaration since it's part of the libfrog platform support code, not
> > libxfs.  xfs_scrub will make use of it in the next patch.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  include/libxfs.h           |    1 -
> >  include/platform_defs.h.in |    2 ++
> >  libfrog/linux.c            |    9 ++++++++-
> >  3 files changed, 10 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/include/libxfs.h b/include/libxfs.h
> > index 63696df5..227084ae 100644
> > --- a/include/libxfs.h
> > +++ b/include/libxfs.h
> > @@ -135,7 +135,6 @@ extern void	libxfs_device_close (dev_t);
> >  extern int	libxfs_device_alignment (void);
> >  extern void	libxfs_report(FILE *);
> >  extern void	platform_findsizes(char *path, int fd, long long *sz, int *bsz);
> > -extern int	platform_nproc(void);
> >  
> >  /* check or write log footer: specify device, log size in blocks & uuid */
> >  typedef char	*(libxfs_get_block_t)(char *, int, void *);
> > diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
> > index d111ec6d..adb00181 100644
> > --- a/include/platform_defs.h.in
> > +++ b/include/platform_defs.h.in
> > @@ -77,4 +77,6 @@ typedef unsigned short umode_t;
> >  # define ASSERT(EX)	((void) 0)
> >  #endif
> >  
> > +extern int	platform_nproc(void);
> > +
> >  #endif	/* __XFS_PLATFORM_DEFS_H__ */
> > diff --git a/libfrog/linux.c b/libfrog/linux.c
> > index b6c24879..79bd79eb 100644
> > --- a/libfrog/linux.c
> > +++ b/libfrog/linux.c
> > @@ -242,10 +242,17 @@ platform_align_blockdev(void)
> >  	return max_block_alignment;
> >  }
> >  
> > +/* How many CPUs are online? */
> >  int
> >  platform_nproc(void)
> >  {
> > -	return sysconf(_SC_NPROCESSORS_ONLN);
> > +	long nproc = sysconf(_SC_NPROCESSORS_ONLN);
> > +
> > +	if (nproc < 1)
> > +		return 1;
> > +	if (nproc >= INT_MAX)
> > +		return INT_MAX;
> > +	return nproc;
> >  }
> 
> hm, may as well remove the test from libxfs then?
> 
> int
> libxfs_nproc(void)
> {
>         int     nr;
> 
>         nr = platform_nproc();
>         if (nr < 1)
>                 nr = 1;
>         return nr;
> }

Eh, I'll just remove libxfs_nproc since it's now just a shallow wrapper
to another library.

--D
