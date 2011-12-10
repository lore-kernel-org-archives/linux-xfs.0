Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBAMDo7K014730 for <xfs@oss.sgi.com>; Sat, 10 Dec 2011 16:13:51 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F83F9E5EB9
	for <xfs@oss.sgi.com>; Sat, 10 Dec 2011 14:13:48 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	NDsDWh1OWGiUOzCb for <xfs@oss.sgi.com>;
	Sat, 10 Dec 2011 14:13:48 -0800 (PST)
Date: Sun, 11 Dec 2011 09:13:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS causing stack overflow
Message-ID: <20111210221345.GG14273@dastard>
References: <CAAnfqPAm559m-Bv8LkHARm7iBW5Kfs7NmjTFidmg-idhcOq4sQ@mail.gmail.com>
	<20111209115513.GA19994@infradead.org>
	<20111209221956.GE14273__25752.826271537$1323469420$gmane$org@dastard>
	<m262hop5kc.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <m262hop5kc.fsf@firstfloor.org>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, "Ryan C. England" <ryan.england@corvidtec.com>, xfs@oss.sgi.com

On Sat, Dec 10, 2011 at 11:52:51AM -0800, Andi Kleen wrote:
> Dave Chinner <david@fromorbit.com> writes:
> >
> > You forgot about interrupt stacking - that trace shows the system
> > took an interrupt at the point of highest stack usage in the
> > writeback call chain.... :/
> 
> The interrupts are always running on other stacks these days
> (even 32bit got switched over).

Where does the x86-64 do the interrupt stack switch?

I know the x86 32 bit interrupt handler switches to an irq/softirq
context stack, but the 64 bit one doesn't appear to. Indeed,
arch/x86/kernel/irq_{32,64}.c are very different, and only the 32
bit irq handler switches to another stack to process the
interrupts...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
