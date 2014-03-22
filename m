Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 889AA7F73
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2014 00:12:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D9F9BAC001
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 22:12:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id o7q0jtLgAmzATsz5 for
	<xfs@oss.sgi.com>; Fri, 21 Mar 2014 22:12:09 -0700 (PDT)
Date: Sat, 22 Mar 2014 01:12:05 -0400
From: Kyle McMartin <kmcmarti@redhat.com>
Subject: Re: [PATCH] xfsdump: don't assume getdents exists
Message-ID: <20140322051205.GB8095@redacted.bos.redhat.com>
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
> Hey Kyle - were you going to do a V2 of this one?
> 
> Just checking, thanks - 

i've got a pair of somewhat more substantial patches to fix the ifdef
hell in this file, clean things up so it works on both getdents64 only
and not, and then rips out the pre-2.4.1 getdents code.

https://github.com/jkkm/xfsdump/commit/e156bcf06effbf5f2e26c53efb0ce028c4281f9e
https://github.com/jkkm/xfsdump/commit/fff56b471220a8fa305b9158c4f8f0c7344c8fe6

the latter looks quite a bit better... care to take a quick look and if
they're decent, i'll submit them both.

--kyle

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
