Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0KEX0Wx019213 for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 08:33:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 44FFCA1B5A
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 06:32:59 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id VvIdPi66Q28RxW3D for
	<xfs@oss.sgi.com>; Tue, 20 Jan 2009 06:32:59 -0800 (PST)
Date: Tue, 20 Jan 2009 09:32:57 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20090120143257.GA21073@infradead.org>
References: <4974CA20.6050308@sandeen.net> <20090120004611.GA6445@disturbed>
	<20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com>
	<20090120114906.GA12526@infradead.org>
	<20090120121335.GA19182@infradead.org>
	<20090120124515.GA31838@infradead.org> <4975D88B.7020906@gmail.com>
	<20090120140514.GA2976@infradead.org> <4975DE45.7050004@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4975DE45.7050004@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

On Tue, Jan 20, 2009 at 03:23:01PM +0100, Jacek Luczak wrote:
> I've applied it and now running ,,fixed'' kernel. What I've notice is:
> $ LC_ALL=C df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda1              20G  -40E   40E   -  /
> /dev/sda5              20G  -23E   23E   -  /home
> /dev/sda6              56G   56G  774M  99% /NORA
> /dev/sda7              45G   44G  1.2G  98% /MAGAZYN

Yeah, it's more of a hack.  If you drop the patch and just enable
CONFIG_LBD it should be fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
