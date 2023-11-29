Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="U2/PtluB"
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86B01735
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 00:21:33 -0800 (PST)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1fa21f561a1so2040754fac.3
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 00:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1701246093; x=1701850893; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=swfU8TF0GzJsUCWnFgrLrmU8UHRbqYlkMBWEYbcAmZA=;
        b=U2/PtluBWBX3uyj/XdIM5Bvi19SHVGLvyAA6I97YZjzGOWVrGCcqCJ/pgmI6aL2jil
         E7g3x99hY1jqEq5w/g9M2dcjiNIPuKz65MY1D30Omq0i79f0zA9mmFjm8jjB1QQ5onv4
         wodS9O+zvziNnqJ08KLspM4r23xAYdSdvadVngTX3LAHDP/kvzz1sYiFIHbMDyvgwLOB
         MRGAZ6nDZfJg96zMmGZuhUpUJ8rHSQjEOp/4nM8ydHd+FBjT8FewoOAmaqOVTjWVHDa/
         b7T+C0amdp9N1KqNBmJzJIDRwuK+dmU9sG09gY6S52lDwQpOqB99qVz/75yOEk/Mlr27
         d4UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701246093; x=1701850893;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=swfU8TF0GzJsUCWnFgrLrmU8UHRbqYlkMBWEYbcAmZA=;
        b=mcho906BKO+8bhXrQ0kpsq3oOO2d4Evui7v4QiVsAVoSC4oLle/VWP45g6g2ob2IWr
         gqdps0xs8OfSbZvH0n3DXeQCxR6oF6VbBE2toVIl6FfWrRBQqZzH60cN4j/qEs81fTj2
         I4zw5IQb09kjszPzUfLD8ZFFy5E6MHE2t4uv/P5YBXMRh5ziwtQW+iBvHSXXmXlZYq2O
         ppgVnIUufH3UKOig9BiQkQ3K8dHYXGQZyu+3qnKv6fayAWNhKuELDFXH0FQ3c+hRSidO
         tZonUaENiEqPLycWMq0XskxB2dAErp3815eO6tWuwfn8iBMjz2dW+QIREazNMCjnflz5
         ebwQ==
X-Gm-Message-State: AOJu0YxkcQjSD0niYDvIv945emMp9NxIcHcMApwjEIgUqNeStrHJLFxu
	PZnLw8rR6jeIW6BtmRL+Gm7SKi+CLo/aBVokrlk=
X-Google-Smtp-Source: AGHT+IGVKdsy0ika4FEQDbNAvl4JeOnKczlPT7ZcDKU2KMi4Krqapi4yKesSRbNtUW6R3V+gXEIEsA==
X-Received: by 2002:a05:6870:5d92:b0:1f9:6962:b06c with SMTP id fu18-20020a0568705d9200b001f96962b06cmr23325760oab.53.1701246093214;
        Wed, 29 Nov 2023 00:21:33 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id ei6-20020a056a0080c600b006cb95c0fff4sm17131pfb.71.2023.11.29.00.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 00:21:32 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1r8Fp4-001Qhf-0C;
	Wed, 29 Nov 2023 19:21:30 +1100
Date: Wed, 29 Nov 2023 19:21:30 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: XBF_DONE semantics
Message-ID: <ZWb0ik2CJc7lxz8E@dread.disaster.area>
References: <20231128153808.GA19360@lst.de>
 <ZWZW1bb+ih16tU+5@dread.disaster.area>
 <20231129061805.GA1987@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129061805.GA1987@lst.de>

On Wed, Nov 29, 2023 at 07:18:05AM +0100, Christoph Hellwig wrote:
> On Wed, Nov 29, 2023 at 08:08:37AM +1100, Dave Chinner wrote:
> > > But places that use buf_get and manually fill in data only use it in a
> > > few cases. 
> > 
> > Yes. the caller of buf_get always needs to set XBF_DONE if it is
> > initialising a new buffer ready for it to be written. It should be
> > done before the caller drops the buffer lock so that no other lookup
> > can see the buffer in the state of "contains valid data but does not
> > have XBF_DONE set".
> 
> That makes sense, but we do have a whole bunch of weird things going
> on as well:
> 
>  - xfs_buf_ioend_handle_error sets XBF_DONE when retrying or failing

Write path. It is expected that XBF_DONE is set prior to submitting
the write, so this should be a no-op. It's probably detritus from
the repeated factoring of the buf_ioend code over the years that
we've never looked deeply into.

>  - xfs_buf_ioend sets XBF_DONE on successful write completion as well

Same. It's really only needed on read IO, but I'm guessing that
somewhere along the line it was done for all IO and we've never
stopped doing that.

>  - xfs_buf_ioend_fail drops XBF_DONE for any I/O failure

That's actually correct.

We're about to toss the buffer because we can't write it back. The
very next function call is xfs_buf_stale(), which invalidates the
buffer and it's contents. It should not have XBF_DONE and XBF_STALE
set at the same time.

It may be worthwhile to move the clearing of XBF_DONE to be inside
xfs_buf_stale(), but I'd have to look at the rest of the code to see
if that's the right thing to do or not.

>  - xfs_do_force_shutdown sets XBF_DONE on the super block buffer on
>    a foced shutdown

No idea why that exists.  I'd have to go code spelunking to find out
what it was needed for.

>  - xfs_trans_get_buf_map sets XBF_DONE on a forced shutdown

That code just looks broken. we're in the middle of a transaction
doing a buffer read, we found a match and raced with a shutdown so
we stale the buffer, mark it donei, bump the recursion count and
return it without an error?

A quick spelunk through history indicates stale vs undelay-write vs
XFS_BUF_DONE was an inconsistent mess. We fixed all the stale vs
done nastiness in the xfs_trans_buf_read() path, but missed this
case in the get path.

As it is, I'd say the way shutdown racing is handled here is broken
and could be fixed by returning -EIO instead of the staled buffer.
The buffer is already linked into the transaction, so the
transaction cancel in response to the IO error will handle the
buffer appropriately....

> So there's definitively a bunch of weird things not fully in line
> with the straight forward answer.

No surprises there - this is a 30 year old code base. Nothing looks
particularly problematic, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
