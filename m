Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 16A2E7F3F
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 05:05:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E7A7D8F8040
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 03:05:28 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id xzzgDoCe4mF5wmnI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 07 Jul 2014 03:05:23 -0700 (PDT)
Date: Mon, 7 Jul 2014 03:05:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] libxfs: reused invalidated buffers leak state and data
Message-ID: <20140707100523.GA3544@infradead.org>
References: <1404453435-1915-1-git-send-email-david@fromorbit.com>
	<1404453435-1915-5-git-send-email-david@fromorbit.com>
	<20140704141509.GB29520@infradead.org>
	<20140704222210.GM9508@dastard>
	<20140705094807.GB18130@infradead.org>
	<20140706235444.GP9508@dastard> <20140707000929.GR9508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140707000929.GR9508@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jul 07, 2014 at 10:09:29AM +1000, Dave Chinner wrote:
> Is that sufficient for the moment?

Looks good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
