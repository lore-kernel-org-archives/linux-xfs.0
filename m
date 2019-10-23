Return-Path: <SRS0=UAxe=YQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17279CA9EA0
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 01:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1F802086D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 01:22:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PL5gjaRf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732637AbfJWBWu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 21:22:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38284 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbfJWBWu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 21:22:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9N1JPue005519;
        Wed, 23 Oct 2019 01:22:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ABSgUsWOHhv4YTByO/xrXRjZnZrcTi5fA20Rf2nUiz0=;
 b=PL5gjaRfeAn1+B9b4IDGx2ibt1D6ZszGom6Wl/V8OVwkk7FTUvz0mxRRfsxIcpP6t1Xt
 cPbLBKSgXFUMwBEGQz1E/pENfKHKe1evt6W7tbuiShB++vF5tQFgHb689NpSqQ2Dupyo
 Q4U69JIEwCaBa5y+1LOzaG0Cv2BFoz2WcvJW/niS5AebvNmxbPFZbujH8Yb0i8hdfk/V
 KWi8b0ZOVNjCyO2bPt8gTUVRgd/OE09TB1DE5Sj3Km/OkwEtnuNc51i7hVELsB1orI4n
 YueICJxpePdtvkgGz4B0OOQvpKpcJpLkdpkX36bfXCz+owbX1iWwMm062Ha1fgQrXbV+ eQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vqswtj9m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Oct 2019 01:22:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9N1JPf7091876;
        Wed, 23 Oct 2019 01:22:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vsx2sdpwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Oct 2019 01:22:34 +0000
Received: from abhmp0023.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9N1MUHZ027148;
        Wed, 23 Oct 2019 01:22:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Oct 2019 01:22:30 +0000
Date:   Tue, 22 Oct 2019 18:22:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org, goodmirek@goodmirek.com,
        Hillf Danton <hillf.zj@alibaba-inc.com>,
        Dmitry Vyukov <dvyukov@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [Bug 205135] System hang up when memory swapping (kswapd
 deadlock)
Message-ID: <20191023012228.GP913374@magnolia>
References: <bug-205135-27@https.bugzilla.kernel.org/>
 <bug-205135-27-vbbrgnF9A3@https.bugzilla.kernel.org/>
 <20191022152422.e47fda82879dc7cd1f3cf5e5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022152422.e47fda82879dc7cd1f3cf5e5@linux-foundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910230010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910230011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 22, 2019 at 03:24:22PM -0700, Andrew Morton wrote:
> 
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> On Tue, 22 Oct 2019 09:02:22 +0000 bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> > https://bugzilla.kernel.org/show_bug.cgi?id=205135
> > 
> > --- Comment #7 from goodmirek@goodmirek.com ---
> > Everyone who uses a swapfile on XFS filesystem seem affected by this hang up.
> > Not sure about other filesystems, I did not have a chance to test it elsewhere.
> > 
> > This unreproduced bot crash could be related:
> > https://lore.kernel.org/linux-mm/20190910071804.2944-1-hdanton@sina.com/
> 
> Thanks.  Might be core MM, might be XFS, might be Fedora.
> 
> Hilf, does your patch look related?  That seems to have gone quiet?
> 
> Should we progress Tetsuo's patch?

Hmm...

Oct 09 15:44:52 kernel: Linux version 5.4.0-0.rc1.git1.1.fc32.x86_64 (mockbuild@bkernel03.phx2.fedoraproject.org) (gcc version 9.2.1 20190827 (Red Hat 9.2.1-1) (GCC)) #1 SMP Fri Oct 4 14:57:23 UTC 2019

...istr 5.4-rc1 had some writeback bugs in it...

                        -> #1 (fs_reclaim){+.+.}:
Oct 09 13:47:08 kernel:        fs_reclaim_acquire.part.0+0x25/0x30
Oct 09 13:47:08 kernel:        __kmalloc+0x4f/0x330
Oct 09 13:47:08 kernel:        kmem_alloc+0x83/0x1a0 [xfs]
Oct 09 13:47:08 kernel:        kmem_alloc_large+0x3c/0x100 [xfs]
Oct 09 13:47:08 kernel:        xfs_attr_copy_value+0x5d/0xa0 [xfs]
Oct 09 13:47:08 kernel:        xfs_attr_get+0xe7/0x1d0 [xfs]
Oct 09 13:47:08 kernel:        xfs_get_acl+0xad/0x1e0 [xfs]
Oct 09 13:47:08 kernel:        get_acl+0x81/0x110
Oct 09 13:47:08 kernel:        posix_acl_create+0x58/0x160
Oct 09 13:47:08 kernel:        xfs_generic_create+0x7e/0x2f0 [xfs]
Oct 09 13:47:08 kernel:        lookup_open+0x5bd/0x820
Oct 09 13:47:08 kernel:        path_openat+0x340/0xcb0
Oct 09 13:47:08 kernel:        do_filp_open+0x91/0x100
Oct 09 13:47:08 kernel:        do_sys_open+0x184/0x220
Oct 09 13:47:08 kernel:        do_syscall_64+0x5c/0xa0
Oct 09 13:47:08 kernel:        entry_SYSCALL_64_after_hwframe+0x49/0xbe

That's XFS trying to allocate memory to load an acl off disk, only it
looks this thread does a MAYFAIL allocation.  It's a GFP_FS (since we
don't set KM_NOFS) allocation so we recurse into fs reclaim, and the
ACL-getter has locked the inode (which is probably why lockdep
triggers).  I wonder if that's really a deadlock vs. just super-slow
behavior, but otoh I don't think we're supposed to allow reclaim to jump
into the filesystems when the fs has locks held.

That kmem_alloc_large should probably be changed to KM_NOFS.  Dave?

--D
