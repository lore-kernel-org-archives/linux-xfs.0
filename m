Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A377978F2E
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 01:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734572839; cv=none; b=EMusBDOP1W6tAcbJ120nRlcausDtECsf5aDbiRg3b75aS2Q55J911OUpt3FQK/E8qMIubIpDTFbrOJvoSRrQd/GSvIHDToTd/D/A0bRFQBP8hw5WKAU2w5hYJKjTW/36J+mbqfVyS9x2w/5k2kOPaKrYFnELgYI+afeZ1ims2+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734572839; c=relaxed/simple;
	bh=QoEtvf7G0kC0x/Wl3nJ0XIYl2HZa0Re3rk+nGV30jwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uUHZ+ucgbl3Guuy/8kXVQVKWNaz0iVsumV6l21E8Kk0Sgss6dGVbxcGXRv2jsN0v/4AF9KxhR2jaW0KfMzw0FPtBOH2LxlxAsZqDBkw7zeejzA8fbX88Tf2Ov0OZo/KDeKaZ76eTJFBuXNIuajsyi6yn596xxnq279WfsjfMQNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=sBTgTpaZ; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="sBTgTpaZ"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-21636268e43so3279345ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 17:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1734572837; x=1735177637; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nFHEfXVHBOjseorucBg5TQ9yn5KG0rfffOIvw+zi84o=;
        b=sBTgTpaZ8mVD4iBQgBXOlDPLUcA5D4ujZK+4p/HUNST3Ta9ntAVCPRnVoYkIbRgbwj
         BxAi5U3Kfw7qQvfqcPkVo4P6RsG56qd9I9pFjG8p0wkGGZJZwXdXUDKpxUf9maop46i/
         AbPkuAuyhFSmGz6HZ0ZhQEjEcjzc08AiDx2hC30agh/yco9b77JUDOHTv0F8V5GWaPiF
         fc77ZlyF6VTKe2YM3h85tATwMlj0NU45kEZ06niLjkXDkxTtcl440PwxVSuPb+AQg8e9
         WbwbGBfbyy3wNrbd5CNivDXmZH3H/6RrwbTb9JyvPI51sXy3+lyOj2n8OQEFaN+ys4Xa
         UOig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734572837; x=1735177637;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nFHEfXVHBOjseorucBg5TQ9yn5KG0rfffOIvw+zi84o=;
        b=SJgKxlPPi959nTUn++v6Sd/xLhBI0fXY/OgkVvHqyZ+2UQMpvpl6e8bxkBVqQxZHu3
         ejyNS14h5zf2UxWyf1nmI+VJtM1pHsYod6T4VcdLW9xpONqDlC17MtgmrXGrpERO3XuN
         H6cXdWnf1Clbztg9NbXEVNLoPeDl4MiQEWWmz1c8te2YlxCW0kjUIH0Qw+yRfOQxEugp
         c/PBxF7c4wl3F7Q/r6jE3OGk5i60+6ETIBURkXKl7/4Z16FOVwJ/gXYMN8e8R0OwJ/bq
         4kJLAc1dNGzYUjpDEHNpRqdqJ+GoYccC8J/FSabcqUm1C7CkVEbTqUaB5NMwSf4KvlV7
         QWEw==
X-Forwarded-Encrypted: i=1; AJvYcCXThSr2J7HZQM04ialvnfhxUjsrNKD4Qh3RNDfjnzQiwQU7XWYQbNlMzPEXelHohY3l6OF9FepTHaA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6BSHt3Lud2Oiq3w6Jldb4lX1f1i/4bWMiRD4c1Mr+vSCmRZGB
	TYW3MCiIZ8gXNTu3KflHVOc+vfP9OnBaPwf8NnXG7eHB2gugPwnoox5O//LNHtRbAcob/L4ApxS
	U
X-Gm-Gg: ASbGncumc4Rl63joZ0ajHC5VfQ5JfP1vi8GWoDri27tejDqaXVWF4dK5LdB/LJsTkLT
	AvzvwXGdIgg5fbUfQVcLxZDO4ThnaOMhjMWc9aoklmmwtaAtAVTy9f8e/D7NKmw8/6/WZzGTktA
	Ngmf5q9ygNbFhOpDQ0O4chLoGCcX2529JXz6aIrQOZZjhpwYAOt7CXMieK8HOANZTXjQ/6n6jJP
	B/QLW5Pan2H4ZsbfjYF5vwS9mO4kb4L+YrE6BlqDpeNpXT5OZgwKwDs8zDmp39WEVykGJfQt4hK
	Zbkk+XoN57Y4b2dFo/tZFbZhcBQ1EQ==
X-Google-Smtp-Source: AGHT+IHoM9BuzRwWE3UvBbujRjFPqKOpZTGf3EdvmaxlJ9Nm6SjjQJoIghbJbF3BGqAvlV3zRrZEww==
X-Received: by 2002:a17:902:fc4e:b0:20c:6399:d637 with SMTP id d9443c01a7336-219d96d213emr29814395ad.40.1734572837007;
        Wed, 18 Dec 2024 17:47:17 -0800 (PST)
Received: from dread.disaster.area (pa49-195-9-235.pa.nsw.optusnet.com.au. [49.195.9.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc962940sm1898825ad.34.2024.12.18.17.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2024 17:47:16 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tO5dB-0000000CUAL-2X1s;
	Thu, 19 Dec 2024 12:47:13 +1100
Date: Thu, 19 Dec 2024 12:47:13 +1100
From: Dave Chinner <david@fromorbit.com>
To: Song Liu <song@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-security-module@vger.kernel.org,
	willy@infradead.org, corbet@lwn.net, clm@fb.com,
	josef@toxicpanda.com, dsterba@suse.com, brauner@kernel.org,
	jack@suse.cz, cem@kernel.org, djwong@kernel.org,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	fdmanana@suse.com, johannes.thumshirn@wdc.com, kernel-team@meta.com
Subject: Re: [RFC v2] lsm: fs: Use inode_free_callback to free i_security in
 RCU callback
Message-ID: <Z2N7Ibxnmm-KEvea@dread.disaster.area>
References: <20241218211615.506095-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241218211615.506095-1-song@kernel.org>

On Wed, Dec 18, 2024 at 01:16:15PM -0800, Song Liu wrote:
> inode->i_security needes to be freed from RCU callback. A rcu_head was
> added to i_security to call the RCU callback. However, since struct inode
> already has i_rcu, the extra rcu_head is wasteful. Specifically, when any
> LSM uses i_security, a rcu_head (two pointers) is allocated for each
> inode.
> 
> Rename i_callback to inode_free_callback and call security_inode_free_rcu
> from it to free i_security so that a rcu_head is saved for each inode.
> Special care are needed for file systems that provide a destroy_inode()
> callback, but not a free_inode() callback. Specifically, the following
> logic are added to handle such cases:
> 
>  - XFS recycles inode after destroy_inode. The inodes are freed from
>    recycle logic. Let xfs_inode_free_callback() call inode_free_callback.

NACK. That's a massive layering violation.

LSMs are VFS layer functionality. They *must* be removed from the
VFS inode before ->destroy_inode() is called. If a filesystem
supplies ->destroy_inode(), then it -owns- the inode exclusively
from that point onwards. All VFS and 3rd party stuff hanging off the
inode must be removed from the inode before ->destroy_inode() is
called.

Them's the rules, and hacking around LSM object allocation/freeing
to try to handle how filesystems manage inodes -underneath- the VFS
is just asking for problems. LSM object management needs to be
handled entirely by the generic LSM VFS hooks, not tightly coupled
to VFS and/or low level filesystem inode lifecycle management.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
