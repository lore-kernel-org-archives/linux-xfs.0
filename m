Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OHuEx5060026 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 11:56:14 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	bOFDfkfX0nii4D1w (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 09:56:13 -0800 (PST)
Date: Tue, 24 Jan 2012 12:56:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: check for size parsing errors in xfs_quota
Message-ID: <20120124175612.GH9853@infradead.org>
References: <4F1D9989.8060808@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F1D9989.8060808@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: James Lawrie <james@jdlawrie.co.uk>, xfs-oss <xfs@oss.sgi.com>

> -		v = (__uint64_t)cvtnum(blocksize, sectorsize, s);
> -		*value = v >> 9;	/* syscalls use basic blocks */
> +		v = cvtnum(blocksize, sectorsize, s);
> +		if (v == -1LL) {
> +			fprintf(stderr, _("%s: Error: could not parse size %s.\n"), progname, s);
> +			return 0;
> +		}
> +		*value = (__uint64_t)v >> 8;	/* syscalls use basic blocks */

Why do you replace the shift by nine with a shift by 8?

Also please don't introduce new overly long lines, just move the
translated string to a line of its own, indented by a single tab similar
to how we do it in most new xfs/xfsprogs code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
