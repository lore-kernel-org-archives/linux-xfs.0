Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 403917CA7
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2016 20:45:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 111B38F8037
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2016 18:45:22 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id WHY772nN2MT4g3ur (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Sep 2016 18:45:19 -0700 (PDT)
Date: Sat, 3 Sep 2016 02:45:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
	detected
Message-ID: <20160903014514.GB2356@ZenIV.linux.org.uk>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
	<1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
	<20160903003919.GI30056@dastard>
	<CA+55aFy17iuUYRSLO=e1e+W5oW8GRYy93myk816UjRgEFxQDOw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFy17iuUYRSLO=e1e+W5oW8GRYy93myk816UjRgEFxQDOw@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, CAI Qian <caiqian@redhat.com>, xfs@oss.sgi.com

On Fri, Sep 02, 2016 at 05:57:04PM -0700, Linus Torvalds wrote:
> On Fri, Sep 2, 2016 at 5:39 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > Fundamentally a splice infrastructure problem.
> =

> Yeah, I don't really like how we handle the pipe lock.
> =

> It *might* be possible to instead just increment the reference
> counters as we build a kvec[] array of them, and simply do teh write
> without holding the pipe lock at all.
> =

> That has other problems, ie concurrect spices from the same pipe would
> possibly write the same data multiple times, though.
> =

> But yes, the fundamental problem is how splice wants to take the pipe
> lock both early and late. Very annoying.

We could, in principle, add another flavour of iov_iter, with bvec
array attached to it with copy_page_to_iter() sticking an extra ref to that
page into array.  Then, under pipe lock, feed that thing to ->read_iter()
and do an equivalent of splice_to_pipe() that would take bvec array instead
of struct page */struct partial_page arrays.

Hell, we could even have copy_to_iter() for these puppies allocate a page,
stick it into the next bvec and copy into it.  Especially if we have those
bvec zeroed, with copy_page_to_iter() leaving ->bvec pointing to the next
(unused) bvec and copy_to_iter() doing that only when a page had been
completely filled.  I.e.

copy_page_to_iter()
	if (!iter->nr_segs)
		return 0;
	if (iter->bvec->bv_page) {
		iter->bvec++;
		if (!--iter->nr_segs)
			return 0;
	}
	stick (page,offset,bytes) into iter->bvec
	iter->bvec++;
	iter->nr_segs--;
	return bytes;

copy_to_iter():
	wanted =3D bytes;
	while (bytes && iter->nr_segs) {
		if (!iter->bvec->bv_page)
			iter->bvec->bv_page =3D alloc_page()
		n =3D min(PAGE_SIZE - iter->bvec->bv_len, bytes);
		memcpy_to_page(addr, iter->bvec->bv_len, n);
		bytes -=3D n;
		iter->bvec->bv_len +=3D n;
		if (iter->bvec->bv_len =3D=3D PAGE_SIZE) {
			iter->bvec++;
			iter->nr_segs--;
		}
	}
	return wanted - bytes;

That should suffice for quite a few of read_iter-using file_operations,
if not for all of them.  pipe lock is on the outside, same as for write
side *and* for=A0default_file_splice_read().  And filesystem gets the
same locking it would for read(2)/readv(2)/etc...

Comments?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
