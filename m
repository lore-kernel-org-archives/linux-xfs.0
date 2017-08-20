Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41364 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752250AbdHTCKy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 19 Aug 2017 22:10:54 -0400
Subject: Re: Estimate xfs_repair run time
References: <22ed5cf73260ae39bf59779b302d8ad3@assyoma.it>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a6bffbd0-a87f-86e2-2245-2d5da40c800a@sandeen.net>
Date: Sat, 19 Aug 2017 21:10:53 -0500
MIME-Version: 1.0
In-Reply-To: <22ed5cf73260ae39bf59779b302d8ad3@assyoma.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>, linux-xfs@vger.kernel.org

As for this question:

On 8/19/17 5:05 AM, Gionatan Danti wrote:
> Hi list,

...

> How do you feel using a single big LV + XFS + preallocated RAW disk images? Can a problem on the main XFS filesystem be contained on only some VM files, or it really risks to destroy the entire filesystem?

It's pretty rare to have large-scale, filesystem-wide corruption.  The only times I've ever seen filesystems really get wiped out by corruption was when the underlying storage went haywire; a scrambled raid, etc.  The sort of thing no filesystem could cope with ...

-Eric
