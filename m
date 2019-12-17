Return-Path: <SRS0=4VMi=2H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9E5C43603
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 15:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EF462146E
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 15:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbfLQPDH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 10:03:07 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:34221 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728137AbfLQPDG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Dec 2019 10:03:06 -0500
Received: from mail-qk1-f178.google.com ([209.85.222.178]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MidPj-1i5QvH1viJ-00fkml; Tue, 17 Dec 2019 16:03:04 +0100
Received: by mail-qk1-f178.google.com with SMTP id t129so2257882qke.10;
        Tue, 17 Dec 2019 07:03:04 -0800 (PST)
X-Gm-Message-State: APjAAAWzOiS9gq08VJXc2Jg0cICH6LbvbFT6vgm8HDWORUX/TGzRBDtz
        NmTpXXOX2VjGyRunFrdDy4SBHKYVDAh43LwboIQ=
X-Google-Smtp-Source: APXvYqwc0fq6mo/e9+54FsMGfmRP7FjPi8In/jh2UBJWxjovcfmNBj+vHsKIKGnSh3evb92wQN+j3ZT+6Ci1E7bllrw=
X-Received: by 2002:a05:620a:a5b:: with SMTP id j27mr5516403qka.286.1576594983209;
 Tue, 17 Dec 2019 07:03:03 -0800 (PST)
MIME-Version: 1.0
References: <20191213204936.3643476-1-arnd@arndb.de> <20191213205417.3871055-12-arnd@arndb.de>
 <20191213211728.GL99875@magnolia> <CAK8P3a3k9dq+9DnPFBKdzOe=ALPXXjCvBBj8r_xsqz1vTswGsg@mail.gmail.com>
In-Reply-To: <CAK8P3a3k9dq+9DnPFBKdzOe=ALPXXjCvBBj8r_xsqz1vTswGsg@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 17 Dec 2019 16:02:47 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2nJKR+_Gc6G_S6Bd0fKecBCM+a2cekOU+6m6kw_c4q9A@mail.gmail.com>
Message-ID: <CAK8P3a2nJKR+_Gc6G_S6Bd0fKecBCM+a2cekOU+6m6kw_c4q9A@mail.gmail.com>
Subject: Re: [PATCH v2 21/24] xfs: quota: move to time64_t interfaces
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:fpGAju1zQvUCcUf48j/gXu75msZcF0o5OEonjKLAZGOjaJEnHuh
 mo3IRrlG1L56Tsae6vueRz7aFXMHpc3MWu7NfQjU6kB3TD9kZAE6FdOeSLqxmQoNVt81olx
 Ygq+wXrGcb2+u8XLMEw8/w7y1ro7H6ua7KLaN03eBRQoN2BdJ5/l0ntWpD6EIenLHspXLxh
 QXq7J2uPz1d/1NjzMDOGQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:6mydIPYCVns=:5M9ks08R1UtQXi/DFck2FR
 WTtu5IVff2r6qNY+6wnQ2ra4JwJGpC1XNNPUJ5Z6QtIBpUA6jqnCmmViTJicjxIeKvbvUvnd4
 Dol1eVuDahuknfQyFL6hrqM+2YEXA4fPiQ0FubpK4+5Hol60TksLoKKyDIHQna5yunmJ2opd4
 PdXshmw2jF3BeMtEiiMouLstQuHrVsJqC6++1iExvOqPrvqoqm91GZQp33JmFUb2HstnYV7Sb
 leP+3SqeStg2foMe4wbRiylhG43kzH0Qa5wzGTW7yjcohcKDQxOkSMDD86KHS2AoZnsBG2kTA
 wbcOgRNLqrRY1GeLcSr3d8Q0NqqYLUvc3Y0YasRc0oObNx9CAlOD3bCluM+7NT4k533bVo6Hv
 EmMMMxXes3e1LQBtQeee9gDi9gbFkeFb8O91kTW02gXbk4349jEtviH8fJLcqD3eehX+UzzDO
 4dTsvpV6g5wrnTB5BoU432aH8+xlecXR4u+TKawzXYMjqH7ufYcDf4kQQjBKKfDw4dFryUteF
 ABQnnaMZ4MA4rZaELoAsI4BGHKPHXA/6l0gzcNIcy2g1owU0N7L4zsPuc2pNBAIyjsmH9LZ/b
 sCot4/8LRk4ABvvoznSiboEBFqoi7+4t9I5iBhqy9Ml1pWM5QTLopLedxayZFreVSu3JKg9sq
 56Hhuc1/MWaDyQc9EaQMD3/qpI1SyJetHufDhg+a/nw/pZXhWX6blQE3DTKECQ8FgUmVJTgHA
 m7EpNOl0OnmsYlV0C/gY9G1cpADSUGXBti3fM2iVJAeI0xLh/mw5ZCuhmi62VuRSH9+cvj9G3
 U3OByhm4a7ayIpdDsmh2GFnur+c4PX8fjZI+5jsRQ7oOnLLYZyJDau1wTkQGRMdohyUjf9X92
 S9aHx3LrDS6049+YJp9Q==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 16, 2019 at 5:52 PM Arnd Bergmann <arnd@arndb.de> wrote:
> On Fri, Dec 13, 2019 at 10:17 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>>
>> Hmm, so one thing that I clean up on the way to bigtime is the total
>> lack of clamping here.  If (for example) it's September 2105 and
>> rtbtimelimit is set to 1 year, this will cause an integer overflow.  The
>> quota timer will be set to 1970 and expire immediately, rather than what
>> I'd consider the best effort of February 2106.

One more hing to note (I will add this to the changelog text) is that on
32-bit architectures, the limit here is y2038, while on 64-bit
architectures it's y2106:

int xfs_trans_dqresv(...)
{
       time_t                  timer; /* signed 'long' */
       timer = be32_to_cpu(dqp->q_core.d_btimer);
       /* get_seconds() returns unsigned long */
      if ((timer != 0 && get_seconds() > timer))
                return -EDQUOT;
}

> I don't think clamping would be good here, that just replaces
> one bug with another at the overflow time. If you would like to
> have something better before this gets extended, I could try to
> come up with a version that converts it to the nearest 64-bit
> timestamp, similar to the way that time_before32() in the kernel
> or the NTP protocol work.
>
> If you think it can get extended properly soon, I'd just leave the
> patch as it is today in order to remove the get_seconds()
> interface for v5.6.

I've tried this now, and but this feels wrong: it adds lots of complexity
for corner cases and is still fragile, e.g. when the time is wrong
during boot before ntp runs. See that patch below for reference.

I also see that quotatool on xfs always uses the old xfs quota
interface, so it already overflows on the user space side. Fixing
this properly seems to be a bigger effort than I was planning for
(on an unpatched 64-bit kernel):

$ sudo quotatool -b    -u  -t 220month  /mnt/tmp -r
$ rm file ; fallocate -l 11M file
$ sudo quotatool -d /mnt/tmp -u arnd
1000 /mnt/tmp 11264 10240 20480 570239975 2 0 00
$ sudo quotatool -b    -u  -t 222month  /mnt/tmp -r
$ rm file ; fallocate -l 11M file
$ sudo quotatool -d /mnt/tmp -u arnd
1000 /mnt/tmp 11264 10240 20480 18446744069990008316 2 0 00

       Arnd

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 9cfd3209f52b..6c9128bb607b 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -98,6 +98,23 @@ xfs_qm_adjust_dqlimits(
                xfs_dquot_set_prealloc_limits(dq);
 }

+static __be32 xfs_quota_timeout32(s64 limit)
+{
+       time64_t now = ktime_get_real_seconds();
+       u32 timeout;
+
+       /* avoid overflows in out-of-range limits */
+       if ((u64)limit > S32_MAX)
+               limit = S32_MAX;
+       timeout = now + limit;
+
+       /* avoid timeout of zero */
+       if (lower_32_bits(timeout) == 0)
+               return cpu_to_be32(1);
+
+       return cpu_to_be32(lower_32_bits(timeout));
+}
+
 /*
  * Check the limits and timers of a dquot and start or reset timers
  * if necessary.
@@ -137,7 +154,7 @@ xfs_qm_adjust_dqtimers(
                    (d->d_blk_hardlimit &&
                     (be64_to_cpu(d->d_bcount) >
                      be64_to_cpu(d->d_blk_hardlimit)))) {
-                       d->d_btimer = cpu_to_be32(ktime_get_real_seconds() +
+                       d->d_btimer = xfs_quota_timeout32(
                                        mp->m_quotainfo->qi_btimelimit);
                } else {
                        d->d_bwarns = 0;
@@ -160,7 +177,7 @@ xfs_qm_adjust_dqtimers(
                    (d->d_ino_hardlimit &&
                     (be64_to_cpu(d->d_icount) >
                      be64_to_cpu(d->d_ino_hardlimit)))) {
-                       d->d_itimer = cpu_to_be32(ktime_get_real_seconds() +
+                       d->d_itimer = xfs_quota_timeout32(
                                        mp->m_quotainfo->qi_itimelimit);
                } else {
                        d->d_iwarns = 0;
@@ -183,7 +200,7 @@ xfs_qm_adjust_dqtimers(
                    (d->d_rtb_hardlimit &&
                     (be64_to_cpu(d->d_rtbcount) >
                      be64_to_cpu(d->d_rtb_hardlimit)))) {
-                       d->d_rtbtimer = cpu_to_be32(ktime_get_real_seconds() +
+                       d->d_rtbtimer = xfs_quota_timeout32(
                                        mp->m_quotainfo->qi_rtbtimelimit);
                } else {
                        d->d_rtbwarns = 0;
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 1ea82764bf89..2087626b4bee 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -601,6 +601,14 @@ xfs_qm_scall_setqlim(
        return error;
 }

+/* Assume timers are within +/- 68 years of current wall clock */
+static time64_t xfs_quota_time32_to_time64(time64_t now, __be32 timer)
+{
+       s32 diff = be32_to_cpu(timer) - lower_32_bits(now);
+
+       return now + diff;
+}
+
 /* Fill out the quota context. */
 static void
 xfs_qm_scall_getquota_fill_qc(
@@ -609,6 +617,8 @@ xfs_qm_scall_getquota_fill_qc(
        const struct xfs_dquot  *dqp,
        struct qc_dqblk         *dst)
 {
+       time64_t now = ktime_get_real_seconds();
+
        memset(dst, 0, sizeof(*dst));
        dst->d_spc_hardlimit =
                XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_blk_hardlimit));
@@ -618,8 +628,8 @@ xfs_qm_scall_getquota_fill_qc(
        dst->d_ino_softlimit = be64_to_cpu(dqp->q_core.d_ino_softlimit);
        dst->d_space = XFS_FSB_TO_B(mp, dqp->q_res_bcount);
        dst->d_ino_count = dqp->q_res_icount;
-       dst->d_spc_timer = be32_to_cpu(dqp->q_core.d_btimer);
-       dst->d_ino_timer = be32_to_cpu(dqp->q_core.d_itimer);
+       dst->d_spc_timer = xfs_quota_time32_to_time64(now,
dqp->q_core.d_btimer);
+       dst->d_ino_timer = xfs_quota_time32_to_time64(now,
dqp->q_core.d_itimer);
        dst->d_ino_warns = be16_to_cpu(dqp->q_core.d_iwarns);
        dst->d_spc_warns = be16_to_cpu(dqp->q_core.d_bwarns);
        dst->d_rt_spc_hardlimit =
@@ -627,7 +637,7 @@ xfs_qm_scall_getquota_fill_qc(
        dst->d_rt_spc_softlimit =
                XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_rtb_softlimit));
        dst->d_rt_space = XFS_FSB_TO_B(mp, dqp->q_res_rtbcount);
-       dst->d_rt_spc_timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
+       dst->d_rt_spc_timer = xfs_quota_time32_to_time64(now,
dqp->q_core.d_rtbtimer);
        dst->d_rt_spc_warns = be16_to_cpu(dqp->q_core.d_rtbwarns);

        /*
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index d1b9869bc5fa..c75887da6546 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -636,7 +636,8 @@ xfs_trans_dqresv(
                        }
                        if (softlimit && total_count > softlimit) {
                                if ((timer != 0 &&
-                                    ktime_get_real_seconds() > timer) ||
+                                    time_after32(ktime_get_real_seconds(),
+                                                 timer)) ||
                                    (warns != 0 && warns >= warnlimit)) {
                                        xfs_quota_warn(mp, dqp,
                                                       QUOTA_NL_BSOFTLONGWARN);
@@ -664,7 +665,8 @@ xfs_trans_dqresv(
                        }
                        if (softlimit && total_count > softlimit) {
                                if  ((timer != 0 &&
-                                     ktime_get_real_seconds() > timer) ||
+                                    time_after32(ktime_get_real_seconds(),
+                                                 timer)) ||
                                     (warns != 0 && warns >= warnlimit)) {
                                        xfs_quota_warn(mp, dqp,
                                                       QUOTA_NL_ISOFTLONGWARN);
