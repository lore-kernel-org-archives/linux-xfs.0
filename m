Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:45331 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752245AbeDUDWk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Apr 2018 23:22:40 -0400
Message-ID: <5ADAAE79.5020803@cn.fujitsu.com>
Date: Sat, 21 Apr 2018 11:22:33 +0800
From: Xiao Yang <yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Subject: question about mkfs.xfs
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

Hi Eric£¬

Before commit 16adcb8 in xfsprogs-dev, only "sunit=0,swidth=0" is vaild
and will convert
into the default stripe config as expected. After this commit, both
"sunit=0,swidth=0"
and "sunit=0,swidth=64" will be forced to convert into the default
stripe config.

If either of sunit and swidth is not 0, should we do a forced conversion?
I am not sure if we should reject the combination(e.g. sunit=0,swidth=64).

Thanks,
Xiao Yang


