Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBC2Vahm065706 for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 20:31:38 -0600
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A217156D8B4
	for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 18:31:33 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id xkbs0meZSRklnLg1 for
	<xfs@oss.sgi.com>; Sun, 11 Dec 2011 18:31:33 -0800 (PST)
Date: Mon, 12 Dec 2011 03:31:30 +0100
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: XFS causing stack overflow
Message-ID: <20111212023130.GI24062@one.firstfloor.org>
References: <CAAnfqPAm559m-Bv8LkHARm7iBW5Kfs7NmjTFidmg-idhcOq4sQ@mail.gmail.com>
	<20111209115513.GA19994@infradead.org>
	<20111209221956.GE14273__25752.826271537$1323469420$gmane$org@dastard>
	<m262hop5kc.fsf@firstfloor.org> <20111210221345.GG14273@dastard>
	<20111211000036.GH24062@one.firstfloor.org>
	<20111211230511.GH14273@dastard>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111211230511.GH14273@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, "Ryan C. England" <ryan.england@corvidtec.com>, Andi Kleen <andi@firstfloor.org>, xfs@oss.sgi.com

> But that happens before do_IRQ is called, so what is the do_IRQ call
> chain doing on this stack given that we've already supposed to have
> switched to the interrupt stack before do_IRQ is called?

Not sure I understand the question.

The pt_regs are on the original stack (but they are quite small), all the rest 
is on the new stack. ISTs are not used for interrupts, only for 
some special exceptions. do_IRQ doesn't switch any stacks on 64bit.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
