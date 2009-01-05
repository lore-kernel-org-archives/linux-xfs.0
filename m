Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n05GM1BA000637 for <xfs@oss.sgi.com>; Mon, 5 Jan 2009 10:22:01 -0600
Received: from email.aon.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6BCC16140A
	for <xfs@oss.sgi.com>; Mon,  5 Jan 2009 08:21:59 -0800 (PST)
Received: from email.aon.at (nat-warsl417-02.aon.at [195.3.96.120]) by
	cuda.sgi.com with ESMTP id 8kgcE7aDSuiEHP2g for
	<xfs@oss.sgi.com>; Mon, 05 Jan 2009 08:21:59 -0800 (PST)
Received: from smarthub93.highway.telekom.at (HELO email.aon.at)
	([172.18.5.237]) (envelope-sender <peter.klotz@aon.at>)
	by fallback44.highway.telekom.at (qmail-ldap-1.03) with SMTP
	for <xfs@oss.sgi.com>; 5 Jan 2009 16:21:58 -0000
Message-ID: <49623384.2070801@aon.at>
Date: Mon, 05 Jan 2009 17:21:24 +0100
From: Peter Klotz <peter.klotz@aon.at>
MIME-Version: 1.0
Subject: Re: BUG: soft lockup - is this XFS problem?
References: <gifgp1$8ic$1@ger.gmane.org> <20081223171259.GA11945@infradead.org>
	<20081230042333.GC27679@wotan.suse.de>
	<20090103214443.GA6612@infradead.org>
	<20090105014821.GA367@wotan.suse.de>
	<20090105041959.GC367@wotan.suse.de>
	<20090105064838.GA5209@wotan.suse.de>
In-Reply-To: <20090105064838.GA5209@wotan.suse.de>
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
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, Roman Kononov <kernel@kononov.ftml.net>, xfs@oss.sgi.com

Nick Piggin wrote:
> I believe this patch should solve it. Please test and confirm before
> I send it upstream.


My test successfully completed two times, writing a 900GB file in each run.
I used a patched 2.6.27.10 x86_64 kernel.

On an unpatched system this test usually fails before reaching 100GB.

Thank you for fixing this issue that quick.

Regards, Peter.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
