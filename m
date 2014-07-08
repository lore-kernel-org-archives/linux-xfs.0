Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A68917F47
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 09:24:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 86A368F808F
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 07:24:30 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id IbWIOuVBULt4Fw2i (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 Jul 2014 07:24:26 -0700 (PDT)
Date: Tue, 8 Jul 2014 07:24:25 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUCE] xfsprogs: master branch updated to 871fbfd
Message-ID: <20140708142425.GA19979@infradead.org>
References: <20140708014039.GV9508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140708014039.GV9508@dastard>
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

>       [6af7c1e] libxfs: reused invalidated buffers leak state and data

The committed version still clears b_error outside of b_lock..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
