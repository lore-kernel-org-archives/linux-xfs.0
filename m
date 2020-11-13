Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 496E5C388F9
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 03:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C953822243
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 03:57:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B5ROd0oK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgKMD5g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Nov 2020 22:57:36 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33824 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgKMD5g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Nov 2020 22:57:36 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AD3sVCi099635
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 03:57:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=geWwsI5zOUC6jv6SSYr8PLJ6VwdtVLNzd6M3B+fQRcs=;
 b=B5ROd0oKcAPNpXKrwszHzt1ZQ2igDOjEB23sBldBI4JpnCNLsGcGsNPoDJdmzSZuqHyY
 Vp+VpvJXPJrO2Ebd62UhQTmOJehc6MQ3WL9Y0nJ6YgKspmXpeMMUggSFQAiYPqxRAtga
 L/AsWITQkQSDWClbowyaOFjZXClTTSodqbFAK9Xc//Qk2Yj05skaD2rhNzX4Qih/lT31
 VcPShiZGFpfiKf9OTm5ygPQzzBCExxDC61lrwl4PRN0wimBDdmxvng5t7ITQRKncIclq
 orLWj91Qq3T3Qh+M7G+OI2ykl9Vsc7S8X4PJanxScymRUVaU0bLTzKb2GMpE3nYgfR3O UQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3b8vmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 03:57:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AD3pClv192732
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 03:57:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34rt575edg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 03:57:33 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AD3vWQw017244
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 03:57:32 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 19:57:32 -0800
Subject: Re: [PATCH v13 13/14] [RFC] xfsprogs: Add log item printing for ATTRI
 and ATTRD
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201023063306.7441-1-allison.henderson@oracle.com>
 <20201023063306.7441-14-allison.henderson@oracle.com>
 <20201110235236.GN9695@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <58e644f4-78c0-86ec-491f-85e45f7a6d6a@oracle.com>
Date:   Thu, 12 Nov 2020 20:57:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201110235236.GN9695@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=2 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=2
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130020
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/10/20 4:52 PM, Darrick J. Wong wrote:
> On Thu, Oct 22, 2020 at 11:33:05PM -0700, Allison Henderson wrote:
>> This patch implements a new set of log printing functions to print the
>> ATTRI and ATTRD items and vectors in the log.  These will be used during
>> log dump and log recover operations.
>>
>> RFC: Though most attributes are strings, the attribute operations accept
>> any binary payload, so we cannot assume them printable.  This was done
>> intentionally in preparation for parent pointers.  And until parent
>> pointers get here, attributes have no discernible format.  So the print
>> routines are just a simple hex dump for now.  It's not pretty, but works
>> for now.
> 
> Perhaps this should print the string if the entire buffer consists of
> printable characters?
I'm fine with that as long as everyone else is.  Just thought I should 
point it out.  :-)

> 
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   logprint/log_misc.c      |  31 +++++++-
>>   logprint/log_print_all.c |  12 +++
>>   logprint/log_redo.c      | 197 +++++++++++++++++++++++++++++++++++++++++++++++
>>   logprint/logprint.h      |  10 +++
>>   4 files changed, 249 insertions(+), 1 deletion(-)
>>
>> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
>> index af927cb..900a75d 100644
>> --- a/logprint/log_misc.c
>> +++ b/logprint/log_misc.c
>> @@ -54,11 +54,29 @@ print_stars(void)
>>   	   "***********************************\n");
>>   }	/* print_stars */
>>   
>> +void
>> +print_hex_dump(char *ptr, int len) {
>> +	int i = 0;
>> +
>> +	for (i = 0; i < len; i++) {
>> +		if (i % 16 == 0)
>> +			printf("%08x ", i);
>> +
>> +		printf("%02x", ptr[i]);
>> +
>> +		if ((i+1)%16 == 0)
>> +			printf("\n");
>> +		else if ((i+1)%2 == 0)
>> +			printf(" ");
>> +	}
>> +	printf("\n");
>> +}
>> +
>>   /*
>>    * Given a pointer to a data segment, print out the data as if it were
>>    * a log operation header.
>>    */
>> -static void
>> +void
>>   xlog_print_op_header(xlog_op_header_t	*op_head,
>>   		     int		i,
>>   		     char		**ptr)
>> @@ -949,6 +967,17 @@ xlog_print_record(
>>   					be32_to_cpu(op_head->oh_len));
>>   			break;
>>   		    }
>> +		    case XFS_LI_ATTRI: {
>> +                        skip = xlog_print_trans_attri(&ptr,
>> +                                        be32_to_cpu(op_head->oh_len),
>> +                                        &i);
>> +                        break;
>> +                    }
>> +                    case XFS_LI_ATTRD: {
> 
> Inconsistent indenting.
> 
> Not that this function was a sparkling gem to begin with...
> 
No worries, will fix, it's been a while since I've looked at this patch. :-)


>> +                        skip = xlog_print_trans_attrd(&ptr,
>> +                                        be32_to_cpu(op_head->oh_len));
>> +                        break;
>> +                    }
>>   		    case XFS_LI_RUI: {
>>   			skip = xlog_print_trans_rui(&ptr,
>>   					be32_to_cpu(op_head->oh_len),
>> diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
>> index 1924a0a..2b3f035 100644
>> --- a/logprint/log_print_all.c
>> +++ b/logprint/log_print_all.c
>> @@ -402,6 +402,12 @@ xlog_recover_print_logitem(
>>   	case XFS_LI_EFI:
>>   		xlog_recover_print_efi(item);
>>   		break;
>> +	case XFS_LI_ATTRD:
>> +		xlog_recover_print_attrd(item);
>> +		break;
>> +	case XFS_LI_ATTRI:
>> +		xlog_recover_print_attri(item);
>> +		break;
>>   	case XFS_LI_RUD:
>>   		xlog_recover_print_rud(item);
>>   		break;
>> @@ -454,6 +460,12 @@ xlog_recover_print_item(
>>   	case XFS_LI_EFI:
>>   		printf("EFI");
>>   		break;
>> +	case XFS_LI_ATTRD:
>> +		printf("ATTRD");
>> +		break;
>> +	case XFS_LI_ATTRI:
>> +		printf("ATTRI");
>> +		break;
>>   	case XFS_LI_RUD:
>>   		printf("RUD");
>>   		break;
>> diff --git a/logprint/log_redo.c b/logprint/log_redo.c
>> index 297e203..3e790e2 100644
>> --- a/logprint/log_redo.c
>> +++ b/logprint/log_redo.c
>> @@ -8,6 +8,7 @@
>>   #include "libxlog.h"
>>   
>>   #include "logprint.h"
>> +#include "xfs_attr_item.h"
>>   
>>   /* Extent Free Items */
>>   
>> @@ -653,3 +654,199 @@ xlog_recover_print_bud(
>>   	f = item->ri_buf[0].i_addr;
>>   	xlog_print_trans_bud(&f, sizeof(struct xfs_bud_log_format));
>>   }
>> +
>> +/* Attr Items */
>> +
>> +static int
>> +xfs_attri_copy_log_format(
>> +	char				*buf,
>> +	uint				len,
>> +	struct xfs_attri_log_format	*dst_attri_fmt)
>> +{
>> +	uint dst_len = sizeof(struct xfs_attri_log_format);
>> +
>> +	if (len == dst_len) {
>> +		memcpy((char *)dst_attri_fmt, buf, len);
>> +		return 0;
>> +	}
>> +
>> +	fprintf(stderr, _("%s: bad size of attri format: %u; expected %u\n"),
>> +		progname, len, dst_len);
>> +	return 1;
>> +}
>> +
>> +int
>> +xlog_print_trans_attri(
>> +	char				**ptr,
>> +	uint				src_len,
>> +	int				*i)
>> +{
>> +	struct xfs_attri_log_format	*src_f = NULL;
>> +	xlog_op_header_t		*head = NULL;
>> +	uint				dst_len;
>> +	int				error = 0;
>> +
>> +	dst_len = sizeof(struct xfs_attri_log_format);
>> +	if (src_len != dst_len) {
>> +		fprintf(stderr, _("%s: bad size of attri format: %u; expected %u\n"),
>> +				progname, src_len, dst_len);
>> +		return 1;
>> +	}
>> +
>> +	/*
>> +	 * memmove to ensure 8-byte alignment for the long longs in
>> +	 * xfs_attri_log_format_t structure
>> +	 */
>> +	if ((src_f = (struct xfs_attri_log_format *)malloc(src_len)) == NULL) {
> 
> 	src_f = malloc(src_len);
> 	if (!src_f) {
> 
Sure, will break up a bit

>> +		fprintf(stderr, _("%s: xlog_print_trans_attri: malloc failed\n"),
>> +				progname);
>> +		exit(1);
>> +	}
>> +	memmove((char*)src_f, *ptr, src_len);
>> +	*ptr += src_len;
>> +
>> +	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id: 0x%llx\n"),
>> +		src_f->alfi_size, src_f->alfi_name_len, src_f->alfi_value_len,
>> +				(unsigned long long)src_f->alfi_id);
>> +
>> +	if (src_f->alfi_name_len > 0) {
>> +		printf(_("\n"));
>> +		(*i)++;
>> +		head = (xlog_op_header_t *)*ptr;
>> +		xlog_print_op_header(head, *i, ptr);
>> +		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len));
>> +		if (error)
>> +			goto error;
>> +	}
>> +
>> +	if (src_f->alfi_value_len > 0) {
>> +		printf(_("\n"));
>> +		(*i)++;
>> +		head = (xlog_op_header_t *)*ptr;
>> +		xlog_print_op_header(head, *i, ptr);
>> +		error = xlog_print_trans_attri_value(ptr, be32_to_cpu(head->oh_len),
>> +				src_f->alfi_value_len);
>> +	}
>> +error:
>> +	free(src_f);
>> +
>> +	return error;
>> +}	/* xlog_print_trans_attri */
>> +
>> +int
>> +xlog_print_trans_attri_name(
>> +	char				**ptr,
>> +	uint				src_len)
>> +{
>> +	printf(_("ATTRI:  name len:%u\n"), src_len);
>> +	print_hex_dump(*ptr, src_len);
>> +
>> +	*ptr += src_len;
>> +
>> +	return 0;
>> +}	/* xlog_print_trans_attri */
>> +
>> +int
>> +xlog_print_trans_attri_value(
>> +	char				**ptr,
>> +	uint				src_len,
>> +	int				value_len)
>> +{
>> +	int len = value_len;
>> +
>> +	if (len > MAX_ATTR_VAL_PRINT)
>> +		len = MAX_ATTR_VAL_PRINT;
>> +
>> +	printf(_("ATTRI:  value len:%u\n"), value_len);
>> +	print_hex_dump(*ptr, len);
> 
> print_hex_dump(*ptr, min(len, MAX_ATTR_VAL_PRINT)); ?
Ok, will simplify.

Thanks!
Allison

> 
> --D
> 
>> +
>> +	*ptr += src_len;
>> +
>> +	return 0;
>> +}	/* xlog_print_trans_attri_value */
>> +
>> +void
>> +xlog_recover_print_attri(
>> +	struct xlog_recover_item	*item)
>> +{
>> +	struct xfs_attri_log_format	*f, *src_f = NULL;
>> +	uint				src_len, dst_len;
>> +
>> +	int				region = 0;
>> +
>> +	src_f = (struct xfs_attri_log_format *)item->ri_buf[0].i_addr;
>> +	src_len = item->ri_buf[region].i_len;
>> +
>> +	/*
>> +	 * An xfs_attri_log_format structure contains a attribute name and
>> +	 * variable length value  as the last field.
>> +	 */
>> +	dst_len = sizeof(struct xfs_attri_log_format);
>> +
>> +	if ((f = ((struct xfs_attri_log_format *)malloc(dst_len))) == NULL) {
>> +		fprintf(stderr, _("%s: xlog_recover_print_attri: malloc failed\n"),
>> +			progname);
>> +		exit(1);
>> +	}
>> +	if (xfs_attri_copy_log_format((char*)src_f, src_len, f))
>> +		goto out;
>> +
>> +	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id: 0x%llx\n"),
>> +		f->alfi_size, f->alfi_name_len, f->alfi_value_len, (unsigned long long)f->alfi_id);
>> +
>> +	if (f->alfi_name_len > 0) {
>> +		region++;
>> +		printf(_("ATTRI:  name len:%u\n"), f->alfi_name_len);
>> +		print_hex_dump((char *)item->ri_buf[region].i_addr,
>> +			       f->alfi_name_len);
>> +	}
>> +
>> +	if (f->alfi_value_len > 0) {
>> +		int len = f->alfi_value_len;
>> +
>> +		if (len > MAX_ATTR_VAL_PRINT)
>> +			len = MAX_ATTR_VAL_PRINT;
>> +
>> +		region++;
>> +		printf(_("ATTRI:  value len:%u\n"), f->alfi_value_len);
>> +		print_hex_dump((char *)item->ri_buf[region].i_addr, len);
>> +	}
>> +
>> +out:
>> +	free(f);
>> +
>> +}
>> +
>> +int
>> +xlog_print_trans_attrd(char **ptr, uint len)
>> +{
>> +	struct xfs_attrd_log_format *f;
>> +	struct xfs_attrd_log_format lbuf;
>> +	uint core_size = sizeof(struct xfs_attrd_log_format);
> 
> Indenting issues and whatnot...
> 
>> +
>> +	memcpy(&lbuf, *ptr, MIN(core_size, len));
>> +	f = &lbuf;
>> +	*ptr += len;
>> +	if (len >= core_size) {
>> +		printf(_("ATTRD:  #regs: %d	id: 0x%llx\n"),
>> +			f->alfd_size,
>> +			(unsigned long long)f->alfd_alf_id);
>> +		return 0;
>> +	} else {
>> +		printf(_("ATTRD: Not enough data to decode further\n"));
>> +		return 1;
>> +	}
>> +}	/* xlog_print_trans_attrd */
>> +
>> +void
>> +xlog_recover_print_attrd(
>> +	struct xlog_recover_item		*item)
>> +{
>> +	struct xfs_attrd_log_format	*f;
>> +
>> +	f = (struct xfs_attrd_log_format *)item->ri_buf[0].i_addr;
>> +
>> +	printf(_("	ATTRD:  #regs: %d	id: 0x%llx\n"),
>> +		f->alfd_size,
>> +		(unsigned long long)f->alfd_alf_id);
>> +}
>> diff --git a/logprint/logprint.h b/logprint/logprint.h
>> index ee85bfe..2e256bd 100644
>> --- a/logprint/logprint.h
>> +++ b/logprint/logprint.h
>> @@ -28,6 +28,7 @@ extern void xfs_log_print_trans(struct xlog *, int);
>>   extern void print_xlog_record_line(void);
>>   extern void print_xlog_op_line(void);
>>   extern void print_stars(void);
>> +extern void print_hex_dump(char* ptr, int len);
>>   
>>   extern struct xfs_inode_log_format *
>>   	xfs_inode_item_format_convert(char *, uint, struct xfs_inode_log_format *);
>> @@ -52,4 +53,13 @@ extern void xlog_recover_print_bui(struct xlog_recover_item *item);
>>   extern int xlog_print_trans_bud(char **ptr, uint len);
>>   extern void xlog_recover_print_bud(struct xlog_recover_item *item);
>>   
>> +#define MAX_ATTR_VAL_PRINT	128
>> +
>> +extern int xlog_print_trans_attri(char **ptr, uint src_len, int *i);
>> +extern int xlog_print_trans_attri_name(char **ptr, uint src_len);
>> +extern int xlog_print_trans_attri_value(char **ptr, uint src_len, int value_len);
>> +extern void xlog_recover_print_attri(struct xlog_recover_item *item);
>> +extern int xlog_print_trans_attrd(char **ptr, uint len);
>> +extern void xlog_recover_print_attrd(struct xlog_recover_item *item);
>> +extern void xlog_print_op_header(xlog_op_header_t *op_head, int i, char **ptr);
>>   #endif	/* LOGPRINT_H */
>> -- 
>> 2.7.4
>>
