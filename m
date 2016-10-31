Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.webx.cz ([109.123.222.201]:41114 "EHLO mail.webx.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S944195AbcJaPgh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 Oct 2016 11:36:37 -0400
From: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Subject: Re: BUG: Metadata corruption detected at xfs_attr3_leaf_read_verify
Date: Mon, 31 Oct 2016 16:36:33 +0100
Message-ID: <7837406.5hmCKvTK5C@libor-nb>
In-Reply-To: <20161031120226.GT14023@dastard>
References: <5244720.RPRsZ88NJ0@libor-nb> <3301912.kAxTXXYXM8@libor-nb> <20161031120226.GT14023@dastard>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

Hello,

On pondělí 31. října 2016 23:02:26 CET Dave Chinner wrote:
> On Mon, Oct 31, 2016 at 09:54:00AM +0100, Libor Klep�? wrote:
> > Hello,
> > i have upgrade VM called vps1 in original email (the one on bottom of
> > email) to debian kernel 4.7.8-1~bpo8+1 and compiled xfsprogs 4.8.0.
> > 
> > Here is output of xfs_repair -n and xfs_repair. Is it supposed to write
> > if/
> > what is being repaired, when i forgot -v option?
> 
> repair will always tell you if there are errors. The logs you have
> posted indicate a clean filesystem with no errors.

Ok, so this one looks good for now.
I have to arrange a "upgrade and xfs_repair run" window with other customer to 
deal with machine called vps2 in my original email.

> 
> Cheers,
> 
> Dave.

Thanks,

Libor

