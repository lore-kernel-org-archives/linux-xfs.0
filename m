Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D403EC2D0A3
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 15:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D88222370
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 15:18:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QfYTMA5x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgKCPSb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 10:18:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26106 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728302AbgKCPSY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 10:18:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604416700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mPeaCNfbSuE1FmaXcYs1WRy3f6GiGe/BIjpgXxBqqXM=;
        b=QfYTMA5xoyCqyI6jvJBXzXuE+eUj4u3BoSoNNVoNsVgg2TENODYJqtFZyQ9nlI+V6NhZN+
        eC827HjzglfgLnvWu6LyxXMMW/Ha7QcOUKgo/7/AJgW0AnZmNoqUPaxCPgnHf6ZEKKvisr
        hNvfLenxflbkyWnrAF4UYgcQuyUxVIc=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-FZqCzFciNGSmBiU4Ca17Ag-1; Tue, 03 Nov 2020 10:18:18 -0500
X-MC-Unique: FZqCzFciNGSmBiU4Ca17Ag-1
Received: by mail-pl1-f197.google.com with SMTP id y9so10794386pll.18
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2020 07:18:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mPeaCNfbSuE1FmaXcYs1WRy3f6GiGe/BIjpgXxBqqXM=;
        b=ZXudEe9CG/XdefpcKFkAuemMLzJWArDDnajzcemVwyVRReGVUKTgle2I/dTV765qlr
         xYwSVjLz5QUwrXaM/6PlAUiYvSy5ICLCFzOhJ3FvWroPLhCpVV7x/3mdOKvgaIkdQ2i4
         VfFXW6lJc9gUCrWUA+JMxV1MboCH8uecPHiMiBmUJeswjRA87Cr0CRUyQwR19wxv+Lly
         K2b6QoB8Czk+Tl9yYBi4xb+o8LwMLWJ54VqJBs5jMzf/BW97GSgODeChygYYbv7XB5K5
         6q0Yq7tWvNNgNMC0QVh3TsqpSLUjF+KB4NRt7K1ZnvCzC8K7cmZppXjwUP0n3XQ6PtjQ
         1aWg==
X-Gm-Message-State: AOAM532JORmICLJBa0IoIWoRTdEu3ib94Dq5dWLXAAn+pJsMbNmb1r0s
        BhlFlkqZn5/HHNRgwvMow5llJLyANOzP8NCbL1y+09VkE4rWVAmJEl3JJ/kcwLc3/gbAHKZaem+
        d4paUN9GIaii1LzoCAdoX
X-Received: by 2002:a17:90a:4b45:: with SMTP id o5mr207811pjl.223.1604416697611;
        Tue, 03 Nov 2020 07:18:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyh6BnN1p7LQI1xKnrRKo7Li1brr7srYmOg2xTnOV/t9zG1Bh+NNt+yjA6LTU4GphJ6byn8bA==
X-Received: by 2002:a17:90a:4b45:: with SMTP id o5mr207794pjl.223.1604416697357;
        Tue, 03 Nov 2020 07:18:17 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f5sm15961527pgi.86.2020.11.03.07.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 07:18:16 -0800 (PST)
Date:   Tue, 3 Nov 2020 23:18:06 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2 2/2] xfsdump: intercept bind mount targets
Message-ID: <20201103151806.GA886627@xiangao.remote.csb>
References: <20201103023315.786103-1-hsiangkao@redhat.com>
 <20201103023315.786103-2-hsiangkao@redhat.com>
 <5ac048c3-7db6-4487-78ae-86ee9851c5c8@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ac048c3-7db6-4487-78ae-86ee9851c5c8@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Hi Eric,

On Tue, Nov 03, 2020 at 09:03:48AM -0600, Eric Sandeen wrote:
> On 11/2/20 8:33 PM, Gao Xiang wrote:

...

> > +
> > +		nread = getdents_wrap(fd, (char *)gdp, gdsz);
> > +		/*
> > +		 * negative count indicates something very bad happened;
> > +		 * try to gracefully end this dir.
> > +		 */
> > +		if (nread < 0) {
> > +			mlog(MLOG_NORMAL | MLOG_WARNING,
> > +_("unable to read dirents for directory ino %llu: %s\n"),
> > +			      ino, strerror(errno));
> > +			/* !!! curtis looked at this, and pointed out that
> 
> Nobody knows who curtis is, I think we can drop this comment now ;)
> If we can't read the directory I think it's fine to simply error out here.

This was copied from dump_dir(), ok, I will error out this.

> 
> > +			 * we could take some recovery action here. if the
> > +			 * errno is appropriate, lseek64 to the value of
> > +			 * doff field of the last dirent successfully
> > +			 * obtained, and contiue the loop.
> > +			 */
> > +			nread = 0; /* pretend we are done */
> > +		}
> > +
> > +		/* no more directory entries: break; */
> > +		if (!nread)
> > +			break;
> > +
> > +		for (p = gdp; nread > 0;
> > +		     nread -= (int)p->d_reclen,
> > +		     assert(nread >= 0),
> > +		     p = (struct dirent *)((char *)p + p->d_reclen)) {
> > +			if (!strcmp(p->d_name, "..") && p->d_ino == ino) {
> > +				mlog(MLOG_DEBUG, "FOUND: name %s d_ino %llu\n",
> > +				     p->d_name, ino);
> > +				free(gdp);
> > +				return BOOL_TRUE;
> > +			}
> 
> I think we can stop as soon as we have found ".." yes?  No need to continue
> iterating the directory, either ".." is what we wanted, or it's not, but either
> way we are done when we have checked it.  On the off chance that we have
> a very large root dir, stopping early might be good.

Yes, that is correct.

> 
> > +		}
> > +	}
> > +	free(gdp);
> > +	return BOOL_FALSE;
> > +}
> > +
> >  bool_t
> >  content_init(int argc,
> >  	      char *argv[],
> > @@ -1393,6 +1448,13 @@ baseuuidbypass:
> >  			      mntpnt);
> >  			return BOOL_FALSE;
> >  		}
> > +
> > +		if (!check_rootdir(sc_fsfd, rootstat.st_ino)) {
> > +			mlog(MLOG_ERROR,
> > +"oops, seems to be a bind mount, please use the actual mountpoint instead\n");
> 
> Could there be any other reason for this failure?  Maybe something like:
> 
> 			mlog(MLOG_ERROR,
> _("%s is not the root of the filesystem (bind mount?) - use primary mountpoint\n"),
> 				mntpnt);
> 
> or similar?
> 
> in any case I think it needs the i18n _("...") treatment.

Ok, will quickly send the fixed version about this!


Thanks for your review!


Thanks,
Gao Xiang

> 
> Thanks!
> 
> -Eric
> 
> > +			return BOOL_FALSE;
> > +		}
> > +
> >  		sc_rootxfsstatp =
> >  			(struct xfs_bstat *)calloc(1, sizeof(struct xfs_bstat));
> >  		assert(sc_rootxfsstatp);
> > 
> 

