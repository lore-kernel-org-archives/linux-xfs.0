Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o62HkFhC252906 for <xfs@oss.sgi.com>; Fri, 2 Jul 2010 12:46:15 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D38851584D50
	for <xfs@oss.sgi.com>; Fri,  2 Jul 2010 10:49:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bf9rA5i2bPiWe6OC for
	<xfs@oss.sgi.com>; Fri, 02 Jul 2010 10:49:03 -0700 (PDT)
Message-ID: <4C2E2687.3080700@redhat.com>
Date: Fri, 02 Jul 2010 12:48:55 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH xfstests] _qmount: mount w/o selinux xattrs
References: <4C2CF34F.7070008@redhat.com>
	<20100702071006.GB30776@infradead.org>
In-Reply-To: <20100702071006.GB30776@infradead.org>
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
Cc: xfs mailing list <xfs@oss.sgi.com>

On 07/02/2010 02:10 AM, Christoph Hellwig wrote:
> On Thu, Jul 01, 2010 at 02:58:07PM -0500, Eric Sandeen wrote:
>> when selinux is on it can change quota usage due to extra
>> xattr blocks.
>>
>> Mounting with a context prevents this.  We already do so
>> for xfs in general because so many things look at detailed
>> on-disk format, and extra xattrs confuses those tests.
>>
>> For other filesystems, we've left selinux alone so far, 
>> as that seemed the best way to test.
>>
>> However, it throws quota accounting off, so add a fixup
>> in _qmount()
> 
> What about just disabling selinux for all filesystems instead of just
> XFS for the general case.

Well it seems like if we -can- test with it on, that's good.
Certain distros ship with it on by default, so exercising lots
of scenarios with it on seems beneficial...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
