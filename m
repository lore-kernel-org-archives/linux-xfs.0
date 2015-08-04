Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 787537FA4
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 06:21:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 24F2DAC002
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 04:21:05 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id gnzoukBPIBAoV3HF (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Aug 2015 04:21:03 -0700 (PDT)
Date: Tue, 4 Aug 2015 04:21:03 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 08/11] xfsprogs: Add fls check into autoconf
Message-ID: <20150804112103.GF18906@infradead.org>
References: <1438612789-17486-1-git-send-email-jtulak@redhat.com>
	<1438612789-17486-9-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1438612789-17486-9-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

Can't you just use something like:

AC_CHECK_DECL([fls],
        [AC_DEFINE([HAVE_FLS_PROTOTYPE], [1],
	 [Define to 1 if have fls prototype])],
	 [],
	 [#include <string.h>])

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
