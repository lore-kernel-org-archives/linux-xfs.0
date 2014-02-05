Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BDE727F51
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 00:57:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9DF418F8040
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 22:57:32 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id SiW6ZyZi4vR0wB3k (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 22:57:30 -0800 (PST)
Date: Tue, 4 Feb 2014 22:57:28 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] support appending AIO writes
Message-ID: <20140205065728.GA30899@infradead.org>
References: <20140204172402.380571745@bombadil.infradead.org>
	<20140204222901.GE13997@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140204222901.GE13997@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Sergey Meirovich <rathamahata@gmail.com>, xfs@oss.sgi.com

On Wed, Feb 05, 2014 at 09:29:01AM +1100, Dave Chinner wrote:
> The patches look sane. Does the dio change conflict with the
> work Al is doing right now of the direct IO path, or will
> marshalling that part of the change through the XFS tree be fine?

I've not seen any changes in that area in Al's trees.  That being said
I don't think this little flag should cause any major problems as we'll
have to pass the flags argument in some form of direct I/O method for
all the other quirks we have.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
