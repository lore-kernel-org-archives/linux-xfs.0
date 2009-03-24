Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2OMAxEU049056 for <xfs@oss.sgi.com>; Tue, 24 Mar 2009 17:11:09 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B78311C03A9
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2009 15:10:30 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id qpyRd1Id4ePnAbUk for
	<xfs@oss.sgi.com>; Tue, 24 Mar 2009 15:10:30 -0700 (PDT)
References: <20090318094119.561416000@bombadil.infradead.org>
	<20090318094132.076764000@bombadil.infradead.org>
	<49C4650B.4040509@sandeen.net>
	<20090321200806.GA15245@infradead.org>
	<49C56650.10008@sandeen.net> <20090324083037.GP26138@disturbed>
Message-Id: <612C6156-D3B9-43BF-880A-DE54EB4F56A9@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20090324083037.GP26138@disturbed>
Mime-Version: 1.0 (iPod Mail 5H11)
Subject: Re: [PATCH 3/5] xfs: kill ino64 mount option
Date: Tue, 24 Mar 2009 08:11:36 -0500
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>



On Mar 24, 2009, at 3:30 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Sat, Mar 21, 2009 at 05:12:32PM -0500, Eric Sandeen wrote:
>> Christoph Hellwig wrote:
>>> On Fri, Mar 20, 2009 at 10:54:51PM -0500, Eric Sandeen wrote:
>>>> Christoph Hellwig wrote:
>>>>
>>>>> The ino64 mount option adds a fixed offset to 32bit inode numbers
>>>>> to bring them into the 64bit range.  There's no need for this kind
>>>>> of debug tool given that it's easy to produce real 64bit inode  
>>>>> numbers
>>>>> for testing.
>>>> hm, easy how?
>>>
>>> Actually test with a large enough device and let them spread evenly
>>> over the AGs.
>>
>> It's the large-enough device which sometimes is at odds with "easy"
>
> Sparse loopback image

OK I'm sold...

Eric

>
> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
