Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD3F1401B
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 22:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721688349; cv=none; b=oVwlzctL/CASyMfEKi72PWhHjO/ev7qia/25uWcHLkBMoTh80lfsbqz6kjCSvSvFOolfx3fBW788QZKEf+BcJqXPL2wEs2CB5DofkJZ3WqHB0mg6cZD/riE/H4EPQ8g4h0qPN9H1TNqpsBD6OQlv7rHCUAnayYLgN6j+HLIArH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721688349; c=relaxed/simple;
	bh=uVdritk0JsORT3qUrN+AQP7I8IZwQhAfJyOhgdYoLWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PoB0N8OJiG/Ku+vuMSuQQlUWynaOlOrpo0K0IF8x0hexYhwL4wkRTdAhsu7XZw+uSjrmjuCHwZQL7S0aTzfpNGMpNfKDprcpmLYU2P7H0AbcXuWLhx4jUBw15IMMLRysGB6sb1vd7AnhO9hDYfzJOtJ8GJYOU7b5XAFZCgBzuQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=AHYmbSwJ; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="AHYmbSwJ"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1fd9e70b592so1191235ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 15:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721688346; x=1722293146; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KEcwuhvEeFjOOC/U/CGg+SYiPDfYN8K/o4ccKITGK7o=;
        b=AHYmbSwJPiG0ZWSp/l+wkPtrA6R9SaMrR1mwU27lS3J3rYVG4pXI9mwmVocUW6KueD
         SsU77GHmgLH/byjhxllREZWPYyxmiKNOtaEaUBzpAUf3UOo2oNR2/MI6jIytKLCEjVie
         F1AUI8qijvJEj/tg7j1UM9p3xl1F+y0+B2eEAOcQlNi+9pzCvE9J3LGO1/RHnhg5VMPf
         sxWZdjgUd5sCXa2DVfUuHfAr8lidBTjc9YkBWWZzlFvx/RLWmFXLDb9rWliMCEK0BA8d
         hwDWFzZ/XZl5WLskoW4helWiGjDtRElduTfn2JHCvog5d/mqHloK3yX450oHzuyAc24z
         MNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721688346; x=1722293146;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KEcwuhvEeFjOOC/U/CGg+SYiPDfYN8K/o4ccKITGK7o=;
        b=BVM8Jxxgp4pqkmGHfM8g9/6pwqd0JdgcF5MRyiga+V9dlePzrlnha4B/lCsJtiFyTE
         sjLqy4mPEOV9I78LIOjnM+vq/+3Jd072GU+QBtqSQr7disgoEhjppTgxN/qumGthRe72
         CR3Qwk5B0vjJnnXxjiTWro0ExTGMez9QfnCXfzgmJVRljZJ6Wpudkr8lcQFUpa1sUGk5
         EJXMVrxJDLEsfVCNngGFyXmbG2HI13u+rhi1yYFxtQFVXTT//lMAYy/v3iyg90IN7/gx
         tzbMcGAAffsk0kmsiGlHI/R12n6rhhltjXE3HBrbsEudOE+Bi1t7WkM9BnxpOntY/MTW
         /z4A==
X-Forwarded-Encrypted: i=1; AJvYcCU/xJ9oM4BoBiYtmoM8N+kFBPQErnAefqCKvL+dV5omi700t4XPGe+NdPXanijVEP1aZMHnYgx8W7sU4d1gcLQLRNphpGFZpqVU
X-Gm-Message-State: AOJu0Yz9E5ECuBMqhmkJBbITK+8FC2mlmHbTJomhSKgn6o4lLc1LK5Ur
	hOr/bbg31md9kz96mlw1Ff5DWShRuz3CnXkTo+wHNuWYpQSEri+CL4AOYfDp8lokkmDmVSikYeD
	d
X-Google-Smtp-Source: AGHT+IEy+RNvXeNa+4P2Zs59dYas6ynTAjSMeVbeF47JwLByCDQJ68eloO9scRGKcduIULtIN8Omhw==
X-Received: by 2002:a17:903:1cc:b0:1fd:9c2d:2ef1 with SMTP id d9443c01a7336-1fd9c2d320emr40183585ad.53.1721688346456;
        Mon, 22 Jul 2024 15:45:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f452205sm60334615ad.223.2024.07.22.15.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jul 2024 15:45:45 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sW1mp-007pFW-0V;
	Tue, 23 Jul 2024 08:45:43 +1000
Date: Tue, 23 Jul 2024 08:45:43 +1000
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: allow SECURE namespace xattrs to use reserved pool
Message-ID: <Zp7hF6hjonHBt7wp@dread.disaster.area>
References: <fa801180-0229-4ea7-b8eb-eb162935d348@redhat.com>
 <Zp5vq86RtodlF-d1@infradead.org>
 <da41c7f5-8542-4b8e-9e98-2c33a74ca1a9@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da41c7f5-8542-4b8e-9e98-2c33a74ca1a9@sandeen.net>

On Mon, Jul 22, 2024 at 10:05:03AM -0500, Eric Sandeen wrote:
> On 7/22/24 9:41 AM, Christoph Hellwig wrote:
> > On Fri, Jul 19, 2024 at 05:48:53PM -0500, Eric Sandeen wrote:
> >>  	xfs_attr_sethash(args);
> >>  
> >> -	return xfs_attr_set(args, op, args->attr_filter & XFS_ATTR_ROOT);
> >> +	rsvd = args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_SECURE);
> >> +	return xfs_attr_set(args, op, rsvd);
> > 
> > This looks fine, although I'd probably do without the extra local
> > variable.  More importantly though, please write a comment documenting
> > why we are dipping into the reserved pool here.  We should have had that
> > since the beginning, but this is a better time than never.
> > 
> > 
> 
> Ok, I thought the local var was a little prettier but *shrug* can do it
> either way.
> 
> To be honest I'm not sure why it was done for ROOT; dchinnner mentioned
> something about DMAPI requirements, long ago...

Because the xattrs created with inode allocation are not atomic
(which they could be now because parent pointers added the
infrastructure to add xattrs atomically in the create transaction),
stuff like ACLs, security xattrs and, historically, DMAPI xattrs
could fail to be created when the inode was allocated.

For DMAPI/DMF, this was a big issue if the xattr creation got ENOSPC
or the system crashed between inode creation (i.e the DMAPI CREATE
notification being processed by DMF) and the xattr being written on
the newly allocated inode. This would leave leave "untracked" inodes
in the filesystem, and the only way DMF could discover inodes
lacking in DMAPI xattrs was to run a full filesystem DMAPI-bulkstat
scan to synchronise the filesystem state with the DMF database held
in userspace. When you're tracking hundreds of millions to billions
of inodes, being forced to do a full fs inode scan after crashes or
ENOSPC before everything works properly again is, well, kinda
annoying.

Similar issues afflicted Trix (Trusted Irix) where security xattrs
(such as ACLs) went missing on crash or ENOSPC. On Irix, they were
stored in the XFS_ATTR_ROOT namespace, and the use of reserved block
space for XFS_ATTR_ROOT was introduced in 1997 on Irix.

commit 32d7e9a0d0fbca91a3d036c8518a87e10abfafb3
Author: gnuss <gnuss>
Date:   Fri Dec 19 19:35:42 1997 +0000

    pv: 553766 rv: lord@cray.com
    Add reserved flag param to routines in block allocation call sequence

This commit contains just the addition of XFS_TRANS_RESERVE for
XFS_ATTR_ROOT xattrs. Nothing else used it - this was specically a
fix for ACL/DMAPI xattr creation at ENOSPC....

However, ACL support on linux, and hence XFS_ATTR_SECURE, didn't
exist until 2004:

commit af80e14283d9475582dfb2d91395b674b9827fa8
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Jan 29 03:56:41 2004 +0000

    Add the security extended attributes namespace.

This added the XFS_ATTR_SECURE namespace because ACLs are in a
different xattr namespace in Linux (i.e. TRUSTED -> XFS_ATTR_ROOT,
SECURITY -> XFS_ATTR_SECURE), but the xattr set/change code never
added the XFS_ATTR_SECURE flag to the XFS_TRANS_RESERVE case.

It wasn't until 2007 that we started to use the reserve block pool
for other ENOSPC avoidance cases (like indirect delalloc BMBT block
reservation exhaustion in writeback) here:

commit bdebc6a4aca2ac056b8174f5b6a3bf27b28f6a5d
Author: Dave Chinner <dgc@sgi.com>
Date:   Fri Jun 8 16:03:59 2007 +0000

    Prevent ENOSPC from aborting transactions that need to succeed

So, essentially, for the first 10 years of it's life,
XFS_TRANS_RESERVE was used supposed to be to prevent ENOSPC at inode
creation for security and trusted xattrs....

> It seems reasonable, and it's been there forever but also not
> obviously required, AFAICT.

In hindsight, it looks to me like this was an oversight made back
in 2004 when XFS_ATTR_SECURE was added to linux for security
xattrs. As Christoph says: "it should have been there since the
beginning".

-Dave.
-- 
Dave Chinner
david@fromorbit.com
