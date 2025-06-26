Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E9243159
	for <linux-xfs@vger.kernel.org>; Thu, 26 Jun 2025 03:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750910285; cv=none; b=o5xfCLvImp9yPZZp9Ftu+RDnaAnctnTj0q7pWSa7cUEDoC6zbpnDSA3mz9l20/rb1obZNzeVPMZXxP0nuX5We41yJbMnCBShUkaK/cc5qrWHEd17/MBq0AaM7gNpg/IqgfvQu/4JHIb96kDLGmv9vSJvF3AGgkA70Y5PfgQ76wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750910285; c=relaxed/simple;
	bh=T2Miax55TEaH5XXrNWxmT95KXQwslFMTuIhlDQPaD6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KlsgTWPjwdEqSUj1CuirfJLL2salAJITAjZFGE+MOdN0BWiQCLpVW0Lm9ExJvcfBYTD8G0j4IW5I3jsipWy3APjq/VLhpWl18Gb8WfXtfblDxtY/an+QU+LF2mfumRu3RePkRFolavae8Y8P0R/+cRcEJLoJIbmv7J/TA0P8N+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=3NzRWHAm; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="3NzRWHAm"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7425bd5a83aso763491b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 20:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1750910283; x=1751515083; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ukewhoDGjvLSFodXCnO2Wi7qwdFCCxAWQjKm3BxoyQw=;
        b=3NzRWHAm72ObkQsmlY+xEArO65buF439G7C0VhjZEwSSIe2/gnAnYiYiHzpFnXsf43
         8gZ2H46RzbSiL3nHERBMuO9hTELT4lmYsekqVMHyq9UHhnykJs7/OzYeDdRYRiILApW2
         WgRmsWcK6thNMXyAH5wtS9T1LKy+qDK3JOQZS2D8uR8mIqIr9QwznFSA/PzVL7l/S1gw
         AkF0ABxBR+0Mk7vBqoxomKd06u9smeX/eGdVvF+OFADKqarURp2hzLSRP2lUnYuojHC2
         MhHR3or1gS8hxXAc5HBk+g7SCXksXr8g7KqRkERX+Yg+MgUTis23Cwlyh8eLV4jGdEYC
         3R2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750910283; x=1751515083;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ukewhoDGjvLSFodXCnO2Wi7qwdFCCxAWQjKm3BxoyQw=;
        b=C0f+R1Jh8UMVAL7vbmmUFilHBj+XwkaeZRqE7STecyQdB0/0anXbEdy8Jx8Xt6iwG6
         GYXINSn3QnY7FlLbUP5s0vQ2hScNxEsbjxXO1KGi6kPOIME6NRvVXOsaNY0zhUBcU4TF
         9YPmOHsV0UFc2krLbEBIiG1DK9qVqZKNjEy58iD9byy8K+5okTfXGxElXvMGShRqpenJ
         QlAUBVSdAfjsgKwkB1sjK+E/rADvBDxVYy2hEy9/x/5UJSkoSZOvo7u7CjNbd0TOBUBG
         I2+eayPQ/QDdLUXQBzQYd3BfrT9TSJ5Qu126fM6Si3AzKDIpxYoIKpMVQqD7C/TphF3z
         TCkw==
X-Forwarded-Encrypted: i=1; AJvYcCWPvoTUAOgto1B+HmIiDggZ5QLPBTHWy4a63gXX7epR3KecCjN6zPwkVY75aDVmTPykBICB8HhVqpM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgXHV26crJYy+AAAM+hEytiSEXm9B9mrv3SYX0Von93rO8mFMo
	vT4T3Ge7UTqNZqz4hEJ2vbxgRpfkCrk8bV2KjzoFqp2+IH/5zEgDoKGwC8/KWH9tcmdCGgR+dXV
	62Eri
X-Gm-Gg: ASbGncvAbBN91ErzoVeKj13JDJTQC4WlVZu4vSdO1jaN04v/RwVoYHocrQy4iYldbyG
	Rt31JqEr5oJlGmbGl32nCMPJhMaHGLRIRu6X1Dtyf3YXpUSzQBjJ0gv2zj/agCkC29kn2GVEBne
	7rcSL1vF+nuOe6DlXj/lxYZPs9ZIgR/CiCb7PC0EEVaycTBwXHiaaiw/bde6iCDoEwWxfBZgCqC
	td2Ih7bXm9WHgRf1ScSxSg5wN9ebibL0Uqa0Rf+EPwtX/a1XIIFGm9NznEb/veLIQh1EK8UyAF0
	OAYRldNPG4301jh5rVoGo8Hva2gDwiYsaR+VMQ6VmNEaUE6ZuF6ZSkHBBzmEmrBj7sTFtWHsq+d
	G0NdjwCqV6fCErkfGNo8qH5UGNGfVyfQNwiqvkMkl2Ob2ttEt
X-Google-Smtp-Source: AGHT+IGfMj1hupvnOX/mD73qau+DpHSUC+w5eDTmeBI+czHsebUdwnvPvrfHC2KQ/TS+fSfAjMVx1g==
X-Received: by 2002:a05:6a00:c86:b0:740:afda:a742 with SMTP id d2e1a72fcca58-74ad4059d79mr8122379b3a.0.1750910283181;
        Wed, 25 Jun 2025 20:58:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749c88548dbsm6145745b3a.133.2025.06.25.20.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 20:58:02 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uUdkN-00000003L0Q-42Kg;
	Thu, 26 Jun 2025 13:57:59 +1000
Date: Thu, 26 Jun 2025 13:57:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	djwong@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	yc1082463@gmail.com
Subject: Re: [PATCH] xfs: report a writeback error on a read() call
Message-ID: <aFzFR6zD7X1_9bWj@dread.disaster.area>
References: <aFqyyUk9lO5mSguL@infradead.org>
 <51cc5d2e-b7b1-4e48-9a8c-d6563bbc5e2d@gmail.com>
 <aFuezjrRG4L5dumV@infradead.org>
 <88e4b40b61f0860c28409bd50e3ae5f1d9c0410b.camel@kernel.org>
 <aFvbr6H3WUyix2fR@infradead.org>
 <6ac46aa32eee969d9d8bc55be035247e3fdc0ac8.camel@kernel.org>
 <aFvkAIg4pAeCO3PN@infradead.org>
 <11735cf2e1893c14435c91264d58fae48be2973d.camel@kernel.org>
 <CALOAHbDtFh5P_P0aTzaKRcwGfQmkrhgmk09BQ1tu9ZdXvKi8vQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbDtFh5P_P0aTzaKRcwGfQmkrhgmk09BQ1tu9ZdXvKi8vQ@mail.gmail.com>

On Thu, Jun 26, 2025 at 10:41:47AM +0800, Yafang Shao wrote:
> On Wed, Jun 25, 2025 at 10:06 PM Jeff Layton <jlayton@kernel.org> wrote:
> >
> > On Wed, 2025-06-25 at 04:56 -0700, Christoph Hellwig wrote:
> > > On Wed, Jun 25, 2025 at 07:49:31AM -0400, Jeff Layton wrote:
> > > > Another idea: add a new generic ioctl() that checks for writeback
> > > > errors without syncing anything. That would be fairly simple to do and
> > > > sounds like it would be useful, but I'd want to hear a better
> > > > description of the use-case before we did anything like that.
> 
> As you mentioned earlier, calling fsync()/fdatasync() after every
> write() blocks the thread, degrading performance—especially on HDDs.
> However, this isn’t the main issue in practice.
> The real problem is that users typically don’t understand "writeback
> errors". If you warn them, "You should call fsync() because writeback
> errors might occur," their response will likely be: "What the hell is
> a writeback error?"
> 
> For example, our users (a big data platform) demanded that we
> immediately shut down the filesystem upon writeback errors. These
> users are algorithm analysts who write Python/Java UDFs for custom
> logic—often involving temporary disk writes followed by reads to pass
> data downstream. Yet, most have no idea how these underlying processes
> work.

And that's exactly why XFS originally never threw away dirty data on
writeback errors. Because scientists and data analysts that wrote
programs to chew through large amounts of data didn't care about
persistence of their data mid-processing. They just wanted what they
wrote to be there the next time the processing pipeline read it.

> > > That's what I mean with my above proposal, except that I though of an
> > > fcntl or syscall and not an ioctl.
> >
> > Yeah, a fcntl() would be reasonable, I think.
> >
> > For a syscall, I guess we could add an fsync2() which just adds a flags
> > field. Then add a FSYNC_JUSTCHECK flag that makes it just check for
> > errors and return.
> >
> > Personally, I like the fcntl() idea better for this, but maybe we have
> > other uses for a fsync2().
> 
> What do you expect users to do with this new fcntl() or fsync2()? Call
> fsync2() after every write()? That would still require massive
> application refactoring.

<sigh>

We already have a user interface that provides exactly the desired
functionality.

$ man sync_file_range
....
   Some details
       SYNC_FILE_RANGE_WAIT_BEFORE  and  SYNC_FILE_RANGE_WAIT_AFTER
       will  detect  any I/O errors or ENOSPC conditions and will
       return these to the caller.
....

IOWs, checking for a past writeback IO error is as simple as:

	if (sync_file_range(fd, 0, 0, SYNC_FILE_RANGE_WAIT_BEFORE) < 0) {
		/* An unreported writeback error was pending on the file */
		wb_err = -errno;
		......
	}

This does not cause new IO to be issued, it only blocks on writeback
that is currently in progress, and it has no data integrity
requirements at all. If the writeback has already been done, all it
will do is sweep residual errors out to userspace.....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
