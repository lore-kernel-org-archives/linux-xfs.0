Return-Path: <SRS0=C5JC=AS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2311C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jul 2020 14:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB9402073E
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jul 2020 14:39:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YwbkkwPA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgGGOj0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jul 2020 10:39:26 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57091 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728247AbgGGOj0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jul 2020 10:39:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594132763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qx4Vv/c1Ni8G26JoRd547qPM+Eg6Wzx54sTBnI579X4=;
        b=YwbkkwPASnugEBG0KYunLc6lRSOFWjnoffXs/yPL6jjHlMLhQKUUJGSYG0XF9UzpRXMGAt
        L5gIVMTtiGNpxTP68HB2mOMyKwbJWRor6r9K/gE2SQ2vOjkdeCn12cpkFVuvnIcc2u2h/w
        oRXzU6baOjF+uAnxI9ufa17DAW7XNYE=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-uKyQO_YeMDSp4OXQZ14lvQ-1; Tue, 07 Jul 2020 10:39:20 -0400
X-MC-Unique: uKyQO_YeMDSp4OXQZ14lvQ-1
Received: by mail-pl1-f200.google.com with SMTP id a8so7376552plm.7
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jul 2020 07:39:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Qx4Vv/c1Ni8G26JoRd547qPM+Eg6Wzx54sTBnI579X4=;
        b=bx8OUVEbL24ss535ayA0O33yYLiyngaDod1nC5sMhzBjOwUGuLB4px9Oa7mj3lFDbO
         kMZ3jefmzoFLQbeJkFLUPm51+anG3Y/cKBa63hZ2s5oHarZkulL0sXqP97q3bEd6klhP
         F18OvrKN14/fH573UX0+JID4cWNr7eRznXbLkKgSMoc5YV680Nj+xP5WfDL34HaDjAi9
         f8BqMPKAL8reImE3wge/onpmz/nkUbXQ8K9hRNZXh8sK2H8CsK9BJHNI1ywFVPErTgyb
         Yuc/F69dWworthfrP9KJxxqTG0VfimO9KppMq5LYRsozDey9cZOOYRJAdFLct9BqYIWO
         Loug==
X-Gm-Message-State: AOAM531YQvdgZ7ioSjn7ohLSqOtqNZ51qee2vFZ6mroNcjiODSSGkTlm
        hseL/oWoJkluifz9yDzX+5pZqzvZGv3iuhSHykCjTZcF5yFu7yx/jIaBJNh3SL7PlfSSDNON+ke
        asKvoFbh7wpbQXWqpGWhx
X-Received: by 2002:a62:cfc2:: with SMTP id b185mr14611868pfg.125.1594132758801;
        Tue, 07 Jul 2020 07:39:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyn1Hgo3Csrp1FR6PR9bs3iFjRd9/luxkRCDyv2mu5PuZa06ANpsjax73Aa1YCB1rpTbQpR2A==
X-Received: by 2002:a62:cfc2:: with SMTP id b185mr14611839pfg.125.1594132758478;
        Tue, 07 Jul 2020 07:39:18 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b21sm13195246pfb.45.2020.07.07.07.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 07:39:17 -0700 (PDT)
Date:   Tue, 7 Jul 2020 22:39:08 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: track unlinked inodes in core inode
Message-ID: <20200707143908.GA1934@xiangao.remote.csb>
References: <20200623095015.1934171-1-david@fromorbit.com>
 <20200623095015.1934171-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623095015.1934171-4-david@fromorbit.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

During working on this stuff, I found some another noticiable places
to mention. Hope it of some help...

On Tue, Jun 23, 2020 at 07:50:14PM +1000, Dave Chinner wrote:

...

>  /*
> - * This is called when the inode's link count has gone to 0 or we are creating
> - * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
> - *
> - * We place the on-disk inode on a list in the AGI.  It will be pulled from this
> - * list when the inode is freed.
> + * Always insert at the head, so we only have to do a next inode lookup to
> + * update it's prev pointer. The AGI bucket will point at the one we are
> + * inserting.
>   */
> -STATIC int
> -xfs_iunlink(
> +static int
> +xfs_iunlink_insert_inode(
>  	struct xfs_trans	*tp,
> +	struct xfs_buf		*agibp,
>  	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	struct xfs_agi		*agi;
> -	struct xfs_buf		*agibp;
> -	xfs_agino_t		next_agino;
> -	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> +	struct xfs_agi		*agi = agibp->b_addr;
> +	xfs_agino_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);

unnecessary modification here... (use xfs_agnumber_t instead)

> -/* Return the imap, dinode pointer, and buffer for an inode. */
> -STATIC int
> -xfs_iunlink_map_ino(
> +/*
> + * Remove can be from anywhere in the list, so we have to do two adjacent inode
> + * lookups here so we can update list pointers. We may be at the head or the
> + * tail of the list, so we have to handle those cases as well.
> + */
> +static int
> +xfs_iunlink_remove_inode(
>  	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno,
> -	xfs_agino_t		agino,
> -	struct xfs_imap		*imap,
> -	struct xfs_dinode	**dipp,
> -	struct xfs_buf		**bpp)
> +	struct xfs_buf		*agibp,
> +	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_agi		*agi = agibp->b_addr;
> +	xfs_agino_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);

same here

>  /*
> @@ -2762,56 +2735,107 @@ xlog_recover_process_one_iunlink(
>   * scheduled on this CPU to ensure other scheduled work can run without undue
>   * latency.
>   */
> -STATIC void
> -xlog_recover_process_iunlinks(
> -	struct xlog	*log)
> +static int
> +xlog_recover_iunlink_ag(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno)
>  {
> -	xfs_mount_t	*mp;
> -	xfs_agnumber_t	agno;
> -	xfs_agi_t	*agi;
> -	xfs_buf_t	*agibp;
> -	xfs_agino_t	agino;
> -	int		bucket;
> -	int		error;
> +	struct xfs_agi		*agi;
> +	struct xfs_buf		*agibp;
> +	int			bucket;
> +	int			error;
>  
> -	mp = log->l_mp;
> +	/*
> +	 * Find the agi for this ag.
> +	 */
> +	error = xfs_read_agi(mp, NULL, agno, &agibp);
> +	if (error) {
>  
> -	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
>  		/*
> -		 * Find the agi for this ag.
> +		 * AGI is b0rked. Don't process it.
> +		 *
> +		 * We should probably mark the filesystem as corrupt after we've
> +		 * recovered all the ag's we can....
>  		 */
> -		error = xfs_read_agi(mp, NULL, agno, &agibp);
> +		return 0;
> +	}
> +
> +	/*
> +	 * Unlock the buffer so that it can be acquired in the normal course of
> +	 * the transaction to truncate and free each inode.  Because we are not
> +	 * racing with anyone else here for the AGI buffer, we don't even need
> +	 * to hold it locked to read the initial unlinked bucket entries out of
> +	 * the buffer. We keep buffer reference though, so that it stays pinned
> +	 * in memory while we need the buffer.
> +	 */
> +	agi = agibp->b_addr;
> +	xfs_buf_unlock(agibp);
> +
> +	/*
> +	 * The unlinked inode list is maintained on incore inodes as a double
> +	 * linked list. We don't have any of that state in memory, so we have to
> +	 * create it as we go. This is simple as we are only removing from the
> +	 * head of the list and that means we only need to pull the current
> +	 * inode in and the next inode.  Inodes are unlinked when their
> +	 * reference count goes to zero, so we can overlap the xfs_iget() and
> +	 * xfs_irele() calls so we always have the first two inodes on the list
> +	 * in memory. Hence we can fake up the necessary in memory state for the
> +	 * unlink to "just work".
> +	 */
> +	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
> +		struct xfs_inode	*ip, *prev_ip = NULL;
> +		xfs_agino_t		agino, prev_agino = NULLAGINO;
> +
> +		agino = be32_to_cpu(agi->agi_unlinked[bucket]);
> +		while (agino != NULLAGINO) {
> +			ip = xlog_recover_get_one_iunlink(mp, agno, agino,
> +							  bucket);
> +			if (!ip) {
> +				/*
> +				 * something busted, but still got to release
> +				 * prev_ip, so make it look like it's at the end
> +				 * of the list before it gets released.
> +				 */
> +				error = -EFSCORRUPTED;
> +				if (prev_ip)
> +					prev_ip->i_next_unlinked = NULLAGINO;
> +				break;
> +			}
> +			if (prev_ip) {
> +				ip->i_prev_unlinked = prev_agino;
> +				xfs_irele(prev_ip);
> +			}

(little confused about this, why not xfs_irele the current ip and move it after
agino = ip->i_next_unlinked; ....)


And some comments about "[PATCH 4/4] xfs: introduce inode unlink log item.
(no need to raise another thread about this since I'm not fully reviewing that..)

> @@ -2185,6 +2136,7 @@ xfs_iunlink(
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	int			error;
>  
> +	ASSERT(ip->i_next_unlinked == NULLAGINO);
>  	ASSERT(VFS_I(ip)->i_nlink == 0);
>  	ASSERT(VFS_I(ip)->i_mode != 0);
>  	trace_xfs_iunlink(ip);

this ASSERT is not necessary since some unreasonable numbers could be loaded
from disk for crafted images... (seems only for debugging use...)

Thanks,
Gao Xiang

