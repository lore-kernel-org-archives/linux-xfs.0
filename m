Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4HFoLMc190676 for <xfs@oss.sgi.com>; Tue, 17 May 2011 10:50:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 855D0CC790F
	for <xfs@oss.sgi.com>; Tue, 17 May 2011 08:50:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id XqSJlgPnpwGbtp4u for
	<xfs@oss.sgi.com>; Tue, 17 May 2011 08:50:20 -0700 (PDT)
Date: Tue, 17 May 2011 11:50:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: system hangs 2.6.39-rc7 xfs related
Message-ID: <20110517155018.GB17735@infradead.org>
References: <87ei3y7aei.fsf@sycorax.lbl.gov>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87ei3y7aei.fsf@sycorax.lbl.gov>
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
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, May 16, 2011 at 11:44:37AM -0700, Alex Romosan wrote:
> my system just sort of locked up and everything that's trying to write
> to disk is stuck. dmesg gives me this:

This looks quite similar to a few other XFS issues in the .39 cycle.
Can you upgrade to latest Linus HEAD which has fixes for these similar
issues and see if that fixes your issues?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
