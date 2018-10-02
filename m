Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:1233 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726672AbeJCEbt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Oct 2018 00:31:49 -0400
Date: Wed, 3 Oct 2018 07:46:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [somewhat OT] I just discovered that Stratis uses XFS.
Message-ID: <20181002214620.GO18567@dastard>
References: <20181002162530.42b30c11@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181002162530.42b30c11@harpe.intellique.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Oct 02, 2018 at 04:25:30PM +0200, Emmanuel Florac wrote:
> Hi all, 
> in fact I just discovered that Stratis exists :)
> (https://stratis-storage.github.io/relnotes/relnotes-1.0.html) ( details
> on https://lwn.net/Articles/755454/)
> 
> Reading the FAQ (https://stratis-storage.github.io/FAQ.html) I see that
> it uses XFS as a filesystem layer. Furthermore it seems to come from
> RedHat. What are the relations with the future XFS capabilities that
> Dave (IIRC) demonstrated recently?

No relationship at all - the XFS snapshot/subvolume stuff was
already being prototyped when I first heard about Stratis.  Stratis
will be able to use this future XFS functionality however they see
fit for their users.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
