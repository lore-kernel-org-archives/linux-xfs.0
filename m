Return-Path: <SRS0=aEZv=Z7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC3CCC43603
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Dec 2019 23:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83562206D3
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Dec 2019 23:34:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gkY+o4sA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfLIXe5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Dec 2019 18:34:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54834 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbfLIXe4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Dec 2019 18:34:56 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB9NYIZA010926;
        Mon, 9 Dec 2019 23:34:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=I0KM9itUwghk+XUPlb3c8SR9ZXdizN0y58mZv+Tvgf8=;
 b=gkY+o4sAmywHzF14HDU9cYnzLSXfXHpKp6B4XXX++S1pN+JY4CCsNWoh/PUaKG6wyp42
 RyGQOOvCtmR3A4F0I2+VDzzPwCTl3z+UraP5wKUCfl4yPsHPO5GK612DvRuMTw4NJOrJ
 aCnHm/EOZime9hctRfAb9hTEEUY3K1+g5DfN/H6POdL/ADnj6R++r81WhdB9yIrzpwqn
 LzyD26uiZa+e2geN1HhtXhLTc6d1KL9TPQCl9fWyu8h1MR5ruHG4+opO3G+JzmB+CC0c
 f1pIbxu5gjIC2RPl8wHdbI1qrshJHtHRA2hX2Ll+LXi9SOxNcYIHR5JjE1I+yQYgIABd aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wr41q2tkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Dec 2019 23:34:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB9NT8Pw186196;
        Mon, 9 Dec 2019 23:34:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2wsru82n56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Dec 2019 23:34:48 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB9NYlYF018343;
        Mon, 9 Dec 2019 23:34:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Dec 2019 15:34:47 -0800
Date:   Mon, 9 Dec 2019 15:34:46 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] mkfs: Break block discard into chunks of 2 GB
Message-ID: <20191209233445.GC9464@magnolia>
References: <20191128062139.93218-1-preichl@redhat.com>
 <6ad2e204-aa5b-c487-e03e-4a75b01018fa@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ad2e204-aa5b-c487-e03e-4a75b01018fa@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912090185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912090186
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 09, 2019 at 04:00:17PM -0600, Eric Sandeen wrote:
> On 11/28/19 12:21 AM, Pavel Reichl wrote:
> > Some users are not happy about the BLKDISCARD taking too long and at the same
> > time not being informed about that - so they think that the command actually
> > hung.
> > 
> > This commit changes code so that progress reporting is possible and also typing
> > the ^C will cancel the ongoing BLKDISCARD.
> 
> Ok I'm going to nitpick this just a little bit more...
> 
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > ---
> >  mkfs/xfs_mkfs.c | 50 ++++++++++++++++++++++++++++++++++++-------------
> >  1 file changed, 37 insertions(+), 13 deletions(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 18338a61..0defadb2 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -1240,17 +1240,40 @@ done:
> >  }
> >  
> >  static void
> > -discard_blocks(dev_t dev, uint64_t nsectors)
> > +discard_blocks(dev_t dev, uint64_t nsectors, int quiet)
> >  {
> > -	int fd;
> > +	int		fd;
> > +	uint64_t	offset = 0;
> > +	/* Discard the device 2G at a time */
> > +	const uint64_t	step = 2ULL << 30;
> > +	const uint64_t	count = BBTOB(nsectors);
> >  
> > -	/*
> > -	 * We intentionally ignore errors from the discard ioctl.  It is
> > -	 * not necessary for the mkfs functionality but just an optimization.
> > -	 */
> >  	fd = libxfs_device_to_fd(dev);
> > -	if (fd > 0)
> > -		platform_discard_blocks(fd, 0, nsectors << 9);
> > +	if (fd <= 0)
> > +		return;
> > +	if (!quiet) {
> > +		printf("Discarding blocks...\n");
> > +		printf("...\n");
> > +	}
> 
> Let's change this output so that it prints only a single line, i.e.
> 
> +	if (!quiet) {
> +		printf("Discarding blocks... ");

This needs fflush(stdout); here to force the message out of stdio output
buffering.

--D

> 
> ...
> 
> +	if (!quiet)
> +		printf("Done.\n");
> 
> Then in xfstests there's only one line to filter.
> 
> I think there was a suggestion to test isatty() to see if we're on a terminal,
> but I have some concern that a hung script will lead to confusion as well if
> there's no status message.  We can add terminal testing in a later patch if that
> really seems like the right way to go.
> 
> If you're ok with the above, I can make the change on commit to save another
> patch round trip, and
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> > +
> > +	/* The block discarding happens in smaller batches so it can be
> > +	 * interrupted prematurely
> > +	 */
> > +	while (offset < count) {
> > +		uint64_t	tmp_step = min(step, count - offset);
> > +
> > +		/*
> > +		 * We intentionally ignore errors from the discard ioctl. It is
> > +		 * not necessary for the mkfs functionality but just an
> > +		 * optimization. However we should stop on error.
> > +		 */
> > +		if (platform_discard_blocks(fd, offset, tmp_step))
> > +			return;
> > +
> > +		offset += tmp_step;
> > +	}
> > +	if (!quiet)
> > +		printf("Done.\n");
> >  }
> >  
> >  static __attribute__((noreturn)) void
> > @@ -2507,18 +2530,19 @@ open_devices(
> >  
> >  static void
> >  discard_devices(
> > -	struct libxfs_xinit	*xi)
> > +	struct libxfs_xinit	*xi,
> > +	int			quiet)
> >  {
> >  	/*
> >  	 * This function has to be called after libxfs has been initialized.
> >  	 */
> >  
> >  	if (!xi->disfile)
> > -		discard_blocks(xi->ddev, xi->dsize);
> > +		discard_blocks(xi->ddev, xi->dsize, quiet);
> >  	if (xi->rtdev && !xi->risfile)
> > -		discard_blocks(xi->rtdev, xi->rtsize);
> > +		discard_blocks(xi->rtdev, xi->rtsize, quiet);
> >  	if (xi->logdev && xi->logdev != xi->ddev && !xi->lisfile)
> > -		discard_blocks(xi->logdev, xi->logBBsize);
> > +		discard_blocks(xi->logdev, xi->logBBsize, quiet);
> >  }
> >  
> >  static void
> > @@ -3749,7 +3773,7 @@ main(
> >  	 * All values have been validated, discard the old device layout.
> >  	 */
> >  	if (discard && !dry_run)
> > -		discard_devices(&xi);
> > +		discard_devices(&xi, quiet);
> >  
> >  	/*
> >  	 * we need the libxfs buffer cache from here on in.
> > 
