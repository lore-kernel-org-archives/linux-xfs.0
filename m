Return-Path: <SRS0=CSRb=5Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE299C2BB55
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 15:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A435820769
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 15:51:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NyPK31zD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgDIPv1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 11:51:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58352 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728221AbgDIPv1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 11:51:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039FdBsG171814;
        Thu, 9 Apr 2020 15:50:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=gO7jrRc/YigvU3PUSpLluOu+YL+3iEAZSaGm/cz3n0w=;
 b=NyPK31zDoiiAdDysvjTl/6D0QYOcl077F3oZdrIIY7c1Lv3EJObuvUelm2ZPwmJ5rLD7
 u1pN29hBoefnBZPs2rSZbe6HhjNnZ5FY/FO7NI9j98I+wsQWE3AMyijnPzVwlLgu2Nha
 h4U0VbKRu00nvN1yEuWUg2yN2AmdjnOKG9NdjA2tFuQBGDLBjBuNfR7FD5QK6d0/1sVw
 CdviplkwQzsCR3hV0o5FfeYahqrEPyGpiCPNm/MzKG3hgEoqXhPshzlIS/ZjP9Q0tpQJ
 vLPLNhu//34EhRG4KLQbGzV0jXRDvrLHkX68AtLH1i8Pf3oiLOQIZrBtbp1+O1cGK8dG uA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 309gw4e79f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 15:50:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039FasMU057361;
        Thu, 9 Apr 2020 15:50:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 309ag4y4k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 15:50:52 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 039Fonwr027652;
        Thu, 9 Apr 2020 15:50:49 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Apr 2020 08:50:49 -0700
Subject: Re: [PATCH] xfs: stop CONFIG_XFS_DEBUG from changing compiler flags
To:     Arnd Bergmann <arnd@arndb.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-kernel@vger.kernel.org
References: <20200409080909.3646059-1-arnd@arndb.de>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <f33a0493-dad9-5ddd-f2c1-60b9004d855e@oracle.com>
Date:   Thu, 9 Apr 2020 08:50:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200409080909.3646059-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=948 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004090118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1011
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=975 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004090118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/9/20 1:08 AM, Arnd Bergmann wrote:
> I ran into a linker warning in XFS that originates from a mismatch
> between libelf, binutils and objtool when certain files in the kernel
> are built with "gcc -g":
> 
> x86_64-linux-ld: fs/xfs/xfs_trace.o: unable to initialize decompress status for section .debug_info
> 
> After some discussion, nobody could identify why xfs sets this flag
> here. CONFIG_XFS_DEBUG used to enable lots of unrelated settings, but
> now its main purpose is to enable extra consistency checks and assertions
> that are unrelated to the debug info.
> 
> Remove the Makefile logic to set the flag here. If anyone relies
> on the debug info, this can simply be enabled again with the global
> CONFIG_DEBUG_INFO option.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Link: https://urldefense.com/v3/__https://lore.kernel.org/lkml/20200409074130.GD21033@infradead.org/__;!!GqivPVa7Brio!JzJUQORI8aWjYFMvoyVmkgYSofJexLQn7p16KvP39F-NjuIzEXWqypgw0FnCyrdFtmZm$
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Ok, looks good
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/Makefile | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 4f95df476181..ff94fb90a2ee 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -7,8 +7,6 @@
>   ccflags-y += -I $(srctree)/$(src)		# needed for trace events
>   ccflags-y += -I $(srctree)/$(src)/libxfs
>   
> -ccflags-$(CONFIG_XFS_DEBUG) += -g
> -
>   obj-$(CONFIG_XFS_FS)		+= xfs.o
>   
>   # this one should be compiled first, as the tracing macros can easily blow up
> 
