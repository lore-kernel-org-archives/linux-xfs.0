Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 152067CA0
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2016 07:31:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DD2EF8F8039
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2016 05:31:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FkWtJtbzQQlUyni8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 18 Mar 2016 05:31:10 -0700 (PDT)
Date: Fri, 18 Mar 2016 12:31:07 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: xfs_growfs causing "Metadata corruption detected at
	xfs_agf_read_verify"
Message-ID: <20160318123107.GB8856@redhat.com>
References: <20160317224803.GA8856@redhat.com> <56EB35F8.1030601@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56EB35F8.1030601@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Mar 17, 2016 at 05:55:52PM -0500, Eric Sandeen wrote:
> On 3/17/16 5:48 PM, Richard W.M. Jones wrote:
> > 
> > With recent kernels (or maybe xfsprogs?) we've noticed strange
> > filesystem corruption after using xfs_growfs.
> > 
> > Examples:
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=1315895 (on aarch64)
> > https://www.redhat.com/archives/libguestfs/2016-March/msg00113.html (x86_64)
> > https://rwmj.wordpress.com/2015/11/04/virt-builder-fedora-23-image/#comment-15668 (x86_64)
> > 
> > Do these errors look familiar?  I don't yet have a simple test case,
> > still working on that.
> 
> try:
> http://oss.sgi.com/pipermail/xfs/2016-March/047683.html

I've tried this patch now, but I still can't get a solid reproducer
(one that doesn't involve using aarch64).

I just tried to create a filesystem on kernel 4.6.0, grow it on 4.6.0,
then copy it to another machine with 4.4.4.  However that didn't
reproduce the bug, so I couldn't verify if the patch fixes the bug.
(Maybe 4.4.4 is too new?)

Can you help me to understand under what circumstances this bug would
appear, as far as you understand what's happening?

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-p2v converts physical machines to virtual machines.  Boot with a
live CD or over the network (PXE) and turn machines into KVM guests.
http://libguestfs.org/virt-v2v

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
