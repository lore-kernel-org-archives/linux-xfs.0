Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9D86F7F62
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 14:47:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6DA5E304048
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 12:47:01 -0700 (PDT)
Received: from mail.samba.org (fn.samba.org [216.83.154.106]) by cuda.sgi.com
	with ESMTP id Npvp5e3FRROqNC4X (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 12:47:00 -0700 (PDT)
Date: Fri, 26 Sep 2014 12:46:56 -0700
From: Jeremy Allison <jra@samba.org>
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
Message-ID: <20140926194656.GC13066@samba2>
References: <20140918195650.GI19952@sgi.com> <20140922222611.GZ4322@dastard>
	<5422C540.1060007@sgi.com> <20140924231024.GA4758@dastard>
	<54257D3F.70302@sgi.com> <20140926165605.GA25274@infradead.org>
	<20140926170407.GB6012@samba2> <5425C067.7080904@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5425C067.7080904@sgi.com>
Reply-To: Jeremy Allison <jra@samba.org>
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
To: Olaf Weber <olaf@sgi.com>
Cc: tinguely@sgi.com, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, linux-fsdevel@vger.kernel.org, Jeremy Allison <jra@samba.org>

On Fri, Sep 26, 2014 at 09:37:11PM +0200, Olaf Weber wrote:
> 
> My argument against "mount time case-insensitivity" and for "mkfs
> time case-insensitivity" is related to switching from the
> case-sensitive domain to the case-insensitive one.
> 
> For case-sensitive, from "README" to "readme" there are 64 different
> possible filenames.  Let's say you create 63 out of these 64. Now
> remount the filesystem case-insensitive, and try to open by the 64th
> version of "readme". It is not an exact match for any of the 63
> candidate files, and a case-insensitive match to all 63 candidate
> files. Which of these 63 files should be opened, and why that one in
> particular?

I'm ok with "mkfs time case-insensitivity" - really !
Most of my OEMs would set that and claim victory (few
of them care much about NFS semantics :-).

> >Having CI matching can speed up Samba operations by a
> >factor of 10 on large directories (warning, number made
> >up, depending on the number of entries per dir :-).
> 
> I really want that to be true, but the proof of the pudding...

No it really *is* true. The reason I can't give
exact numbers is it depends on the number of entries.

Remember, for every cache *miss*, we have to scan
the entire directory.

So a user asks for README, and we attempt that
and it fails. So now we have to enumerate the
entire directory to see if READMe (or any other
case varient) exists.

Now do that in a directory with 10, 100, 1000,
.... 10000000 existing files (don't laugh, I've
seen an application for Music files that did
*exactly* that). On a case insensitive filesystem
you just request README and you're done.

Certain vendors who shall remain nameless :-)
created test cases of just this example to
show how much storage on Linux sucks. Not
a happy camper about that - and telling them
to use ZFS on FreeBSD or Solaris just doesn't
feel right :-).

Jeremy.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
