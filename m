Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EF2C17440
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 08:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01DB821E6F
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 08:40:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="jLrpEgHM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="aRzBUiI/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbfKLIkp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 03:40:45 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:42639 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727065AbfKLIkp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 03:40:45 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id ADE29583;
        Tue, 12 Nov 2019 03:40:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 12 Nov 2019 03:40:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        0sw6NGVNSkMgugQB3SyMJOPI1XuB+MQ57NtIWRdvmh0=; b=jLrpEgHMQDJmqgEO
        Iw7m1guQw8IEJ/GXEaJwspOhlyGN75yT8mZ2wc5X1spVZVpbEP7HcmqbZgMghO6a
        OVOe58dj2oql5KphHK0/xOJmpN5uzsjkEUc7m6C3OvhILzxmwmI8uL/h/Vrm7fvi
        gC75BYrNEQ3iZMA8e061LulRMHHgxl9rxYvdQzBqoMsXFSvOlnPlcWmZTHbJtDDj
        lVKE7VlFBcrNFSgknOVlhe1GCe0w3tqEIgaCg+rvx6rBPBtSjwFZewrjSO0WdKzt
        mdTBtK0kO5TtMgaZimq8hidz4tpoMSglYKj2GHK7qqSA1zheiun9Hu3TUVL65zR1
        bSOJWQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=0sw6NGVNSkMgugQB3SyMJOPI1XuB+MQ57NtIWRdvm
        h0=; b=aRzBUiI/tA+Qob4M+kxeus2lVPy6N/ryKIpMx00lID4e+taSOAOQoPrac
        xn/7pFvWcASA85EFLczzaTQeQKzXbDz4NXVX9uWWATex9o/bB2zGCqYeT1+GiLYS
        BoFx61gdI0iGRak8oQd5n+1pXGaoHmu/Jg6nn+fWclEqxDYKtNDuztM4JTL66Jno
        qudNJyjEQE2WvPPptVzuLmmzGgMkldfaSRjUBnNTpIPQ6ElDbcxNo6ybt+VDIrlk
        2/jWWsrYrUpE7VoAuPG/TzqqNgaQrwZz5VsHkbIVoBWGweo81gMfK42CUzLcDwBw
        o9c9XPpPTPcS0vdYIBpnGVtZ8KU5g==
X-ME-Sender: <xms:CnDKXSYeIN7i1IY1Y0BJ_NhoVfKam5B-K57Rq1iugTuvfTCmZaf5YA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvkedgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhushhpvggtthffohhmrghinhculdegledmnecujfgurhepkffuhffvffgjfhgtofgg
    gfesthejredtredtjeenucfhrhhomhepkfgrnhcumfgvnhhtuceorhgrvhgvnhesthhhvg
    hmrgifrdhnvghtqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhkmhhsghdruggv
    vhdpghhithhhuhgsrdhiohdpghhithhhuhgsrdgtohhmnecukfhppeduudekrddvtdekrd
    dukeelrddukeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:CnDKXdkKPfBB0yCkvuNMSEN1DLWCUC6QCs4PSiHkXfU6viJ7JJwAWQ>
    <xmx:CnDKXYhWQ9mkK7bS2Pe00lhpYDXwvmfj6-hBy5XsFkGZw90vwuqgzg>
    <xmx:CnDKXfSNQhm0bPpYs63wUqtCos0shJKXE3TscG3vcMkNBVFKwwhI_Q>
    <xmx:C3DKXZx7_RTRm5-j87zoNsbMfdh04H4HH6S3sA3Byzcrqau1LK_rdQ>
Received: from centos8 (unknown [118.208.189.18])
        by mail.messagingengine.com (Postfix) with ESMTPA id 65ECF3060060;
        Tue, 12 Nov 2019 03:40:39 -0500 (EST)
Message-ID: <3fb8b1b04dd7808b45caf5262ee629c09c71e0b6.camel@themaw.net>
Subject: Re: [xfs] 73e5fff98b: kmsg.dev/zero:Can't_open_blockdev
From:   Ian Kent <raven@themaw.net>
To:     kernel test robot <rong.a.chen@intel.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
        lkp@lists.01.org, ltp@lists.linux.it
Date:   Tue, 12 Nov 2019 16:39:50 +0800
In-Reply-To: <20191111010022.GH29418@shao2-debian>
References: <20191111010022.GH29418@shao2-debian>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-6.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2019-11-11 at 09:00 +0800, kernel test robot wrote:
> FYI, we noticed the following commit (built with gcc-7):
> 
> commit: 73e5fff98b6446de1490a8d7809121b0108d49f4 ("xfs: switch to use
> the new mount-api")
> https://git.kernel.org/cgit/fs/xfs/xfs-linux.git xfs-5.5-merge
> 
> in testcase: ltp
> with following parameters:
> 
> 	disk: 1HDD
> 	fs: xfs
> 	test: fs-03
> 
> test-description: The LTP testsuite contains a collection of tools
> for testing the Linux kernel and related features.
> test-url: http://linux-test-project.github.io/
> 
> 
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp
> 2 -m 8G
> 
> caused below changes (please refer to attached dmesg/kmsg for entire
> log/backtrace):
> 
> 
> 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> 
> [  135.976643] LTP: starting fs_fill
> [  135.993912] /dev/zero: Can't open blockdev

I've looked at the github source but I don't see how to find out what
command was used when this error occurred so I don't know even how to
start to work out what might have caused this.

Can you help me to find the test script source please.

> [  136.020327] raid6: sse2x4   gen() 14769 MB/s
> [  136.037281] raid6: sse2x4   xor()  8927 MB/s
> [  136.054236] raid6: sse2x2   gen() 12445 MB/s
> [  136.071397] raid6: sse2x2   xor()  7441 MB/s
> [  136.089313] raid6: sse2x1   gen() 10089 MB/s
> [  136.107334] raid6: sse2x1   xor()  7201 MB/s
> [  136.108198] raid6: using algorithm sse2x4 gen() 14769 MB/s
> [  136.109320] raid6: .... xor() 8927 MB/s, rmw enabled
> [  136.111966] raid6: using ssse3x2 recovery algorithm
> [  136.122740] xor: automatically using best checksumming
> function   avx       
> [  136.187956] Btrfs loaded, crc32c=crc32c-intel
> [  136.216946] fuse: init (API version 7.31)
> [  136.327654] EXT4-fs (loop0): mounting ext2 file system using the
> ext4 subsystem
> [  136.334974] EXT4-fs (loop0): mounted filesystem without journal.
> Opts: (null)
> [  136.338933] Mounted ext2 file system at /tmp/ltp-
> bl4kncm4Ti/g2oJfj/mntpoint supports timestamps until 2038
> (0x7fffffff)
> [  137.897422] EXT4-fs (loop0): mounting ext3 file system using the
> ext4 subsystem
> [  137.908242] EXT4-fs (loop0): mounted filesystem with ordered data
> mode. Opts: (null)
> [  137.910111] Mounted ext3 file system at /tmp/ltp-
> bl4kncm4Ti/g2oJfj/mntpoint supports timestamps until 2038
> (0x7fffffff)
> 
> 
> To reproduce:
> 
>         # build kernel
> 	cd linux
> 	cp config-5.4.0-rc3-00117-g73e5fff98b644 .config
> 	make HOSTCC=gcc-7 CC=gcc-7 ARCH=x86_64 olddefconfig prepare
> modules_prepare bzImage modules
> 	make HOSTCC=gcc-7 CC=gcc-7 ARCH=x86_64 INSTALL_MOD_PATH=<mod-
> install-dir> modules_install
> 	cd <mod-install-dir>
> 	find lib/ | cpio -o -H newc --quiet | gzip > modules.cgz
> 
> 
>         git clone https://github.com/intel/lkp-tests.git
>         cd lkp-tests
>         bin/lkp qemu -k <bzImage> -m modules.cgz job-script # job-
> script is attached in this email
> 
> 
> 
> Thanks,
> Rong Chen
> 

