Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A833A453B;
	Sun, 18 Oct 2026 15:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792338522; cv=none; b=mQPBS+o84ndHvbu/QcdVOn1C4GVAz3KkMHOy+po/FHyJ1hA0VwMxGc05BP51inAKwA5NIHPzUfWko9D/iGKa3lou/NNSk+cymGWKFk0m/8bvXZvegGuC4+cljbBj3f9VF5uU83y7IV7IhFFaHC3rjBxnxchZ8u6V6AgcoytMMRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792338522; c=relaxed/simple;
	bh=FaRcLEUs6l15qig9t/5mUVXsio7boF41UEEgpQSRb4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T55XSCI5Bv56z3Hz7iH+q3uCuqzavW/LdzfnBbLbQ+2F21ozj5E0tkJXj1ZPmVDvzuYoL1scaALTOtQ80iK+KwKQZK/ru7MWmriw/gq+yiB8Y9M/K3gqORZouwhMktbG+8pd2rix8Jejv23kJ6tLwNybtIYZvoT83l5E3tSmtZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WVyI2KX3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WVyI2KX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F62E1F000C8;
	Sun, 18 Oct 2026 15:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792338520;
	bh=qHr+ZYKSpAzCi10EtcwRrDzJJq6BBKkyzbps+RPUef0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WVyI2KX3sfSFb7oZBIkg5vyFZX7+LpvwVP7fn4Cty10Z+Y1LmZOfywyVqCXWWjkZk
	 w0HsKNxrIpDN+fTkwgMX01zxZ9pMY6N/P1LtrU17V8ZUMVAxbiAmgrPDGg7W+Rjs6i
	 cOUCAgudB6PnoTQaLURK0fj6/ZYFFSlnOyU9KKE/6KmvZiNJKMOPTK8W4Rny4GZZn5
	 dnzO8E7iP9hzjx0W6bJF+lnhorAfjoibm0p1V0l9L9VW6uVghDWolJvqlzthVu28XZ
	 /BYjpM8dC6pSBrEBdq8Xis70LV4n4Q0dBgk6Rq7VtYXCr+VagK8d6QqHe7hk60/2QA
	 1AcOlXaFgMXKQ==
Date: Sun, 18 Oct 2026 17:48:34 +0200
From: Christian Brauner <brauner@kernel.org>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 20/28] gfs2: wait for a pending withdraw before
 remounting read-only
Message-ID: <20261018-ungemacht-sodbrennen-hausordnung-42d33a4f7098@brauner>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-20-60743a3dc326@kernel.org>
 <CAHc6FU5bdAjABRm=bnH68b2f66TZTDZ8sPdatLB2fS7-55U=yw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHc6FU5bdAjABRm=bnH68b2f66TZTDZ8sPdatLB2fS7-55U=yw@mail.gmail.com>

On Fri, Oct 16, 2026 at 02:32:01AM +0200, Andreas Gruenbacher wrote:
> Christian,
> 
> On Mon, Oct 12, 2026 at 1:27 PM Christian Brauner <brauner@kernel.org> wrote:
> > Since commit 9c4a3de6cd5b ("gfs2: Asynchronous withdraw") most of a
> > withdraw happens in do_withdraw() from a work item and SDF_JOURNAL_LIVE
> > stays set until it ran. A remount to read-only in that window goes
> > through gfs2_make_fs_ro(). Its log flushes bail out early on the
> > withdrawn filesystem before FLUSH_SHUTDOWN can clear SDF_JOURNAL_LIVE
> > and then gfs2_quota_cleanup() hits its BUG_ON():
> >
> >   kernel BUG at fs/gfs2/quota.c:1532!
> >   RIP: 0010:gfs2_quota_cleanup+0x562/0x6b0
> >    gfs2_make_fs_ro+0xf3/0x2e0
> >    gfs2_reconfigure+0x42e/0xfd0
> >    reconfigure_super+0x437/0xb20
> >
> > Just flushing the withdraw work before the remount isn't enough.
> > gfs2_withdraw() sets SDF_WITHDRAWN, calls dump_stack() and only then
> > queues the work. So a remount can see a withdrawn filesystem while
> > there's nothing to flush yet. And a withdraw can also start in the
> > middle of gfs2_make_fs_ro().
> >
> > So let do_withdraw() wake up waiters when it clears SDF_JOURNAL_LIVE and
> > let gfs2_make_fs_ro() wait for the bit after its log flushes, right
> > before gfs2_quota_cleanup(). On a healthy filesystem the shutdown flush
> > already cleared it. umount doesn't need to wait. gfs2_put_super() sets
> > SDF_NORECOVERY first and gfs2_quota_cleanup() only BUGs without it. Once
> > the bit is clear the journal isn't live anymore and gfs2_make_fs_ro()
> > doesn't write anything.
> >
> > gfs2_make_fs_rw() can leave the bit set on a withdrawn filesystem as
> > well. It checks for a withdraw and then sets SDF_JOURNAL_LIVE. If
> > do_withdraw() runs in between it finds the journal not live yet and
> > returns. Nothing clears the bit then and the next remount to read-only
> > waits for it forever. So check for the withdraw and set the bit under
> > sd_log_flush_lock, which do_withdraw() holds while it tests the bit.
> > Then either the remount sees the withdraw or do_withdraw() sees the live
> > journal.
> >
> > Reproducer, lock_nolock: a SCHED_FIFO task writes 1 to the withdraw
> > sysfs knob from cpu 1 and keeps cpu 1 busy (RT throttling and cpu 1's
> > fair server disabled) so do_withdraw() can't run, then from cpu 2:
> >
> >   mount -o remount,ro /mnt
> >
> > On lock_dlm the window lasts as long as the withdraw helper runs. The
> > window before the work is queued can be widened with a kprobe on
> > dump_stack_lvl() that delays the task writing to the withdraw knob by a
> > few seconds. A remount to read-only or sysrq u in that window hits the
> > same BUG_ON().
> >
> > Fixes: 9c4a3de6cd5b ("gfs2: Asynchronous withdraw")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> > ---
> >  fs/gfs2/super.c | 22 ++++++++++++++++++----
> >  fs/gfs2/util.c  |  2 +-
> >  2 files changed, 19 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
> > index 06302c29340f..1d7b39354d65 100644
> > --- a/fs/gfs2/super.c
> > +++ b/fs/gfs2/super.c
> > @@ -147,12 +147,23 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
> >         }
> >
> >         error = gfs2_quota_init(sdp);
> > -       if (!error && gfs2_withdrawn(sdp)) {
> > -               gfs2_quota_cleanup(sdp);
> > +       if (error)
> > +               return error;
> > +
> > +       /*
> > +        * do_withdraw() only takes a live journal down. Check for a withdraw
> > +        * under the lock it holds for that so that either we see the withdraw
> > +        * or it sees the journal live. Otherwise gfs2_make_fs_ro() waits for
> > +        * the bit forever.
> > +        */
> > +       down_write(&sdp->sd_log_flush_lock);
> > +       if (gfs2_withdrawn(sdp))
> >                 error = -EIO;
> > -       }
> > -       if (!error)
> > +       else
> >                 set_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
> > +       up_write(&sdp->sd_log_flush_lock);
> > +       if (error)
> > +               gfs2_quota_cleanup(sdp);
> >         return error;
> >  }
> >
> > @@ -565,6 +576,9 @@ void gfs2_make_fs_ro(struct gfs2_sbd *sdp)
> >                                    HZ * 5);
> >                 gfs2_assert_warn(sdp, gfs2_log_is_empty(sdp));
> >         }
> > +       /* A withdraw that do_withdraw() didn't finish yet leaves it live. */
> > +       if (!test_bit(SDF_NORECOVERY, &sdp->sd_flags))
> > +               wait_on_bit(&sdp->sd_flags, SDF_JOURNAL_LIVE, TASK_UNINTERRUPTIBLE);
> >         gfs2_quota_cleanup(sdp);
> >  }
> >
> > diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
> > index 83b8bb6446e5..1535ce2b7aa8 100644
> > --- a/fs/gfs2/util.c
> > +++ b/fs/gfs2/util.c
> > @@ -122,7 +122,7 @@ static void do_withdraw(struct gfs2_sbd *sdp)
> >                 up_write(&sdp->sd_log_flush_lock);
> >                 return;
> >         }
> > -       clear_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
> > +       clear_and_wake_up_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
> >         gfs2_ail_drain(sdp); /* frees all transactions */
> >         up_write(&sdp->sd_log_flush_lock);
> >
> >
> > --
> > 2.53.0
> >
> 
> this looks good all around, thank you very much. Can I add it to my gfs2 queue?

I was planning to just provide a stable branch for everyone to pull post
-rc1. Then you can just pull that in?
