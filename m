Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0DMgdOv197016 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 16:42:40 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfsprogs: Make the compile output cleaner V2
Date: Wed, 13 Jan 2010 16:43:33 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6966@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20100113220814.GA17310@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Wed, Jan 13, 2010 at 09:03:27PM +1100, Dave Chinner wrote:
>> -LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
>> +DISTDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
>>  	built .census install.* install-dev.* *.gz autom4te.cache/* libtool \
>>  	include/builddefs include/platform_defs.h
> 
>>  distclean: clean
>> -	rm -f $(LDIRT)
>> +	$(Q)rm -f $(DISTDIRT)
> 
> What does this have to do with the rest?
> 
> Otherwise looks good,

I didn't get the original in my e-mail or I would have
responded to it directly.  I like this change a lot.

> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Any chance you could also port it to xfsdump?

And dmapi and xfstests, for that matter...

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
