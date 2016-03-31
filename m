Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D9E227CA0
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 14:48:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A856D8F8052
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 12:48:03 -0700 (PDT)
Received: from mail-io0-f195.google.com (mail-io0-f195.google.com
	[209.85.223.195]) by cuda.sgi.com with ESMTP id
	hCAMlW7ydRSsZuUm (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 31 Mar 2016 12:47:58 -0700 (PDT)
Received: by mail-io0-f195.google.com with SMTP id q128so14937866iof.2
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 12:47:58 -0700 (PDT)
Subject: Re: fallocate mode flag for "unshare blocks"?
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20160331180821.GD22462@fieldses.org>
Date: Thu, 31 Mar 2016 13:47:50 -0600
Message-Id: <779E9BCF-8224-44FE-8AAE-E0341A7B475C@dilger.ca>
References: <20160302155007.GB7125@infradead.org>
	<20160330182755.GC2236@birch.djwong.org>
	<20160331011813.GJ30721@dastard>
	<20160331075440.GA4209@infradead.org>
	<20160331111850.GP11812@dastard>
	<20160331180821.GD22462@fieldses.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4612191233703215933=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>


--===============4612191233703215933==
Content-Type: multipart/signed; boundary="Apple-Mail=_65FDF3D5-A690-4317-889A-FA2B05734D3A"; protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_65FDF3D5-A690-4317-889A-FA2B05734D3A
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Mar 31, 2016, at 12:08 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> 
> On Thu, Mar 31, 2016 at 10:18:50PM +1100, Dave Chinner wrote:
>> On Thu, Mar 31, 2016 at 12:54:40AM -0700, Christoph Hellwig wrote:
>>> On Thu, Mar 31, 2016 at 12:18:13PM +1100, Dave Chinner wrote:
>>>> On Wed, Mar 30, 2016 at 11:27:55AM -0700, Darrick J. Wong wrote:
>>>>> Or is it ok that fallocate could block, potentially for a long time as
>>>>> we stream cows through the page cache (or however unshare works
>>>>> internally)?  Those same programs might not be expecting fallocate to
>>>>> take a long time.
>>>> 
>>>> Yes, it's perfectly fine for fallocate to block for long periods of
>>>> time. See what gfs2 does during preallocation of blocks - it ends up
>>>> calling sb_issue_zerout() because it doesn't have unwritten
>>>> extents, and hence can block for long periods of time....
>>> 
>>> gfs2 fallocate is an implementation that will cause all but the most
>>> trivial users real pain.  Even the initial XFS implementation just
>>> marking the transactions synchronous made it unusable for all kinds
>>> of applications, and this is much worse.  E.g. a NFS ALLOCATE operation
>>> to gfs2 will probab;ly hand your connection for extended periods of
>>> time.
>>> 
>>> If we need to support something like what gfs2 does we should have a
>>> separate flag for it.
>> 
>> Using fallocate() for preallocation was always intended to
>> be a faster, more efficient method allocating zeroed space
>> than having userspace write blocks of data. Faster, more efficient
>> does not mean instantaneous, and gfs2 using sb_issue_zerout() means
>> that if the hardware has zeroing offloads (deterministic trim, write
>> same, etc) it will use them, and that will be much faster than
>> writing zeros from userspace.
>> 
>> IMO, what gfs2 is definitely within the intended usage of
>> fallocate() for accelerating the preallocation of blocks.
>> 
>> Yes, it may not be optimal for things like NFS servers which haven't
>> considered that a fallocate based offload operation might take some
>> time to execute, but that's not a problem with fallocate. i.e.
>> that's a problem with the nfs server ALLOCATE implementation not
>> being prepared to return NFSERR_JUKEBOX to prevent client side hangs
>> and timeouts while the operation is run....
> 
> That's an interesting idea, but I don't think it's really legal.  I take
> JUKEBOX to mean "sorry, I'm failing this operation for now, try again
> later and it might succeed", not "OK, I'm working on it, try again and
> you may find out I've done it".
> 
> So if the client gets a JUKEBOX error but the server goes ahead and does
> the operation anyway, that'd be unexpected.

Well, the tape continued to be mounted in the background and/or the file
restored from the tape into the filesystem...

> I suppose it's comparable to the case where a slow fallocate is
> interrupted--would it be legal to return EINTR in that case and leave
> the application to sort out whether some part of the allocation had
> already happened?

If the later fallocate() was not re-doing the same work as the first one,
it should be fine for the client to re-send the fallocate() request.  The
fallocate() to reserve blocks does not touch the blocks that are already
allocated, so this is safe to do even if another process is writing to the
file.  If you have multiple processes writing and calling fallocate() with
PUNCH/ZERO/COLLAPSE/INSERT to overlapping regions at the same time then
the application is in for a world of hurt already.

> Would it be legal to continue the fallocate under the covers even after
> returning EINTR?

That might produce unexpected results in some cases, but it depends on
the options used.  Probably the safest is to not continue, and depend on
userspace to retry the operation on EINTR.  For fallocate() doing prealloc
or punch or zero this should eventually complete even if it is slow.

Cheers, Andreas

> But anyway my first inclination is to say that the NFS FALLOCATE
> protocol just wasn't designed to handle long-running fallocates, and if
> we really need that then we need to give it a way to either report
> partial results or to report results asynchronously.
> 
> --b.





--Apple-Mail=_65FDF3D5-A690-4317-889A-FA2B05734D3A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVv1+53Kl2rkXzB/gAQhZqw//fFFv84kEe1JyjFDEn9izxwBNuFWV12DA
VqeaTu5+ecxVVvp37mo6cL/aoFmoHGEBvJdin82q4iFBmT9egVgDt18cOs8jEK55
HKwT1MIJdnbJGZxkkVIvTExK5yN3VOEzfQ7FrifzVVE8kvFqusrIxQ2peWjbjECC
m/U1jljzc/eWgGuEWqk1nz6EBmHKRYMagVEOJYmXgd3aq5bmLEa2pkIGXEE2e9OS
XlEDRsmv7hOH7yBbcrguarszbXJdtj09mNRHNlSFlgtJFVLC4WHj4bCwZi5OebJ/
MTSyIkNFoRd59h0gaRtwUXDqRivBQ2GLc96OqCiSMU/4uysVs+z4KPA+QWaU0Jgy
FUWcCgu4k2rwrHvE4mXk5IbAu8uAT5aiSk7D4+QStUzbbRA0cGhtnansduMtTP1A
1t9iik9wtykm+VzEeJGEdfCe5v7od947bdR219GbVkNkBsh7oKMNiBgZBpwov9oh
LXhf6hrhHJqGMAc9WOTRazG66k9oWLAnpbYnOXitmD/sJXIRtHP02uFmDVyLLZsA
VqaPKdarP5tzzXOJfdVb1AXB1DVzL4W8PnXjBLWFRHebftmi3OGtVcBxIrQLai3r
FSs0MEaOjIT/QT576Nxtma4WPu5FbdaYO02tV3UCPwKXI+XnogJ32ZICu96nk1pc
1Tc9h6MjPBM=
=5o0N
-----END PGP SIGNATURE-----

--Apple-Mail=_65FDF3D5-A690-4317-889A-FA2B05734D3A--


--===============4612191233703215933==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4612191233703215933==--
