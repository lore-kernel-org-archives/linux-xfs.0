Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA1EC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 31 May 2022 06:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244128AbiEaGD2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 May 2022 02:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244115AbiEaGD0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 May 2022 02:03:26 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 55972205E8
        for <linux-xfs@vger.kernel.org>; Mon, 30 May 2022 23:03:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D52C910E6F50;
        Tue, 31 May 2022 16:03:23 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nvuyP-000taH-RP; Tue, 31 May 2022 16:03:21 +1000
Date:   Tue, 31 May 2022 16:03:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 18/18] xfs_logprint: Add log item printing for ATTRI
 and ATTRD
Message-ID: <20220531060321.GB1098723@dread.disaster.area>
References: <20220520190031.2198236-1-allison.henderson@oracle.com>
 <20220520190031.2198236-19-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520190031.2198236-19-allison.henderson@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6295afac
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=IKSpoxSOl1IqwHQefMYA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 20, 2022 at 12:00:31PM -0700, Allison Henderson wrote:
> This patch implements a new set of log printing functions to print the
> ATTRI and ATTRD items and vectors in the log.  These will be used during
> log dump and log recover operations.
> 
> Though most attributes are strings, the attribute operations accept
> any binary payload, so we should not assume them printable.  This was
> done intentionally in preparation for parent pointers.  Until parent
> pointers get here, attributes have no discernible format.  So the print
> routines are just a simple print or hex dump for now.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Oh, this reminds me how much I dislike logprint, having multiple,
very subtly different ways to print the same information in slightly
different formats.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

But this is a bug I needed to fix...

.....
> +	if (src_f->alfi_value_len > 0) {
> +		printf(_("\n"));
> +		(*i)++;
> +		head = (xlog_op_header_t *)*ptr;
> +		xlog_print_op_header(head, *i, ptr);
> +		error = xlog_print_trans_attri_value(ptr, be32_to_cpu(head->oh_len),
> +				src_f->alfi_value_len);
> +	}

So this passes the length of the region and the length of the
value. They are not the same, the value can be split across multiple
regions as the value is split across multiple log writes. so....

> +int
> +xlog_print_trans_attri_value(
> +	char				**ptr,
> +	uint				src_len,
> +	int				value_len)
> +{
> +	int len = max(value_len, MAX_ATTR_VAL_PRINT);
> +
> +	printf(_("ATTRI:  value len:%u\n"), value_len);
> +	print_or_dump(*ptr, len);

This dumps the value length from a buffer of src_len, overruns the
end of the buffer and Bad Things Happen. (i.e. logprint segv's)

This should be:

	int len = min(value_len, src_len);

So that the dump doesn't overrun the region buffer....

I'll fix it directly in my stack, I think this is the only remaining
failure I'm seeing with my current libxfs 5.19 sync branch....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
