Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6A3200BF
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 04:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711599197; cv=none; b=Re4O54tqYKDPPJDteoPhgjxiZSS1dMUcR7rwMPyA72+34RCEI8/UuewtEjJC3U0UEMJahsYghY1Ynne+4etvGBIW8TKGUXu7F6jRXtiZatxjLAjXasLD20upN+a5tMIM/uAlhDJWuI6Vkl5rnztdG4/vN5Imu2vROY5LhScrr2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711599197; c=relaxed/simple;
	bh=sEDmW2Jv3GO1IramInrCAFFWYGWWXy9ORmpLjjcbSzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V21BmrEV1RFORAFQMFuHsBz4znTLJcMFKW8vU9U2/ZIgq/VrnFoouRDEJ9q4SzhJQQmORKSNoHg3nmP11bH7fJTlxn+sJoXDWuNcNY6/S/XsiHDfi/gtP3Q8785c9yxcDkLD8Jc3WrlMgYEp/Mq/1xGjOz61cmvHkFGV+GRNxpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=eClQdq3G; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="eClQdq3G"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6e46dcd8feaso372181b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 21:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711599195; x=1712203995; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fEHjc4htzhfzSh8rGI2seQBd+iWq/7j4XFPClvaXxQ8=;
        b=eClQdq3GUwDXaQlD5oIPM3gvvWB7Suqsh3/tC472wgDUUd2bsXJo9QZ9AQHmzORvVm
         g8WJW4T1zDkvlby78olpxLH2qycFPH7NislsT+uUXQ7YiRCYQwll7V71oXcDLQU0Im2x
         zJb8NEd8VMZ/tx6fo45XfZ8ERLcC+//GmZSpp6iS/UWXwEDOODUyQMVafNTty1JlQ78N
         6tYbJFdxDjVJoknQ7v9hYdDDns9qmMqSVRFEHPYm0yQjBteL9S05ZmZXkEtIvrNs7SWG
         hVSTHXxr3WrETJUXWU1fxSAuZgIBxMn514mvxslOEd55hSi4ARy7WWDtDdpURfyqqvgG
         6tvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711599195; x=1712203995;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fEHjc4htzhfzSh8rGI2seQBd+iWq/7j4XFPClvaXxQ8=;
        b=VUu2lv8B/Y25Rj7qvD0Tb6wLBO9YQHCzHpxdyVMtQttEMrsy/WAmGbfSkcRQRJu3IB
         0jqVtQD35KswxoZDZWxO7VuPb87XQITm3lHRta/1CSlQa27XajP+RGS0QyXMkCrgPCDH
         Vaj17oaNPfdkgXMVcAKoEKBvScdKYzWz3bySFvcl3MsWJDPu6UfakmE4z+pxzi1pVDNB
         h45bStkOSybEOMSYdWkcD0Gd8zQrt2aiBZQdJndewodVpA0Yx4cGWkvFKT8amGLgtqwL
         a4alPYgyOf+1eZecTCojjgbcBqB1rko0LOxKK07ZQRNoWYNx44kLVvG0PzXEadXzJJlT
         QwJw==
X-Forwarded-Encrypted: i=1; AJvYcCX/BvzbArmlpzy//jm/PtFK0/JoFsLzdPXKSkQ25ZuIg4gBM0s/1sz/6FuGYEAmgM7IYyu3dThfoKR4EY70EZnOvAY3OTXOgmHY
X-Gm-Message-State: AOJu0YxfHqqbpkJzFqOpXowTHAfqrhgz0cXDPPospQFaBgI9z5sHCDGq
	U84OwgGnwax/epGnLD3NQj4HI9twztuetMK+l0Ua3IRzDzHCSdwyNWnXuVuZqPKKSHL9eGc6Klx
	j
X-Google-Smtp-Source: AGHT+IHL7zeGJhzKOBhgJ0O5BjYTsJRlJVFmvvhb4oLXVcddZTpOki39bixOVSSFeVyvqbtdVzdwKw==
X-Received: by 2002:a05:6a20:3206:b0:1a3:495e:3f17 with SMTP id hl6-20020a056a20320600b001a3495e3f17mr1681082pzc.24.1711599195407;
        Wed, 27 Mar 2024 21:13:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id y62-20020a17090a53c400b0029be7922b32sm2762292pjh.26.2024.03.27.21.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 21:13:14 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rph8a-00Cg1a-18;
	Thu, 28 Mar 2024 15:13:12 +1100
Date: Thu, 28 Mar 2024 15:13:12 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/13] xfs: free RT extents after updating the bmap btree
Message-ID: <ZgTuWIIMrtupCRav@dread.disaster.area>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327110318.2776850-4-hch@lst.de>

On Wed, Mar 27, 2024 at 12:03:08PM +0100, Christoph Hellwig wrote:
> Currently xfs_bmap_del_extent_real frees RT extents before updating
> the bmap btree, while it frees regular blocks after performing the bmap
> btree update.  While this behavior goes back to the original commit,
> I can't find any good reason for handling RT extent vs regular block
> freeing differently. 

It's to do with free space btree manipulations and ENOSPC.  The
truncate for data device extents was originally a two-phase
operation. First it removed the bmapbt record, but because this can
free BMBT extents, it can use up all the free space tree reservation
space. So the transaction gets rolled to commit the BMBT change and
the xfs_bmap_finish() call that frees the data extent runs with a
new transaction reservation that allows different free space btrees
to be logged without overrun.

However, on crash, this could lose the free space because there was
nothing to tell recovery about the extents removed from the BMBT,
hence EFIs were introduced. They tie the extent free operation to the
bmapbt record removal commit for recovery of the second phase of the
extent removal process.

Then RT extents came along. RT extent freeing does not require a
free space btree reservation because the free space metadata is
static and transaction size is bound. Hence we don't need to care if
the BMBT record removal modifies the per-ag free space trees and we
don't need a two-phase extent remove transaction. The only thing we
have to care about is not losing space on crash.

Hence instead of recording the extent for freeing in the bmap list
for xfs_bmap_finish() to process in a new transaction, it simply
freed the rtextent directly. So the original code (from 1994) simply
replaced the "free AG extent later" queueing with a direct free:

@@ -920,7 +937,10 @@ xfs_bmap_del_extent(
               (got.br_startblock == NULLSTARTBLOCK));
        delay = got.br_startblock == NULLSTARTBLOCK;
        if (!delay) {
-               xfs_bmap_add_free(del->br_startblock, del->br_blockcount, flist);
+               if (ip->i_d.di_flags & XFS_DIFLAG_REALTIME)
+                       xfs_rtfree_extent(ip->i_mount, ip->i_transp, del->br_startblock, del->br_blockcount);
+               else
+                       xfs_bmap_add_free(del->br_startblock, del->br_blockcount, flist);
                del_endblock = del->br_startblock + del->br_blockcount;
                if (cur)
                        xfs_bmbt_lookup_eq(cur, got.br_startoff, got.br_startblock, got.br_blockcount);

This code was originally at the start of xfs_dmap_del_extent(), but
the xfs_bmap_add_free() got moved to the end of the function via the
"do_fx" flag (the current code logic) in 1997 because:

commit c4fac74eaa580edcc6b65e977151d73f2b6e9aa5
Author: Doug Doucette <doucette@engr.sgi.com>
Date:   Wed Jul 9 17:34:17 1997 +0000

    Fix xfs_bmap_del_extent, so it can back out of the case where an
    extent is being split, and the space allocation fails.

There was a shutdown occurring because of a case where splitting the
extent record failed because the BMBT split and the filesystem
didn't have enough space for the split to be done. (FWIW, I'm not
sure this can happen anymore.)

The commit backed out the BMBT change on ENOSPC error, and in doing
so I think this actually breaks RT free space tracking. However, it
then returns an ENOSPC error, and we have a dirty transaction in the
RT case so this will shut down the filesysetm when the transaction
is cancelled. Hence the corrupted "bmbt now points at freed rt dev
space" condition never make it to disk, but it's still the wrong way
to handle the issue.

IOWs, this proposed change fixes that "shutdown at ENOSPC on rt
devices" situation that was introduced by the above commit back in
1997.

Nice!

> We use the same transaction, and unless rmaps
> or reflink are enabled (which currently aren't support for RT inodes)
> there are no transactions rolls or deferred ops that can rely on this
> ordering.

Yup, I see no problem there.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
