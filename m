Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7DVHuB060211 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 07:31:17 -0600
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 731FB22765D
	for <xfs@oss.sgi.com>; Mon,  7 Nov 2011 05:31:15 -0800 (PST)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id Rm1XsS1mWfTGg4fq
	for <xfs@oss.sgi.com>; Mon, 07 Nov 2011 05:31:15 -0800 (PST)
Received: by bkaq10 with SMTP id q10so2007896bka.26
	for <xfs@oss.sgi.com>; Mon, 07 Nov 2011 05:31:15 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 6/9] xfstests: add a new test that runs fsstress under
	ENOSPC conditions
In-Reply-To: <20111107132533.GP12759@twin.jikos.cz>
References: <1320342953-7973-1-git-send-email-dmonakhov@openvz.org>
	<1320342953-7973-6-git-send-email-dmonakhov@openvz.org>
	<20111107132533.GP12759@twin.jikos.cz>
Date: Mon, 07 Nov 2011 17:31:11 +0400
Message-ID: <87sjm0kqjk.fsf@dmbot.sw.ru>
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
To: dave@jikos.cz
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu, hch@lst.de, aelder@sgi.com

On Mon, 7 Nov 2011 14:25:33 +0100, David Sterba <dave@jikos.cz> wrote:
> Hi,
> 
> I saw this while running the newly added tests on btrfs:
> 
> On Thu, Nov 03, 2011 at 09:55:50PM +0400, Dmitry Monakhov wrote:
> > --- /dev/null
> > +++ b/269
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
> > +	pid=$!
> > +	echo "Run dd writers in parallel"
> > +	for ((i=0; i < num_iterations; i++))
> > +	do
> > +		# File will be opened with O_TRUNC each time
> > +		dd if=/dev/zero of=$SCRATCH_MNT/SPACE_CONSUMER bs=1M count=1 \
> > +			> /dev/null 2>&1
> > +		sleep $enospc_time
> > +	done
> > +	kill $pid
> 
> 269      [failed, exit status 1] - output mismatch (see 269.out.bad)
> --- 269.out     2011-11-07 13:26:23.000000000 +0100
> +++ 269.out.bad 2011-11-07 14:07:44.000000000 +0100
> @@ -3,3 +3,4 @@
>  Run fsstress
> 
>  Run dd writers in parallel
> +./269: line 60: kill: (9754) - No such process
> 
> > +	wait $pid
> > +}
> 
> and the test is reported to fail. Seems that the dd commands finish in less 2
> seconds.
Have you recompile fsstress via make?
test explicitly want use new feature "-f setattr=1"
> 
> 
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
