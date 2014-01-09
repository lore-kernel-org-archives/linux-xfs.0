Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 929C929DF8
	for <xfs@oss.sgi.com>; Thu,  9 Jan 2014 12:48:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 884018F8037
	for <xfs@oss.sgi.com>; Thu,  9 Jan 2014 10:48:45 -0800 (PST)
Received: from mail-qe0-f47.google.com (mail-qe0-f47.google.com
	[209.85.128.47]) by cuda.sgi.com with ESMTP id et9uMFoAAR0AGyMK
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 09 Jan 2014 10:48:41 -0800 (PST)
Received: by mail-qe0-f47.google.com with SMTP id 5so3449270qeb.34
	for <xfs@oss.sgi.com>; Thu, 09 Jan 2014 10:48:40 -0800 (PST)
Message-ID: <52CEEF03.7080407@gmail.com>
Date: Thu, 09 Jan 2014 13:48:35 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: require 64-bit sector_t
References: <20131114164603.GA13628@infradead.org>	<20131216221559.GO1935@sgi.com>
	<20140109151903.GF1935@sgi.com>
In-Reply-To: <20140109151903.GF1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>, Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 01/09/2014 10:19 AM, Ben Myers wrote:
> On Mon, Dec 16, 2013 at 04:15:59PM -0600, Ben Myers wrote:
>> Hey Christoph,
>>
>> On Thu, Nov 14, 2013 at 08:46:03AM -0800, Christoph Hellwig wrote:
>>> Trying to support tiny disks only and saving a bit memory might have
>>> made sense on an SGI O2 15 years ago, but is pretty pointless today.
>>>
>>> Remove the rarely tested codepath that uses various smaller in-memory
>>> types to reduce our test matrix and make the codebase a little bit
>>> smaller and less complicated.
>>>
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> This looks ok to me.  I'm not seeing much downside to removing the smaller
>> in-memory types.
>>
>> Reviewed-by: Ben Myers <bpm@sgi.com>
> 
> Anyone else have an opinion on this one?  I think its 3.14 material and I'd
> like to pull it in.
> 
> Thanks,
> 	Ben

Either way is fine with me.  I use CONFIG_LBDAF=n, but it isn't a make-or-break 
kernel config option.  Most issues I've seen in testing were solved by Jeff 
Liu's patches.  This part of the test matrix seemed okay, but if Christoph wants 
to get rid of it, that's fine.  The XFS support matrix is rather brutal...

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
