Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57588 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751890AbeCWDm5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Mar 2018 23:42:57 -0400
Date: Thu, 22 Mar 2018 20:42:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2 v5] fsck.xfs: allow forced repairs using xfs_repair
Message-ID: <20180323034251.GI4818@magnolia>
References: <20180315182850.36783-1-jtulak@redhat.com>
 <20180316170720.44227-1-jtulak@redhat.com>
 <709ab06b-4efc-2925-6621-f17ed4c048c6@sandeen.net>
 <20180323032548.GG4818@magnolia>
 <f68aab96-7a08-26ee-2b9c-dfe291689506@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f68aab96-7a08-26ee-2b9c-dfe291689506@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Mar 22, 2018 at 10:29:27PM -0500, Eric Sandeen wrote:
> 
> 
> On 3/22/18 10:25 PM, Darrick J. Wong wrote:
> >> It make sense to check that it's available before running it, but I think
> >> hardcoding paths runs the risk of missing it if it's somewhere unique.
> 
> > OTOH hardcoding the path (since we control where xfs_repair gets
> > installed) means that we avoid the "someone poisoned PATH" attack.  I'm
> > not sure I buy that argument since if you have root access you probably
> > can just bind mount a garbage atop /sbin/xfs_repair, but eh.
> 
> But this is the initramfs, right?  Do we really have any idea where things
> land?  Do initramfs paths follow the installed system paths?  (maybe?)

They land wherever the initramfs construction script puts them, though
at least on Debian the binaries are usually put in the same places as
they are on the rootfs.  Not sure about dracut. :)

--D

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
