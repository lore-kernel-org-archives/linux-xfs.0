Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0M1pKFe015290 for <xfs@oss.sgi.com>; Wed, 21 Jan 2009 19:51:20 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0F33AA4DF
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2009 17:50:34 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	RMgrZiGEtmAHuuD5 for <xfs@oss.sgi.com>;
	Wed, 21 Jan 2009 17:50:34 -0800 (PST)
Date: Thu, 22 Jan 2009 09:58:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20090121225800.GO10158@disturbed>
References: <20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com>
	<20090120114906.GA12526@infradead.org>
	<20090120121335.GA19182@infradead.org>
	<20090120124515.GA31838@infradead.org> <4975D88B.7020906@gmail.com>
	<20090120140514.GA2976@infradead.org>
	<4975DE45.7050004@gmail.com> <20090121040512.GK10158@disturbed>
	<4976E524.1050607@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4976E524.1050607@gmail.com>
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
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

On Wed, Jan 21, 2009 at 10:04:36AM +0100, Jacek Luczak wrote:
> Dave Chinner pisze:
> > Please try the patch I posted this morning - it fixes the problem
> > properly and shouldn't have this side effect.
> 
> Your patch work for me. I've made also some tests a'la one proposed by
> Christoph, here also everything works. Good work guys!

Thanks for testing the fix, Jacek. I'll get it pushed upstream
now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
