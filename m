Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AF78F66
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 03:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724729035; cv=none; b=AiW1NJDIxDL/ghEPyBIcFAI7y9Dr3RqzYiNUsx78blq8kcNvNcUyo4ahJ9j/rblkXI/o3Zm1lEuVD/bJ358DD46fe9DUfR86aEpy4bRU9spfKDmSxyOl4ZnC1I5pZcBhRXODq6X057DdFQle79FhAHjxi9wHCms/HKL6A8Y1g2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724729035; c=relaxed/simple;
	bh=3VQC+oYr1QkMfOP+oQVFlDWngFNujyutxTt5PaAYGUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HkuiYq4JprLbevb6QOHs4bRGZsiAMY3xVb93ECedOiuB15R35oI1Kbe9Ph1/zUq0ZiUxgUmgE1G6EltiY6lpTf9b0i6fD9oMuV8oN7W5X1YSCdtjXNtpmifDBpU6ZfM65nlVb/KpAa3ex0r39UctPUQn8EGRcuGIwyFmw1eJvuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=mJeDYw+F; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="mJeDYw+F"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7cd9e634ea9so2964399a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 20:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724729033; x=1725333833; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mwAQ1bg9N3yOeqS2uUN/ZfX4LxWfRfY5QTvMH1jInNc=;
        b=mJeDYw+FusLkES6RyaacEtAgEIQzpBXWJbzcWBpo6+j+jZuyeHmR/LDwfnffcCOuuK
         ZUTaYRORXzE3641CL7jLvEs4/yci8PRUlkdJom2EnjyoZae56Ji+glfVPCcEBytOuApE
         VWJMkvIwGH++n19+MX3WJsOqAE6aeDe9SZ6js6iHQJzR20L0cGRRVPgCig5iWim15fOu
         enZVkTntq9mWVKullZA1ERdElByFwVhURiXh0avNhc/gfcb5L46m+atmplGLu5HqN0z4
         Al2DcZj+IFdclRzd9MRl+w537ull9lxcp9bryc5ugxhfpIB4UHFWAWX2+aIuYB/q9rXH
         jJjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724729033; x=1725333833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mwAQ1bg9N3yOeqS2uUN/ZfX4LxWfRfY5QTvMH1jInNc=;
        b=WNi7+I8gzccVZYd4NivWA9ohQc+LrrzlTuq/OyhYWnEkJ+5whVUmho7AmjkWcEKzvT
         CmQPjASxnUWKWeTFCJVrw9kq2UstNc4M6v3zgzKfvR5wQ6RabvrM4PwKwDT8H8LAwkvs
         7AQlztvMXF15nb6n8QnxW7Qjzj77n2MpUkTrNum78GQFfkgJWIjXkrfJlbfoHei91hnU
         fjvyymHez7GgzTrSokLP5k0ZGoR9e2uINGarjc53Sn2kw6jPRylJleqiAakuYfESU8Sq
         nOWhSPfDWtC7bD8SDH6w4fWxEzwi/zr2/SVXe9cGjq45+Gajl9A2FekEjF1yshjS/2z5
         ECSg==
X-Forwarded-Encrypted: i=1; AJvYcCVhEAonMHy3rJwyskL8auhkT4WdH220hFH9bnJsG7ipYBO02xpf4aKDaWp8KCVKjA8WG4Pki4JH0rg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzO/mvWWN4GkXvobwyYQ+XegtLwVKltm47YQcyaoqhkOXtwOQ91
	k+3TCKVHAWl4F1ZvdormQwJnoffxqURHBbOxPdRfkO5iKvwHF0AVEHJOV6JaP2nk/2AA/F2ylJ+
	/
X-Google-Smtp-Source: AGHT+IEJTpu2u3I2oE7oxtYifHxqk0mFnKUax9mmczMyloN3WNbX4LSDtrVcwPe1PohFVy6XNL5fdQ==
X-Received: by 2002:a05:6a20:ce4c:b0:1c4:c93e:a57b with SMTP id adf61e73a8af0-1ccc08aa56emr1704471637.23.1724729033108;
        Mon, 26 Aug 2024 20:23:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855664e2sm74160705ad.30.2024.08.26.20.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 20:23:52 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1simoA-00E5oT-0M;
	Tue, 27 Aug 2024 13:23:50 +1000
Date: Tue, 27 Aug 2024 13:23:50 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: liuhuan01@kylinos.cn, linux-xfs@vger.kernel.org, cmaiolino@redhat.com
Subject: Re: [PATCH] xfs_db: make sure agblocks is valid to prevent corruption
Message-ID: <Zs1GxsICOpY/SKzn@dread.disaster.area>
References: <20240821104412.8539-1-liuhuan01@kylinos.cn>
 <20240823004912.GU6082@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823004912.GU6082@frogsfrogsfrogs>

On Thu, Aug 22, 2024 at 05:49:12PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 21, 2024 at 06:44:12PM +0800, liuhuan01@kylinos.cn wrote:
> > From: liuh <liuhuan01@kylinos.cn>
> > 
> > Recently, I was testing xfstests. When I run xfs/350 case, it always generate coredump during the process.
> > 	xfs_db -c "sb 0" -c "p agblocks" /dev/loop1
> > 
> > System will generate signal SIGFPE corrupt the process. And the stack as follow:
> > corrupt at: (*bpp)->b_pag = xfs_perag_get(btp->bt_mount, xfs_daddr_to_agno(btp->bt_mount, blkno)); in function libxfs_getbuf_flags
> > 	#0  libxfs_getbuf_flags
> > 	#1  libxfs_getbuf_flags
> > 	#2  libxfs_buf_read_map
> > 	#3  libxfs_buf_read
> > 	#4  libxfs_mount
> > 	#5  init
> > 	#6  main
> > 
> > The coredump was caused by the corrupt superblock metadata: (mp)->m_sb.sb_agblocks, it was 0.
> > In this case, user cannot run in expert mode also.
> > 
> > Never check (mp)->m_sb.sb_agblocks before use it cause this issue.
> > Make sure (mp)->m_sb.sb_agblocks > 0 before libxfs_mount to prevent corruption and leave a message.
> > 
> > Signed-off-by: liuh <liuhuan01@kylinos.cn>
> > ---
> >  db/init.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/db/init.c b/db/init.c
> > index cea25ae5..2d3295ba 100644
> > --- a/db/init.c
> > +++ b/db/init.c
> > @@ -129,6 +129,13 @@ init(
> >  		}
> >  	}
> >  
> > +	if (unlikely(sbp->sb_agblocks == 0)) {
> > +		fprintf(stderr,
> > +			_("%s: device %s agblocks unexpected\n"),
> > +			progname, x.data.name);
> > +		exit(1);
> 
> What if we set sb_agblocks to 1 and let the debugger continue?

Yeah, I'd prefer that xfs_db will operate on a corrupt filesystem and
maybe crash unexpectedly than to refuse to allow any diagnosis of
the corrupt filesystem.

xfs_db is a debug and forensic analysis tool. Having it crash
because it didn't handle some corruption entirely corectly isn't
something that we should be particularly worried about...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
