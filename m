Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Aug 2006 21:30:58 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k774UkDW012275
	for <linux-xfs@oss.sgi.com>; Sun, 6 Aug 2006 21:30:46 -0700
Message-ID: <44D6A61A.5090900@sandeen.net>
Date: Sun, 06 Aug 2006 21:31:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: write back cache and barriers
References: <5545990.post@talk.nabble.com> <44CC2D1A.3060805@sandeen.net> <200608061100.36508.Martin@lichtvoll.de>
In-Reply-To: <200608061100.36508.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com

Martin Steigerwald wrote:

> Hello Eric,
> 
> for my article I looked at the source code of those. It seems that journal 
> block device tests wether barriers work
> 
> commit.c:       if (ret == -EOPNOTSUPP && barrier_done) {
> commit.c:                       "JBD: barrier-based sync failed on %s - "
> commit.c:                       "disabling barriers\n",
> 
> Also reiserfs 3 seems to deactivate barriers if not avaible (journal.c)
> 
>                 if (reiserfs_barrier_flush(p_s_sb)) {
>                         int ret;
>                         lock_buffer(journal->j_header_bh);
>                         ret = submit_barrier_buffer(journal->j_header_bh);
>                         if (ret == -EOPNOTSUPP) {
>                                 set_buffer_uptodate(journal->j_header_bh);
>                                 disable_barrier(p_s_sb);
>                                 goto sync;
>                         }
>                         wait_on_buffer(journal->j_header_bh);
>                         check_barrier_completion(p_s_sb, 
> journal->j_header_bh);
>                 } else {
> 
> (both sources from kernel 2.6.17.7)

Yep, you're right, not quite sure how I missed that...

Thanks,

-Eric
