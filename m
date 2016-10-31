Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:29826 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S941329AbcJaMC3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Oct 2016 08:02:29 -0400
Date: Mon, 31 Oct 2016 23:02:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: Metadata corruption detected at xfs_attr3_leaf_read_verify
Message-ID: <20161031120226.GT14023@dastard>
References: <5244720.RPRsZ88NJ0@libor-nb>
 <3822835.q6ryES8eE3@libor-nb>
 <20161024024024.GX14023@dastard>
 <3301912.kAxTXXYXM8@libor-nb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3301912.kAxTXXYXM8@libor-nb>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Oct 31, 2016 at 09:54:00AM +0100, Libor Klepáč wrote:
> Hello,
> i have upgrade VM called vps1 in original email (the one on bottom of email)
> to debian kernel 4.7.8-1~bpo8+1 and compiled xfsprogs 4.8.0.
> 
> Here is output of xfs_repair -n and xfs_repair. Is it supposed to write if/
> what is being repaired, when i forgot -v option?

repair will always tell you if there are errors. The logs you have
posted indicate a clean filesystem with no errors.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
