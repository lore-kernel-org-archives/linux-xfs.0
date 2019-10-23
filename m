Return-Path: <SRS0=UAxe=YQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 720B9CA9EA0
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 02:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4746D2053B
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 02:37:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="dDYsvw2x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387695AbfJWChm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 22:37:42 -0400
Received: from mout.gmx.net ([212.227.17.22]:60877 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732279AbfJWChl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Oct 2019 22:37:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1571798239;
        bh=G1Ko12j0L7dYxIRBxxdebwm3oJ5jJdlUh7AAblDIu+k=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=dDYsvw2xJnhc0F0bu8F6kVmDemF9mhLrqQx8g6m4lur11TLel+L7apOuWQ3P6bYle
         0Z1WI5yGpCmtod1gBODKSnLcuvj28iOeWHZMxGmz4NQ97unrUGMkejTH/0/SPjj1eg
         81f6h0/HFQKbH83p7JYsjIlrVumWS28NMCStDN74=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.2.153] ([34.92.93.240]) by mail.gmx.com (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mqs0X-1hj2kR0cjp-00mpvq; Wed, 23
 Oct 2019 04:37:19 +0200
Subject: Re: [Bug 205135] System hang up when memory swapping (kswapd
 deadlock)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org, goodmirek@goodmirek.com,
        Hillf Danton <hillf.zj@alibaba-inc.com>,
        Dmitry Vyukov <dvyukov@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
References: <bug-205135-27@https.bugzilla.kernel.org/>
 <bug-205135-27-vbbrgnF9A3@https.bugzilla.kernel.org/>
 <20191022152422.e47fda82879dc7cd1f3cf5e5@linux-foundation.org>
 <20191023012228.GP913374@magnolia>
From:   Su Yue <Damenly_Su@gmx.com>
Message-ID: <1b2a8e67-bd52-1905-34a5-477f9987004c@gmx.com>
Date:   Wed, 23 Oct 2019 10:37:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:70.0)
 Gecko/20100101 Thunderbird/70.0
MIME-Version: 1.0
In-Reply-To: <20191023012228.GP913374@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:8BmaCzBMLLZVp53lF81bAZfe4HjIGEsdj8mitXa/7UailVAjtSO
 st5Q/FDUXY5L9FNglyQmLfACFI+DnbPhL2rlzGf/aqYA5W/jsVl3sEMA2CieZhRBsMKiIjd
 /jh4ZoWA+RoixOe9zUFWCZNqQcEcXrMKeKiwHpGy9dr2rwZpghLdBiVMGF2AlELQZifTVOY
 VbaoPn/+y2SWpEG3K/AgA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:KsBL4bJxrEA=:3UPzFW23vlEg6KldB4U9BW
 wBSWx5doSC9o1ujXidN3t4F1sFKbD+PSbk3Md40kdi/uG1hqPV+pGiObWBkTykbJKD209od4s
 QRMPZXxkwP94/nA5dTkXpw5GXublSO5RpR2uy9MQ/zrNNKhmvQ9t1gf1YNY9aeT1jbN5GCNSW
 mq+Sdk7dUAP8egaPFs+DmNtzAVufVQEtPFFgQ0sT1qmH7DAMfuBt4KvMBR4slhswRGfXxhNYy
 Mg90eMxy7XF3fx61eNci6sM1TFLpHOoAYIbNaJzq8kuEbwTs5jLOq6XCU+k4OK8Xf08B008vq
 xIJ7wmRYW8adRrD5/HJvAOHm0Od1kiczYa9TMmHRBtgs9lL8dBqpOteMgRrbD/pV2SIDYQuk1
 fc5W8HO3fxDMDWQv7dFCa3CtK5UNjXM1wD11EBHE2q+Kl+O0DuB3FxzIVhCXBAlnCtXcdhtWT
 2eMFI44KGxBX40sZdTgGjraJz/V3KUQjvq2LmDIYs1J3WGt3O1ooKnmwQaH/rvtIRT0rqB8vz
 80CZGghhyh/QZqh9i51fkObkpX0TdWCNcqINEJCKbvYfTnHJlczOh06W80SLeZb5dp4EFrBlK
 sKwW94ha0d3c3isz1wf8kBc93ZwXxnQZn1ZDVshIUlzPhh7fLr09W7JpPOCvcJfazlVT5sQho
 IT+dMeIuKdXHOmxaDeE2woq/WEbVegYYOlNY+YGB4BVMwIEYQVGoG2o5Pics+NFeRpK5RzYLr
 CS87JAo8lxMIyodHtDMkCIJdWvou9/EIrVG4PjsptW12PIL5rIVP6EHCCEkTvPked15kWdQ6m
 67Eohp9a9YL1+cQuF/RQk2LW27VG+T87XpnFmGMigAkWNclp4wTxZ+j5yVTH32iCw/LBqkHB5
 aavJDSnspeVhYPf+RLl5eqmERG5YyL26QEo72zh3wRrYbR1DC8L4cPCtfg9OlyFIcVBzYn1k1
 yPi4QPG8fsvNMQH5HtI2fnep8bbtp1EhcX+TOoN+IFUQnlUyx+jzqwamGlldVCuVACnXqtcg/
 G9iYhMGDqI5i4SthSWLA1igE5Gq+fz7K2HT7gjEZkTYN9he+LujTmStdlLTbvfi2T6TGcTDXs
 UoGoQDPXAXT9VpW02+ACE6evSCtlF9DGqnK2T1JTlsKwPCpShS+DOVlBNh7plsek8HDZzyHsY
 QcasSHwUs8lhOy1kAiOhTO2btN0l+uX/E/F1Ld74GmFzNdY+y3TB6WmxapA0XGQSrotzH0jsY
 6kyzIYUe3ZMvFdkvQAmEV1x4xv/QVTyr3tVIG5VEYLIIalU0c+kCia1MzCM4=
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just to remind, running xfstests/generic/273 could trigger the lockdep
deadlock warning.

=2D-
Su

On 2019/10/23 9:22 AM, Darrick J. Wong wrote:
> On Tue, Oct 22, 2019 at 03:24:22PM -0700, Andrew Morton wrote:
>>
>> (switched to email.  Please respond via emailed reply-to-all, not via t=
he
>> bugzilla web interface).
>>
>> On Tue, 22 Oct 2019 09:02:22 +0000 bugzilla-daemon@bugzilla.kernel.org =
wrote:
>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D205135
>>>
>>> --- Comment #7 from goodmirek@goodmirek.com ---
>>> Everyone who uses a swapfile on XFS filesystem seem affected by this h=
ang up.
>>> Not sure about other filesystems, I did not have a chance to test it e=
lsewhere.
>>>
>>> This unreproduced bot crash could be related:
>>> https://lore.kernel.org/linux-mm/20190910071804.2944-1-hdanton@sina.co=
m/
>>
>> Thanks.  Might be core MM, might be XFS, might be Fedora.
>>
>> Hilf, does your patch look related?  That seems to have gone quiet?
>>
>> Should we progress Tetsuo's patch?
>
> Hmm...
>
> Oct 09 15:44:52 kernel: Linux version 5.4.0-0.rc1.git1.1.fc32.x86_64 (mo=
ckbuild@bkernel03.phx2.fedoraproject.org) (gcc version 9.2.1 20190827 (Red=
 Hat 9.2.1-1) (GCC)) #1 SMP Fri Oct 4 14:57:23 UTC 2019
>
> ...istr 5.4-rc1 had some writeback bugs in it...
>
>                          -> #1 (fs_reclaim){+.+.}:
> Oct 09 13:47:08 kernel:        fs_reclaim_acquire.part.0+0x25/0x30
> Oct 09 13:47:08 kernel:        __kmalloc+0x4f/0x330
> Oct 09 13:47:08 kernel:        kmem_alloc+0x83/0x1a0 [xfs]
> Oct 09 13:47:08 kernel:        kmem_alloc_large+0x3c/0x100 [xfs]
> Oct 09 13:47:08 kernel:        xfs_attr_copy_value+0x5d/0xa0 [xfs]
> Oct 09 13:47:08 kernel:        xfs_attr_get+0xe7/0x1d0 [xfs]
> Oct 09 13:47:08 kernel:        xfs_get_acl+0xad/0x1e0 [xfs]
> Oct 09 13:47:08 kernel:        get_acl+0x81/0x110
> Oct 09 13:47:08 kernel:        posix_acl_create+0x58/0x160
> Oct 09 13:47:08 kernel:        xfs_generic_create+0x7e/0x2f0 [xfs]
> Oct 09 13:47:08 kernel:        lookup_open+0x5bd/0x820
> Oct 09 13:47:08 kernel:        path_openat+0x340/0xcb0
> Oct 09 13:47:08 kernel:        do_filp_open+0x91/0x100
> Oct 09 13:47:08 kernel:        do_sys_open+0x184/0x220
> Oct 09 13:47:08 kernel:        do_syscall_64+0x5c/0xa0
> Oct 09 13:47:08 kernel:        entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> That's XFS trying to allocate memory to load an acl off disk, only it
> looks this thread does a MAYFAIL allocation.  It's a GFP_FS (since we
> don't set KM_NOFS) allocation so we recurse into fs reclaim, and the
> ACL-getter has locked the inode (which is probably why lockdep
> triggers).  I wonder if that's really a deadlock vs. just super-slow
> behavior, but otoh I don't think we're supposed to allow reclaim to jump
> into the filesystems when the fs has locks held.
>
> That kmem_alloc_large should probably be changed to KM_NOFS.  Dave?
>
> --D
>
