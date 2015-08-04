Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2C9407FA4
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 06:16:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0AE9930404E
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 04:16:37 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 8eML7cmEdSAw7BFT (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Aug 2015 04:16:35 -0700 (PDT)
Date: Tue, 4 Aug 2015 04:16:35 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: fix syntax error in include/buildmacros
Message-ID: <20150804111635.GA18906@infradead.org>
References: <1438659509-16656-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1438659509-16656-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 04, 2015 at 11:38:29AM +0800, Eryu Guan wrote:
> There's an extra ";" in include/buildmacros, which causes make
> install-dev to fail
> 
>     ......
>     Installing libhandle-install-dev
>     cd ../libhandle/.libs; ... if [ "x/usr/lib64" != "x/usr/lib64"; ]; ...
>     /bin/sh: line 0: [: missing `]'
>     /bin/sh: ]: command not found
>     ......
> 
> This was introduced by
> 02ef543 libhandle: fix installation for symlinked /usr

Thanks, loosk like some shells are stricter than others here.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
