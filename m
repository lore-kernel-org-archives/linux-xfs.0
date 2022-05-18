Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FAF8C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 01:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbiERBC3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 21:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbiERBC2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 21:02:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F4154024
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 18:02:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D72D661592
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 01:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3608BC385B8;
        Wed, 18 May 2022 01:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652835746;
        bh=HoC8Vwll/DTVTKxfrzNwa83UHMgRiqmO91s1MyktLyA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FcGMokz3XsASj1K2SSwvcjuBQrPc4lkFkjsiV3D38VNABoc0+ovK+P6/lIV4eIK57
         vDCneL6Kj/rRXQVOfiBYWNnDwphD9QV/o7jOVT5a1yMZCWwpSexEMs2z8ckDNyJy/w
         EdjMMj31uLAZS+eMy3IUx48wyymljPglf99e9ThoFIU++vZ0pApXC9uPGrbHo5k/S3
         vreuy1d8fNg7qGM5UebzqLLBBp+QlAIYb8OHceh5P1XN4ZzAlTKxjHBecEMG8kODsn
         zbAZG1uFS5RtEayWcLPcHriJcmOXpeAk3EB6HdRRAa00QCEALXWITgKRHuoJNvTWVn
         12VxlJCHosUjw==
Date:   Tue, 17 May 2022 18:02:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/18] xfsprogs: Add log item printing for ATTRI and ATTRD
Message-ID: <YoRFoewCIo+aV/ae@magnolia>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
 <20220518001227.1779324-19-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518001227.1779324-19-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 17, 2022 at 05:12:27PM -0700, Allison Henderson wrote:
> This patch implements a new set of log printing functions to print the
> ATTRI and ATTRD items and vectors in the log.  These will be used during
> log dump and log recover operations.
> 
> RFC: Though most attributes are strings, the attribute operations accept
> any binary payload, so we should not assume them printable.  This was
> done intentionally in preparation for parent pointers.  Until parent
> pointers get here, attributes have no discernible format.  So the print
> routines are just a simple print or hex dump for now.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  logprint/log_misc.c      |  48 +++++++++-
>  logprint/log_print_all.c |  12 +++
>  logprint/log_redo.c      | 197 +++++++++++++++++++++++++++++++++++++++
>  logprint/logprint.h      |  12 +++
>  4 files changed, 268 insertions(+), 1 deletion(-)
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index 35e926a3baec..d8c60388375b 100644
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

Nits: indentation and whatnot.

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
> index 182b9d53aaaa..79d37a2d28b7 100644
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
> index 297e203d0976..502345d1a842 100644
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

max()?

Other than that, everything looks ok to me.

You might want to change the subject of this one with the name of the
tool it modifies, e.g.

xfs_logprint: Add log item printing for ATTRI and ATTRD

--D

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
> index 38a7d3fa80a9..b4479c240d94 100644
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
> 2.25.1
> 
