Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A32C47F56
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 10:56:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 35C2AAC00F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 08:56:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id l14IfobKmD47krxc for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 08:56:20 -0700 (PDT)
Message-ID: <53569123.2080807@sandeen.net>
Date: Tue, 22 Apr 2014 10:56:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: bulletfproof xfs_qm_scall_trunc_qfiles()
References: <53558354.5040309@redhat.com>	<20140422062736.GA31337@infradead.org>
	<535663CB.5080309@oracle.com>
In-Reply-To: <535663CB.5080309@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On 4/22/14, 7:42 AM, Jeff Liu wrote:
> 
> On 04/22 2014 14:27 PM, Christoph Hellwig wrote:
>> On Mon, Apr 21, 2014 at 03:45:08PM -0500, Eric Sandeen wrote:
>>> Coverity noticed that if we sent junk into
>>> xfs_qm_scall_trunc_qfiles(), we could get back an
>>> uninitialized error value.  So sanitize the flags we
>>> will accept, and initialize error anyway for good measure.
>>>
>>> (This bug may have been introduced via c61a9e39).
> 
> Indeed, my mistake.

No worries, it's a very small thing, and programatically
impossible.  Not trying to point fingers, just looking for
whether it's a new warning or an old one.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
