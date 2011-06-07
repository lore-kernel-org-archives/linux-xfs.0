Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p57E9q3G027057 for <xfs@oss.sgi.com>; Tue, 7 Jun 2011 09:09:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F3C94A6352
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2011 07:09:51 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	hL6NvN4IKV8A3SIy for <xfs@oss.sgi.com>;
	Tue, 07 Jun 2011 07:09:51 -0700 (PDT)
Date: Tue, 7 Jun 2011 10:09:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS: accounting of reclaimable inodes is incorrect
Message-ID: <20110607140949.GA31769@infradead.org>
References: <4DEE0EA4.9090002@profihost.ag>
	<20110607115441.GA4653@infradead.org>
	<4DEE2078.3010102@profihost.ag>
	<20110607133429.GA9049@infradead.org>
	<4DEE2C36.8030008@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DEE2C36.8030008@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: xfs@oss.sgi.com

On Tue, Jun 07, 2011 at 03:48:38PM +0200, Stefan Priebe - Profihost AG wrote:
> Am 07.06.2011 15:34, schrieb Christoph Hellwig:
> >On Tue, Jun 07, 2011 at 02:58:32PM +0200, Stefan Priebe - Profihost AG wrote:
> >Linux 2.6.32 isn't really something supported by us.  It's not just a
> >very old codebase, but also one where a lot of the XFS code was pretty
> >much in flux.  If you want supported old releases work use one of
> >the commercially supported one like RedHat or SuSE.
> OK so my thought was totally wrong. I thought the longterm stable
> releases will still get bugfixed by SGI or whoever wrote the stuff.
> Sorry for that then. But what is then the idea of a longterm stable?

I have no idea what the idea is, but it's clearly not viable for normal
kernel developers.  Backporting code to age old releases and QAing it is
a major effort, and people generally don't do it unless they are paid
for it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
