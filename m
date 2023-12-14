Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F689944C
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 22:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="cftnfI8J"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6d9e756cf32so69538a34.2
        for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 14:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1702593096; x=1703197896; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X+uKpvIFE8it5UldH4hBWXo0RxItJFS4saHsjjG96J4=;
        b=cftnfI8JQraErmsR2kd6IUVw6a1l08bnAUVvG/R4LUsmiUj2NsGlam0/43NYWROhK1
         s936HLGdvflC54aMMgT5yjRpHzc6aDwWNfqzCOXf3gSJXNNz0tL7rIoCwZjt5EvZk1Nn
         JoWcjr/P+GD1vBN7U+7JKwz5TcjDZ5dhhDWbHFx3eoCQ+asf03HHBjpwvCUloblNTgKQ
         MDnqPardzqkycR0NZ7J9C5sRNlAR6F1M0MGEc57YfKQtQ/Tj9q9GVD2iVXIo9Scv1Yea
         mB6YqyMGgshsBmB92QyCTjWZrNpoI0a2GIzdFgZWEQQHQapm8XhRjlyDaBifipNjP9pj
         +ESQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702593096; x=1703197896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X+uKpvIFE8it5UldH4hBWXo0RxItJFS4saHsjjG96J4=;
        b=EncxoCsG4Jkqto8yUulbGejtfcIjVL4NmDyKlCmg4vL8ZlntLwdbk8boSg+kil7/bp
         igXod0GtzYZoZPNAAAYOR4ZlB9C6XHE8ntE4tXh3SCvXoN2PDKzpouhIgsFd/qL5gRzn
         E2cjbOGR/N/jnsGesh/8xZz0zibQMOeJ+4HBCkbBYLFf1F40z3zlHAcfzJhkYKGOPSx3
         8fNVrx3KpwgpdJTGjf5+plMJ3LzaqqYgBWIZcNOIJUhq7l/F8uDjeL0zY49FfgCVHZ16
         EaLZNb3u6qClVSqvD3tqdZVzjtj5WdsgO209OUCenDoheCOAZsjnOq33hj4cQ20NdLB0
         VhxQ==
X-Gm-Message-State: AOJu0Yztwo5nxApA/4HzhMPXNGSBDMZ+s+77eibtnOW+CHbVmjroyi/5
	j8f9+Byvozj+lZSRpEml9lLC0A5XxGY5Xrh59Wc=
X-Google-Smtp-Source: AGHT+IFWedNRQ2JUNO1tTNkU35loGYMyo6prRMNjSiC9H1aPpikLELUNcYTF9ugjHgrgEg5YV0p0cw==
X-Received: by 2002:a05:6870:c186:b0:1fa:fec3:8c43 with SMTP id h6-20020a056870c18600b001fafec38c43mr12199574oad.53.1702593096404;
        Thu, 14 Dec 2023 14:31:36 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id z9-20020a6552c9000000b005c662e103a1sm10503587pgp.41.2023.12.14.14.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 14:31:35 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rDuEu-008NyB-33;
	Fri, 15 Dec 2023 09:31:32 +1100
Date: Fri, 15 Dec 2023 09:31:32 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: initialise di_crc in xfs_log_dinode
Message-ID: <ZXuCRNtth6VY6svP@dread.disaster.area>
References: <20231214214035.3795665-1-david@fromorbit.com>
 <20231214214718.GL361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214214718.GL361584@frogsfrogsfrogs>

On Thu, Dec 14, 2023 at 01:47:18PM -0800, Darrick J. Wong wrote:
> On Fri, Dec 15, 2023 at 08:40:35AM +1100, Dave Chinner wrote:
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index 157ae90d3d52..0287918c03dc 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -557,6 +557,9 @@ xfs_inode_to_log_dinode(
> >  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> >  		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
> >  		to->di_v3_pad = 0;
> > +
> > +		/* dummy value for initialisation */
> > +		to->di_crc = 0;
> 
> I wonder if the log should be using kzalloc instead of kmalloc for
> buffers that will end up on disk?  Kind of a nasty performance hit
> just for the sake of paranoia, though.

That's really only an issue for the xfs_log_dinode - it's really the
only structure copy we do in log formating. For the rest of the
structures we are simply doing memcpy of large ranges of data into
the allocated space and there's really no point in zeroing memory
ranges that we are just about to entirely copy over.

Especially considering item formatting is the hottest part of the
transaction commit path....

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
