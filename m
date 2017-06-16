Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39551 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750780AbdFPRrG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jun 2017 13:47:06 -0400
Date: Fri, 16 Jun 2017 10:46:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: XFS Calltraces by using XFS with Ceph
Message-ID: <20170616174646.GD5421@birch.djwong.org>
References: <ff5af7a48b502752faac6f2bbc1c3bb7@jonas-server.de>
 <20170614120829.GA65212@bfoster.bfoster>
 <b447cdcdc5a7278c6a9cc46627e22c94@jonas-server.de>
 <20170614140732.GA857@bfoster.bfoster>
 <20170614155513.GQ4530@birch.djwong.org>
 <34ddf391569ed02b85a59eff856088ab@jonas-server.de>
 <20170615192009.18ddd3bc@harpe.intellique.com>
 <7c00729f5554099fcf5eae65ee1cb4a0@jonas-server.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c00729f5554099fcf5eae65ee1cb4a0@jonas-server.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: list@jonas-server.de
Cc: Emmanuel Florac <eflorac@intellique.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, linux-xfs-owner@vger.kernel.org

On Fri, Jun 16, 2017 at 07:37:11AM +0200, list@jonas-server.de wrote:
> Am 2017-06-15 19:20, schrieb Emmanuel Florac:
> >Le Thu, 15 Jun 2017 07:55:12 +0200
> >list@jonas-server.de écrivait:
> >
> >>> Looking at the new Elixir[1], it looks like we're trying to deref
> >>> ((*bpp)->b_addr)->magic, so that might explain the crash you see.
> >>>
> >>> --D
> >>>
> >>> [1]
> >>> http://elixir.free-electrons.com/linux/v4.4.72/source/fs/xfs/libxfs/xfs_da_btree.c#L270
> >>>
> >>>>
> >
> >Indeed that matches exactly the crash Darrick mentioned. Looks like you
> >need either a special hand-patched kernel... or wait for an official
> >fix for this one :/
> 
> When will a fix normally be in the ubuntu kernel? I need to have a stable
> distribution kernel, I can not install a patched version.

Like Emmanuel said, first a fix has to go upstream, then it can go to the
4.4 stable kernel, and then it'll probably end up in the Ubuntu kernel.

Can you post a metadump of the xfs filesystem somewhere for further
analysis?  I'm pretty sure it's the same problem reported by David Shaw
on this list a couple of weeks ago.  Since you can't run one-off test
kernels, send us a metadump for recreation in a lab is the only other
way to figure out if the fix works.

(And yes, I /do/ have a lightly tested fix which I'm about to send out.)

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
