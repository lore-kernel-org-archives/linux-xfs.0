Return-Path: <SRS0=4VMi=2H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9110AC2D0BF
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 22:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5194624650
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 22:18:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AnfBCabV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfLQWST (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 17:18:19 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47706 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfLQWSS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Dec 2019 17:18:18 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBHMEK8V073249;
        Tue, 17 Dec 2019 22:18:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Wbvd3oUGIUItHk1HveBEmJ3WNSTUYg+PKf6vZ+PiPjw=;
 b=AnfBCabV5TxAdjkWg1LcitWqAVqNYShJobMKBsnPEf3n9u1BaAV4JR+hXYHb14WYzmr8
 EGh5teyY36rMlX5wYV/DqmZz/H9k22bqGEjZIXKVeQ3xvDaE27uKniY3Etc4SaR4ZHRE
 Qp12cNRzdOoxkEppQr35XiJlkxO57eQGZeniAupYrY+BbeSL3pFCvmhCgVJJiZ3hYJwK
 0ZApTWPqlbW+OctznBZ025Mm5DAJtSIqisIYk27XfSO37AohUEpapMvaR2mfs3brjcGK
 A25rGs3zc3z19zB6w0AAxu78HaIWliprig5YbWw032Dp9+WQPgHZbsXbfs7wG4F9CTwP 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wvrcr9k81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 22:18:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBHMEM9u121137;
        Tue, 17 Dec 2019 22:16:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2wxm5nyccm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 22:16:05 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBHMFveB018906;
        Tue, 17 Dec 2019 22:15:57 GMT
Received: from localhost (/10.159.137.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Dec 2019 14:15:57 -0800
Date:   Tue, 17 Dec 2019 14:15:55 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     y2038 Mailman List <y2038@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Pavel Reichl <preichl@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 21/24] xfs: quota: move to time64_t interfaces
Message-ID: <20191217221555.GE12765@magnolia>
References: <20191213204936.3643476-1-arnd@arndb.de>
 <20191213205417.3871055-12-arnd@arndb.de>
 <20191213211728.GL99875@magnolia>
 <CAK8P3a3k9dq+9DnPFBKdzOe=ALPXXjCvBBj8r_xsqz1vTswGsg@mail.gmail.com>
 <CAK8P3a2nJKR+_Gc6G_S6Bd0fKecBCM+a2cekOU+6m6kw_c4q9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2nJKR+_Gc6G_S6Bd0fKecBCM+a2cekOU+6m6kw_c4q9A@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912170177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912170177
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 17, 2019 at 04:02:47PM +0100, Arnd Bergmann wrote:
> On Mon, Dec 16, 2019 at 5:52 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > On Fri, Dec 13, 2019 at 10:17 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >>
> >> Hmm, so one thing that I clean up on the way to bigtime is the total
> >> lack of clamping here.  If (for example) it's September 2105 and
> >> rtbtimelimit is set to 1 year, this will cause an integer overflow.  The
> >> quota timer will be set to 1970 and expire immediately, rather than what
> >> I'd consider the best effort of February 2106.
> 
> One more hing to note (I will add this to the changelog text) is that on

Ok, I'll look for it in the next revision you send out.

By the way, would you mind cc'ing the xfs list on all 24 patches?  They
probably aren't directly relevant to xfs, but it does make it a lot
easier for us to look at the other 21 patches and think "Oh, ok, so
there isn't some core infrastructure change that we're not seeing".

> 32-bit architectures, the limit here is y2038, while on 64-bit
> architectures it's y2106:

Yikes.  I probably just need to send the bigtime series and see what you
all think about the mess I created^W^W^Wway I dealt with all that.

> int xfs_trans_dqresv(...)
> {
>        time_t                  timer; /* signed 'long' */
>        timer = be32_to_cpu(dqp->q_core.d_btimer);
>        /* get_seconds() returns unsigned long */
>       if ((timer != 0 && get_seconds() > timer))
>                 return -EDQUOT;
> }
> 
> > I don't think clamping would be good here, that just replaces
> > one bug with another at the overflow time. If you would like to
> > have something better before this gets extended, I could try to
> > come up with a version that converts it to the nearest 64-bit
> > timestamp, similar to the way that time_before32() in the kernel
> > or the NTP protocol work.
> >
> > If you think it can get extended properly soon, I'd just leave the
> > patch as it is today in order to remove the get_seconds()
> > interface for v5.6.
> 
> I've tried this now, and but this feels wrong: it adds lots of complexity
> for corner cases and is still fragile, e.g. when the time is wrong
> during boot before ntp runs. See that patch below for reference.

Yeah, that is pretty weird to glue the upper 32 bits of the timestamp
onto the expiration timer...

--D

> I also see that quotatool on xfs always uses the old xfs quota
> interface, so it already overflows on the user space side. Fixing
> this properly seems to be a bigger effort than I was planning for
> (on an unpatched 64-bit kernel):
> 
> $ sudo quotatool -b    -u  -t 220month  /mnt/tmp -r
> $ rm file ; fallocate -l 11M file
> $ sudo quotatool -d /mnt/tmp -u arnd
> 1000 /mnt/tmp 11264 10240 20480 570239975 2 0 00
> $ sudo quotatool -b    -u  -t 222month  /mnt/tmp -r
> $ rm file ; fallocate -l 11M file
> $ sudo quotatool -d /mnt/tmp -u arnd
> 1000 /mnt/tmp 11264 10240 20480 18446744069990008316 2 0 00
> 
>        Arnd
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 9cfd3209f52b..6c9128bb607b 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -98,6 +98,23 @@ xfs_qm_adjust_dqlimits(
>                 xfs_dquot_set_prealloc_limits(dq);
>  }
> 
> +static __be32 xfs_quota_timeout32(s64 limit)
> +{
> +       time64_t now = ktime_get_real_seconds();
> +       u32 timeout;
> +
> +       /* avoid overflows in out-of-range limits */
> +       if ((u64)limit > S32_MAX)
> +               limit = S32_MAX;
> +       timeout = now + limit;
> +
> +       /* avoid timeout of zero */
> +       if (lower_32_bits(timeout) == 0)
> +               return cpu_to_be32(1);
> +
> +       return cpu_to_be32(lower_32_bits(timeout));
> +}
> +
>  /*
>   * Check the limits and timers of a dquot and start or reset timers
>   * if necessary.
> @@ -137,7 +154,7 @@ xfs_qm_adjust_dqtimers(
>                     (d->d_blk_hardlimit &&
>                      (be64_to_cpu(d->d_bcount) >
>                       be64_to_cpu(d->d_blk_hardlimit)))) {
> -                       d->d_btimer = cpu_to_be32(ktime_get_real_seconds() +
> +                       d->d_btimer = xfs_quota_timeout32(
>                                         mp->m_quotainfo->qi_btimelimit);
>                 } else {
>                         d->d_bwarns = 0;
> @@ -160,7 +177,7 @@ xfs_qm_adjust_dqtimers(
>                     (d->d_ino_hardlimit &&
>                      (be64_to_cpu(d->d_icount) >
>                       be64_to_cpu(d->d_ino_hardlimit)))) {
> -                       d->d_itimer = cpu_to_be32(ktime_get_real_seconds() +
> +                       d->d_itimer = xfs_quota_timeout32(
>                                         mp->m_quotainfo->qi_itimelimit);
>                 } else {
>                         d->d_iwarns = 0;
> @@ -183,7 +200,7 @@ xfs_qm_adjust_dqtimers(
>                     (d->d_rtb_hardlimit &&
>                      (be64_to_cpu(d->d_rtbcount) >
>                       be64_to_cpu(d->d_rtb_hardlimit)))) {
> -                       d->d_rtbtimer = cpu_to_be32(ktime_get_real_seconds() +
> +                       d->d_rtbtimer = xfs_quota_timeout32(
>                                         mp->m_quotainfo->qi_rtbtimelimit);
>                 } else {
>                         d->d_rtbwarns = 0;
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 1ea82764bf89..2087626b4bee 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -601,6 +601,14 @@ xfs_qm_scall_setqlim(
>         return error;
>  }
> 
> +/* Assume timers are within +/- 68 years of current wall clock */
> +static time64_t xfs_quota_time32_to_time64(time64_t now, __be32 timer)
> +{
> +       s32 diff = be32_to_cpu(timer) - lower_32_bits(now);
> +
> +       return now + diff;
> +}
> +
>  /* Fill out the quota context. */
>  static void
>  xfs_qm_scall_getquota_fill_qc(
> @@ -609,6 +617,8 @@ xfs_qm_scall_getquota_fill_qc(
>         const struct xfs_dquot  *dqp,
>         struct qc_dqblk         *dst)
>  {
> +       time64_t now = ktime_get_real_seconds();
> +
>         memset(dst, 0, sizeof(*dst));
>         dst->d_spc_hardlimit =
>                 XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_blk_hardlimit));
> @@ -618,8 +628,8 @@ xfs_qm_scall_getquota_fill_qc(
>         dst->d_ino_softlimit = be64_to_cpu(dqp->q_core.d_ino_softlimit);
>         dst->d_space = XFS_FSB_TO_B(mp, dqp->q_res_bcount);
>         dst->d_ino_count = dqp->q_res_icount;
> -       dst->d_spc_timer = be32_to_cpu(dqp->q_core.d_btimer);
> -       dst->d_ino_timer = be32_to_cpu(dqp->q_core.d_itimer);
> +       dst->d_spc_timer = xfs_quota_time32_to_time64(now,
> dqp->q_core.d_btimer);
> +       dst->d_ino_timer = xfs_quota_time32_to_time64(now,
> dqp->q_core.d_itimer);
>         dst->d_ino_warns = be16_to_cpu(dqp->q_core.d_iwarns);
>         dst->d_spc_warns = be16_to_cpu(dqp->q_core.d_bwarns);
>         dst->d_rt_spc_hardlimit =
> @@ -627,7 +637,7 @@ xfs_qm_scall_getquota_fill_qc(
>         dst->d_rt_spc_softlimit =
>                 XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_rtb_softlimit));
>         dst->d_rt_space = XFS_FSB_TO_B(mp, dqp->q_res_rtbcount);
> -       dst->d_rt_spc_timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
> +       dst->d_rt_spc_timer = xfs_quota_time32_to_time64(now,
> dqp->q_core.d_rtbtimer);
>         dst->d_rt_spc_warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
> 
>         /*
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index d1b9869bc5fa..c75887da6546 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -636,7 +636,8 @@ xfs_trans_dqresv(
>                         }
>                         if (softlimit && total_count > softlimit) {
>                                 if ((timer != 0 &&
> -                                    ktime_get_real_seconds() > timer) ||
> +                                    time_after32(ktime_get_real_seconds(),
> +                                                 timer)) ||
>                                     (warns != 0 && warns >= warnlimit)) {
>                                         xfs_quota_warn(mp, dqp,
>                                                        QUOTA_NL_BSOFTLONGWARN);
> @@ -664,7 +665,8 @@ xfs_trans_dqresv(
>                         }
>                         if (softlimit && total_count > softlimit) {
>                                 if  ((timer != 0 &&
> -                                     ktime_get_real_seconds() > timer) ||
> +                                    time_after32(ktime_get_real_seconds(),
> +                                                 timer)) ||
>                                      (warns != 0 && warns >= warnlimit)) {
>                                         xfs_quota_warn(mp, dqp,
>                                                        QUOTA_NL_ISOFTLONGWARN);
