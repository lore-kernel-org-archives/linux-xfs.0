Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4F8F67F62
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 09:33:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3D1B58F8033
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 07:33:59 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 8TMlg1gK3xTf4yga (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 20 Dec 2015 07:33:58 -0800 (PST)
Date: Sun, 20 Dec 2015 07:33:57 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/4] xfsprogs: xfs_io: fix a memory leak in imap_f
Message-ID: <20151220153357.GC20135@infradead.org>
References: <1449832143-26356-1-git-send-email-t.vivek@samsung.com>
	<1449832143-26356-2-git-send-email-t.vivek@samsung.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1449832143-26356-2-git-send-email-t.vivek@samsung.com>
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
To: Vivek Trivedi <t.vivek@samsung.com>
Cc: a.sahrawat@samsung.com, pankaj.m@samsung.com, xfs@oss.sgi.com

> @@ -39,6 +39,8 @@ imap_f(int argc, char **argv)
> -		if (count == 0)
> +		if (count == 0) {
> +			free(t);
>  			return 0;
> +		}

please use a goto out_free; here

>
>  		for (i = 0; i < count; i++) {
>  			printf(_("ino %10llu count %2d mask %016llx\n"),
>  				(unsigned long long)t[i].xi_startino,
> @@ -55,6 +59,7 @@ imap_f(int argc, char **argv)
>  				(unsigned long long)t[i].xi_allocmask);
>  		}
>  	}
> +	free(t);
>  	perror("xfsctl(XFS_IOC_FSINUMBERS)");
>  	exitcode = 1;
>  	return 0;

and place the free just before the return here so that we have a single
uwinding exit.

Otherwise this looks good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
