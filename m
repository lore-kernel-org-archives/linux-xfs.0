Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4KEKdfT105991 for <xfs@oss.sgi.com>; Wed, 20 May 2009 09:20:39 -0500
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4C1419F0FAA
	for <xfs@oss.sgi.com>; Wed, 20 May 2009 07:20:49 -0700 (PDT)
Received: from thunker.thunk.org (THUNK.ORG [69.25.196.29]) by cuda.sgi.com
	with ESMTP id vSSGlMG937Kz5ehx for <xfs@oss.sgi.com>;
	Wed, 20 May 2009 07:20:49 -0700 (PDT)
Date: Wed, 20 May 2009 10:20:38 -0400
From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT vs XFS at 80% filled filesystem
Message-ID: <20090520142038.GD24836@mit.edu>
References: <49F9565E.40804@gslab.com> <20090430183450.GB19276@mit.edu>
	<1242651808.3339.28.camel@alhena> <20090518131755.GJ32019@mit.edu>
	<1242798210.3457.4.camel@alhena> <20090520105011.GD3523@mit.edu>
	<1242820274.3457.12.camel@alhena>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1242820274.3457.12.camel@alhena>
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
To: Milind <milind@gslab.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Wed, May 20, 2009 at 05:21:14PM +0530, Milind wrote:
> my CFLAGS are
> CFLAGS=-Wl,--dynamic-linker,/home/miline/toolchain/x86_64-unknown-linux-gnu/glibc-2.7/lib/ld-linux-x86-64.so.2,--rpath,/home/miline/toolchain/x86_64-unknown-linux-gnu/glibc-2.7/lib/
> 
> libuuid.so is supposed to have dependancy
> on /home/miline/toolchain/x86_64-unknown-linux-gnu/glibc-2.7/lib/ld-linux-x86-64.so.2 (third entry in ldd output) right? And not on /lib64/ld-linux-x86-64.so.2
> 
> I tried modifying as follows but didn't really work. Any comments?
> 

I suggest you read the man page for "ld", in particular for the option
--rpath-link....

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
