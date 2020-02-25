Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 163B2C35DF9
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 09:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB4AC21556
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 09:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgBYJbq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 04:31:46 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45439 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728965AbgBYJbq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 04:31:46 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 77BFE3A2C0D;
        Tue, 25 Feb 2020 20:31:44 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j6WZ5-00085R-NB; Tue, 25 Feb 2020 20:31:43 +1100
Date:   Tue, 25 Feb 2020 20:31:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 17/19] xfs: Add helper function
 xfs_attr_leaf_mark_incomplete
Message-ID: <20200225093143.GL10776@dread.disaster.area>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-18-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223020611.1802-18-allison.henderson@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=4u0NCo0VbqFD-kTH6QgA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 22, 2020 at 07:06:09PM -0700, Allison Collins wrote:
> This patch helps to simplify xfs_attr_node_removename by modularizing the code
> around the transactions into helper functions.  This will make the function easier
> to follow when we introduce delayed attributes.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>

Another candidate for being at the start of this patchset.

> ---
>  fs/xfs/libxfs/xfs_attr.c | 45 +++++++++++++++++++++++++++++++--------------
>  1 file changed, 31 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index dd935ff..b9728d1 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1416,6 +1416,36 @@ xfs_attr_node_shrink(
>  }
>  
>  /*
> + * Mark an attribute entry INCOMPLETE and save pointers to the relevant buffers
> + * for later deletion of the entry.
> + */
> +STATIC int
> +xfs_attr_leaf_mark_incomplete(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	*state)
> +{
> +	int error;
> +
> +	/*
> +	 * Fill in disk block numbers in the state structure
> +	 * so that we can get the buffers back after we commit
> +	 * several transactions in the following calls.
> +	 */

Reformat to use all 80 columns.

[ Handy vim hints, add this to your .vimrc:

" set the textwidth to 80 characters for C code
 au BufNewFile,BufRead *.c,*.h set tw=80

" set the textwidth to 68 characters for guilt commit messages
 au BufNewFile,BufRead guilt.msg.*,.gitsendemail.*,git.*,*/.git/* set tw=68

" Formatting the current paragraph according to
" the current 'textwidth' with ^J (control-j):
  imap <C-J> <c-o>gqap
   map <C-J> gqap

" highlight textwidth
set cc=+1

]

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
