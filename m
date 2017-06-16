Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.jonas-server.de ([185.53.128.64]:53684 "EHLO
        mail.jonas-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750921AbdFPFhd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jun 2017 01:37:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Fri, 16 Jun 2017 07:37:11 +0200
From: list@jonas-server.de
Subject: Re: XFS Calltraces by using XFS with Ceph
In-Reply-To: <20170615192009.18ddd3bc@harpe.intellique.com>
References: <ff5af7a48b502752faac6f2bbc1c3bb7@jonas-server.de>
 <20170614120829.GA65212@bfoster.bfoster>
 <b447cdcdc5a7278c6a9cc46627e22c94@jonas-server.de>
 <20170614140732.GA857@bfoster.bfoster>
 <20170614155513.GQ4530@birch.djwong.org>
 <34ddf391569ed02b85a59eff856088ab@jonas-server.de>
 <20170615192009.18ddd3bc@harpe.intellique.com>
Message-ID: <7c00729f5554099fcf5eae65ee1cb4a0@jonas-server.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, linux-xfs-owner@vger.kernel.org

Am 2017-06-15 19:20, schrieb Emmanuel Florac:
> Le Thu, 15 Jun 2017 07:55:12 +0200
> list@jonas-server.de écrivait:
> 
>> > Looking at the new Elixir[1], it looks like we're trying to deref
>> > ((*bpp)->b_addr)->magic, so that might explain the crash you see.
>> >
>> > --D
>> >
>> > [1]
>> > http://elixir.free-electrons.com/linux/v4.4.72/source/fs/xfs/libxfs/xfs_da_btree.c#L270
>> >
>> >>
> 
> Indeed that matches exactly the crash Darrick mentioned. Looks like you
> need either a special hand-patched kernel... or wait for an official
> fix for this one :/

When will a fix normally be in the ubuntu kernel? I need to have a 
stable distribution kernel, I can not install a patched version.
