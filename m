Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77ADDC432C3
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 16:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C1DF2071C
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 16:33:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PSqpgQcn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfKVQdP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 11:33:15 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40096 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfKVQdO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 11:33:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMGODMV029935;
        Fri, 22 Nov 2019 16:33:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ZIILXMSmy0Xg9i6MNA92QKyKFMi81n37CzlSIygwYzA=;
 b=PSqpgQcnxU4nwzlxi539EB7d4A+CJTdB2tILmNLTNwAJjV7p1d4kPLZPeA0TtLUmu0yP
 Ua7YbT7Ia1E3Ca44prm0fmZMOQvMmBfV9EKpU9I1siKlvixuz/CjtOnrNSgcaMwo49Xk
 /BnE8ANdupuvvobAQXLT5ByFSiqIBSu9m1x7VRMPoyLiMTdZiKHtpVEkH0EUN0IJL3SP
 FAf/E+g5y8hhxEAjZL78bgXc8Wds7z3CKehmllqeZ3ybx07F5RgjcJZRiduh3Dx1vboc
 Sq5eoodSxKWO/o6yoFesq0SHeCU5kf/xEhFRH3mPPOzVtMw7cogaRagO2touQUjgZhEA hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wa8hubprm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 16:33:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMGT6sL090292;
        Fri, 22 Nov 2019 16:31:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2wec294wdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 16:31:08 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAMGV7PO030028;
        Fri, 22 Nov 2019 16:31:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Nov 2019 08:31:07 -0800
Date:   Fri, 22 Nov 2019 08:31:06 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] mkfs: Show progress during block discard
Message-ID: <20191122163106.GH6219@magnolia>
References: <20191121214445.282160-1-preichl@redhat.com>
 <20191121214445.282160-3-preichl@redhat.com>
 <20191121215917.GA6219@magnolia>
 <CAJc7PzXhL0moF8bCkNNnSWrA7R6EUi6Anz3An-nuFSP5yD=PmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJc7PzXhL0moF8bCkNNnSWrA7R6EUi6Anz3An-nuFSP5yD=PmA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911220141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911220141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 22, 2019 at 05:27:42PM +0100, Pavel Reichl wrote:
> On Thu, Nov 21, 2019 at 10:59 PM Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> >
> > On Thu, Nov 21, 2019 at 10:44:45PM +0100, Pavel Reichl wrote:
> > > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > > ---
> > >  mkfs/xfs_mkfs.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > >
> > > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > > index a02d6f66..07b8bd78 100644
> > > --- a/mkfs/xfs_mkfs.c
> > > +++ b/mkfs/xfs_mkfs.c
> > > @@ -1248,6 +1248,7 @@ discard_blocks(dev_t dev, uint64_t nsectors)
> > >       const uint64_t  step            = (uint64_t)2<<30;
> > >       /* Sector size is 512 bytes */
> > >       const uint64_t  count           = nsectors << 9;
> > > +     uint64_t        prev_done       = (uint64_t) ~0;
> > >
> > >       fd = libxfs_device_to_fd(dev);
> > >       if (fd <= 0)
> > > @@ -1255,6 +1256,7 @@ discard_blocks(dev_t dev, uint64_t nsectors)
> > >
> > >       while (offset < count) {
> > >               uint64_t        tmp_step = step;
> > > +             uint64_t        done = offset * 100 / count;
> > >
> > >               if ((offset + step) > count)
> > >                       tmp_step = count - offset;
> > > @@ -1268,7 +1270,13 @@ discard_blocks(dev_t dev, uint64_t nsectors)
> > >                       return;
> > >
> > >               offset += tmp_step;
> > > +
> > > +             if (prev_done != done) {
> >
> > Hmm... so this prints the status message every increase percentage
> > point, right?
> 
> Not at all, the 'least change' it prints is one percent but that's the
> maximum granularity i.e. I tested with 10 GB file and the output was:
> 
> Discarding:  0% done
> Discarding: 20% done
> Discarding: 40% done
> Discarding: 60% done
> Discarding: 80% done
> Discarding is done.
> 
> So ATM there could be up to 102 lines - please propose a different idea.

if (device supports discard) {
	if (!quiet)
		printf(_("Discarding blocks, this may take some time..."));
	<discard loop>
}
<the rest of mkfs>

> 
> >
> > > +                     prev_done = done;
> > > +                     fprintf(stderr, _("Discarding: %2lu%% done\n"), done);
> >
> > This isn't an error, so why output to stderr?
> My bad, sorry.
> 
> >
> > FWIW if it's a tty you might consider ending that string with \r so the
> > status messages don't scroll off the screen.  Or possibly only reporting
> > status if stdout is a tty?
> 
> Do I get it right that you propose to not flow the terminal with
> dozens of lines which just update the percentage but instead keep
> updating the same line? If so, I do like that.

Correct.

--D

> >
> > --D
> >
> > > +             }
> > >       }
> > > +     fprintf(stderr, _("Discarding is done.\n"));
> > >  }
> > >
> > >  static __attribute__((noreturn)) void
> > > --
> > > 2.23.0
> > >
> >
> 
