Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA88athg101338 for <xfs@oss.sgi.com>; Tue, 8 Nov 2011 02:36:55 -0600
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6825922AAF0
	for <xfs@oss.sgi.com>; Tue,  8 Nov 2011 00:32:11 -0800 (PST)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id AGhOPFDqYHq5Sgl6
	for <xfs@oss.sgi.com>; Tue, 08 Nov 2011 00:32:11 -0800 (PST)
Received: by bkaq10 with SMTP id q10so212773bka.26
	for <xfs@oss.sgi.com>; Tue, 08 Nov 2011 00:32:11 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 09/12] xfstests: add a new test that runs fsstress under
	ENOSPC conditions
In-Reply-To: <20111107212235.GH5534@dastard>
References: <1320330301-2682-1-git-send-email-dmonakhov@openvz.org>
	<1320330301-2682-10-git-send-email-dmonakhov@openvz.org>
	<20111107212235.GH5534@dastard>
Date: Tue, 08 Nov 2011 12:32:05 +0400
Message-ID: <87lirrkoai.fsf@dmbot.sw.ru>
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
Cc: linux-fsdevel@vger.kernel.org, aelder@sgi.com, tytso@mit.edu, hch@lst.de, xfs@oss.sgi.com

On Tue, 8 Nov 2011 08:22:35 +1100, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Nov 03, 2011 at 06:24:58PM +0400, Dmitry Monakhov wrote:
> > During stress testing we want to cover as much code paths as possible
> > fsstress is very good for this purpose. But it has expandable nature
> > (disk usage almost continually grow). So once it goes in no ENOSPC
> > condition it will be where till the end. But by running 'dd' writers
> > in parallel we can regularly trigger ENOSPC but only for a limited
> > periods of time because each time it opens the same file with O_TRUNC.
> 
> .....
> 
> So you have a 512MB filesystem, and you do:
> 
> > +# Disable all sync operations to get higher load
> > +FSSTRESS_AVOID="$FSSTRESS_AVOID -ffsync=0 -fsync=0 -ffdatasync=0"
> > +_workout()
> > +{
> > +	echo ""
> > +	echo "Run fsstress"
> > +	echo ""
> > +	num_iterations=10
> > +	enospc_time=2
> > +	out=$SCRATCH_MNT/fsstress.$$
> > +	args="-p128 -n999999999 -f setattr=1 $FSSTRESS_AVOID -d $out"
> > +	echo "fsstress $args" >> $here/$seq.full
> > +	$FSSTRESS_PROG $args > /dev/null 2>&1 &
> 
> run a bunch of fsstress processes
> 
> > +	pid=$!
> > +	echo "Run dd writers in parallel"
> > +	for ((i=0; i < num_iterations; i++))
> > +	do
> > +		# File will be opened with O_TRUNC each time
> > +		dd if=/dev/zero of=$SCRATCH_MNT/SPACE_CONSUMER bs=1M count=1 \
> > +			> /dev/null 2>&1
> > +		sleep $enospc_time
> > +	done
> 
> Then write the same 1MB file 10 times, 2 seconds apart, giving a
> total space usage of the dd processes of 1MB over 20s.
Hmm.. definitely it should not have count parameter at all, it
supposed to run until ENOSPC (that's why it's called spaceconsumer),
similar to 270'th testcase.
Patch will be in the list in a minute.
> 
> > +	kill $pid
> > +	wait $pid
> > +}
> 
> Then kill the fsstress.
> 
> AFAICT, fsstress won't always fill 511MB in 20s - on my test systems
> the fill rate is typically around 5s per 100MB, which would result
> in the filesystem not being filled with this test and hence not
> exercising ENOSPC.  Perhaps this would be better done like test 083,
> which uses a fixed number of write-only operations per fsstress
> process that is known to end up at ENOSPC, rather than hoping it
> gets there in 20s. 
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
