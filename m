Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7B1E37F52
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 07:55:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 541BE8F8066
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 05:55:36 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id c2drvfOZPbY0lRIq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Feb 2014 05:55:35 -0800 (PST)
Date: Wed, 5 Feb 2014 13:55:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/3] support appending AIO writes
Message-ID: <20140205135528.GN10323@ZenIV.linux.org.uk>
References: <20140204172402.380571745@bombadil.infradead.org>
	<20140204222901.GE13997@dastard>
	<20140205065728.GA30899@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140205065728.GA30899@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, Sergey Meirovich <rathamahata@gmail.com>, xfs@oss.sgi.com

On Tue, Feb 04, 2014 at 10:57:28PM -0800, Christoph Hellwig wrote:
> On Wed, Feb 05, 2014 at 09:29:01AM +1100, Dave Chinner wrote:
> > The patches look sane. Does the dio change conflict with the
> > work Al is doing right now of the direct IO path, or will
> > marshalling that part of the change through the XFS tree be fine?
> 
> I've not seen any changes in that area in Al's trees.  That being said
> I don't think this little flag should cause any major problems as we'll
> have to pass the flags argument in some form of direct I/O method for
> all the other quirks we have.

Shouldn't be a problem; there might be textual conflicts, but seeing that
XFS tree is much less likely to be rebased, I can just pull from it once
it gets to those.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
