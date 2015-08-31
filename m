Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8C72D7F47
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 13:58:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 703468F8035
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 11:58:19 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id JDZU4mb9Y8go8Vii (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 31 Aug 2015 11:58:18 -0700 (PDT)
Date: Mon, 31 Aug 2015 11:58:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/11] xfsprogs: avoid dependency on linux
	XATTR_SIZE/LIST_MAX
Message-ID: <20150831185817.GD349@infradead.org>
References: <1440590449-20372-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-2-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1440590555-20463-2-git-send-email-jtulak@redhat.com>
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

> index b1c0c10..d532f44 100644
> --- a/libhandle/handle.c
> +++ b/libhandle/handle.c
> @@ -21,6 +21,8 @@
>  #include "xfs.h"
>  #include "handle.h"
>  #include "parent.h"
> +#include "xfs/xfs_arch.h"
> +#include "xfs/xfs_format.h"

These headers should not be used in libhandle.  As mentioned last time I
think libhandle should get it's own LIBHANDLE_XATTR_LIST_MAX define,
separate frome the one for the on disk format.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
