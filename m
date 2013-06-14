Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C8D617CBF
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 19:53:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 97F9C8F8037
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 17:53:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hjCYQlY7ZYhEEBUQ for
	<xfs@oss.sgi.com>; Thu, 13 Jun 2013 17:53:25 -0700 (PDT)
Message-ID: <51BA6981.407@redhat.com>
Date: Thu, 13 Jun 2013 19:53:21 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 01/27] xfs: update mount options documentation
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
	<1371032567-21772-2-git-send-email-david@fromorbit.com>
	<51B9CA59.6010706@sandeen.net> <20130614004052.GO29338@dastard>
In-Reply-To: <20130614004052.GO29338@dastard>
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
Cc: xfs@oss.sgi.com

On 6/13/13 7:40 PM, Dave Chinner wrote:
>>> +
>>> > > +	The sunit and swidth parameters specified must be compatible
>>> > > +	with the existing filesystem alignment characteristics. If
>>> > > +	the filesystem was not created with data alignment
>>> > > +	constraints, then it may be impossible to set a valid sunit
>>> > > +	(and hence swidth) value.  In general, that means the only
>>> > > +	valid changes to sunit are increasing it by a power-of-2
>>> > > +	multiple. Valid swidth values are any integer multiple of a
>>> > > +	valid sunit value.
>> > 
>> > now I'm confused.  It's only relevant to a filesystem w/ geometry
>> > specified, but if it wasn't specified, it may be possible . . . ?
>> > And if nothing was specified (i.e. 0 su/sw) then we can only increase
>> > that 0 by a power of 2?
>> > 
>> > 
>>> > > +	For filesystems that have existing data alignment values on
>>> > > +	disk (i.e. specified by mkfs), any new valid values passed
>>> > > +	in as mount options will overwrite the values stored on
>>> > > +	disk. Hence this mount option does not need to be specified
>>> > > +	for every mount operation in this case.
>> > 
>> > so I think this all needs to clarify whether it works on filesystems
>> > w/o existing geometry, or not.  And "why you might want this" would
>> > be helpful too.
> It's obviously too complex to explain everything in a short "what"
> description. I suspect that the best thing to do here is simply
> document it as a method of changing alignment for a device that has
> changed geometry such as a adding a disk to a MD RAID5 device. I'm
> going to drop any reference to sunit/swidth being zero because that
> case was a hack for fixing a CXFS client bug.
> 


Ok, fair enough on the what not why.

But FWIW, even if we aren't saying why, just what, the docs seem
inconsistent here.

It talks about existing geometry being required for this option, but also
says what happens if it's not.

If you drop that part, then that sounds good.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
