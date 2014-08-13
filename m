Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C62A47F3F
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 19:03:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A5390304032
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 17:03:42 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	nVhjC05lrA2cfbxZ for <xfs@oss.sgi.com>;
	Tue, 12 Aug 2014 17:03:39 -0700 (PDT)
Date: Wed, 13 Aug 2014 10:03:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: use-after-free on log replay failure
Message-ID: <20140813000312.GC20518@dastard>
References: <4B2A412C75324EE9880358513C069476@alyakaslap>
	<9D3CBECB663B4A77B7EF74B67973310A@alyakaslap>
	<20140804230721.GA20518@dastard>
	<AC10852F403846A182491ED8071135ED@alyakaslap>
	<20140806152042.GB39990@bfoster.bfoster>
	<CAOcd+r3bC59m7Rh-3tmjrnWnF5XoPQfE=U+=hz78NcAGu+Ou1g@mail.gmail.com>
	<20140811132057.GA1186@bfoster.bfoster>
	<20140811215207.GS20518@dastard>
	<20140812120341.GA46654@bfoster.bfoster>
	<DC407F6E8F8C4EE1AF7117D7D6ABF282@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <DC407F6E8F8C4EE1AF7117D7D6ABF282@alyakaslap>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Aug 12, 2014 at 03:39:02PM +0300, Alex Lyakas wrote:
> Then I set up the following Device Mapper target onto /dev/vde:
> dmsetup create VDE --table "0 41943040 linear-custom /dev/vde 0"
> I am attaching the code (and Makefile) of dm-linear-custom target.
> It is exact copy of dm-linear, except that it has a module
> parameter. With the parameter set to 0, this is an identity mapping
> onto /dev/vde. If the parameter is set to non-0, all WRITE bios are
> failed with ENOSPC. There is a workqueue to fail them in a different
> context (not sure if really needed, but that's what our "real"
> custom
> block device does).

FWIW, now I've looked at the dm module, this could easily be added
to the dm-flakey driver by adding a "queue_write_error" option
to it (i.e. similar to the current drop_writes and corrupt_bio_byte
options).

If we add the code there, then we could add a debug-only XFS sysfs
variable to trigger the log recovery sleep, and then use dm-flakey
to queue and error out writes. That gives us a reproducable xfstest
for this condition. Brian, does that sound like a reasonable plan to
you?

Thanks for describing the method you've been using to reproduce the
bug so clearly, Alex.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
