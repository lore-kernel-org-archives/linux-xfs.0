Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48188 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727730AbfFXK6C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Jun 2019 06:58:02 -0400
Date: Mon, 24 Jun 2019 12:58:00 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] quota: honor quote type in Q_XGETQSTAT[V] calls
Message-ID: <20190624105800.GD32376@quack2.suse.cz>
References: <0b96d49c-3c0b-eb71-dd87-750a6a48f1ef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b96d49c-3c0b-eb71-dd87-750a6a48f1ef@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Bob Peterson <rpeterso@redhat.com>

On Fri 21-06-19 18:27:13, Eric Sandeen wrote:
> The code in quota_getstate and quota_getstatev is strange; it
> says the returned fs_quota_stat[v] structure has room for only
> one type of time limits, so fills it in with the first enabled
> quota, even though every quotactl command must have a type sent
> in by the user.
> 
> Instead of just picking the first enabled quota, fill in the
> reply with the timers for the quota type that was actually
> requested.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> I guess this is a change in behavior, but it goes from a rather
> unexpected and unpredictable behavior to something more expected,
> so I hope it's ok.
> 
> I'm working on breaking out xfs quota timers by type as well
> (they are separate on disk, but not in memory) so I'll work
> up an xfstest to go with this...

Yeah, makes sense. I've added the patch to my tree.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
