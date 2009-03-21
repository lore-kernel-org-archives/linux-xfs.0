Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2LMDLXR018616 for <xfs@oss.sgi.com>; Sat, 21 Mar 2009 17:13:38 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9F3D1C5E751
	for <xfs@oss.sgi.com>; Sat, 21 Mar 2009 15:12:42 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id HlHQebxiUSLAirWn for <xfs@oss.sgi.com>;
	Sat, 21 Mar 2009 15:12:42 -0700 (PDT)
Message-ID: <49C56650.10008@sandeen.net>
Date: Sat, 21 Mar 2009 17:12:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] xfs: kill ino64 mount option
References: <20090318094119.561416000@bombadil.infradead.org>	<20090318094132.076764000@bombadil.infradead.org>	<49C4650B.4040509@sandeen.net>
	<20090321200806.GA15245@infradead.org>
In-Reply-To: <20090321200806.GA15245@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Fri, Mar 20, 2009 at 10:54:51PM -0500, Eric Sandeen wrote:
>> Christoph Hellwig wrote:
>>
>>> The ino64 mount option adds a fixed offset to 32bit inode numbers
>>> to bring them into the 64bit range.  There's no need for this kind
>>> of debug tool given that it's easy to produce real 64bit inode numbers
>>> for testing.
>> hm, easy how?
> 
> Actually test with a large enough device and let them spread evenly
> over the AGs.

It's the large-enough device which sometimes is at odds with "easy"

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
