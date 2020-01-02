Return-Path: <SRS0=76Wm=2X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D319FC2D0C2
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 18:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A55DF206E6
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 18:08:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iQo0KKnx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgABSI3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 13:08:29 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39984 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727890AbgABSI3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jan 2020 13:08:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002I4O1W124195;
        Thu, 2 Jan 2020 18:08:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=9vAGTFW/D24dQaXdwW831G4R7KtTBNtt7sc37WYNAw8=;
 b=iQo0KKnxXOubTy7cZbaHfmraduQO9HOcEFwh9kUFDOd0GgcTo4arM0YI83joC55C++4g
 szwDeZkmLoOuSYSm3O0PffrJp1uEgXPFJc8gKu10ET2YkgRFnf4HBbO9eshIx7VFzZNN
 7bH382PUMxC9rizDd9zSyYgqcITm5mDSsXTwPguy4ABUNMaevXsQCjTERwu3G3pywBd2
 +EkovqFPqd4jixtDioOTiz0gds06HEW0iDXJL+B8lvLSZFmJEohadxUKy7QBKFyKa5qF
 jK5YuXHDE7D+4UzNiCCMl1/487d/rh46NQirB1T0gX+QJg7b0gtHhHQLOvvS9kVYLTu0 9Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2x5xftrshj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 18:08:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002I3RX1013879;
        Thu, 2 Jan 2020 18:08:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2x9jm6e6tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 18:08:07 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 002I7pDp008364;
        Thu, 2 Jan 2020 18:07:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jan 2020 10:07:51 -0800
Date:   Thu, 2 Jan 2020 10:07:49 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] xfs: disallow broken ioctls without
 compat-32-bit-time
Message-ID: <20200102180749.GA1508633@magnolia>
References: <20191218163954.296726-1-arnd@arndb.de>
 <20191218163954.296726-2-arnd@arndb.de>
 <20191224084514.GC1739@infradead.org>
 <CAK8P3a2ANKoV1DhJMUuAr0qKW7HgRvz9LM2yLkSVWP9Rn-LUhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2ANKoV1DhJMUuAr0qKW7HgRvz9LM2yLkSVWP9Rn-LUhA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001020151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001020151
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 02, 2020 at 10:16:21AM +0100, Arnd Bergmann wrote:
> On Tue, Dec 24, 2019 at 9:45 AM Christoph Hellwig <hch@infradead.org> wrote:
> > On Wed, Dec 18, 2019 at 05:39:29PM +0100, Arnd Bergmann wrote:
> > > +/* disallow y2038-unsafe ioctls with CONFIG_COMPAT_32BIT_TIME=n */
> > > +static bool xfs_have_compat_bstat_time32(unsigned int cmd)
> > > +{
> > > +     if (IS_ENABLED(CONFIG_COMPAT_32BIT_TIME))
> > > +             return true;
> > > +
> > > +     if (IS_ENABLED(CONFIG_64BIT) && !in_compat_syscall())
> > > +             return true;
> > > +
> > > +     if (cmd == XFS_IOC_FSBULKSTAT_SINGLE ||
> > > +         cmd == XFS_IOC_FSBULKSTAT ||
> > > +         cmd == XFS_IOC_SWAPEXT)
> > > +             return false;
> > > +
> > > +     return true;
> >
> > I think the check for the individual command belongs into the callers,
> > which laves us with:
> >
> > static inline bool have_time32(void)
> > {
> >         return IS_ENABLED(CONFIG_COMPAT_32BIT_TIME) ||
> >                 (IS_ENABLED(CONFIG_64BIT) && !in_compat_syscall());
> > }
> >
> > and that looks like it should be in a generic helper somewhere.
> 
> Yes, makes sense.
> 
> I was going for something XFS specific here because XFS is unique in the
> kernel in completely deprecating a set of ioctl commands (replacing
> the old interface with a v5) rather than allowing the user space to be
> compiled with 64-bit time_t.
> 
> If we add a global helper for this, I'd be tempted to also stick a
> WARN_RATELIMIT() in there to give users a better indication of
> what broke after disabling CONFIG_COMPAT_32BIT_TIME.
> 
> The same warning would make sense in the system calls, but then
> we have to decide which combinations we want to allow being
> configured at runtime or compile-time.
> 
> a) unmodified behavior
> b) just warn but allow
> c) no warning but disallow
> d) warn and disallow
> 
> > >       if (XFS_FORCED_SHUTDOWN(mp))
> > >               return -EIO;
> > >
> > > @@ -1815,6 +1836,11 @@ xfs_ioc_swapext(
> > >       struct fd       f, tmp;
> > >       int             error = 0;
> > >
> > > +     if (!xfs_have_compat_bstat_time32(XFS_IOC_SWAPEXT)) {
> > > +             error = -EINVAL;
> > > +             goto out;
> > > +     }
> >
> > And for this one we just have one cmd anyway.  But I actually still
> > disagree with the old_time check for this one entirely, as voiced on
> > one of the last iterations.  For swapext the time stamp really is
> > only used as a generation counter, so overflows are entirely harmless.
> 
> Sorry I missed that comment earlier. I've had a fresh look now, but
> I think we still need to deprecate XFS_IOC_SWAPEXT and add a
> v5 version of it, since the comparison will fail as soon as the range
> of the inode timestamps is extended beyond 2038, otherwise the
> comparison will always be false, or require comparing the truncated
> time values which would add yet another representation.

I prefer we replace the old SWAPEXT with a new version to get rid of
struct xfs_bstat.  Though a SWAPEXT_V5 probably only needs to contain
the *stat fields that swapext actually needs to check that the file
hasn't been changed, which would be ino/gen/btime/ctime.

(Maybe I'd add an offset/length too...)

--D

>        Arnd
