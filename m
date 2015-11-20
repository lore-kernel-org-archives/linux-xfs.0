Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 03D7A7F37
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 14:07:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E8015304062
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 12:07:45 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 3nxZMCRVwYlNVTh3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 20 Nov 2015 12:07:42 -0800 (PST)
Date: Fri, 20 Nov 2015 15:07:33 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH] xfs: support for non-mmu architectures
Message-ID: <20151120200733.GA350@thunk.org>
References: <1447800381-20167-1-git-send-email-octavian.purdila@intel.com>
	<20151119232455.GM14311@dastard>
	<CAFLxGvx9x-4gnCQh7203G72Jy+EULbMnGTK=2r3ko=Yy9FB7Wg@mail.gmail.com>
	<20151120005843.GP14311@dastard>
	<CAE1zotLw-vCz2qF4JmXEYFF_yPbkhQ2HEEYxMwvdRbhKRCaxTw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAE1zotLw-vCz2qF4JmXEYFF_yPbkhQ2HEEYxMwvdRbhKRCaxTw@mail.gmail.com>
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
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>

On Fri, Nov 20, 2015 at 04:26:28PM +0200, Octavian Purdila wrote:
> It is already possible to mount arbitrary filesystem images in
> userspace using VMs . LKL doesn't change that, it just reduces the
> amount of dependencies you need to do so.

It is true that you can mount arbitrary file systems in userspace
using VM's.  But those the kvm binary is typically not run with root
privileges in the host OS --- at least, not if the system
administrator is smart.  So a root compromise does not cause a
catastrophic security vulnerability, and if the guest OS crashes ---
again, not a real problem.

In the caase where people are trying to claim that containers are just
as secure as VM's, and plan to give container "guest" system
administrators root-like powers, the question which immediately comes
to mind is whether the LKML/fuse daemon is running inside or outside
the container.  If it is outside the container, the a potential
security compromise of the binary running binary will be catastrophic
to the overall security of the host system and all of its containers.
If it is inside the container, you will be partially breaking the
illusion that the container works just like a VM (since a user runinng
"ps" will see all of these mysterious userspace processes that could
be killed, etc.), but it significantly reduces the security problems
if a maliciously crafted (or maliciously modulated) block device is
mounted.

> Could you expand of what burden does this use-case put on fs
> developers? I am sure that, if needed, we can put restrictions in LKL
> to avoid that.

The bottom line is who is going to get all of the support calls and
nasty e-mails explaining how our "crappy" code has caused some silly
container VM system administrator's customers $$$ worth of losses.  As
long as we can make sure that it's been underlined that the code is
being used well outside of its intended scope, and if it breaks, the
user gets to keep both pieces, and all complaints, threatened
lawsuits, etc. should go to the LKL maintainers or the purveyors of
said container-based products, I suppose that should be OK.  :-)

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
