Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Aug 2006 02:01:36 -0700 (PDT)
Received: from mondschein.lichtvoll.de (mondschein.lichtschiff.de [194.150.191.238] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7691HDW009265
	for <linux-xfs@oss.sgi.com>; Sun, 6 Aug 2006 02:01:22 -0700
Received: from localhost (dslb-084-056-104-201.pools.arcor-ip.net [84.56.104.201])
	by mondschein.lichtvoll.de (Postfix) with ESMTP id 08D49FA68A
	for <linux-xfs@oss.sgi.com>; Sun,  6 Aug 2006 10:59:18 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: write back cache and barriers
Date: Sun, 6 Aug 2006 11:00:35 +0200
References: <5545990.post@talk.nabble.com> <44CC2D1A.3060805@sandeen.net>
In-Reply-To: <44CC2D1A.3060805@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200608061100.36508.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Sonntag 30 Juli 2006 05:52 schrieb Eric Sandeen:

> > If I try mounting a xfs filesystem I get a message like "barriers are
> > not supported by this device" but if I mount a ext3 or a reiserfs
> > filesystem respectively with options barrier=1 and barrier=flush they
> > don't complain. If I mount the reiserfs I explicity get a message
> > like "using barriers". So who tells the truth ??
>
> I don't see ext3 or reiser actually checking whether the underlying
> device supports barriers.  xfs does, in xfs_mountfs_check_barriers().

Hello Eric,

for my article I looked at the source code of those. It seems that journal 
block device tests wether barriers work

commit.c:       if (ret == -EOPNOTSUPP && barrier_done) {
commit.c:                       "JBD: barrier-based sync failed on %s - "
commit.c:                       "disabling barriers\n",

Also reiserfs 3 seems to deactivate barriers if not avaible (journal.c)

                if (reiserfs_barrier_flush(p_s_sb)) {
                        int ret;
                        lock_buffer(journal->j_header_bh);
                        ret = submit_barrier_buffer(journal->j_header_bh);
                        if (ret == -EOPNOTSUPP) {
                                set_buffer_uptodate(journal->j_header_bh);
                                disable_barrier(p_s_sb);
                                goto sync;
                        }
                        wait_on_buffer(journal->j_header_bh);
                        check_barrier_completion(p_s_sb, 
journal->j_header_bh);
                } else {

(both sources from kernel 2.6.17.7)

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
