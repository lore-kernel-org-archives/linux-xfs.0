Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DB0077F6F
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 08:54:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6AB52AC001
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 06:54:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 8aC5W7imZKK0aLGP for <xfs@oss.sgi.com>;
	Fri, 24 Oct 2014 06:54:03 -0700 (PDT)
Message-ID: <544A59F7.4070601@sandeen.net>
Date: Fri, 24 Oct 2014 08:53:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: enable sparse checking
References: <54498F4A.9030207@redhat.com>
	<20141024061718.GA15341@infradead.org>
In-Reply-To: <20141024061718.GA15341@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 10/24/14 1:17 AM, Christoph Hellwig wrote:
> On Thu, Oct 23, 2014 at 06:29:14PM -0500, Eric Sandeen wrote:
>> Enable "make C=1" or "make C=2" to do sparse checking.
>> Blatantly ripped off from djwong's patch in e2fsprogs to
>> do the same.
>>
>> Note, this requires unreleased sparse after v0.5, which
>> enables the CHAR_BIT definition; otherwise it chokes.
> 
> I'm pretty sure I used to be able to do sparse checks on xfsprogs using
> 
> CC=cgcc make

Hm, so you can.

Ok, so maybe this is dumb, or is it convenient (to work like it does
in the kernel tree?)

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
