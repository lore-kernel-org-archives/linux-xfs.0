Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D46A1C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 791B564F61
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhBCTER (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 14:04:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229606AbhBCTD6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 14:03:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612378951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LUzMrogS8qrYw5hSFFhBwgN0UFlVYvV5ccW9FCdYmPs=;
        b=HQZ2/Tpdw2AD2/HnzGRvfxou2MFXbotMOavQjmO38yQe6WfWqSmZw8ZJ9YCommBAx+cUk8
        FsIZibU+JURU36OPwIKTw2wZ16WzNYi6ePbXUeK6VJK8V0TMEm+jYLcmBeINq3SKveIjnA
        kDxGNayt9ARAdpUi13XJjLCRgUeze0U=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-F7SE42pEMGW5PwCV6QTXVw-1; Wed, 03 Feb 2021 14:02:30 -0500
X-MC-Unique: F7SE42pEMGW5PwCV6QTXVw-1
Received: by mail-pf1-f198.google.com with SMTP id z10so462100pfa.1
        for <linux-xfs@vger.kernel.org>; Wed, 03 Feb 2021 11:02:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LUzMrogS8qrYw5hSFFhBwgN0UFlVYvV5ccW9FCdYmPs=;
        b=e1bYZz2VXzMzbKDw0VZ/W6rXOG4OsOOa1CGT4hWr6ZnZ9aK5to/EAxDXhZIfFXImV5
         7J1fECtbz5GXdrokg9ZotCMmP5THGhIDpyyQM9/9i3r2IT2o6Gtxxe7TGBnZDzqI7wQ4
         u9lPCox+zJ2x8SILTiSC/IMr7CxBJPS0P7xnv/gnGMdAOhjDQuYWr3t624x7aMmM6Y6F
         Os6lJ/i2x25Yd4l2PKUuGTDbNOp7G3pUl3d00ktXpSZRXQeoMhPpmCM6i8ipU+cIX4rj
         EyWe6jMHSaNlD1kpAWLTUiIc/E2uryrZwA9hfQ/WAOOK2uwCMCOzoRvK0JnmFfuVvxzU
         aKdQ==
X-Gm-Message-State: AOAM531yXFlvCbW6N2+Lv7AhWsKqhJafjE/IQfWcZDwASpG//xPJmhpb
        fCbJv53WBk1uZRS+JF5jOtI8riQ6MQQ7OBKHhndB1BvRlwxgPTKisbHdCCOpm/kBkMkSJRk/1PY
        OHhwTQK9jyMaAlDeJEVf8
X-Received: by 2002:a17:90a:9503:: with SMTP id t3mr4325418pjo.189.1612378948926;
        Wed, 03 Feb 2021 11:02:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzbl2gFk43CCqm/OFC6ErAJ+iyQQZlbwuK4mfuN2bmlni3qDnvr6FDpl1N3sjNzAizDeDcAww==
X-Received: by 2002:a17:90a:9503:: with SMTP id t3mr4325396pjo.189.1612378948690;
        Wed, 03 Feb 2021 11:02:28 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bv21sm2795671pjb.15.2021.02.03.11.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 11:02:28 -0800 (PST)
Date:   Thu, 4 Feb 2021 03:02:17 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 6/7] xfs: support shrinking unused space in the last AG
Message-ID: <20210203190217.GA20513@xiangao.remote.csb>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
 <20210126125621.3846735-7-hsiangkao@redhat.com>
 <20210203142337.GB3647012@bfoster>
 <20210203145146.GA935062@xiangao.remote.csb>
 <20210203181211.GZ7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210203181211.GZ7193@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Wed, Feb 03, 2021 at 10:12:11AM -0800, Darrick J. Wong wrote:
> On Wed, Feb 03, 2021 at 10:51:46PM +0800, Gao Xiang wrote:

...

> > > 
> > > > +		}
> > > > +
> > > >  		if (error)
> > > >  			goto out_trans_cancel;
> > > >  	}
> > > > @@ -137,15 +157,15 @@ xfs_growfs_data_private(
> > > >  	 */
> > > >  	if (nagcount > oagcount)
> > > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> > > > -	if (nb > mp->m_sb.sb_dblocks)
> > > > +	if (nb != mp->m_sb.sb_dblocks)
> > > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
> > > >  				 nb - mp->m_sb.sb_dblocks);
> > > 
> > > Maybe use delta here?
> > 
> > The reason is the same as above, `delta' here was changed due to 
> > xfs_resizefs_init_new_ags(), which is not nb - mp->m_sb.sb_dblocks
> > anymore. so `extend` boolean is used (rather than just use delta > 0)
> 
> Long question:
> 
> The reason why we use (nb - dblocks) is because growfs is an all or
> nothing operation -- either we succeed in writing new empty AGs and
> inflating the (former) last AG of the fs, or we don't do anything at
> all.  We don't allow partial growing; if we did, then delta would be
> relevant here.  I think we get away with not needing to run transactions
> for each AG because those new AGs are inaccessible until we commit the
> new agcount/dblocks, right?
> 
> In your design for the fs shrinker, do you anticipate being able to
> eliminate all the eligible AGs in a single transaction?  Or do you
> envision only tackling one AG at a time?  And can we be partially
> successful with a shrink?  e.g. we succeed at eliminating the last AG,
> but then the one before that isn't empty and so we bail out, but by that
> point we did actually make the fs a little bit smaller.

Thanks for your question. I'm about to sleep, I might try to answer
your question here.

As for my current experiement / understanding, I think eliminating all
the empty AGs + shrinking the tail AG in a single transaction is possible,
that is what I'm done for now;
 1) check the rest AGs are empty (from the nagcount AG to the oagcount - 1
    AG) and mark them all inactive (AGs freezed);
 2) consume an extent from the (nagcount - 1) AG;
 3) decrease the number of agcount from oagcount to nagcount.

Both 2) and 3) can be done in the same transaction, and after 1) the state
of such empty AGs is fixed as well. So on-disk fs and runtime states are
all in atomic.

> 
> There's this comment at the bottom of xfs_growfs_data() that says that
> we can return error codes if the secondary sb update fails, even if the
> new size is already live.  This convinces me that it's always been the
> case that callers of the growfs ioctl are supposed to re-query the fs
> geometry afterwards to find out if the fs size changed, even if the
> ioctl itself returns an error... which implies that partial grow/shrink
> are a possibility.
> 

I didn't realize that possibility but if my understanding is correct
the above process is described as above so no need to use incremental
shrinking by its design. But it also support incremental shrinking if
users try to use the ioctl for multiple times.

If I'm wrong, kindly point out, many thanks in advance!

Thanks,
Gao Xiang

