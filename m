Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3FD627CA0
	for <xfs@oss.sgi.com>; Sun, 27 Mar 2016 08:15:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C55D1AC001
	for <xfs@oss.sgi.com>; Sun, 27 Mar 2016 06:15:42 -0700 (PDT)
Received: from brightrain.aerifal.cx (216-12-86-13.cv.mvl.ntelos.net
	[216.12.86.13]) by cuda.sgi.com with ESMTP id 4lnlU7dAgxvl6iTQ
	for <xfs@oss.sgi.com>; Sun, 27 Mar 2016 06:15:37 -0700 (PDT)
Date: Sun, 27 Mar 2016 09:15:30 -0400
From: Rich Felker <dalias@libc.org>
Subject: Re: Build regressions/improvements in v4.6-rc1
Message-ID: <20160327131530.GX21636@brightrain.aerifal.cx>
References: <CAMuHMdXx80zs5VoA_aYc_wMn37O=fa6oXk-ovteHq0hGQYUUzg@mail.gmail.com>
	<CAMuHMdW3dfhZVT0e4tiqsbEPjYYA_hGUXQer1bQDeF2Gbs4WJg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAMuHMdW3dfhZVT0e4tiqsbEPjYYA_hGUXQer1bQDeF2Gbs4WJg@mail.gmail.com>
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
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux-sh list <linux-sh@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Cris <linux-cris-kernel@axis.com>, xfs@oss.sgi.com

On Sun, Mar 27, 2016 at 02:43:24PM +0200, Geert Uytterhoeven wrote:
> On Sun, Mar 27, 2016 at 2:39 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > Below is the list of build error/warning regressions/improvements in
> > v4.6-rc1[1] compared to v4.5[2].
> >
> > Summarized:
> >   - build errors: +9/-6
> 
> > [1] http://kisskb.ellerman.id.au/kisskb/head/10114/ (all 262 configs)
> > [2] http://kisskb.ellerman.id.au/kisskb/head/10047/ (all 262 configs)
> 
> > 9 error regressions:
> >   + /home/kisskb/slave/src/fs/xfs/xfs_ondisk.h: error: call to
> > '__compiletime_assert_79' declared with attribute error: XFS:
> > sizeof(xfs_attr_shortform_t) is wrong, expected 8:  => 79:2
> 
> cris-allyesconfig, cris-allmodconfig
> 
> >   + error: smp-shx3.c: undefined reference to `local_timer_setup':  =>
> > .text+0xadec)
> 
> shx3_defconfig

Thanks for catching this. I've prepared a patch and I'm checking
whether it fixes the problem.

Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
