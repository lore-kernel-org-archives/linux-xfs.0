Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from walrus.jabberwocky.com ([173.9.29.57]:53521 "EHLO
        mail.jabberwocky.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdFTNGy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2017 09:06:54 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] xfs: don't crash on unexpected holes in dir/attr btrees
From: David Shaw <dshaw@jabberwocky.com>
In-Reply-To: <20170616175337.GE5421@birch.djwong.org>
Date: Tue, 20 Jun 2017 09:01:11 -0400
Content-Transfer-Encoding: 8BIT
Message-Id: <8076750C-88B9-4E8E-BAFE-332222BCD7C7@jabberwocky.com>
References: <20170616175337.GE5421@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: list@jonas-server.de, Emmanuel Florac <eflorac@intellique.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Jun 16, 2017, at 1:53 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> Hi all,
> 
> So I /think/ the xfs_attr_inactive crashes that both of you have been
> seeing are a result of XFS assuming that there aren't ever any mapping
> holes in the extended attribute fork and crashing when it tries to
> grab a buffer for the hole and fails to notice that holes don't have
> buffers.  This lightly tested patch gets rid of /that/ problem.
> 
> So, if you're willing, can you try this out and see if the crashes go
> away?  Granted, this might only enable us to lurch on whatever's next...

I can give this a try.

Now that you have an idea of what caused the issue, is there some way to (easily or not) reproduce it, ideally in userspace?  Part of the problem we're having is that we can't reproduce it on a test machine so are forced to wait for it to happen in the field under load, where it inconveniences users.

David

