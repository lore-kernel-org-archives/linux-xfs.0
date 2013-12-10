Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9A6447F76
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 14:01:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 372B1AC011
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 12:01:46 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DXzad9vxPX0Hdknt for
	<xfs@oss.sgi.com>; Tue, 10 Dec 2013 12:01:45 -0800 (PST)
Date: Tue, 10 Dec 2013 14:50:12 -0500
From: Kyle McMartin <kmcmarti@redhat.com>
Subject: Re: [PATCH] xfsdump: don't assume getdents exists
Message-ID: <20131210195012.GG31356@redacted.bos.redhat.com>
References: <20131106213635.GC24712@redacted.bos.redhat.com>
	<52A72930.4020404@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A72930.4020404@sandeen.net>
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
Cc: sandeen@redhat.com, xfs@oss.sgi.com

On Tue, Dec 10, 2013 at 08:46:08AM -0600, Eric Sandeen wrote:
> On 11/6/13, 3:36 PM, Kyle McMartin wrote:
> > New Linux ports are using a standard syscall list that does not include
> > deprecated syscalls where 64-bit clean alternatives exist. As a result,
> > on arm64, __NR_getdents is undefined, resulting in xfsdump failing to
> > build.
> > 
> > To avoid that, in the case where __NR_getdents is unset in unistd.h,
> > avoid building the fallback path entirely, since
> > __ASSUME_GETDENTS64_SYSCALL will be true, the SYS_getdents64 case will
> > be the primary (and only) path used.
> > 
> > Signed-off-by: Kyle McMartin <kyle@redhat.com>
> 
> Hey Kyle - were you going to do a V2 of this one?
> 
> Just checking, thanks - 
> -Eric
> 

Yeah, I can do that today. Thanks Eric.

--Kyle

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
