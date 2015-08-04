Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 97C5E7FA8
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 03:46:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 77E6B8F8033
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 01:46:27 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id aYTDfhzONH5almfo (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Aug 2015 01:46:25 -0700 (PDT)
Date: Tue, 4 Aug 2015 01:46:25 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 04/11] xfsprogs: Add ifdef dirent checks where it was
	missing
Message-ID: <20150804084625.GB12844@infradead.org>
References: <1438612789-17486-1-git-send-email-jtulak@redhat.com>
	<1438612789-17486-5-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1438612789-17486-5-git-send-email-jtulak@redhat.com>
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

> diff --git a/io/readdir.c b/io/readdir.c
> index 20b8898..ed8f04d 100644
> --- a/io/readdir.c
> +++ b/io/readdir.c
> @@ -104,12 +104,16 @@ read_directory(
>  		if (!dirent)
>  			break;
>  
> +#ifdef _DIRENT_HAVE_D_RECLEN
>  		*total += dirent->d_reclen;
> +#endif

You probably want to use d_namen + sizeof(*dirent) to approimate
the value if d_reclen doesn't exist.

>  		count++;
>  
>  		if (dump) {
>  			dump_dirent(offset, dirent);
> +#ifdef _DIRENT_HAVE_D_OFF
>  			offset = dirent->d_off;
> +#endif

We're only using the offset for dumping the value, maybe setting
it to 0 and adding a comment explaining it should go into the else
branch here?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
