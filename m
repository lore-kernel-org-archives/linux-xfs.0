Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Oct 2006 17:54:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k940sWaG002037
	for <xfs@oss.sgi.com>; Tue, 3 Oct 2006 17:54:33 -0700
Received: from smtp110.sbc.mail.mud.yahoo.com (smtp110.sbc.mail.mud.yahoo.com [68.142.198.209])
	by cuda.sgi.com (Spam Firewall) with SMTP id B8DB24676ED
	for <xfs@oss.sgi.com>; Tue,  3 Oct 2006 17:53:50 -0700 (PDT)
Date: Tue, 3 Oct 2006 17:47:08 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: [RFC 0/3] Convert XFS inode hashes to radix trees
Message-ID: <20061004004708.GA17969@tuatara.stupidest.org>
References: <20061003060610.GV3024@melbourne.sgi.com> <20061003212335.GA13120@tuatara.stupidest.org> <20061003222256.GW4695059@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061003222256.GW4695059@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com, dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>

On Wed, Oct 04, 2006 at 08:22:56AM +1000, David Chinner wrote:

> That's a good question. In a recent thread on linux-fsdevel about
> these patches Christoph Hellwig pointed out that 32bit user space is
> not ready for 64 bit inodes, so it's probably going to be a while
> before the second half of this mod is ready (which exports 64 bit
> inodes ito userspace on 32bit platforms).

yes a patch changing struct kstat and filldir* was merged...

> http://marc.theaimsgroup.com/?l=linux-fsdevel&m=115946211808497&w=2
> http://marc.theaimsgroup.com/?l=linux-fsdevel&m=115948836023569&w=2

> As it stands, there's still a few barriers to getting 64 bit inodes
> on 32 bit platforms and I can't see them going away quickly. Right
> now I see little reason in moving to 64 bit inodes for 32 bit
> platforms for XFS because of the 16TB filesystem size limit (that
> only needs 33-36 bit inodes depending on the inode size) and no
> 32bit platform is currently able to repair a filesystem of that
> size.

so that leaves NFS3+

is it really worth the pain then?
