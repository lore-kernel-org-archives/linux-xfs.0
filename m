Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB0EC43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 23:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D32E2176D
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 23:12:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dv3PSq54"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfLRXL7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 18:11:59 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39814 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfLRXL7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 18:11:59 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIN9ojn090998;
        Wed, 18 Dec 2019 23:11:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=3goM3DDoZjKFCk+30R3B+gURSy7lF5gQUOEIDLyAxfU=;
 b=Dv3PSq54z5VxLTFds/FyuWXhDqMyop6bZYphudZatiIpSrMfozITG3QjtMkOnghq+LXZ
 tUWmSYVf16FIfg2cJgc/S8NHslWHfsitI6OXdb7y0YP04x4KEkoD5DZLcF5iTDX6y50R
 C6nZ6vi81hrZeX4XWOC65Mo8XfxTW/m6EUskkKRUsoY2HrRGnybogmLsv8BZy5n7RyAB
 ufBo/I1oK9lcp7s5mGtX2Rnul9zaidMQ1VZ8U86AFpLmYRNZW2/7yz3uIMzx9e28tXmk
 Z/MLqPfa3yfJ5HdRLRK6yQY2IvXXwP6ECDJmPnkJr+xCY2xVKMzMosca9ZvpEi4TEG3k VA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wvqpqgm5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 23:11:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIN9q0k048911;
        Wed, 18 Dec 2019 23:11:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2wyut4c6sw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 23:11:56 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBINBt1G027034;
        Wed, 18 Dec 2019 23:11:55 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 15:11:55 -0800
Date:   Wed, 18 Dec 2019 15:11:52 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix sparse checker warnings on kmem tracepoints
Message-ID: <20191218231152.GL7489@magnolia>
References: <7c2af866-5a8e-3f48-ac07-041c3085c545@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c2af866-5a8e-3f48-ac07-041c3085c545@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 18, 2019 at 04:18:16PM -0600, Eric Sandeen wrote:
> Sparse checker doesn't like kmem.c tracepoints:
> 
> kmem.c:18:32: warning: incorrect type in argument 2 (different base types)
> kmem.c:18:32:    expected int [signed] flags
> kmem.c:18:32:    got restricted xfs_km_flags_t [usertype] flags
> 
> So take an xfs_km_flags_t, and cast it to an int when we print it.
> 
> Fixes: 0ad95687c3ad ("xfs: add kmem allocation trace points")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok insofar as cem will eventually kill these off, right?
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index c13bb3655e48..dd165b6d2289 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3545,11 +3545,11 @@ TRACE_EVENT(xfs_pwork_init,
>  )
>  
>  DECLARE_EVENT_CLASS(xfs_kmem_class,
> -	TP_PROTO(ssize_t size, int flags, unsigned long caller_ip),
> +	TP_PROTO(ssize_t size, xfs_km_flags_t flags, unsigned long caller_ip),
>  	TP_ARGS(size, flags, caller_ip),
>  	TP_STRUCT__entry(
>  		__field(ssize_t, size)
> -		__field(int, flags)
> +		__field(xfs_km_flags_t, flags)
>  		__field(unsigned long, caller_ip)
>  	),
>  	TP_fast_assign(
> @@ -3559,13 +3559,13 @@ DECLARE_EVENT_CLASS(xfs_kmem_class,
>  	),
>  	TP_printk("size %zd flags 0x%x caller %pS",
>  		  __entry->size,
> -		  __entry->flags,
> +		  (int)__entry->flags,
>  		  (char *)__entry->caller_ip)
>  )
>  
>  #define DEFINE_KMEM_EVENT(name) \
>  DEFINE_EVENT(xfs_kmem_class, name, \
> -	TP_PROTO(ssize_t size, int flags, unsigned long caller_ip), \
> +	TP_PROTO(ssize_t size, xfs_km_flags_t flags, unsigned long caller_ip), \
>  	TP_ARGS(size, flags, caller_ip))
>  DEFINE_KMEM_EVENT(kmem_alloc);
>  DEFINE_KMEM_EVENT(kmem_alloc_io);
> 
