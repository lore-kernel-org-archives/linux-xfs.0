Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3580D4964E
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 23:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720047734; cv=none; b=sDm7XXvwCMxXiG7AsPFbzKW61Rm2vAljrRuJ/fTDSfyLQqnNClIz0K6XKrysbQNG9h1TtsxjVqXbp5L05qh1t3G0xbWoIUyJvbKvgNdLw+3m/rduJRLL+sNz40iI9sTR79cpWu52wR5ffwK4A71m6jyres5D2dKFMXr5CApERW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720047734; c=relaxed/simple;
	bh=b/tZudZ4MxQfNa6R4TJI1O0ixve9TnQVGqOVLhkkSHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PANFri18Y5bZeTWaoSJYmVlqsfaJCHbNhEuz2bDET4k2Bqm0E9UdgPohFZ2hw4lKlB+m2YW/MfFTsy1gM323q0ckAnncDPHWxmr7nTmOsnkyh1DQv3lbq4++/1w0mVjpCEFnP8GkzlHC+ZaNEtOOWkMMocJrP1zkzsKe4Redg4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=j+1cPsQs; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="j+1cPsQs"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1fb1c918860so7243975ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 03 Jul 2024 16:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1720047732; x=1720652532; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RQ8689AvEPkediPvUKKNjHlFAD8V9KTAIbnDO82hhz0=;
        b=j+1cPsQsz5fytIJ+RqfR0WhTiscQEvMuj8Z274BiII5YGlagYMsoIhjlsMlL02YKO4
         siQqZm+hwfDuPBvHKGImpO3ySk2Uvp70LXtHnd2WfbgWKN6AYrXaosISiP8uxVWquxfw
         GOtm/fOP1CHU5jZ79imeW3fj8A+xbnKzi0ylZadyYAyIwQhKsuVr80MBM0R0dKrzuB3R
         HtMl2LczpmTZ65lr2Sn+ikGyBHtBkfnLM8yeYfTSI650ylUggu2EkAHM+K2enJrO9Cc9
         Z/sTnoW8qcXFwFeKFA/VEIMK2MkBLEqJyi79aixQFuYLyFEPuCPRkjv+jLt96d0MgLL/
         Xx3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720047732; x=1720652532;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RQ8689AvEPkediPvUKKNjHlFAD8V9KTAIbnDO82hhz0=;
        b=IpJ2nn6ePY6ciXoJhBgP1HODNcSVH2Q568MSPN77kkM0o+WMWsRbRMe0tjQ/RRzGZa
         e4jxlqZQ38uOwdfEl9voHAx8DaaZsnaPins8QgCeuN8RO3h0xMAF8vZjfk8r3V6MpVJW
         YTNNf70bBz3Ek0FYOAUZ/VmuzhnCaMSfyeaTm5V9thE/ACvyVL9CdqDCx7jSmWWeRKaG
         GirHNDztLxZJ95mqlZszRWmmaCxpBPOQ0Nl981+e59KxnD0JkYMLjcuyXmPgpj1mJfaR
         yqDsha5PAZKG7CHCI54iKaTTgS3xw9bYgXcRY48qdVyJ08d+UNL2pmYapOdflsOpxmi3
         4cIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWncLm+b+xQxZDDs2x7/l/EVJrFkmjQxvbu1fnUTdNFpndsJft2wDa12EpOzUwMvkfdwglq7CzudlosIK20gG/I9ZGkRSMA0Cxq
X-Gm-Message-State: AOJu0YwZZnPkol+xFV76drqlaCYkHtbmmOEhJ2jWjNnDC7IzbBsFIkMP
	aV1dk06WKop6epPd5HFFRkt0n5qfgqpIzo6UeSXNIc6LXUHYxz2z8a0+KcRUJP0=
X-Google-Smtp-Source: AGHT+IGLJxyk3WkMtbQ0yuAmN9CXHoHO/7sN9iAr/E8zwGNefnoIPl0V4O+kd0pz+bQHVaJSp5nwAw==
X-Received: by 2002:a17:902:fc45:b0:1fa:d491:a472 with SMTP id d9443c01a7336-1fb1a04e7dfmr47354265ad.11.1720047732469;
        Wed, 03 Jul 2024 16:02:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fb2f38983fsm3268355ad.18.2024.07.03.16.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jul 2024 16:02:12 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sP8zJ-003BI3-2e;
	Thu, 04 Jul 2024 09:02:09 +1000
Date: Thu, 4 Jul 2024 09:02:09 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@kernel.org>,
	linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: enable WQ_MEM_RECLAIM on m_sync_workqueue
Message-ID: <ZoXYcbWmYouaybfE@dread.disaster.area>
References: <>
 <ZoI0dKgc8oRoKKUn@infradead.org>
 <172000614061.16071.4185403871079452726@noble.neil.brown.name>
 <ZoVdAPusEMugHBl8@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoVdAPusEMugHBl8@infradead.org>

On Wed, Jul 03, 2024 at 07:15:28AM -0700, Christoph Hellwig wrote:
> On Wed, Jul 03, 2024 at 09:29:00PM +1000, NeilBrown wrote:
> > I know nothing of this stance.  Do you have a reference?
> 
> No particular one.
> 
> > I have put a modest amount of work into ensure NFS to a server on the
> > same machine works and last I checked it did - though I'm more
> > confident of NFSv3 than NFSv4 because of the state manager thread.
> 
> How do you propagate the NOFS flag (and NOIO for a loop device) to
> the server an the workqueues run by the server and the file system
> call by it?  How do you ensure WQ_MEM_RECLAIM gets propagate to
> all workqueues that could be called by the file system on the
> server (the problem kicking off this discussion)?

Don't forget PF_LOCAL_THROTTLE, too.  I note that nfsd_vfs_write()
knows when it is doing local loopback write IO and in that case sets
PF_LOCAL_THROTTLE:

	if (test_bit(RQ_LOCAL, &rqstp->rq_flags) &&
            !(exp_op_flags & EXPORT_OP_REMOTE_FS)) {
                /*
                 * We want throttling in balance_dirty_pages()
                 * and shrink_inactive_list() to only consider
                 * the backingdev we are writing to, so that nfs to
                 * localhost doesn't cause nfsd to lock up due to all
                 * the client's dirty pages or its congested queue.
                 */
                current->flags |= PF_LOCAL_THROTTLE;
                restore_flags = true;
        }

This also has impact on memory reclaim congestion throttling (i.e.
it turns it off), which is also needed for loopback IO to prevent it
being throttled by reclaim because it getting congested trying to
reclaim all the dirty pages on the upper filesystem that the IO
thread is trying to clean...

However, I don't see it calling memalloc_nofs_save() there to
prevent memory reclaim recursion back into the upper NFS client
filesystem.

I suspect that because filesystems like XFS hard code GFP_NOFS
context for page cache allocation to prevent NFSD loopback IO from
deadlocking hides this issue. We've had to do that because,
historically speaking, there wasn't been a way for high level IO
submitters to indicate they need GFP_NOFS allocation context.

Howver, we have had the memalloc_nofs_save/restore() scoped API for
several years now, so it seems to me that the nfsd should really be
using this rather than requiring the filesystem to always use
GFP_NOFS allocations to avoid loopback IO memory allocation
deadlocks...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
