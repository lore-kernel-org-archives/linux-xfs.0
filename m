Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34374 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731663AbeGSRXq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 13:23:46 -0400
Date: Thu, 19 Jul 2018 09:39:47 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: refactor unmount record write
Message-ID: <20180719163947.GB10151@infradead.org>
References: <153195715716.16758.18150859087945516040.stgit@magnolia>
 <153195716953.16758.3719225666646928225.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153195716953.16758.3719225666646928225.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Looks generally fine, but some tiny nitpicks:

> +	/* the data section must be 32 bit size aligned */
> +	struct {
> +		uint16_t magic;
> +		uint16_t pad1;
> +		uint32_t pad2; /* may as well make it 64 bits */
> +	} magic = {
> +		.magic = XLOG_UNMOUNT_TYPE,
> +	};

Can we please give this structure type a name and move it to
xfs_log_format.h?  They way this had been done always irked me.

> +	/*
> +	 * At this point, we're umounting anyway,
> +	 * so there's no point in transitioning log state
> +	 * to IOERROR. Just continue...
> +	 */

Use up all 80 lines, please.

> +	if (!(iclog->ic_state == XLOG_STATE_ACTIVE ||
> +	      iclog->ic_state == XLOG_STATE_DIRTY) &&
> +	    !XLOG_FORCED_SHUTDOWN(log))
> +		xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> +	else
> +		spin_unlock(&log->l_icloglock);

	switch (iclog->ic_state) {
	default:
		if (!XLOG_FORCED_SHUTDOWN(log)) {
			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
			break;
		}
		/*FALLHRU*/
	case XLOG_STATE_ACTIVE:
	case XLOG_STATE_DIRTY:
		spin_unlock(&log->l_icloglock);
		break;

