Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA3FC433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 17:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9E0164E17
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 17:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbhA1Rgh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 12:36:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233143AbhA1Rfz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 12:35:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10D3964E15;
        Thu, 28 Jan 2021 17:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611855314;
        bh=Ffo40kLUBFO2EI9p5k0Dle55VGS4RD6jppWNB/dsqOo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f38P0PJ0ask2rKU0nYVv56Z6AcRLTdCiffLE2bWipC3kogtuGJ+oOkTdEm2QToa36
         blusi2LdaWr/4F28RFKToMGY+RGzIkYbv51JmeEyVOVEJ/Cu8Gu4OtuhtxOG9Z97Rn
         v4ogujvzOA/skW9AC2wiCynEcCbyyXKMmmm8UfVOGrSx5Lrws8c4n7Y2VnVnpnoabD
         y6g6scwJLnf/kzPxJdzZ174Z2JuciWf8pGFGabI8msV2VfCeLqOnhCXW89BfQ8cADn
         q3aNlcr/vRB0VLunSx9oKNq4Zmu1HQGx1Qd7BYc9mju1mw723FOJ2lsk0zm0f0BTeC
         35Knv7W1e3ZVg==
Date:   Thu, 28 Jan 2021 09:35:13 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_logprint: print misc buffers when using -o
Message-ID: <20210128173513.GQ7698@magnolia>
References: <20210128073708.25572-1-ddouwsma@redhat.com>
 <20210128073708.25572-2-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128073708.25572-2-ddouwsma@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 06:37:07PM +1100, Donald Douwsma wrote:
> Logprint only dumps raw buffers for unhandled misc buffer types, but
> this information is generally useful when debugging logprint issues so
> allow it to print whenever -o is used.
> 
> Switch to using the common xlog_print_data function to dump the buffer.
> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> ---
>  logprint/log_misc.c      | 19 +++----------------
>  logprint/log_print_all.c |  2 +-
>  2 files changed, 4 insertions(+), 17 deletions(-)
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index c325f046..d44e9ff7 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -392,23 +392,10 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
>  		}
>  	} else {
>  		printf(_("BUF DATA\n"));
> -		if (print_data) {
> -			uint *dp  = (uint *)*ptr;
> -			int  nums = be32_to_cpu(head->oh_len) >> 2;
> -			int  byte = 0;
> -
> -			while (byte < nums) {
> -				if ((byte % 8) == 0)
> -					printf("%2x ", byte);
> -				printf("%8x ", *dp);
> -				dp++;
> -				byte++;
> -				if ((byte % 8) == 0)
> -					printf("\n");
> -			}
> -			printf("\n");
> -		}

Nitpicking: One patch to collapse this into a xlog_recover_print_data
call as a no-functional-changes cleanup, then a second patch to make the
buffer dumps happen any time -D or -o are specified.

TBH the sb/agheader decoders probably need some serious updating to
handle newer fields.  It's also unfortunate that xfs_db doesn't know how
to decode log buffers; adding such a thing would be a neat way to enable
targetted fuzzing of log recovery.

--D

>  	}
> +
> +	xlog_recover_print_data(*ptr, be32_to_cpu(head->oh_len));
> +
>  	*ptr += be32_to_cpu(head->oh_len);
>      }
>      if (head && head->oh_flags & XLOG_CONTINUE_TRANS)
> diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
> index eafffe28..2b9e810d 100644
> --- a/logprint/log_print_all.c
> +++ b/logprint/log_print_all.c
> @@ -176,8 +176,8 @@ xlog_recover_print_buffer(
>  		} else {
>  			printf(_("	BUF DATA\n"));
>  			if (!print_buffer) continue;
> -			xlog_recover_print_data(p, len);
>  		}
> +		xlog_recover_print_data(p, len);
>  	}
>  }
>  
> -- 
> 2.27.0
> 
