Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 850407F37
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 03:14:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D1EFFAC00C
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 01:14:21 -0700 (PDT)
Received: from e28smtp08.in.ibm.com (e28smtp08.in.ibm.com [122.248.162.8]) by
	cuda.sgi.com with ESMTP id LH87OwiftPsIX2tv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 28 Aug 2013 01:14:19 -0700 (PDT)
Received: from /spool/local
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <chandan@linux.vnet.ibm.com>;
	Wed, 28 Aug 2013 13:32:54 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 718F9E0057
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 13:44:47 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r7S8Fn5M35913844
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 13:45:49 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r7S8E97g018580 for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 13:44:10 +0530
From: chandan <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] xfstests: generic/255: Execute only if blocksize <= 4096
Date: Wed, 28 Aug 2013 13:44:09 +0530
Message-ID: <8507420.Xnl9a5Gq1S@localhost.localdomain>
In-Reply-To: <521CD7FC.1080706@sandeen.net>
References: <2909046.09LYLQvZ6q@localhost.localdomain>
	<3942763.p7a9her5Nt@localhost.localdomain>
	<521CD7FC.1080706@sandeen.net>
MIME-Version: 1.0
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
Cc: Eric Sandeen <sandeen@redhat.com>, sekharan@linux.vnet.ibm.com, xfs@oss.sgi.com

On Tuesday, August 27, 2013 11:46:52 AM Eric Sandeen wrote:
> On 8/27/13 7:16 AM, chandan wrote:
> > On Monday, August 26, 2013 09:29:31 AM Eric Sandeen wrote:
> >>
> >> Just as a sanity check, does it also fail on xfs for 64k block sizes on ppc64?
> >>
> > 
> > Yes, it does fail as shown below:
> > 
> 
> (removing linux-btrfs for now):
> 
> Hohum, I get failures on 2k and even 4k blocksize xfs (and ext4) on ppc64 as well.
> (this was on a 3.10 kernel)
> 
> Have you seen this?
> 
> I guess I'm a little reluctant to restrict the test to <=4k until we understand
> what all the issues are and at least see it passing on the smaller block
> sizes... do they work for you?
> 
> -Eric
>

Eric,

I have posted a patch that fixes _test_generic_punch() to obtain the correct
block size. With that patch applied, the code works for 4k blocksize for
both xfs and ext4.

Even the with the above mentioned fix applied, the code doesn't work with
block sizes != 4k. The extent ranges in 255.out were obtained for 4k block
sizes and hence they don't work for other block sizes. I will repost the
patch to restrict execution of generic/255 only when the block size is 4k.

- chandan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
