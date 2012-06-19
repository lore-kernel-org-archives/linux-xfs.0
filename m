Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JEiMaT106047 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 09:44:22 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Iv0LMCAdJVzLCsIi for
	<xfs@oss.sgi.com>; Tue, 19 Jun 2012 07:44:21 -0700 (PDT)
Date: Tue, 19 Jun 2012 10:44:14 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Message-ID: <20120619144413.GA7225@redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org> <20120619015745.GJ25389@dastard>
	<20120619031241.GA3884@redhat.com>
	<alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com>
	<20120619131649.GA6811@redhat.com>
	<alpine.LFD.2.00.1206191519320.21961@dhcp-1-248.brq.redhat.com>
	<20120619133041.GB6811@redhat.com> <4FE0840F.2050704@shiftmail.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FE0840F.2050704@shiftmail.org>
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
To: Spelic <spelic@shiftmail.org>
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jun 19 2012 at  9:52am -0400,
Spelic <spelic@shiftmail.org> wrote:

> On 06/19/12 15:30, Mike Snitzer wrote:
> >I don't recall Spelic saying anything about EOPNOTSUPP. So what
> >has made you zero in on an -EOPNOTSUPP return (which should not be
> >happening)?
> 
> Exactly: I do not know if EOPNOTSUPP is being returned or not.
> 
> If this helps, I have configured dm-thin via lvm2
>   LVM version:     2.02.95(2) (2012-03-06)
>   Library version: 1.02.74 (2012-03-06)
>   Driver version:  4.22.0
> 
> from dmsetup table I only see one option : "skip_block_zeroing", if
> and only if I configure it with -Zn . I do not see anything
> regarding ignore_discard
> 
>      vg1-pooltry1-tpool: 0 20971520 thin-pool 252:1 252:2 2048 0 1
> skip_block_zeroing
>      vg1-pooltry1_tdata: 0 20971520 linear 9:20 62922752
>      vg1-pooltry1_tmeta: 0 8192 linear 9:20 83894272
>      vg1-thinlv1: 0 31457280 thin 252:3 1
> 
> 
> and in dmesg:
> [   33.685200] device-mapper: thin: Discard unsupported by data
> device (dm-2): Disabling discard passdown.
> [   33.709586] device-mapper: thin: Discard unsupported by data
> device (dm-6): Disabling discard passdown.
> 
> 
> I do not know what is the mechanism for which xfs cannot unmap
> blocks from dm-thin, but it really can't.
> If anyone has dm-thin installed he can try. This is 100%
> reproducible for me.

I was initially surprised by this considering the thinp-test-suite does
test a compilebench workload against xfs and ext4 using online discard
(-o discard).

But I just modified that test to use a thin-pool with 'ignore_discard'
and the test still passed on both ext4 and xfs.

So there is more work needed in the thinp-test-suite to use blktrace
hooks to verify that discards are occuring when the compilebench
generated files are removed.

I'll work through that and report back.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
