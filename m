Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF69C4320E
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 19:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79E4F61050
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 19:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhG1Tl7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 15:41:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhG1Tl7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 15:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BC2D6103B;
        Wed, 28 Jul 2021 19:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627501317;
        bh=XJLTl2cChB28wpbLOnZL+lM/pVbTYkYDswsI6RuiJF4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b5ta8XtQj5xRzt7hnpBYZOVHa8e0rkrAem+M9aV0tZ1n4JKbM+/mAaYzK712u0jRH
         JUeN18xwMB8zbP8yIkwcFcnpHHdzlmxM4XEF3o9JgMfDVr56p2zMX9IDlnWGWCLc+y
         TDX2x7+iRgTXvooA94WgMfaGWGWifmFNk8vb/2DvX6VTv5mvuSQcOAPEuqqw0hwpLp
         t7+VvP570qAzKeuaJbhhYnxwX1GUCocDXv3Oux7LxwpfizZ6bqoioIvF8ea+yIti1x
         RVFAVQ0S7JnWWOD6gNtnE+GI78uZE7+ASHNWRfAsnoZl3UoFrRLsrXU35TULlM7Cmb
         nFcG+sWyj/x5Q==
Date:   Wed, 28 Jul 2021 12:41:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 27/27] xfsprogs: Add log item printing for ATTRI and
 ATTRD
Message-ID: <20210728194156.GF3601443@magnolia>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
 <20210727061904.11084-28-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727061904.11084-28-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 11:19:04PM -0700, Allison Henderson wrote:
> This patch implements a new set of log printing functions to print the
> ATTRI and ATTRD items and vectors in the log.  These will be used during
> log dump and log recover operations.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

/me thinks this looks ok, though I admit I'm relying on you to have
exercised logprint and made sure that the output looks right.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  logprint/log_misc.c      |  48 +++++++++++-
>  logprint/log_print_all.c |  12 +++
>  logprint/log_redo.c      | 197 +++++++++++++++++++++++++++++++++++++++++++++++
>  logprint/logprint.h      |  12 +++
>  4 files changed, 268 insertions(+), 1 deletion(-)
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index 35e926a..d8c6038 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -54,11 +54,46 @@ print_stars(void)
>  	   "***********************************\n");
>  }	/* print_stars */
>  
> +void
> +print_hex_dump(char *ptr, int len) {
> +	int i = 0;
> +
> +	for (i = 0; i < len; i++) {
> +		if (i % 16 == 0)
> +			printf("%08x ", i);
> +
> +		printf("%02x", ptr[i]);
> +
> +		if ((i+1)%16 == 0)
> +			printf("\n");
> +		else if ((i+1)%2 == 0)
> +			printf(" ");
> +	}
> +	printf("\n");
> +}
> +
> +bool
> +is_printable(char *ptr, int len) {
> +	int i = 0;
> +
> +	for (i = 0; i < len; i++)
> +		if (!isprint(ptr[i]) )
> +			return false;
> +	return true;
> +}
> +
> +void print_or_dump(char *ptr, int len) {
> +	if (is_printable(ptr, len))
> +		printf("%.*s\n", len, ptr);
> +	else
> +		print_hex_dump(ptr, len);
> +}
> +
>  /*
>   * Given a pointer to a data segment, print out the data as if it were
>   * a log operation header.
>   */
> -static void
> +void
>  xlog_print_op_header(xlog_op_header_t	*op_head,
>  		     int		i,
>  		     char		**ptr)
> @@ -961,6 +996,17 @@ xlog_print_record(
>  					be32_to_cpu(op_head->oh_len));
>  			break;
>  		    }
> +		    case XFS_LI_ATTRI: {
> +			skip = xlog_print_trans_attri(&ptr,
> +					be32_to_cpu(op_head->oh_len),
> +					&i);
> +			break;
> +		    }
> +		    case XFS_LI_ATTRD: {
> +			skip = xlog_print_trans_attrd(&ptr,
> +					be32_to_cpu(op_head->oh_len));
> +			break;
> +		    }
>  		    case XFS_LI_RUI: {
>  			skip = xlog_print_trans_rui(&ptr,
>  					be32_to_cpu(op_head->oh_len),
> diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
> index c9c453f..89cb649 100644
> --- a/logprint/log_print_all.c
> +++ b/logprint/log_print_all.c
> @@ -404,6 +404,12 @@ xlog_recover_print_logitem(
>  	case XFS_LI_EFI:
>  		xlog_recover_print_efi(item);
>  		break;
> +	case XFS_LI_ATTRD:
> +		xlog_recover_print_attrd(item);
> +		break;
> +	case XFS_LI_ATTRI:
> +		xlog_recover_print_attri(item);
> +		break;
>  	case XFS_LI_RUD:
>  		xlog_recover_print_rud(item);
>  		break;
> @@ -456,6 +462,12 @@ xlog_recover_print_item(
>  	case XFS_LI_EFI:
>  		printf("EFI");
>  		break;
> +	case XFS_LI_ATTRD:
> +		printf("ATTRD");
> +		break;
> +	case XFS_LI_ATTRI:
> +		printf("ATTRI");
> +		break;
>  	case XFS_LI_RUD:
>  		printf("RUD");
>  		break;
> diff --git a/logprint/log_redo.c b/logprint/log_redo.c
> index 297e203..502345d 100644
> --- a/logprint/log_redo.c
> +++ b/logprint/log_redo.c
> @@ -653,3 +653,200 @@ xlog_recover_print_bud(
>  	f = item->ri_buf[0].i_addr;
>  	xlog_print_trans_bud(&f, sizeof(struct xfs_bud_log_format));
>  }
> +
> +/* Attr Items */
> +
> +static int
> +xfs_attri_copy_log_format(
> +	char				*buf,
> +	uint				len,
> +	struct xfs_attri_log_format	*dst_attri_fmt)
> +{
> +	uint dst_len = sizeof(struct xfs_attri_log_format);
> +
> +	if (len == dst_len) {
> +		memcpy((char *)dst_attri_fmt, buf, len);
> +		return 0;
> +	}
> +
> +	fprintf(stderr, _("%s: bad size of attri format: %u; expected %u\n"),
> +		progname, len, dst_len);
> +	return 1;
> +}
> +
> +int
> +xlog_print_trans_attri(
> +	char				**ptr,
> +	uint				src_len,
> +	int				*i)
> +{
> +	struct xfs_attri_log_format	*src_f = NULL;
> +	xlog_op_header_t		*head = NULL;
> +	uint				dst_len;
> +	int				error = 0;
> +
> +	dst_len = sizeof(struct xfs_attri_log_format);
> +	if (src_len != dst_len) {
> +		fprintf(stderr, _("%s: bad size of attri format: %u; expected %u\n"),
> +				progname, src_len, dst_len);
> +		return 1;
> +	}
> +
> +	/*
> +	 * memmove to ensure 8-byte alignment for the long longs in
> +	 * xfs_attri_log_format_t structure
> +	 */
> +	src_f = malloc(src_len);
> +	if (!src_f) {
> +		fprintf(stderr, _("%s: xlog_print_trans_attri: malloc failed\n"),
> +				progname);
> +		exit(1);
> +	}
> +	memmove((char*)src_f, *ptr, src_len);
> +	*ptr += src_len;
> +
> +	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id: 0x%llx\n"),
> +		src_f->alfi_size, src_f->alfi_name_len, src_f->alfi_value_len,
> +				(unsigned long long)src_f->alfi_id);
> +
> +	if (src_f->alfi_name_len > 0) {
> +		printf(_("\n"));
> +		(*i)++;
> +		head = (xlog_op_header_t *)*ptr;
> +		xlog_print_op_header(head, *i, ptr);
> +		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len));
> +		if (error)
> +			goto error;
> +	}
> +
> +	if (src_f->alfi_value_len > 0) {
> +		printf(_("\n"));
> +		(*i)++;
> +		head = (xlog_op_header_t *)*ptr;
> +		xlog_print_op_header(head, *i, ptr);
> +		error = xlog_print_trans_attri_value(ptr, be32_to_cpu(head->oh_len),
> +				src_f->alfi_value_len);
> +	}
> +error:
> +	free(src_f);
> +
> +	return error;
> +}	/* xlog_print_trans_attri */
> +
> +int
> +xlog_print_trans_attri_name(
> +	char				**ptr,
> +	uint				src_len)
> +{
> +	printf(_("ATTRI:  name len:%u\n"), src_len);
> +	print_or_dump(*ptr, src_len);
> +
> +	*ptr += src_len;
> +
> +	return 0;
> +}	/* xlog_print_trans_attri */
> +
> +int
> +xlog_print_trans_attri_value(
> +	char				**ptr,
> +	uint				src_len,
> +	int				value_len)
> +{
> +	int len = value_len;
> +
> +	if (len > MAX_ATTR_VAL_PRINT)
> +		len = MAX_ATTR_VAL_PRINT;
> +
> +	printf(_("ATTRI:  value len:%u\n"), value_len);
> +	print_or_dump(*ptr, len);
> +
> +	*ptr += src_len;
> +
> +	return 0;
> +}	/* xlog_print_trans_attri_value */
> +
> +void
> +xlog_recover_print_attri(
> +	struct xlog_recover_item	*item)
> +{
> +	struct xfs_attri_log_format	*f, *src_f = NULL;
> +	uint				src_len, dst_len;
> +
> +	int				region = 0;
> +
> +	src_f = (struct xfs_attri_log_format *)item->ri_buf[0].i_addr;
> +	src_len = item->ri_buf[region].i_len;
> +
> +	/*
> +	 * An xfs_attri_log_format structure contains a attribute name and
> +	 * variable length value  as the last field.
> +	 */
> +	dst_len = sizeof(struct xfs_attri_log_format);
> +
> +	if ((f = ((struct xfs_attri_log_format *)malloc(dst_len))) == NULL) {
> +		fprintf(stderr, _("%s: xlog_recover_print_attri: malloc failed\n"),
> +			progname);
> +		exit(1);
> +	}
> +	if (xfs_attri_copy_log_format((char*)src_f, src_len, f))
> +		goto out;
> +
> +	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id: 0x%llx\n"),
> +		f->alfi_size, f->alfi_name_len, f->alfi_value_len, (unsigned long long)f->alfi_id);
> +
> +	if (f->alfi_name_len > 0) {
> +		region++;
> +		printf(_("ATTRI:  name len:%u\n"), f->alfi_name_len);
> +		print_or_dump((char *)item->ri_buf[region].i_addr,
> +			       f->alfi_name_len);
> +	}
> +
> +	if (f->alfi_value_len > 0) {
> +		int len = f->alfi_value_len;
> +
> +		if (len > MAX_ATTR_VAL_PRINT)
> +			len = MAX_ATTR_VAL_PRINT;
> +
> +		region++;
> +		printf(_("ATTRI:  value len:%u\n"), f->alfi_value_len);
> +		print_or_dump((char *)item->ri_buf[region].i_addr, len);
> +	}
> +
> +out:
> +	free(f);
> +
> +}
> +
> +int
> +xlog_print_trans_attrd(char **ptr, uint len)
> +{
> +	struct xfs_attrd_log_format *f;
> +	struct xfs_attrd_log_format lbuf;
> +	uint core_size = sizeof(struct xfs_attrd_log_format);
> +
> +	memcpy(&lbuf, *ptr, MIN(core_size, len));
> +	f = &lbuf;
> +	*ptr += len;
> +	if (len >= core_size) {
> +		printf(_("ATTRD:  #regs: %d	id: 0x%llx\n"),
> +			f->alfd_size,
> +			(unsigned long long)f->alfd_alf_id);
> +		return 0;
> +	} else {
> +		printf(_("ATTRD: Not enough data to decode further\n"));
> +		return 1;
> +	}
> +}	/* xlog_print_trans_attrd */
> +
> +void
> +xlog_recover_print_attrd(
> +	struct xlog_recover_item		*item)
> +{
> +	struct xfs_attrd_log_format	*f;
> +
> +	f = (struct xfs_attrd_log_format *)item->ri_buf[0].i_addr;
> +
> +	printf(_("	ATTRD:  #regs: %d	id: 0x%llx\n"),
> +		f->alfd_size,
> +		(unsigned long long)f->alfd_alf_id);
> +}
> diff --git a/logprint/logprint.h b/logprint/logprint.h
> index 38a7d3f..b4479c2 100644
> --- a/logprint/logprint.h
> +++ b/logprint/logprint.h
> @@ -29,6 +29,9 @@ extern void xfs_log_print_trans(struct xlog *, int);
>  extern void print_xlog_record_line(void);
>  extern void print_xlog_op_line(void);
>  extern void print_stars(void);
> +extern void print_hex_dump(char* ptr, int len);
> +extern bool is_printable(char* ptr, int len);
> +extern void print_or_dump(char* ptr, int len);
>  
>  extern struct xfs_inode_log_format *
>  	xfs_inode_item_format_convert(char *, uint, struct xfs_inode_log_format *);
> @@ -53,4 +56,13 @@ extern void xlog_recover_print_bui(struct xlog_recover_item *item);
>  extern int xlog_print_trans_bud(char **ptr, uint len);
>  extern void xlog_recover_print_bud(struct xlog_recover_item *item);
>  
> +#define MAX_ATTR_VAL_PRINT	128
> +
> +extern int xlog_print_trans_attri(char **ptr, uint src_len, int *i);
> +extern int xlog_print_trans_attri_name(char **ptr, uint src_len);
> +extern int xlog_print_trans_attri_value(char **ptr, uint src_len, int value_len);
> +extern void xlog_recover_print_attri(struct xlog_recover_item *item);
> +extern int xlog_print_trans_attrd(char **ptr, uint len);
> +extern void xlog_recover_print_attrd(struct xlog_recover_item *item);
> +extern void xlog_print_op_header(xlog_op_header_t *op_head, int i, char **ptr);
>  #endif	/* LOGPRINT_H */
> -- 
> 2.7.4
> 
