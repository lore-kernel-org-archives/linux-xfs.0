Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54779 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751056AbeEUMiT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 May 2018 08:38:19 -0400
Date: Mon, 21 May 2018 14:35:34 +0200
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2 2/2] vfs: dedupe should return EPERM if permission is
 not granted
Message-ID: <20180521123534.GU6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180518215727.26418-1-mfasheh@suse.de>
 <20180518215727.26418-3-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180518215727.26418-3-mfasheh@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Adam Borowski <kilobyte@angband.pl>

On Fri, May 18, 2018 at 02:57:27PM -0700, Mark Fasheh wrote:
> Right now we return EINVAL if a process does not have permission to dedupe a
> file. This was an oversight on my part. EPERM gives a true description of
> the nature of our error, and EINVAL is already used for the case that the
> filesystem does not support dedupe.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>

I gave my ack for v1, no change so

Acked-by: David Sterba <dsterba@suse.com>
