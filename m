Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 793C1C3404E
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 04:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DAE1208E4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 04:38:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z8Kj8CHf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgBSEiI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 23:38:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52648 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbgBSEiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Feb 2020 23:38:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J4Vrm9166884;
        Wed, 19 Feb 2020 04:38:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ILEP0yqXhYcmpFd3mQvlUJBP/8iT69hISjuCordXmFw=;
 b=Z8Kj8CHfy6FVEOoCXXoWY4xk9RDwPI9aatpw4ecGqgXUytFX0l/q3zL+blbsTq8AMpsQ
 n38pqtDjrZU3AQXS5M8O66kCqf1avferu6GwNxU2eds4WcAI07ERkoInck4Wqdc2Cfbz
 rZudMjzuXNA04yB5C5sdpIXmTdNeas4SjVxqKxIQtAdvlkDsVwgPtcelsFlGAgnfZxjp
 srXQ2RudGTmPTHTIchIuWlvG0FXP9i539D1c0HubdbgbU2n+G37r6pDP8dpqpr7nfWL4
 CwOuSrc0Jf7xQSyveU4CYsoC9Dn0Z/lVo7Z7X0hJ1cFMvK5m9w58pXtcWYUHpz0iz+R2 ZA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2y8udd0fyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 04:38:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J4S4wu025642;
        Wed, 19 Feb 2020 04:38:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2y8ud37a3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 04:38:05 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01J4c4MZ014468;
        Wed, 19 Feb 2020 04:38:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Feb 2020 20:38:04 -0800
Date:   Tue, 18 Feb 2020 20:38:02 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] libxfs: return flush failures
Message-ID: <20200219043802.GI9506@magnolia>
References: <158086364511.2079905.3531505051831183875.stgit@magnolia>
 <158086366333.2079905.16346740147118345650.stgit@magnolia>
 <d98bdc0b-e3f1-2c00-90df-8a38388a2651@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d98bdc0b-e3f1-2c00-90df-8a38388a2651@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190029
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 06, 2020 at 12:38:06PM -0700, Allison Collins wrote:
> 
> On 2/4/20 5:47 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Modify platform_flush_device so that we can return error status when
> > device flushes fail.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> I think there's one other place in init.c where platform_flush_device is
> called, but I suppose it didn't need the return code before?

I think the lack of error checking is/was just plain broken, seeing as
the current libxfs_close() code path just eats errors.

However, now that everyone calls libxfs_flush() to find out which
devices (if any) succeeded in flushing, I think there's less need to go
reworking that whole code path.

--D

> Other than that it looks ok.

> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> 
> > ---
> >   libfrog/linux.c    |   25 +++++++++++++++++--------
> >   libfrog/platform.h |    2 +-
> >   2 files changed, 18 insertions(+), 9 deletions(-)
> > 
> > 
> > diff --git a/libfrog/linux.c b/libfrog/linux.c
> > index 41a168b4..60bc1dc4 100644
> > --- a/libfrog/linux.c
> > +++ b/libfrog/linux.c
> > @@ -140,20 +140,29 @@ platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fata
> >   	return error;
> >   }
> > -void
> > -platform_flush_device(int fd, dev_t device)
> > +/*
> > + * Flush dirty pagecache and disk write cache to stable media.  Returns 0 for
> > + * success or -1 (with errno set) for failure.
> > + */
> > +int
> > +platform_flush_device(
> > +	int		fd,
> > +	dev_t		device)
> >   {
> >   	struct stat	st;
> > +	int		ret;
> > +
> >   	if (major(device) == RAMDISK_MAJOR)
> > -		return;
> > +		return 0;
> > -	if (fstat(fd, &st) < 0)
> > -		return;
> > +	ret = fstat(fd, &st);
> > +	if (ret)
> > +		return ret;
> >   	if (S_ISREG(st.st_mode))
> > -		fsync(fd);
> > -	else
> > -		ioctl(fd, BLKFLSBUF, 0);
> > +		return fsync(fd);
> > +
> > +	return ioctl(fd, BLKFLSBUF, 0);
> >   }
> >   void
> > diff --git a/libfrog/platform.h b/libfrog/platform.h
> > index 76887e5e..0aef318a 100644
> > --- a/libfrog/platform.h
> > +++ b/libfrog/platform.h
> > @@ -12,7 +12,7 @@ int platform_check_ismounted(char *path, char *block, struct stat *sptr,
> >   int platform_check_iswritable(char *path, char *block, struct stat *sptr);
> >   int platform_set_blocksize(int fd, char *path, dev_t device, int bsz,
> >   		int fatal);
> > -void platform_flush_device(int fd, dev_t device);
> > +int platform_flush_device(int fd, dev_t device);
> >   char *platform_findrawpath(char *path);
> >   char *platform_findblockpath(char *path);
> >   int platform_direct_blockdev(void);
> > 
