Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B360DC433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Dec 2021 19:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243909AbhLFTW0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Dec 2021 14:22:26 -0500
Received: from sandeen.net ([63.231.237.45]:37970 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235258AbhLFTWZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Dec 2021 14:22:25 -0500
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id DA8B978F9
        for <linux-xfs@vger.kernel.org>; Mon,  6 Dec 2021 13:18:49 -0600 (CST)
Message-ID: <a51287e1-e844-b77f-384f-e682a6cee70c@sandeen.net>
Date:   Mon, 6 Dec 2021 13:18:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: mkfs.xfs ignores data stripe on 4k devices?
Content-Language: en-US
From:   Eric Sandeen <sandeen@sandeen.net>
To:     xfs <linux-xfs@vger.kernel.org>
References: <0c94c1ed-0f3f-ad3f-d57a-158ea681ce19@sandeen.net>
In-Reply-To: <0c94c1ed-0f3f-ad3f-d57a-158ea681ce19@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

That should have been "ignores data device stripe geometry for an internal log ..."

On 12/6/21 1:16 PM, Eric Sandeen wrote:
> This seems odd, and unusual to me, but it's been there so long I'm wondering
> if it's intentional.
> 
> We have various incarnations of this in mkfs since 2003:
> 
>          } else if (lsectorsize > XFS_MIN_SECTORSIZE && !lsu && !lsunit) {
>                  lsu = blocksize;
>                  logversion = 2;
>          }
> 
> which sets the log stripe unit before we query the device geometry, and so
> with the log stripe unit already set, we ignore subsequent device geometry
> that may be discovered:
> 
> # modprobe scsi_debug dev_size_mb=1024 opt_xferlen_exp=10 physblk_exp=3
> 
> # mkfs.xfs -f /dev/sdh
> meta-data=/dev/sdh               isize=512    agcount=8, agsize=32768 blks
>           =                       sectsz=4096  attr=2, projid32bit=1
>           =                       crc=1        finobt=1, sparse=1, rmapbt=0
>           =                       reflink=1    bigtime=0 inobtcount=0
> data     =                       bsize=4096   blocks=262144, imaxpct=25
>           =                       sunit=128    swidth=128 blks
>                                   ^^^^^^^^^
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=2560, version=2
>           =                       sectsz=4096  sunit=1 blks, lazy-count=1
>                                                ^^^^^^^^^^^^
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> surely this is unintentional and suboptimal? But please sanity-check me,
> I don't know how this could have stood since 2003 w/o being noticed...
> 
> Thanks,
> -Eric
> 
> 
