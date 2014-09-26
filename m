Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6DFF28000
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 05:00:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4AB388F8035
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 03:00:28 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 4EU5sDQ7g6JCqDve (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 03:00:27 -0700 (PDT)
Date: Fri, 26 Sep 2014 03:00:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: remove bitfield based superblock updates
Message-ID: <20140926100027.GG10692@infradead.org>
References: <1411647632-28240-1-git-send-email-david@fromorbit.com>
	<1411647632-28240-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411647632-28240-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> +	to->sb_uquotino = cpu_to_be64(from->sb_uquotino);
> +	if (xfs_sb_version_has_pquotino(from)) {
> +		to->sb_qflags = be16_to_cpu(from->sb_qflags);
> +		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
> +		to->sb_pquotino = cpu_to_be64(from->sb_pquotino);
> +		return;
> +	}

sparse complains that the be16_to_cpu should be a cpu_to_be16 for
sb_qflags..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
