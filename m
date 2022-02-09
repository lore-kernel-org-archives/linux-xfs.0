Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B62BC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Feb 2022 02:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242946AbiBICja (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Feb 2022 21:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245362AbiBICdR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Feb 2022 21:33:17 -0500
Received: from out20-14.mail.aliyun.com (out20-14.mail.aliyun.com [115.124.20.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A06C0613CC
        for <linux-xfs@vger.kernel.org>; Tue,  8 Feb 2022 18:33:13 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.05127427|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.136322-0.00200466-0.861674;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047193;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.MnGBlVd_1644373990;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.MnGBlVd_1644373990)
          by smtp.aliyun-inc.com(10.147.44.118);
          Wed, 09 Feb 2022 10:33:11 +0800
Date:   Wed, 09 Feb 2022 10:33:14 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Eric Sandeen <esandeen@redhat.com>
Subject: Re: Any guide to replace a xfs logdev?
Cc:     linux-xfs@vger.kernel.org
In-Reply-To: <6e68c345-8f08-7c16-107e-9e9dacc4f385@redhat.com>
References: <20220208112322.E7D4.409509F4@e16-tech.com> <6e68c345-8f08-7c16-107e-9e9dacc4f385@redhat.com>
Message-Id: <20220209103314.BA30.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.75.04 [en]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

Thanks a lot.

'xfs_repair -L' works well to replace a xfs logdev.
# kernel: 4.18.0-348 / 5.15.21

but a qestion 'cleanly unmounted' below.


> On 2/7/22 9:23 PM, Wang Yugui wrote:
> > Hi,
> > 
> > Any guide to replace a xfs logdev?
> > 
> > case 1: logdev device failed.
> > case 2: replace the logdev with a new NVDIMM-N device.
> > 
> > but I failed to find out some guide to  replace a xfs logdev.
> 
> The external log is specified at mount time on the mount command line,
> so all you should need to do is use the "-o logdev=/dev/XXX" option
> to point at the new device, which must be at least as large as the old
> device, and should be completely zeroed.
> 
> If the filesystem was cleanly unmounted, this should be all that is required.

'mount -o logdev=/dev/newlogdevice' failed,
# kernel: 4.18.0-348(centos 8.5) / 5.15.21

the message in dmesg:
Corruption warning: Metadata has LSN (1:6) ahead of current LSN (1:0).
Please unmount and run xfs_repair (>= v4.3) to resolve.

/dev/newlogdevice is with a same size, and zeroed by blkdiscard(SSD)

'umount' is not enough to get  a  ' cleanly unmounted'?


> If the log device failed during operation, the filesystem is probably
> not consistent, and you will most likely need to run an xfs_repair,
> zeroing out the log and repairing any inconsistencies, since your log
> device has failed and no longer replayable. So, something like:
> 
> # xfs_repair -L -l /dev/newlogdevice /dev/xfsdevice
> 
> where /dev/xfsdevice is your data device holding the filesystem,
> and /dev/newlogdevice is your new/replaced log device.
> 
> Before you actually do this, you might want to see if anyone corrects
> my statements or notices anything I missed. ;)


Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2022/02/09


