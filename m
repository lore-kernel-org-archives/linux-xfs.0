Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p57DmgZY026373 for <xfs@oss.sgi.com>; Tue, 7 Jun 2011 08:48:42 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A8B0E1ED5D66
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2011 06:48:40 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id 0LKuljsfZ8gWXh1F
	for <xfs@oss.sgi.com>; Tue, 07 Jun 2011 06:48:40 -0700 (PDT)
Message-ID: <4DEE2C36.8030008@profihost.ag>
Date: Tue, 07 Jun 2011 15:48:38 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: XFS: accounting of reclaimable inodes is incorrect
References: <4DEE0EA4.9090002@profihost.ag>
	<20110607115441.GA4653@infradead.org>
	<4DEE2078.3010102@profihost.ag>
	<20110607133429.GA9049@infradead.org>
In-Reply-To: <20110607133429.GA9049@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Am 07.06.2011 15:34, schrieb Christoph Hellwig:
> On Tue, Jun 07, 2011 at 02:58:32PM +0200, Stefan Priebe - Profihost AG wrote:
> Linux 2.6.32 isn't really something supported by us.  It's not just a
> very old codebase, but also one where a lot of the XFS code was pretty
> much in flux.  If you want supported old releases work use one of
> the commercially supported one like RedHat or SuSE.
OK so my thought was totally wrong. I thought the longterm stable 
releases will still get bugfixed by SGI or whoever wrote the stuff. 
Sorry for that then. But what is then the idea of a longterm stable?

>> Redhat seems to have fixed it on it's own:
>> https://bugzilla.redhat.com/show_bug.cgi?id=642680
>
> I suspect the upstream commit you want is
> 081003fff467ea0e727f66d5d435b4f473a789b3, but I can't gurantee this
> actually applies to the 2.6.32 codebase.
No it doesn't. I already tried to implement it into current 2.6.32.41 code.

Greets Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
