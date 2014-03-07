Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 23EF27F50
	for <xfs@oss.sgi.com>; Fri,  7 Mar 2014 04:16:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 151328F8065
	for <xfs@oss.sgi.com>; Fri,  7 Mar 2014 02:16:39 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id QGJIxWgBYZTM4JjY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Mar 2014 02:16:38 -0800 (PST)
Date: Fri, 7 Mar 2014 02:16:37 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC, PATCH] xfs: make superblock version checks reflect reality
Message-ID: <20140307101637.GD32333@infradead.org>
References: <1394088890-10713-1-git-send-email-david@fromorbit.com>
	<20140306180534.GA305@infradead.org>
	<20140306225541.GL6851@dastard> <20140307083430.GQ6851@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140307083430.GQ6851@dastard>
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

On Fri, Mar 07, 2014 at 07:34:30PM +1100, Dave Chinner wrote:
> Ok, we don't reject filesystems that don't have the NLINK bit set.
> Older filesystems that have only v1 inodes won't have that bit
> set, and we didn't set NLINK by default in mkfs until late 2007.
> Hence we need to keep some form of NLINK support around.
> 
> The alternative is to simply set the bit in the superblock if it is
> not set, and then just assume everywhere that it is set and we are
> using v2 inodes. That will get rid of the hasnlink/addnlink code
> needed to modify the superblock when the link count goes above
> MAX_NLINK_1, and will result in filesystems always converting v1
> inodes to v2 inodes on writeback of dirty inodes. I don't see a
> problem with taking this approach, bt maybe I'm missing something?

I'd love to get rid of v1 support sprinkled all over.  Obviously this
should be a separate patch, but making both the code and the in-use
filesystems less diverse is a good idea.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
