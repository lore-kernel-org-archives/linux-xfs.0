Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DC78A7FA6
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 07:13:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C7F39304051
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 05:13:13 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id ThpLBe75bKEDf0zV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Aug 2015 05:13:11 -0700 (PDT)
Date: Tue, 4 Aug 2015 08:12:26 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <117593154.2602203.1438690346097.JavaMail.zimbra@redhat.com>
In-Reply-To: <20150804112103.GF18906@infradead.org>
References: <1438612789-17486-1-git-send-email-jtulak@redhat.com>
	<1438612789-17486-9-git-send-email-jtulak@redhat.com>
	<20150804112103.GF18906@infradead.org>
Subject: Re: [PATCH v3 08/11] xfsprogs: Add fls check into autoconf
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com



----- Original Message -----
> From: "Christoph Hellwig" <hch@infradead.org>
> To: "Jan Tulak" <jtulak@redhat.com>
> Cc: hch@infradead.org, xfs@oss.sgi.com
> Sent: Tuesday, August 4, 2015 1:21:03 PM
> Subject: Re: [PATCH v3 08/11] xfsprogs: Add fls check into autoconf
> 
> Can't you just use something like:
> 
> AC_CHECK_DECL([fls],
>         [AC_DEFINE([HAVE_FLS_PROTOTYPE], [1],
> 	 [Define to 1 if have fls prototype])],
> 	 [],
> 	 [#include <string.h>])
> 

You mean to replace the entire autoconf part of the patch with this? 
I will try it. Autoconf is still a bit of a black magic for me, so I
used the already existing checks. :-)

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
