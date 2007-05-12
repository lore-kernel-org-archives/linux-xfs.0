Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 12 May 2007 05:47:04 -0700 (PDT)
Received: from waste.org (waste.org [66.93.16.53])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4CCksfB023990
	for <xfs@oss.sgi.com>; Sat, 12 May 2007 05:46:56 -0700
Date: Sat, 12 May 2007 07:46:41 -0500
From: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an nlink problem?
Message-ID: <20070512124641.GZ11115@waste.org>
References: <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <20070510004918.GS85884050@sgi.com> <46426D31.8070000@goop.org> <20070510012609.GU85884050@sgi.com> <46433049.4020003@goop.org> <20070510153832.GQ11115@waste.org> <Pine.LNX.4.61.0705121320240.9570@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705121320240.9570@yvahk01.tjqt.qr>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, David Chinner <dgc@sgi.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, michal.k.k.piotrowski@gmail.com

On Sat, May 12, 2007 at 01:21:41PM +0200, Jan Engelhardt wrote:
> 
> On May 10 2007 10:38, Matt Mackall wrote:
> >> 
> >>     for i in `seq 20`; do
> >>     	hg clone -U --pull a b-$i
> >>     	hg verify b-$i		# always OK
> >>     	umount /home
> >>     	sleep 5
> >>     	mount /home
> >>     	hg verify b-$i		# often found truncated files
> >>     done
> >>       
> [...]
> >
> >This test looks like it should consist solely of open-for-append and
> >write on about 20k files in the target directory. Because of the
> >--pull, no hardlinks are involved. It shouldn't be all that different
> >from doing tar cf - a | tar xf - b.
> >
> >The files get visited in alphabetical order, so the start of the
> >corruption may be telling.
> 
> You should not assume alphabetical order. Filesystems may be free to
> reorder things and return them (1) randomly like in a hash (2) by
> creation time during readdir().

There is no assumption. Mercurial explicitly visits files in
alphabetical order for the above commands.

-- 
Mathematics is the supreme nostalgia of our time.
