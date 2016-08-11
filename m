Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1D7157CA3
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 04:04:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D1AF88F8035
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 02:04:43 -0700 (PDT)
Received: from smtp1.cc.ic.ac.uk (smtp1.cc.ic.ac.uk [155.198.5.155]) by
	cuda.sgi.com with ESMTP id Ltnz0rGDiZKbsOUE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2016 02:04:40 -0700 (PDT)
Date: Thu, 11 Aug 2016 10:04:09 +0100
From: Wei Lin <lin.wei15@imperial.ac.uk>
Subject: Re: Question on migrating data between PVs in xfs
Message-ID: <20160811090409.GA3448@ic>
References: <20160809145046.GB5583@ic> <20160809223503.GJ19025@dastard>
	<20160810092313.GA16193@ic> <20160810105639.GR16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160810105639.GR16044@dastard>
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
Cc: xfs@oss.sgi.com, Wei Lin <lin.wei15@imperial.ac.uk>

Hi Dave,

Now I see your point. Initially I wanted to store the linear concat
layout in a special file, read this file during allocation to compute on
the fly if an extent falls into a physical volume. But now I do agree
that from the perspective of OS engineering, filesystems should not know
the underlying layout, at least not in such an "ad-hoc" way. Aligning
AGs to physical volumes and applying allocation policy might be the best
approach.

Thank you very much for the help.

Cheers,
-- 
Wei Lin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
