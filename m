Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5577D801F
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 18:02:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 43BD48F8037
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 16:02:54 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	D10TWyfyjjbrwWGP for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 16:02:52 -0700 (PDT)
Date: Sat, 27 Sep 2014 09:02:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: remove bitfield based superblock updates
Message-ID: <20140926230235.GP4945@dastard>
References: <1411647632-28240-1-git-send-email-david@fromorbit.com>
	<1411647632-28240-3-git-send-email-david@fromorbit.com>
	<20140926100027.GG10692@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140926100027.GG10692@infradead.org>
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

On Fri, Sep 26, 2014 at 03:00:27AM -0700, Christoph Hellwig wrote:
> > +	to->sb_uquotino = cpu_to_be64(from->sb_uquotino);
> > +	if (xfs_sb_version_has_pquotino(from)) {
> > +		to->sb_qflags = be16_to_cpu(from->sb_qflags);
> > +		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
> > +		to->sb_pquotino = cpu_to_be64(from->sb_pquotino);
> > +		return;
> > +	}
> 
> sparse complains that the be16_to_cpu should be a cpu_to_be16 for
> sb_qflags..

Good catch. Fixed.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
