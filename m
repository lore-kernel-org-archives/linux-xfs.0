Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1941494AB
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 05:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737349907; cv=none; b=QBUMX6lV1TAQ1uLxRwf5Uc+XBn/wB3+KNNCEKvuWZz5W1Dq4uiBc5vb+3RTrIv14zFLN6KEf9njqd1lJK01L8CNQxxozF3We3zqFkOrlJd88Fg4pt/yYKeytIiKi7l6sFcrE2PiGQ3jJQKtz5oBfQ2x6l/Ht9JLQ5ujk1Dt/QPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737349907; c=relaxed/simple;
	bh=6/hN0uU5Wl1ajZZjuZXT7EQYyfDFmNjcnumjQGHIlDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IlA/TEnBf/y1naTzoocgvHF1BMEn6IY0VkjR6CB2C+SGpYjLjIZ3v0VlwyoLRi8q2VzhK4hk3IhZOFdtJulTGIdQ66yKbDyRi9Ned7eBvJGiv4xVe0zgRznmfB9rS9fMsByW2r8HUOh5gmJo9ePv/c/eCVS0+F3+vkqBYBd1SP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=XyQd/JE5; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="XyQd/JE5"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-21644aca3a0so93002295ad.3
        for <linux-xfs@vger.kernel.org>; Sun, 19 Jan 2025 21:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737349905; x=1737954705; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MewRj9QiRq20R+oAW7gPmxUVZw7d03MaRffdhRRwACc=;
        b=XyQd/JE56btLujCCZrIuxVQTvFK9HnOdlWO3ReG4NpXGFlha/wq8/ZX9M3Qe5oPGY3
         +a+9/DO6LOFXABo8xSP6oYHmypT8TZuGzg7YQYCerOwZM/F2s1COO1hMqyBB20YdLQSP
         sD7kjVOCDZgUHxDKf7wkh5oJhl7ow83PEDj3pfn7pvMEr723qHdpxyhh5a0+W7FZhTft
         jydIFlxnJEal6eitNy8uShAvuOJ4NvZziGSyFB4eJEZHGh27aQp960gJ8DX2G/Kyf/bs
         UF7VKb8T1MIpUsDLP9Q4miTd4vn8E7wgipoIc0Tm421OIqCS2rkdATFb6RFLKVQVoxY6
         1eEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737349905; x=1737954705;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MewRj9QiRq20R+oAW7gPmxUVZw7d03MaRffdhRRwACc=;
        b=nppahXeVgfkyfZYleXDrRgBxV5PBlaSEBA9cU+imsvKV5n3VK3tlw3oa6yot9XTc9P
         0cplDNwVczLO/2kloKlSXWG87nFQQ6kDCWQeb9zgebIjAVMyKnvlV3YbaVx4TJ7okmM+
         EO6DUegfSCCtG4aBi2oKJYFTduN1DKkiFGCh/XI3JSf6+0HGAsN+kgIscFPPcDDN3s2c
         tDyS0jF1glC6He1syLHQM0PH+1Po0O9T2e2DrK3IafUqUFvu+1YzVCBgni4al/2dCijg
         dTbpO73rdxgiP3wlae+fPzdoRVbgITfhEmAEHBTuYp4MYGgyn9+iniJosAFKd/4M6tiv
         ruTg==
X-Forwarded-Encrypted: i=1; AJvYcCXJ0MgujSOSdIeDP8YOzh9W0GtQ/ZbhM/r4K7D/oAlUpJXCEbLjaQoDMC4xo9ofiisGy/Jce+WSVe0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUSITJ2/LHxNmxSRru1qZcU/L3zIN2lz7cR0iP7ZwPzaAkRosL
	dHZicxvMKkq4L36lZM99VsJmFj/megsepojWxvpEX4chIfF0LCo7T0NN4tkaAng=
X-Gm-Gg: ASbGncuFuQmmGzh3lF50f9u3aribNZzZLQjrTs0Sg1ZotP2h2LurcuHcnflaZcksBnb
	dFE78rfVE26ti2HrNO5s30kq4lW/8HAVRqXBVZFfpS+5fm/81H5vfZ91QnIEItygAg7XXWrr1zV
	W1Ctahgo5kFv2FyC02IJUELDCH96VLVxJ682oD84OjcEs872gM8Ns8zU1HtHRvKFO6le16PKRm2
	hiSEVSYw1LSAihNaD9NLqyDiqbVaC09kpd6qVpXB6LH/QbykEBbf2KSJabBI4awwO96ceqrU2kH
	SMf+Us0BAT3crHOcRdXiiUnmG/YnuhaadWMJRk5GOwMecg==
X-Google-Smtp-Source: AGHT+IHhbkqmjwk7Q6aME70kwcXDy+5z8I0QB6+x/heTFSjea9kOICMiW5mp/Ss+fGBt5bxAEJoGtA==
X-Received: by 2002:a17:903:2302:b0:216:4a8a:2665 with SMTP id d9443c01a7336-21c3560949emr171420605ad.50.1737349904797;
        Sun, 19 Jan 2025 21:11:44 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2d403100sm52561115ad.234.2025.01.19.21.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2025 21:11:44 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tZk4b-000000087ZK-0YIq;
	Mon, 20 Jan 2025 16:11:41 +1100
Date: Mon, 20 Jan 2025 16:11:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chi Zhiling <chizhiling@163.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <Z43bDYQ6PwklKgJ3@dread.disaster.area>
References: <Z4BbmpgWn9lWUkp3@dread.disaster.area>
 <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com>
 <20250113024401.GU1306365@frogsfrogsfrogs>
 <Z4UX4zyc8n8lGM16@bfoster>
 <Z4dNyZi8YyP3Uc_C@infradead.org>
 <Z4grgXw2iw0lgKqD@dread.disaster.area>
 <CAOQ4uxjRi9nagj4JVXMFoz0MXP_2YA=bgvoiDqStiHpFpK+tsQ@mail.gmail.com>
 <Z4rXY2-fx_59nywH@dread.disaster.area>
 <CAOQ4uxizxUg+EXar2GzDWgp+reRZ_0wc+DAaSAGmUZ1VXOjjLw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxizxUg+EXar2GzDWgp+reRZ_0wc+DAaSAGmUZ1VXOjjLw@mail.gmail.com>

On Sat, Jan 18, 2025 at 02:03:41PM +0100, Amir Goldstein wrote:
> On Fri, Jan 17, 2025 at 11:19 PM Dave Chinner
> <david@fromorbit.com> wrote:
> > On Fri, Jan 17, 2025 at 02:27:46PM +0100, Amir Goldstein wrote:
> > > On Wed, Jan 15, 2025 at 10:41 PM Dave Chinner
> > > <david@fromorbit.com> wrote: For all practical purposes, we
> > > could maintain a counter in inode not for submitted DIO, but
> > > for files opened O_DIRECT.
> > >
> > > The first open O_DIRECT could serialize with in-flight
> > > buffered writes holding a shared iolock and then buffered
> > > writes could take SH vs. EX iolock depending on folio state
> > > and on i_dio_open_count.
> >
> > I don't see how this can be made to work w.r.t. sane data
> > coherency behaviour. e.g. how does this model serialise a new
> > DIO write that is submitted after a share-locked buffered write
> > has just started and passed all the "i_dio_count == 0" checks
> > that enable it to use shared locking? i.e. we now have
> > potentially overlapping buffered writes and DIO writes being
> > done concurrently because the buffered write may not have
> > instantiated folios in the page cache yet....
> >
> 
> A shared-locked buffered write can only start when there is no
> O_DIRECT file open on the inode.  The first open for O_DIRECT to
> increment i_dio_open_count needs to take exclusive iolock to wait
> for all in-flight buffered writes then release the iolock.
> 
> All DIO submitted via O_DIRECT fds will be safe against in-flight
> share-locked buffered write.

Hooking ->open() and ->release() isn't sufficient. O_DIRECT can be
changed at any time via fcntl(F_SETFL) which isn't synchronised
against IO in progress at all. i.e. we can't track that, nor can we
even use f_ops->check_flags to reject changes to O_DIRECT state
because it doesn't pass either the filp or the inode....

IOWs, as it stands logic like "is the file opened for O_DIRECT" in
the IO path is inherently racy and the racing mechanisms are
directly under the control of unprivileged userspace applications.
Without mods from the VFS down and new hooks being implemented in
XFS along with all the whacky "which serialisiation method do we
use" logic and dealing with the complexities and switching
between them, tracking struct files that are open for O_DIRECT isn't
really a viable mechanism for enabling shared buffered writes...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
