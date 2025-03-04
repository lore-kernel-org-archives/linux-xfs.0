Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E141B414F
	for <linux-xfs@vger.kernel.org>; Tue,  4 Mar 2025 21:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741124712; cv=none; b=Q+05E44quc+A/g1sTzahIRxqJxQP2FN+hwXryW/0i8Eb9hwOiw3EyvAcLBVsVzKRCVQbjSUkEz4TnUAAblxLYVvMWhtFG7SyHvIri6HlA6VfrcPNB/UsbgTN7/5ior+ch+jRxwAnN0LGws1IxQbbS2LgTLnjzzhxNfhyZM3RKEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741124712; c=relaxed/simple;
	bh=HXyjWg0UIo59qPK6UzYC2apM98yYxeM76hoxQYCmhuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HNYFbq6lsfqnyoelL7ht05DpFi219A7pMTc10HUXvyyozGAQ0zFEtfkPVBBEaIVbgURSTXu4pr4oRNgtbeQvDp+2UCNwmwqqXer/+kM1kj4BkdcfhcjUV2Z5NL2XSBjWiDs+7wfQFKaPu3twVZJHiRKgb+TGZpQVPa8FaWxM/4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=fixPYamt; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="fixPYamt"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-223cc017ef5so38156255ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 04 Mar 2025 13:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1741124710; x=1741729510; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JXlvr0AuCIt7jLa/lGvPs7yWirPuSQnv0IzpBQ8cC80=;
        b=fixPYamt8r561SAUipv921X5TNx2q0nlVPMBwGcpl23eZZCYCKG9Btkoo9ACpn6D6r
         /zgkxOE/3NzqNXQCF4OCvzPZZLv0oOjKXMhiyKFLYoYmvXH0P6uIrDwC9HKE9660yGBh
         zuySPWk9bH2g22WKg4Z3przcsSxVYNL8Cth6KPvul8KzeBr3vkMO4F1tE//T9b964Hzk
         41ZscldFWXld9nx/SYUdLoDT7K/JP9SE9LknAvN+tqcRM98TWyL5CjsFtIMOD2XKduDP
         TZ+zmOxHyEG00gQ4r2uNq9UUDZsL+abo5nuNkDXI/mBHomWycaj5lMKXLGsk3ODmvo0D
         KhVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741124710; x=1741729510;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JXlvr0AuCIt7jLa/lGvPs7yWirPuSQnv0IzpBQ8cC80=;
        b=eRH2gmwI04l6nbJ6BJmWXfbVehGndbM3s7j/CseKbpZJ92MUeErOQGabREmsPGx0Uu
         doFQm7xMAt3iqPZmyBpfdvr4es4Rg9LvUjm05F+WBEzRlmmlpseJLsM5s1NqQqqTdhtY
         U128MKQM1NA9hKWwm2NaebdpnEZv8iWP11xEDgm7iqcrH+5xIJTK1WuTlpLwI2qcezQ+
         cF3x8xnHkxsMaUTakgbo+6BgpdCs5ir5aMbYa+obR7EHMY/LMhOiO1Xgd72mK2k176h7
         Biwh4WUrosGYjgGxaXxBuFSsTU8s2Uslk+HO4aQbIn1162NKRJnQbWT5kNRmPLr7Vn4+
         XURg==
X-Forwarded-Encrypted: i=1; AJvYcCWQbIuwqaUebBmAG/S5NToDZUXwzEUxKUoYFInPhWp8tF4qbnn21FUPVD+u5WL0QZS3c5OqqjohpN0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyciYjScnPry2PmY/9DGqUu/vHuAw2xTRHROtevB+o+Yvb6E9m
	Fll7BjlUpT/5FdosPyx9WC4I+X9TMaH3l7jYMVFcp+2fEJMO9zwcPo/A8KY6vxk=
X-Gm-Gg: ASbGncsnxvJIdmM/+sJyrABabHj38sOyVNy6bbcQsY1hSCmi3aAbwKqNp6ldXVOjp5P
	r1Mp5KU9NhSM/GqK37YuPisS9j9VbSO60SUPxsnWtcRYk5suW0TcNF4UO7iRI/Fs5vZOTih4jLM
	5ch68hUdxXlqQR5p2LDKtSLMk/8vZjeFpPksRRtwSaG8IcGkJRkS9uewLqO3briNqOZyDqrIpqZ
	sEWXCBcwxAlAvtTlWN9jhmYjVuYrvVNT3PUC0VnzgacvP5a+Z9Dzn5xUQ2VWuRahi7palhi5DwU
	bZLpRluelPcSBWcJ9Dx7QrtjMCiXtUNUg5CseTwh6Z91whRhz5qayoT16VqHFnn0GNpOEeoPzXn
	Aag/XmlxyD3oRjcF6SPK/
X-Google-Smtp-Source: AGHT+IGNwy59VhNQY+L/AmQpCxxA1/Mp+YoBvn03hGdzhtDUWymDRf7aWS1Y1DjJmIdSpj7CoWsAbw==
X-Received: by 2002:a17:902:f548:b0:220:ee5e:6bb with SMTP id d9443c01a7336-223f1c95914mr11075785ad.20.1741124710362;
        Tue, 04 Mar 2025 13:45:10 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-734a003dd31sm11416022b3a.152.2025.03.04.13.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 13:45:09 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tpa4Z-00000008uUy-1ykB;
	Wed, 05 Mar 2025 08:45:07 +1100
Date: Wed, 5 Mar 2025 08:45:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	lsf-pc@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dchinner@redhat.com, jack@suse.cz, tytso@mit.edu,
	linux-ext4@vger.kernel.org, nirjhar.roy.lists@gmail.com,
	zlang@kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] xfstests: Centralizing filesystem configs and
 device configs
Message-ID: <Z8d0Y0yvlgngKsgo@dread.disaster.area>
References: <Z55RXUKB5O5l8QjM@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <Z6FFlxFEPfJT0h_P@dread.disaster.area>
 <87ed0erxl3.fsf@gmail.com>
 <Z6KRJ3lcKZGJE9sX@dread.disaster.area>
 <87plj0hp7e.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87plj0hp7e.fsf@gmail.com>

On Sat, Mar 01, 2025 at 06:39:57PM +0530, Ritesh Harjani wrote:
> > Why is having hundreds of tiny single-config-only files
> > better than having all the configs in a single file that is
> > easily browsed and searched?
> >
> > Honestly, I really don't see any advantage to re-implementing config
> > sections as a "file per config" object farm. Yes, you can store
> > information that way, but that doesn't make it an improvement over a
> > single file...
> >
> > All that is needed is for the upstream repository to maintain a
> > config file with all the config sections defined that people need.
> > We don't need any new infrastructure to implement a "centralised
> > configs" feature - all we need is an agreement that upstream will
> > ship an update-to-date default config file instead of the ancient,
> > stale example.config/localhost.config files....
> >
> 
> If we can create 1 config for every filesystem instead of creating a lot
> of smaller config files. i.e.  
> - configs/ext4/config.ext4
> - configs/xfs/config.xfs

Why are directories that contain a single file needed here?

> Each of above can contain sections like (e.g.)
> 
> [xfs-b4k]
> MKFS_OPTIONS="-b size=4k"
> ddUNT_OPTIdd    d=""dd
> 
> [xfs-b64k]
> MKFS_OPTIONS="-b size=64k"
> MOUNT_OPTIONS=""
> 
> 
> Then during make we can merge all these configs into a common config file
> i.e. configs/.all-section-configs. We can update the current check script to
> look for either local.config file or configs/.all-section-configs file
> for location the section passed in the command line. 

What does this complexity gain us?

> This will help solve all the listed problems:
> 1. We don't have to add a new parsing logic for configs

We don't need new config files and makefile/build time shenanigans
to do this.

> 2. We don't need to create 1 file per config

Ditto.

> 3. We still can get all sections listed in one place under which check
> script can parse.

Ditto.

> 4. Calling different filesystem sections from a common config file can work.

Yes, that's the whole point of have config sections: one config file
that supports lots of different test configurations!

> So as you mentioned calling something like below should work. 
> 
> ./check -s xfs_4k -s ext4_4k -g quick
> 
> Hopefully this will require minimal changes to work. Does this sound
> good to you?

You haven't explained why we need new infrastructure to do something
we can already do with the existing infrastructure. What problem are
you trying to solve that the current infrastructure does not handle?

i.e. we won't need to change the global config file very often once the
common configs are defined in it; it'll only get modified when
filesystems add new features that need specific mkfs or mount option
support to be added, and that's fairly rare.

Hence I still don't understand what new problem multiple config files
and new infrastructure to support them is supposed to solve...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
