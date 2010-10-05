Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o95IGmhV246283 for <xfs@oss.sgi.com>; Tue, 5 Oct 2010 13:16:51 -0500
Date: Tue, 5 Oct 2010 14:17:29 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: Re: -mm: xfs lockdep warning
Message-ID: <20101005181729.GA30877@lst.de>
References: <201009161546.16909.ruirui.r.yang@tieto.com>
	<20100917005227.GJ24409@dastard>
	<20100920191355.GA28443@infradead.org>
	<AANLkTi=45J+=ytj=NC4bYTVJFRakNQQiFd35K7mrf+Gq@mail.gmail.com>
	<4CA997DF.5030008@kernel.org> <20101004092107.GJ4681@dastard>
	<AANLkTi=3jjoCtYoK0endt8OM=omygO284WN2ZQZ=jceo@mail.gmail.com>
	<4CAB5779.5020901@kernel.org> <4CAB5874.9060106@kernel.org>
	<AANLkTikzvD6B=8bGp6h2+bjV5BimErqLOgt2Ujsn053C@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTikzvD6B=8bGp6h2+bjV5BimErqLOgt2Ujsn053C@mail.gmail.com>
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
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Yang Ruirui <ruirui.r.yang@tieto.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Tue, Oct 05, 2010 at 08:09:58PM +0200, Torsten Kaiser wrote:
> Here is the complete log from bootup until the hang happened the second time.
> I just logged into KDE and then started the upgrade of KOffice, which
> meant that the package manager started to compile 4 programs each with
> -j5. After a few minutes the load got to ~18 and probably at the point
> where filecache and GCCs filled up my 4GB RAM the system got stuck.
> The mouse so longer moved and SysRq+S did not work. The log was
> captured via serial console on a second system.
> 
> I will try tomorrow with frame pointers enabled..

Lots of hangs in sync_page and dm-crypt in the stack is unfortunately
something we've seen quite a few times, and it usually points to that
layer.  In the best case we might just have a similar workqueue priority
issue somewhere in the dm-crypt or maybe just md code. 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
