Return-Path: <SRS0=ynSb=5F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1535CC4332E
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 15:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5AC12070A
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 15:48:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dEgk5Z1u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgCTPsX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Mar 2020 11:48:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53582 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgCTPsX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Mar 2020 11:48:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02KFfP3Y107070;
        Fri, 20 Mar 2020 15:48:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ovcL01/vq/j9hTSy6hTXz5DN9I28B9z8oOT9Txuyjlc=;
 b=dEgk5Z1uJORRR6R4fneC3Err8WI0m1bocoU4X8I96WCGYWqPEEouIKEYRK8HqXV4HHHA
 ecpGnJRgouUyRuYcFREMr9OaLbfBfWsn4MwMoN2LvLkyMo8lXUG014OVe0p67edG6uuy
 K/fKdZk7Ow/SblZCOnZj+0wjtn8TKlmnVoMDijPjjLduqQxhOtT9Xx9ilm/caIOLdl2+
 5aVSqnCXYHKQTqgC5HnBZdZ0oU5Ti+vyVU5L34pSMLwX5jaN27+592fSQKHQnHBgwZ0+
 rQDv4tlzBabFr24waK/eI+y8CWALElbBGP4JFoJRt665Ot4dZdnePrMoZK9PStI7H/Lc kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yrq7meb1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Mar 2020 15:48:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02KFLuet189679;
        Fri, 20 Mar 2020 15:48:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ys92quraw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Mar 2020 15:48:16 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02KFmDk1023709;
        Fri, 20 Mar 2020 15:48:15 GMT
Received: from localhost (/10.159.129.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 20 Mar 2020 08:48:13 -0700
Date:   Fri, 20 Mar 2020 08:48:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v6 1/4] xfs: Refactor xfs_isilocked()
Message-ID: <20200320154812.GA6812@magnolia>
References: <20200227203636.317790-1-preichl@redhat.com>
 <20200227203636.317790-2-preichl@redhat.com>
 <20200228171014.GC8070@magnolia>
 <CAJc7PzUGViiVOuaJz8+cPoxGZZiLkNq23vamCdLktJtxpmRh_Q@mail.gmail.com>
 <62b07adc-eb63-0fd2-8206-38052abfe494@sandeen.net>
 <20200318184927.GE256767@magnolia>
 <CAJc7PzUW23DHtxOLbvYiX9mYMqqfyEbPb9YgQx-PA-mOvnJE_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJc7PzUW23DHtxOLbvYiX9mYMqqfyEbPb9YgQx-PA-mOvnJE_Q@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9566 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003200064
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9566 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003200064
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 20, 2020 at 03:41:08PM +0100, Pavel Reichl wrote:
> On Wed, Mar 18, 2020 at 7:50 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > On Wed, Mar 18, 2020 at 12:46:37PM -0500, Eric Sandeen wrote:
> > > On 3/18/20 12:13 PM, Pavel Reichl wrote:
> > > > On Fri, Feb 28, 2020 at 6:10 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > >
> > > ...
> > >
> > > >> So, this function's call signature should change so that callers can
> > > >> communicate both _SHARED and _EXCL; and then you can pick the correct
> > > >
> > > > Thanks for the suggestion...but that's how v5 signature looked like
> > > > before Christoph and Eric requested change...on the grounds that
> > > > there're:
> > > > *  confusion over a (true, true) set of args
> > > > *  confusion of what happens if we pass (false, false).
> >
> > Yeah.  I don't mean adding back the dual booleans, I meant refactoring
> > the way we define the lock constants so that you can use bit shifting
> > and masking:
> >
> > #define XFS_IOLOCK_SHIFT        0
> > #define XFS_ILOCK_SHIFT         2
> > #define XFS_MMAPLOCK_SHIFT      4
> >
> > #define XFS_SHARED_LOCK_SHIFT   1
> >
> > #define XFS_IOLOCK_EXCL     (1 << (XFS_IOLOCK_SHIFT))
> > #define XFS_IOLOCK_SHARED   (1 << (XFS_IOLOCK_SHIFT + XFS_SHARED_LOCK_SHIFT))
> > #define XFS_ILOCK_EXCL      (1 << (XFS_ILOCK_SHIFT))
> > #define XFS_ILOCK_SHARED    (1 << (XFS_ILOCK_SHIFT + XFS_SHARED_LOCK_SHIFT))
> > #define XFS_MMAPLOCK_EXCL   (1 << (XFS_MMAPLOCK_SHIFT))
> > #define XFS_MMAPLOCK_SHARED (1 << (XFS_MMAPLOCK_SHIFT + XFS_SHARED_LOCK_SHIFT))
> 
> Thank you for the code - now I see what you meant and I like it,
> however allow me a question:
> Are you aware that XFS_IOLOCK_SHIFT, XFS_MMAPLOCK_SHIFT,
> XFS_ILOCK_SHIFT are already defined with different values and used in
> xfs_lock_inumorder()?
> 
> I have no trouble to investigate the code and see if it is OK i.g.
> XFS_IOLOCK_EXCL to be 21 (I guess I should check that no bit arrays
> are used to store the value, etc)
> 
> Or maybe I should just rewrite  the '#define XFS_IOLOCK_SHIFT
> 0' to something like '#define XFS_IOLOCK_TYPE_SHIFT        0' ?
> 
> Do you have any thoughts about that?

XFS_IOLOCK_TYPE_SHIFT seems fine to me to avoid clashing with lockdep. :)

(perhaps XFS_IOLOCK_FLAG_SHIFT?)

--D

> 
> Thanks!
> 
> 
> >
> > Because then in the outer xfs_isilocked function you can do:
> >
> > if (lock_flags & (XFS_ILOCK_EXCL | XFS_ILOCK_SHARED))
> >         return __isilocked(&ip->i_lock, lock_flags >> XFS_ILOCK_SHIFT);
> >
> > if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED))
> >         return __isilocked(&ip->i_mmaplock, lock_flags >> XFS_MMAPLOCK_SHIFT);
> >
> > if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED))
> >         return __isilocked(&VFS_I(ip)->i_rwsem, lock_flags >> XFS_IOLOCK_SHIFT);
> >
> > And finally in __isilocked you can do:
> >
> > static inline bool __isilocked(rwsem, lock_flags)
> > {
> >         int     arg;
> >
> >         if (!debug_locks)
> >                 return rwsem_is_locked(rwsem);
> >
> >         if (lock_flags & (1 << XFS_SHARED_LOCK_SHIFT)) {
> >                 /*
> >                  * The caller could be asking if we have (shared | excl)
> >                  * access to the lock.  Ask lockdep if the rwsem is
> >                  * locked either for read or write access.
> >                  *
> >                  * The caller could also be asking if we have only
> >                  * shared access to the lock.  Holding a rwsem
> >                  * write-locked implies read access as well, so the
> >                  * request to lockdep is the same for this case.
> >                  */
> >                 arg = -1;
> >         } else {
> >                 /*
> >                  * The caller is asking if we have only exclusive access
> >                  * to the lock.  Ask lockdep if the rwsem is locked for
> >                  * write access.
> >                  */
> >                 arg = 0;
> >         }
> >         return lockdep_is_held_type(rwsem, arg);
> > }
> >
> > > >> "r" parameter value for the lockdep_is_held_type() call.  Then all of
> > > >> this becomes:
> > > >>
> > > >>         if !debug_locks:
> > > >>                 return rwsem_is_locked(rwsem)
> > > >>
> > > >>         if shared and excl:
> > > >>                 r = -1
> > > >>         elif shared:
> > > >>                 r = 1
> > > >>         else:
> > > >>                 r = 0
> > > >>         return lockdep_is_held_type(rwsem, r)
> > > >
> > > > I tried to create a table for this code as well:
> > >
> > > <adding back the table headers>
> > >
> > > > (nolockdep corresponds to debug_locks == 0)
> > > >
> > > > RWSEM STATE             PARAMETERS TO XFS_ISILOCKED:
> > > >                         SHARED  EXCL    SHARED | EXCL
> > > > readlocked              y       n       y
> > > > writelocked             *n*     y       y
> > > > unlocked                n       n       n
> > > > nolockdep readlocked    y       y       y
> > > > nolockdep writelocked   y       y       y
> > > > nolockdep unlocked      n       n       n
> > > >
> > > > I think that when we query writelocked lock for being shared having
> > > > 'no' for an answer may not be expected...or at least this is how I
> > > > read the code.
> > >
> > > This might be ok, because
> > > a) it is technically correct (is it shared? /no/ it is exclusive), and
> > > b) in the XFS code today we never call:
> > >
> > >       xfs_isilocked(ip, XFS_ILOCK_SHARED);
> > >
> > > it's always:
> > >
> > >       xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
> > >
> > > So I think that if we document the behavior clearly, the truth table above
> > > would be ok.
> > >
> > > Thoughts?
> >
> > No, Pavel's right, I got the pseudocode wrong, because holding a write
> > lock means you also hold the read lock.
> >
> >         if !debug_locks:
> >                 return rwsem_is_locked(rwsem)
> >
> >         if shared:
> >                 r = -1
> >         else:
> >                 r = 0
> >         return lockdep_is_held_type(rwsem, r)
> >
> > --D
> >
> > > -Eric
> >
> 
