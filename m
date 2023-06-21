Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26CCEB64D7
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Jun 2023 02:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjFUCFh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 22:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjFUCFh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2023 22:05:37 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEA31989
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 19:05:36 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b4fef08cfdso27772135ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 19:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687313135; x=1689905135;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TgoIk25za5BwceVB2X11QLIMvCwIie0NeehHJJR3jGc=;
        b=KjHS9GMRLslIaZEnmD+ZYQdwtQyP5NrcnSyyCxe1BfE2Yfqes1CMJd9O/Xsryfk6Ky
         U28tJvhH9xHga7Mv2cTYz8pKXeLYAMrQL7UHFto9vVbCrsNqHSMG1MAZH+uqYLbY5RwO
         Z67flX1oqmwHXHmFp5ne9M/GiJ7e0fOirknNRK4w7CFZQkWSyV+x7U62HXs8qAw+Y57y
         /4pqsuYETMdmdj6oZXJK3U11/x8gGoSewEDMLgcDyFd49NHDH3WV7Tw0Qb73KrLy4gGe
         4nGNCk5YAfFuUll5oQWsgChcbkiA5xBFcw40HOS2yNSpKLsUB87olzUjVm+Byljw779r
         Vn7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687313135; x=1689905135;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TgoIk25za5BwceVB2X11QLIMvCwIie0NeehHJJR3jGc=;
        b=Q9dO9eGsM8bJu0YEDcXarBGOQ1fqjLFRDvjGBG6Ngdlf8G0jRiG+u2k02BAR1le0Wh
         RJ+qw1kAoiIS9rDreJNpBX3A76mD/2gJpjgsSj0DThhlWxt+ck3YP8yS4sFGhwPMw6IZ
         NOxqfF7JF7IvsAxN7RR4O9b+AItBNTrlkCO6zyjHOgtAQ4euScNq4/ixWxGb4FEBPwWe
         4CjWTvIUrr1MP8sDpTiqTKDaswdxTrGX7ybiQyZcTqmQaXYG1SbX7LEZfFqsI9FGhjWo
         io9M2P4uEhYftCNncOlbi/QN0SEhcq1JGQ47rfsOwbS/J48X31Zzj2aM+UFTr2y0P6Ml
         agyw==
X-Gm-Message-State: AC+VfDz/AzjD1hcU1pq8WvSv3w+xTVwFyX0NNXAZxo9un044padMj8Ku
        INIGrHZtdA6GasSLjZY8GuuVLA==
X-Google-Smtp-Source: ACHHUZ64ho5wxy6ozpFHuXTcyLapzKDRmi+RcyN7N6kunVwX06AjcWLESr9nSt1roaPWa1zTNfO7+w==
X-Received: by 2002:a17:903:280e:b0:1b0:48e9:cddd with SMTP id kp14-20020a170903280e00b001b048e9cdddmr7683822plb.69.1687313135614;
        Tue, 20 Jun 2023 19:05:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id je13-20020a170903264d00b001ae4d4d2676sm2184855plb.269.2023.06.20.19.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 19:05:34 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qBnDw-00EH9m-0R;
        Wed, 21 Jun 2023 12:05:32 +1000
Date:   Wed, 21 Jun 2023 12:05:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: force all buffers to be written during btree
 bulk load
Message-ID: <ZJJa7Cnni0mb/9sN@dread.disaster.area>
References: <168506056054.3728458.14583795170430652277.stgit@frogsfrogsfrogs>
 <168506056076.3728458.7329874829310609452.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506056076.3728458.7329874829310609452.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 05:45:35PM -0700, Darrick J. Wong wrote:
> @@ -2112,6 +2112,37 @@ xfs_buf_delwri_queue(
>  	return true;
>  }
>  
> +/*
> + * Queue a buffer to this delwri list as part of a data integrity operation.
> + * If the buffer is on any other delwri list, we'll wait for that to clear
> + * so that the caller can submit the buffer for IO and wait for the result.
> + * Callers must ensure the buffer is not already on the list.
> + */
> +void
> +xfs_buf_delwri_queue_here(

This is more of an "exclusive" queuing semantic. i.e. queue this
buffer exclusively on the list provided, rather than just ensuring
it is queued on some delwri list....

> +	struct xfs_buf		*bp,
> +	struct list_head	*buffer_list)
> +{
> +	/*
> +	 * We need this buffer to end up on the /caller's/ delwri list, not any
> +	 * old list.  This can happen if the buffer is marked stale (which
> +	 * clears DELWRI_Q) after the AIL queues the buffer to its list but
> +	 * before the AIL has a chance to submit the list.
> +	 */
> +	while (!list_empty(&bp->b_list)) {
> +		xfs_buf_unlock(bp);
> +		delay(1);
> +		xfs_buf_lock(bp);
> +	}

Not a big fan of this as it the buffer can be on the AIL buffer list
for some time (e.g. AIL might have a hundred thousand buffers to
push).

This seems more like a case for:

	while (!list_empty(&bp->b_list)) {
		xfs_buf_unlock(bp);
		wait_event_var(bp->b_flags, !(bp->b_flags & _XBF_DELWRI_Q));
		xfs_buf_lock(bp);
	}

And a wrapper:

void xfs_buf_remove_delwri(
	struct xfs_buf	*bp)
{
	list_del(&bp->b_list);
	bp->b_flags &= ~_XBF_DELWRI_Q;
	wake_up_var(bp->b_flags);
}

And we replace all the places where the buffer is taken off the
delwri list with calls to xfs_buf_remove_delwri()...

This will greatly reduce the number of context switches during a
wait cycle, and reduce the latency of waiting for buffers that are
queued for delwri...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
