Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0D1QmtY053974 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 19:26:48 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	mzdIFNjobERUVKoB for <xfs@oss.sgi.com>;
	Thu, 12 Jan 2012 17:26:46 -0800 (PST)
Date: Fri, 13 Jan 2012 12:26:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] fs: Improve filesystem freezing handling
Message-ID: <20120113012643.GF2806@dastard>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
	<1326331253-6497-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1326331253-6497-2-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, Jan 12, 2012 at 02:20:50AM +0100, Jan Kara wrote:
> + *
> + * Decrement number of writers to the filesystem and wake up possible
> + * waiters wanting to freeze the filesystem.
> + */
> +void sb_end_write(struct super_block *sb)
> +{
> +#ifdef CONFIG_SMP
> +	this_cpu_dec(sb->s_writers);
> +#else
> +	preempt_disable();
> +	sb->s_writers--;
> +	preempt_enable();
> +#endif

I really dislike this type of open coded per-cpu counter
implementation. I can't see that there is no good reason to use it
over percpu_counters here which abstract all this mess away.

i.e. it is relatively rare that the per-cpu count will nest
greater than the percpu_counter batch size (needs more than 32
concurrent blocked active writes per CPU), so there is no
significant overhead to using the percpu_counters here.

Indeed, if there are that many blocked writes per CPU, then the
overhead of an occasional global counter update is going to be lost
in the noise of everything else that is going on.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
