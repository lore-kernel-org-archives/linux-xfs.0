Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi1-f169.google.com ([209.85.167.169]:37941 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbfETXgs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:36:48 -0400
Received: by mail-oi1-f169.google.com with SMTP id u199so11372461oie.5
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 16:36:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAHgs-5XkA5xFgxgSaX9m70gduuO1beq6fiY7UEGv1ad6bd19Hw@mail.gmail.com>
 <20190513140943.GC61135@bfoster>
In-Reply-To: <20190513140943.GC61135@bfoster>
From: Tim Smith <tim.smith@vaultcloud.com.au>
Date: Tue, 21 May 2019 09:36:37 +1000
Message-ID: <CAHgs-5VCjUhk=ijgUmcMPJ7Gd44yH1yExGZnA5xZv4tfFBQQwQ@mail.gmail.com>
Subject: Re: xfs filesystem reports negative usage - reoccurring problem
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 14, 2019 at 12:09 AM Brian Foster <bfoster@redhat.com> wrote:
> Could you also include xfs_info and mount params of the filesystem(s) in
> question?

$ sudo mount | grep sdad
/dev/sdad on /srv/node/sdad type xfs
(rw,noatime,nodiratime,attr2,inode64,logbufs=8,noquota)

$ sudo xfs_info /srv/node/sdad
meta-data=/dev/sdad              isize=512    agcount=10, agsize=268435455 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0
data     =                       bsize=4096   blocks=2441609216, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

$ sudo xfs_info /srv/node/sdac
meta-data=/dev/sdac              isize=512    agcount=10, agsize=268435455 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0
data     =                       bsize=4096   blocks=2441609216, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

> Also, is this negative blocks used state persistent for any of these
> filesystems? IOW, if you unmount/mount, are you right back into this
> state, or does accounting start off sane and fall into this bogus state
> after a period of runtime or due to some unknown operation?

It's persistent. After umount/remount, it's still in the same state.
It seems to happen after some time...
