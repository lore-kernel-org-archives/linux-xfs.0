Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51167 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753120AbdCHPvb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2017 10:51:31 -0500
Date: Wed, 8 Mar 2017 07:50:59 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] fs, xfs: convert xlog_ticket.t_ref from atomic_t to
 refcount_t
Message-ID: <20170308155059.GA4353@infradead.org>
References: <1488963219-11709-1-git-send-email-elena.reshetova@intel.com>
 <1488963219-11709-4-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488963219-11709-4-git-send-email-elena.reshetova@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: darrick.wong@oracle.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

> -	ASSERT(atomic_read(&ticket->t_ref) > 0);
> -	atomic_inc(&ticket->t_ref);
> +	ASSERT(refcount_read(&ticket->t_ref) > 0);
> +	refcount_inc(&ticket->t_ref);

With strict refcount semantics refcount_inc should check that
the count is larger than 0, otherwise we'd need to use 
recount_inc_not_zero or whatever you're going to call it.

Is that something the recount code does / could do?

