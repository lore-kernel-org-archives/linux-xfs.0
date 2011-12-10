Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBAJquL4011749 for <xfs@oss.sgi.com>; Sat, 10 Dec 2011 13:52:57 -0600
Received: from mga09.intel.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38E521A46A39
	for <xfs@oss.sgi.com>; Sat, 10 Dec 2011 11:52:55 -0800 (PST)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
	cuda.sgi.com with ESMTP id gPypSouQoHyuCGsS for
	<xfs@oss.sgi.com>; Sat, 10 Dec 2011 11:52:55 -0800 (PST)
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: XFS causing stack overflow
References: <CAAnfqPAm559m-Bv8LkHARm7iBW5Kfs7NmjTFidmg-idhcOq4sQ@mail.gmail.com>
	<20111209115513.GA19994@infradead.org>
	<20111209221956.GE14273__25752.826271537$1323469420$gmane$org@dastard>
Date: Sat, 10 Dec 2011 11:52:51 -0800
In-Reply-To: <20111209221956.GE14273__25752.826271537$1323469420$gmane$org@dastard>
	(Dave Chinner's message of "Sat, 10 Dec 2011 09:19:56 +1100")
Message-ID: <m262hop5kc.fsf@firstfloor.org>
MIME-Version: 1.0
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, "Ryan C. England" <ryan.england@corvidtec.com>, xfs@oss.sgi.com

Dave Chinner <david@fromorbit.com> writes:
>
> You forgot about interrupt stacking - that trace shows the system
> took an interrupt at the point of highest stack usage in the
> writeback call chain.... :/

The interrupts are always running on other stacks these days
(even 32bit got switched over).

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
