Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4550628
	for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 00:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711068952; cv=none; b=qfZbvyGA6ANfE75P9hJCwZYZO/lnYnY8V1BPQbl8Ao8DEhffK22GDyAiyC+cIMJEQXwdf5fqmT3twvsbUR2oNDY8l9jnzoxq5RRKnLk7VdTKOpV+F/TtsXNNCIZngQ4mwJZo1TA6Fqnp9uXswhZax5/0CFvvbMrBgRfCf7/pGQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711068952; c=relaxed/simple;
	bh=zrZUjzzFQKZaEmm9RSR1gXq/479EkvVXn8nbWEhVWIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YdJYfRiKBIukBYI9/JDc8lkooYnOsT373fb1tCcvF4VoomLc8cxakgd/XTlAxfIypTtvI6ROeGZn7ag0qlongBhBihMEegQuLCPUwqhoS9SchLEdnS0K4fKS6PFNX/UTLajbff8Ry4mEth7n/Cv7WENQ6GjHHySEKs/dthO9avI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=foAhJ3ds; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="foAhJ3ds"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1e00d1e13a2so9584485ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 17:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711068950; x=1711673750; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:resent-to:resent-message-id:resent-date
         :resent-from:from:to:cc:subject:date:message-id:reply-to;
        bh=+ZAjG+9lnIa4IjK/hV23X+eliTGUV+PqVM2x/xVYc7Y=;
        b=foAhJ3dsfjheAtJFUJjAPzre63rkeYpLIeW8exsWMJVNsEiDvcwQ7HfzqVh0ovNHYa
         CcgWL5UJXkxpKLUH11TMFAAznfpWykJqMJrjDABVQ00KZpx27TgoTkMF350TCx2glBve
         djUK0ZwINa33gudkk9gRPQe8kDYL79dbx6D18hJNB0g33hs68Ju5iuuGg3G5VQF2Pnjv
         xShnf7mzye3xO8liXNqUl5w/lxYK6NJJt7ER+dej0SddNA3tvQxIr+oxsfi3J1NPYfyJ
         ApUsJLCeVPwN6P7hZp8joM7Y0Qz8MPfPg1Afcvo9RyrCtAjn7PzS9z760u+1BCer1Dam
         /G4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711068950; x=1711673750;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:resent-to:resent-message-id:resent-date
         :resent-from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ZAjG+9lnIa4IjK/hV23X+eliTGUV+PqVM2x/xVYc7Y=;
        b=KzXdzMILk5J7MMKyrONypMpjQBZSjr5nM5qvhtesFviGCYI2Aaij3DBwgneLrSwoMt
         nWKn2hetaxhfJ+pGww77F1utPTfc4WVD4oQWZBt7U9OXzwjREEwUQH/E8CqZ82U7hvq7
         5eaVfQ+mO3hxV8J9BNhOc8h67aC3Vqo4WuTeRSr7zZgo2C31eEWhFIM3Kkx4r27IlgYo
         v1PmpittXle7DtzcPNZ2q2pp8GSzJbzmTeX/4w1zGQ+1V/i2mTK0R9VkhaANYwvm/bd8
         CGMkXD0VCOxOgesnMhZOnZunqJODvZzdxdwzbP9Z6hpeEGucwtSMAY3UWAy0WNFZOR57
         JoDw==
X-Forwarded-Encrypted: i=1; AJvYcCXyMfGyxALG5KNYjWaLrLPuXf+yGuNnN38mZpx04CyJb+b1O/c2WbSboiMAvzOlmEhEj4TzVTfmo+ytULbAEnsKng3fZQnEd59B
X-Gm-Message-State: AOJu0YyStVpNY7DrbhKAHdVdidWwkyeeCo+S9IFnAgFqJlMph0OIV9Bs
	US2RKjz9Y+FCxQczktVZ1mtCYP7SrVOAVrpXm5+K0lxwtteX1hHz41dCWkoYAJUHYRceWoP/qg6
	S
X-Google-Smtp-Source: AGHT+IGj/6VeS+ukI0Xk343vyCrly9WtqTcgKAMVgwv5lzABX2fGF4d2IjX624p9n5ahTr1ZkjYybA==
X-Received: by 2002:a17:902:d644:b0:1de:e11f:f527 with SMTP id y4-20020a170902d64400b001dee11ff527mr961491plh.30.1711068950170;
        Thu, 21 Mar 2024 17:55:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id u9-20020a170902e5c900b001dd8e1db1b1sm501436plf.175.2024.03.21.17.55.49
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 17:55:49 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rnTCF-005Tny-0d
	for linux-xfs@vger.kernel.org;
	Fri, 22 Mar 2024 11:55:47 +1100
Resent-From: Dave Chinner <david@fromorbit.com>
Resent-Date: Fri, 22 Mar 2024 11:55:47 +1100
Resent-Message-ID: <ZfzXE7O4AbgTfo30@dread.disaster.area>
Resent-To: linux-xfs@vger.kernel.org
Date: Wed, 20 Mar 2024 14:10:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: internalise all remaining i_version support
Message-ID: <ZfpTl/1hKUQeBsX3@dread.disaster.area>
References: <20240318225406.3378998-1-david@fromorbit.com>
 <20240318225406.3378998-3-david@fromorbit.com>
 <20240319175411.GW1927156@frogsfrogsfrogs>
 <ZfoadKGgatGjTM_5@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfoadKGgatGjTM_5@infradead.org>

On Tue, Mar 19, 2024 at 04:06:28PM -0700, Christoph Hellwig wrote:
> Is there much of a good reason to do this now vs oing it whenverer
> we actually sort out i_version semantics?  It adds size to the inode
> and I don't see how the atomics actually cost us much.  The patch
> itself does looks good, though.

I'm kinda with Darrick on this - yes, it burns an extra 8 bytes per
inode, but it doesn't leave us exposed to someone misusing the
inode->i_version field. I also don't like the idea of leaving the
disablement half done - that just makes it more work for whoever
comes later to do something with this again...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
